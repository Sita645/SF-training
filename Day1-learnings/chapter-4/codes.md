# 💻 CODES.md - Engineering Sprint Coding Tasks

This document contains all the practical coding exercises completed during the **Engineering Sprint** while building the **Placement Management System**.

---

# Task 1 - Create ApplicationService Class

## Objective

Create a service class responsible for handling all job application operations.

```apex
public class ApplicationService {

}
```

---

# Task 2 - Create submitApplication() Method

## Objective

Create the first business method.

```apex
public class ApplicationService {

    public void submitApplication(Id studentId, Id jobId){

        System.debug('Application Received Successfully');

    }

}
```

---

# Task 3 - Execute Anonymous

Test the method.

```apex
ApplicationService app = new ApplicationService();

app.submitApplication(null, null);
```

Expected Debug Output

```
Application Received Successfully
```

---

# Task 4 - Query Student Using SOQL

Retrieve one Student record.

```apex
Student__c stu = [
    SELECT Id,
           Name,
           CGPA__c,
           Active_Backlogs__c
    FROM Student__c
    LIMIT 1
];

System.debug(stu);
```

---

# Task 5 - Query Job Using SOQL

Retrieve one Job record.

```apex
Job__c job = [
    SELECT Id,
           Name,
           Minimum_CGPA__c,
           Maximum_Backlogs__c
    FROM Job__c
    LIMIT 1
];

System.debug(job);
```

---

# Task 6 - Eligibility Validation

Compare student eligibility with job requirements.

```apex
Student__c stu = [
    SELECT Id,
           Name,
           CGPA__c,
           Active_Backlogs__c
    FROM Student__c
    LIMIT 1
];

Job__c job = [
    SELECT Id,
           Name,
           Minimum_CGPA__c,
           Maximum_Backlogs__c
    FROM Job__c
    LIMIT 1
];

if(stu.CGPA__c >= job.Minimum_CGPA__c &&
   stu.Active_Backlogs__c <= job.Maximum_Backlogs__c){

    System.debug('Student is ELIGIBLE');

}else{

    System.debug('Student is NOT ELIGIBLE');

}
```

---

# Task 7 - Duplicate Application Check

Prevent duplicate job applications.

```apex
Student__c stu = [
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
    WHERE Student__c = :stu.Id
    AND Job__c = :job.Id

];

if(existingApplications.size() > 0){

    System.debug('Duplicate Application Found');

}else{

    System.debug('No Duplicate Application');

}
```

---

# Task 8 - Insert Job Application (DML)

Save a new Job Application.

```apex
Student__c stu = [
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

application.Student__c = stu.Id;
application.Job__c = job.Id;

insert application;

System.debug('Application Saved Successfully');
```

---

# Skills Practiced

- Apex Classes
- Methods
- Parameters
- Execute Anonymous
- SOQL Queries
- DML Operations
- Business Logic
- Eligibility Validation
- Duplicate Prevention
- Debug Logs

---

# Learning Outcome

By completing these exercises, I learned how to:

- Create Apex service classes.
- Write business methods.
- Retrieve Salesforce records using SOQL.
- Compare business data.
- Validate eligibility.
- Prevent duplicate records.
- Insert records using DML.
- Test Apex code using Execute Anonymous.

---

# Next Steps

The next phase of the project includes:

- Refactoring into reusable helper methods.
- Exception Handling (try-catch).
- Trigger Development.
- Trigger Handler Pattern.
- Test Classes.
- Bulkification.
- Production-ready Apex Architecture.
