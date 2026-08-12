# Candidate API Contract

## Endpoint

POST /candidates

## Purpose

Send a selected student from Salesforce to the external recruitment system.

## Candidate Information

The following information will be sent:

- Student Id
- Name
- Email
- Branch
- CGPA
- Job Id
- Company
- Role
- Selection Date

## Request Example

```json
{
    "studentId": "STU1001",
    "name": "Student Name",
    "email": "student@example.com",
    "branch": "AIML",
    "cgpa": 8.5,
    "jobId": "JOB1001",
    "company": "KSquare",
    "role": "Salesforce Developer",
    "selectionDate": "2026-08-11"
}