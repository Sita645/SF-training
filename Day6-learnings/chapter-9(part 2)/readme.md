# Chapter 9 – Part 2: Building the Application Experience

## Overview

Part 2 focuses on building the application experience for the **Placement Management System** using Salesforce Apex and Lightning Web Components (LWC).

The implementation connects the user interface with the Apex service layer and introduces a reusable child component for displaying individual job records.

---

## Objectives

* Connect LWC with Apex controllers.
* Retrieve eligible jobs for a student.
* Allow students to submit job applications.
* Validate applications through the service layer.
* Prevent duplicate applications.
* Display application success and error messages.
* Implement submitting state handling.
* Use parent-to-child communication in LWC.
* Use child-to-parent communication through `CustomEvent`.
* Build reusable LWC components.

---

## Architecture

```text
Student
   │
   ▼
eligibleJobs LWC
   │
   │ Job data
   ▼
jobCard LWC
   │
   │ Apply event
   ▼
eligibleJobs
   │
   ▼
ApplicationController
   │
   ▼
ApplicationService
   │
   ▼
JobApplicationTrigger
   │
   ▼
Job_Application__c
```

---

# 1. Eligible Jobs

The `eligibleJobs` component allows a student to enter their Salesforce Student Record ID and check available jobs.

### Flow

```text
Enter Student Record ID
        ↓
Check Eligibility
        ↓
EligibleJobsController
        ↓
ApplicationService
        ↓
Return eligible Job records
        ↓
Display Job Cards
```

Eligibility is based on the student's:

* CGPA
* Active Backlogs

and the job's:

* Minimum CGPA
* Maximum Backlogs
* Application Deadline

---

# 2. Application Controller

The `ApplicationController` provides the Apex method used by the LWC to submit an application.

```apex
public with sharing class ApplicationController {

    @AuraEnabled
    public static Id submitApplication(
        Id studentId,
        Id jobId
    ) {

        return ApplicationService.submitApplication(
            studentId,
            jobId
        );
    }
}
```

### Responsibility

The controller acts as the bridge between:

```text
LWC
 ↓
Apex Controller
 ↓
Service Layer
```

Business logic remains inside `ApplicationService`.

---

# 3. Application Service

`ApplicationService` contains the main application-related business logic.

### Responsibilities

* Retrieve eligible jobs.
* Validate applications.
* Check student eligibility.
* Check application deadline.
* Prevent duplicate applications.
* Create `Job_Application__c` records.

The service exposes:

```apex
getEligibleJobs()
```

```apex
validateApplications()
```

```apex
submitApplication()
```

This keeps the business logic separate from the LWC.

---

# 4. Application Submission

When the student clicks **Apply**, the LWC sends:

```javascript
submitApplication({
    studentId: this.studentId,
    jobId: jobId
});
```

The request follows:

```text
Apply
 ↓
eligibleJobs.js
 ↓
ApplicationController
 ↓
ApplicationService
 ↓
Job_Application__c
```

The created application ID is returned to the LWC.

---

# 5. Application Validation

Before an application is saved, `JobApplicationTrigger` invokes:

```apex
ApplicationService.validateApplications(applications);
```

The validation checks:

### Student

* Student exists.
* CGPA is available.
* Active backlogs are available.

### Job

* Job exists.
* Minimum CGPA requirement.
* Maximum backlog requirement.
* Application deadline.

If a rule fails, the application is rejected using:

```apex
application.addError(
    'Validation message'
);
```

---

# 6. Duplicate Application Prevention

Before creating a new application, the service checks whether the student has already applied for the selected job.

```apex
SELECT Id, Name
FROM Job_Application__c
WHERE Student__c = :studentId
AND Job__c = :jobId
LIMIT 1
```

If an existing application is found:

```text
You have already applied for this job.
```

The new application is not created.

---

# 7. Job Card Component

A reusable child component named:

```text
jobCard
```

was created.

Structure:

```text
lwc/
│
├── eligibleJobs/
│
└── jobCard/
    ├── jobCard.html
    ├── jobCard.js
    └── jobCard.js-meta.xml
```

The parent passes a Job record to the child:

