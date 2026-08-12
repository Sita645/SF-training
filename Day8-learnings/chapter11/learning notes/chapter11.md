# Sprint 11 – Learning Notes

## 1. APIs

An API allows Salesforce to communicate with an external system.

In this sprint, Salesforce communicates with an external recruitment
platform to synchronize selected candidates.

---

## 2. REST API

REST APIs allow applications to communicate using HTTP.

The candidate integration uses a REST API to send candidate information
to the external recruitment system.

---

## 3. HTTP Methods

### GET

Used to retrieve data.

### POST

Used to send or create data.

The Candidate Recruitment API uses:

```text
POST /candidates
````

---

## 4. JSON

JSON is used to represent data exchanged between Salesforce and the
external system.

Example:

```json
{
    "candidateName": "Test Student",
    "email": "student@example.com",
    "cgpa": 8.5,
    "role": "Software Developer"
}
```

---

## 5. Apex Callouts

An Apex callout allows Salesforce to communicate with an external
system over HTTP.

The candidate synchronization uses Queueable Apex to perform the
external callout.

---

## 6. Queueable Apex

Queueable Apex is used to perform the external synchronization
asynchronously.

The architecture is:

```text
Job Application
      ↓
Selected
      ↓
Queueable
      ↓
External API
```

The external system does not block the main Salesforce transaction.

---

## 7. Named Credentials

Named Credentials are used to manage the endpoint and authentication
configuration for the external system.

Credentials, passwords, and access tokens should not be hard-coded
in Apex.

---

## 8. Integration Status

Salesforce success and external-system success are separate things.

The application therefore tracks integration state using fields such
as:

* Integration Status
* External Candidate Id
* Last Integration Attempt
* Integration Error

This helps Salesforce understand what happened during synchronization.

---

## 9. Error Handling

The integration handles different responses:

* 201 – Successful creation
* 400 – Bad Request
* 401 – Unauthorized
* 403 – Forbidden
* 500 – Internal Server Error
* Unexpected errors

Integration errors are recorded so that they can be investigated or
retried.

---

## 10. Retry

If the external system is temporarily unavailable, the Salesforce
business transaction should not be lost.

The application can be marked:

```text
Retry Required
```

The `CandidateRetryScheduler` identifies records requiring retry and
starts the retry process.

---

## 11. Duplicate Prevention and Idempotency

Retrying an integration can create duplicate records in the external
system.

The Salesforce Job Application Id can be used as the business
identifier for the candidate submission.

The External Candidate Id is stored after successful synchronization.

The existing integration state should be checked before submitting
the same candidate again.

---

## 12. Point-to-Point Integration

The current implementation uses point-to-point integration:

```text
Salesforce
     ↓
External Recruitment System
```

This is suitable for the current prototype.

When many external systems are involved, middleware can be used for
routing, transformation, orchestration, monitoring, and retry
management.

---

## 13. Synchronous Integration

Synchronous processing is appropriate when the user needs the result
immediately.

Example:

```text
LWC
 ↓
Apex
 ↓
External API
 ↓
Response
 ↓
LWC
```

---

## 14. Asynchronous Integration

Asynchronous processing is appropriate when the user does not need to
wait for the external system.

The candidate synchronization uses:

```text
Trigger / Service
       ↓
Queueable
       ↓
External API
```

---

## 15. Batch Apex

Batch Apex is useful for processing large amounts of Salesforce data
in manageable groups.

The historical synchronization uses:

```text
Scheduled Apex
       ↓
Batch Apex
       ↓
External Integration
       ↓
Error Handling
       ↓
Retry
```

The implementation includes:

* `CandidateHistoricalSyncScheduler`
* `CandidateHistoricalSyncBatch`

---

## 16. Scheduled Apex

Scheduled Apex starts integration work at a predefined time.

The historical synchronization scheduler starts the Batch Apex process
for periodic synchronization.

The retry scheduler is responsible for starting retry processing for
failed integrations.

---

## 17. Callout and Transaction Design

The Salesforce business transaction and external communication are
separate concerns.

A suitable pattern is:

```text
Salesforce Business Transaction
          ↓
       Commit
          ↓
      Queueable
          ↓
     HTTP Callout
          ↓
   External System
```

This reduces the risk of an external dependency blocking the primary
Salesforce business operation.

---

## 18. External System Failures

An external system may be:

* unavailable
* slow
* incorrectly configured
* overloaded
* authenticated differently
* returning unexpected data

Therefore, integration code must be designed for failure.

Important considerations include:

* Timeouts
* Errors
* Authentication
* Retries
* Duplicates
* Monitoring
* Data ownership
* API contracts

---

## 19. Testing

### CandidateSyncQueueableTest

```text
Tests Passed: 4
Tests Failed: 0
Pass Rate: 100%
```

### CandidateHistoricalSyncBatchTest

```text
Tests Passed: 3
Tests Failed: 0
Pass Rate: 100%
```

---

## 20. Key Learning

The main lesson from this sprint is that integration is more than
sending an HTTP request.

A reliable Salesforce integration must consider:

1. API communication
2. Authentication
3. Error handling
4. Retry processing
5. Duplicate prevention
6. Integration status
7. Asynchronous processing
8. Large-data processing
9. Monitoring
10. Data ownership
11. API contracts

The system has now crossed the Salesforce boundary:

```text
Salesforce ↔ External World
```

The external system cannot be assumed to behave perfectly, so the
integration must be designed for real-world failures.
