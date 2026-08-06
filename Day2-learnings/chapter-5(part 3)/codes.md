# 💻 CODES.md - Chapter 5 Part III (Engineering Sprint)

This document contains all the practical Apex coding exercises completed during **Chapter 5 – Part III: Engineering Sprint** while building the **Placement Management System**.

---

# 🚀 Sprint 7 - Retrieve Student Information

## Objective

Retrieve only the required student information needed for eligibility validation.

### Apex Code

```apex
Student__c student = [
    SELECT Id,
           Name,
           CGPA__c,
           Active_Backlogs__c
    FROM Student__c
    LIMIT 1
];

System.debug('Student Details');
System.debug(student);
```

### Skills Practiced

- SOQL
- Query Custom Objects
- Retrieve Required Fields
- Debug Logs

---

# 🚀 Sprint 8 - Retrieve Job Information

## Objective

Retrieve only the job information required for eligibility checking.

### Apex Code

```apex
Job__c job = [
    SELECT Id,
           Name,
           Minimum_CGPA__c,
           Maximum_Backlogs__c,
           Application_Deadline__c
    FROM Job__c
    LIMIT 1
];

System.debug('Job Details');
System.debug(job);
```

### Skills Practiced

- SOQL
- Business Data Retrieval
- Field Selection
- Debug Logs

---

# 🚀 Sprint 9 - Prevent Duplicate Applications

## Objective

Check whether the student has already applied for the selected job.

### Apex Code

```apex
Student__c student = [
    SELECT Id,
           Name
    FROM Student__c
    LIMIT 1
];

Job__c job = [
    SELECT Id,
           Name
    FROM Job__c
    LIMIT 1
];

List<Job_Application__c> existingApplications = [
    SELECT Id,
           Name
    FROM Job_Application__c
    WHERE Student__c = :student.Id
    AND Job__c = :job.Id
];

if(existingApplications.size() > 0){

    System.debug('Duplicate Application Found');

}else{

    System.debug('No Duplicate Application - Continue');

}
```

### Skills Practiced

- SOQL Filtering
- List Collections
- Business Validation
- Duplicate Prevention

---

# 🚀 Sprint 10 - Create Job Application

## Objective

Create a new Job Application after all validations pass.

### Apex Code

```apex
Student__c student = [
    SELECT Id
    FROM Student__c
    LIMIT 1
];

Job__c job = [
    SELECT Id
    FROM Job__c
    LIMIT 1
];

Job_Application__c application = new Job_Application__c();

application.Student__c = student.Id;
application.Job__c = job.Id;
application.Application_Date__c = System.now();
application.Application_Status__c = 'Applied';
application.Eligibility_Status__c = 'Pending';

insert application;

System.debug('Job Application Created Successfully');
```

### Skills Practiced

- Object Creation
- Field Assignment
- DML Insert
- Record Creation

---

# 🚀 Sprint 11 - Update Job Application

## Objective

Update an existing Job Application after interview scheduling.

### Apex Code

```apex
Job_Application__c application = [
    SELECT Id,
           Name,
           Application_Status__c
    FROM Job_Application__c
    LIMIT 1
];

application.Application_Status__c = 'Interview Scheduled';

update application;

System.debug('Application Status Updated Successfully');
```

### Skills Practiced

- SOQL
- DML Update
- Record Modification

---

# 🚀 Sprint 12 - Schedule Interview (Stretch Challenge)

## Objective

Update both the application status and interview date.

### Apex Code

```apex
Job_Application__c application = [
    SELECT Id,
           Application_Status__c,
           Interview_Date__c
    FROM Job_Application__c
    LIMIT 1
];

application.Application_Status__c = 'Interview Scheduled';
application.Interview_Date__c = System.now();

update application;

System.debug('Interview Scheduled Successfully');
```

### Skills Practiced

- DateTime Handling
- Updating Multiple Fields
- DML Update

---

# 🛠 Concepts Practiced

During this engineering sprint, I implemented the following Salesforce concepts:

- Apex Classes
- Apex Methods
- Execute Anonymous
- SOQL Queries
- Query Optimization
- Custom Objects
- Relationship Fields
- Collections (List)
- Conditional Statements (if-else)
- Business Logic
- Duplicate Validation
- Eligibility Validation
- DML Insert
- DML Update
- Debug Logs

---

# 📚 Learning Outcome

By completing this engineering sprint, I learned how to:

- Retrieve Salesforce records using SOQL.
- Query only the required fields for better performance.
- Validate business rules before saving records.
- Prevent duplicate job applications.
- Create records using DML Insert.
- Update records using DML Update.
- Test Apex code using Execute Anonymous.
- Debug Apex programs using Debug Logs.
- Build business logic incrementally following engineering best practices.

---

# 🚀 Next Steps

The next phase of development includes:

- Move all logic into `ApplicationService`.
- Refactor duplicate code.
- Implement `try-catch` exception handling.
- Create Apex Triggers.
- Build Trigger Handler classes.
- Write Apex Test Classes.
- Bulkify SOQL and DML operations.
- Follow enterprise Salesforce architecture patterns.

---

## 📌 Summary

This engineering sprint provided hands-on experience in implementing business logic for a Placement Management System using Apex. The exercises covered the complete application workflow, including data retrieval, validation, record creation, record updates, and debugging while following incremental development practices.
