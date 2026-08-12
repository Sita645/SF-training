public with sharing class CandidateSyncQueueable
    implements Queueable, Database.AllowsCallouts {

    private Id applicationId;

    public CandidateSyncQueueable(Id applicationId) {
        this.applicationId = applicationId;
    }

    private static String shortenError(String message) {

        if (message == null) {
            return null;
        }

        if (message.length() > 255) {
            return message.substring(0, 255);
        }

        return message;
    }

    public void execute(QueueableContext context) {

        /*
         * =========================================================
         * 1. GET JOB APPLICATION
         * =========================================================
         */

        Job_Application__c application = [
            SELECT Id,
                   Student__c,
                   Student__r.Name,
                   Student__r.Student_ID__c,
                   Student__r.Email__c,
                   Student__r.Department__c,
                   Student__r.CGPA__c,
                   Job__c,
                   Job__r.Name,
                   Job__r.Company__c,
                   Application_Date__c,
                   Integration_Status__c,
                   External_Candidate_Id__c
            FROM Job_Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];


        /*
         * =========================================================
         * 2. DUPLICATE PROTECTION
         * =========================================================
         */

        if (
            application.External_Candidate_Id__c != null &&
            application.External_Candidate_Id__c != ''
        ) {

            System.debug(
                'Candidate already synchronized. ' +
                'Skipping duplicate submission.'
            );

            return;
        }


        /*
         * =========================================================
         * 3. CREATE CANDIDATE PAYLOAD
         * =========================================================
         */

        Map<String, Object> candidatePayload =
            new Map<String, Object>();

        candidatePayload.put(
            'studentId',
            application.Student__r.Student_ID__c
        );

        candidatePayload.put(
            'name',
            application.Student__r.Name
        );

        candidatePayload.put(
            'email',
            application.Student__r.Email__c
        );

        candidatePayload.put(
            'branch',
            application.Student__r.Department__c
        );

        candidatePayload.put(
            'cgpa',
            application.Student__r.CGPA__c
        );

        candidatePayload.put(
            'jobId',
            application.Job__c
        );

        candidatePayload.put(
            'company',
            application.Job__r.Company__c
        );

        /*
         * Role is null because your Job__c
         * does not contain Role__c.
         */

        candidatePayload.put(
            'role',
            null
        );

        candidatePayload.put(
            'selectionDate',
            application.Application_Date__c
        );


        /*
         * =========================================================
         * 4. CONVERT TO JSON
         * =========================================================
         */

        String requestBody =
            JSON.serialize(candidatePayload);


        /*
         * =========================================================
         * 5. CREATE HTTP REQUEST
         * =========================================================
         */

        HttpRequest request =
            new HttpRequest();

        request.setEndpoint(
            'callout:Recruitment_API/candidates'
        );

        request.setMethod('POST');

        request.setHeader(
            'Content-Type',
            'application/json'
        );

        request.setBody(requestBody);


        /*
         * =========================================================
         * 6. SEND HTTP REQUEST
         * =========================================================
         */

        Http http =
            new Http();

        HttpResponse response;

        try {

            response = http.send(request);

        }
        catch (Exception ex) {

            Job_Application__c updateApplication =
                new Job_Application__c(
                    Id = applicationId,
                    Integration_Status__c =
                        'Retry Required',
                    Last_Integration_Attempt__c =
                        Datetime.now(),
                    Integration_Error__c =
                        shortenError(
                            ex.getMessage()
                        )
                );

            update updateApplication;

            return;
        }


        /*
         * =========================================================
         * 7. READ RESPONSE
         * =========================================================
         */

        Integer statusCode =
            response.getStatusCode();

        String responseBody =
            response.getBody();


        /*
         * =========================================================
         * 8. CREATE UPDATE RECORD
         * =========================================================
         */

        Job_Application__c updateApplication =
            new Job_Application__c(
                Id = applicationId,
                Last_Integration_Attempt__c =
                    Datetime.now()
            );


        /*
         * =========================================================
         * 9. SUCCESS
         * =========================================================
         */

        if (
            statusCode == 200 ||
            statusCode == 201
        ) {

            updateApplication.Integration_Status__c =
                'Sent';

            updateApplication.Integration_Error__c =
                null;


            if (
                responseBody != null &&
                responseBody != ''
            ) {

                try {

                    Map<String, Object> responseData =
                        (Map<String, Object>)
                        JSON.deserializeUntyped(
                            responseBody
                        );

                    if (
                        responseData.containsKey(
                            'candidateId'
                        )
                    ) {

                        Object externalId =
                            responseData.get(
                                'candidateId'
                            );

                        if (externalId != null) {

                            updateApplication
                                .External_Candidate_Id__c =
                                String.valueOf(
                                    externalId
                                );
                        }
                    }

                }
                catch (Exception ex) {

                    updateApplication
                        .Integration_Error__c =
                        shortenError(
                            'Candidate created, but response could not be processed.'
                        );
                }
            }
        }


        /*
         * =========================================================
         * 10. BAD REQUEST
         * =========================================================
         */

        else if (statusCode == 400) {

            updateApplication.Integration_Status__c =
                'Failed';

            updateApplication.Integration_Error__c =
                shortenError(
                    'HTTP 400 - Bad Request. ' +
                    responseBody
                );
        }


        /*
         * =========================================================
         * 11. AUTHENTICATION FAILURE
         * =========================================================
         */

        else if (statusCode == 401) {

            updateApplication.Integration_Status__c =
                'Failed';

            updateApplication.Integration_Error__c =
                shortenError(
                    'HTTP 401 - Authentication failure. ' +
                    responseBody
                );
        }


        /*
         * =========================================================
         * 12. PERMISSION FAILURE
         * =========================================================
         */

        else if (statusCode == 403) {

            updateApplication.Integration_Status__c =
                'Failed';

            updateApplication.Integration_Error__c =
                shortenError(
                    'HTTP 403 - Permission denied. ' +
                    responseBody
                );
        }


        /*
         * =========================================================
         * 13. SERVER ERROR
         * =========================================================
         */

        else if (statusCode == 500) {

            updateApplication.Integration_Status__c =
                'Retry Required';

            updateApplication.Integration_Error__c =
                shortenError(
                    'HTTP 500 - External server error. ' +
                    responseBody
                );
        }


        /*
         * =========================================================
         * 14. OTHER RESPONSES
         * =========================================================
         */

        else {

            updateApplication.Integration_Status__c =
                'Failed';

            updateApplication.Integration_Error__c =
                shortenError(
                    'Unexpected HTTP status ' +
                    statusCode +
                    '. ' +
                    responseBody
                );
        }


        /*
         * =========================================================
         * 15. SAVE RESULT
         * =========================================================
         */

        update updateApplication;
    }
}