```html
<c-job-card
    key={job.Id}
    job={job}
    is-submitting={isSubmitting}
    onapply={handleApply}>
</c-job-card>
```

---

# 8. Parent-to-Child Communication

The parent component sends the Job record to `jobCard` using:

```html
job={job}
```

The child receives it using:

```javascript
@api job;
```

Therefore:

```text
eligibleJobs
     │
     │ job={job}
     ▼
 jobCard
     │
     ▼
 @api job
```

The child can then display:

```javascript
job.Name
job.Location__c
job.Package_CTC__c
job.Minimum_CGPA__c
job.Maximum_Backlogs__c
job.Application_Deadline__c
```

---

# 9. Child-to-Parent Communication

When the student clicks **Apply** inside `jobCard`, the child creates a custom event:

```javascript
const applyEvent = new CustomEvent(
    'apply',
    {
        detail: {
            jobId: this.job.Id
        }
    }
);

this.dispatchEvent(applyEvent);
```

The parent listens for this event:

```html
onapply={handleApply}
```

The parent receives the Job ID using:

```javascript
const jobId = event.detail.jobId;
```

The communication flow is:

```text
jobCard
   │
   │ CustomEvent
   ▼
apply event
   │
   ▼
eligibleJobs
   │
   ▼
event.detail.jobId
```

---

# 10. Application States

The application submission process supports different UI states.

### Ready

```text
[ Apply ]
```

### Submitting

```text
[ Submitting... ]
```

The button is disabled while the request is being processed.

### Success

```text
✓ Application submitted successfully.
```

### Failure

The application displays the relevant error message, such as:

```text
You have already applied for this job.
```

or:

```text
The application deadline has passed.
```

---

# 11. Error Handling

The LWC handles Apex errors using `try...catch`.

```javascript
try {

    const applicationId =
        await submitApplication({
            studentId: this.studentId,
            jobId: jobId
        });

}
catch (error) {

    this.applicationError =
        this.getErrorMessage(error);

}
```

The UI displays the returned error instead of hiding the actual business validation message.

---

# 12. Final Component Structure

```text
eligibleJobs
│
├── Student Record ID input
│
├── Check Eligibility
│
├── Eligible Jobs
│
└── jobCard
     │
     └── Apply
```

The backend structure is:

```text
ApplicationController
        │
        ▼
ApplicationService
        │
        ├── getEligibleJobs()
        ├── validateApplications()
        └── submitApplication()
        │
        ▼
Job_Application__c
```

---

# 13. Files Implemented

```text
classes/
├── ApplicationController.cls
├── ApplicationController.cls-meta.xml
├── ApplicationService.cls
└── ApplicationService.cls-meta.xml
```

```text
lwc/
├── eligibleJobs/
│   ├── eligibleJobs.html
│   ├── eligibleJobs.js
│   └── eligibleJobs.js-meta.xml
│
└── jobCard/
    ├── jobCard.html
    ├── jobCard.js
    └── jobCard.js-meta.xml
```

---

# 14. Testing

The following scenarios were tested:

| Scenario                      | Expected Result           |
| ----------------------------- | ------------------------- |
| Valid Student + Eligible Job  | Application created       |
| Duplicate Student + Job       | Application rejected      |
| Student below required CGPA   | Application rejected      |
| Student exceeds backlog limit | Application rejected      |
| Deadline passed               | Application rejected      |
| Successful submission         | Success message displayed |
| Application processing        | Submit button disabled    |

---

# 15. Screenshots

Recommended evidence:

```text
screenshots/
├── 01-eligible-jobs.png
├── 02-job-card.png
├── 03-apply-button.png
├── 04-submitting-state.png
├── 05-success-message.png
└── 06-job-application-record.png
```

---

## Key Learning

This part demonstrates how Salesforce LWC and Apex can work together to create a complete business workflow.

The implementation separates responsibilities clearly:

```text
LWC
→ User Interface

Controller
→ Request Handling

Service
→ Business Logic

Trigger
→ Automatic Validation

Database
→ Job Application Record
```

This structure makes the Placement Management System easier to maintain, test, and extend.
