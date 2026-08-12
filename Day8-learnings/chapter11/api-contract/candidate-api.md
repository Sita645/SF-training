# Candidate Recruitment API Contract

## 1. Purpose

This API is used to send selected candidates from the Salesforce
Placement Management System to an external recruitment platform.

---

## 2. Endpoint

The external API is accessed through a Salesforce Named Credential.

**Named Credential:**

`Recruitment_API_Credential`

**Resource:**

`POST /candidates`

The actual base URL is managed by the Named Credential and is not
hard-coded in Apex.

---

## 3. HTTP Method

```text
POST
````

The POST method is used because Salesforce sends candidate information
to the external recruitment system.

---

## 4. Request

The request contains candidate and job application information.

### Request JSON

```json
{
    "applicationId": "Salesforce Job Application Id",
    "studentId": "Salesforce Student Id",
    "candidateName": "Test Student",
    "email": "student@example.com",
    "branch": "CSE",
    "cgpa": 8.5,
    "jobId": "Salesforce Job Id",
    "company": "Test Company",
    "role": "Software Developer",
    "selectionDate": "2026-08-12"
}
```

---

## 5. Successful Response

**HTTP Status:**

```text
201 Created
```

### Response JSON

```json
{
    "success": true,
    "candidateId": "EXT-CAND-001",
    "message": "Candidate created successfully"
}
```

The external candidate identifier is stored in:

```text
External_Candidate_Id__c
```

---

## 6. Error Responses

### 400 – Bad Request

The request contains invalid or missing data.

Salesforce should record the integration error.

### 401 – Unauthorized

Authentication failed.

The candidate must not be marked as successfully synchronized.

### 403 – Forbidden

The authenticated integration does not have permission to perform
the requested operation.

The error should be recorded for investigation.

### 500 – Internal Server Error

The external recruitment system encountered an internal error.

The application can be marked:

```text
Retry Required
```

### Unexpected Error

Unexpected HTTP responses, callout exceptions, timeout errors,
or other exceptions should be captured in:

```text
Integration_Error__c
```

---

## 7. Authentication

Authentication is handled using a Salesforce Named Credential.

```text
Recruitment_API_Credential
```

Credentials, passwords, access tokens, and other secrets are not
hard-coded in Apex.

---

## 8. Integration Status

The Job Application tracks the integration using fields such as:

* Integration Status
* External Candidate Id
* Last Integration Attempt
* Integration Error

### Successful Flow

```text
Pending
   ↓
Sent
   ↓
Success
```

### Failed Flow

```text
Pending
   ↓
Failed
   ↓
Retry Required
   ↓
Retry
   ↓
Success
```

---

## 9. Retry Strategy

If the external recruitment system is temporarily unavailable,
Salesforce should not lose the candidate selection.

The Job Application is marked:

```text
Retry Required
```

`CandidateRetryScheduler` identifies records requiring retry and
initiates the retry process.

Temporary failures should be retried rather than immediately treated
as permanent failures.

---

## 10. Idempotency and Duplicate Prevention

The Salesforce Job Application represents the business transaction.

The Salesforce Job Application Id can be used as the unique business
identifier for the candidate submission.

The External Candidate Id is stored after successful synchronization.

Before sending a candidate again, Salesforce should check the existing
integration state to avoid creating duplicate candidates.

---

## 11. Integration Pattern

The current implementation uses point-to-point integration:

```text
Salesforce
    ↓
External Recruitment API
```

This is appropriate for the current prototype because Salesforce
communicates directly with one external recruitment system.

For a larger environment containing many external systems, middleware
could be introduced for routing, transformation, monitoring,
orchestration, and retry management.

---

## 12. Synchronous vs Asynchronous

Candidate synchronization uses asynchronous processing through
Queueable Apex.

```text
Job Application
      ↓
Selected
      ↓
Queueable
      ↓
Named Credential
      ↓
REST API
      ↓
Response
```

The user does not need to wait for the external recruitment system.

For an immediate verification requirement where the user needs the
response immediately, synchronous integration may be appropriate.

---

## 13. Mock API

If a mock API is used during development or testing, it should be
clearly identified as a development/test endpoint and not as a
production recruitment service.

The production endpoint should be configured through the Named
Credential.

---

## 14. Salesforce Components

### Apex Classes

* `CandidateSyncQueueable`
* `CandidateRetryScheduler`
* `CandidateHistoricalSyncBatch`
* `CandidateHistoricalSyncScheduler`

### Configuration

* Named Credential
* Integration Status fields
* External Candidate Id
* Last Integration Attempt
* Integration Error

### Test Classes

* `CandidateSyncQueueableTest`
* `CandidateHistoricalSyncBatchTest`

### Test Results

**CandidateSyncQueueableTest**

* Tests Passed: 4
* Tests Failed: 0
* Pass Rate: 100%

**CandidateHistoricalSyncBatchTest**

* Tests Passed: 3
* Tests Failed: 0
* Pass Rate: 100%

