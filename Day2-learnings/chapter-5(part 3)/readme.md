# 📘 Chapter 5 – Part III: Engineering Sprint
### Building Complete Business Transactions with SOQL, DML and Apex

> **"Software engineering is not about writing isolated statements. It is about orchestrating a sequence of business activities that together solve a real problem."**

---

# 🎯 Sprint Objective

In this Engineering Sprint, I combined **SOQL**, **Apex**, and **DML** to build a complete business transaction for the Placement Management System.

The goal was not only to retrieve information or modify records individually, but to understand how professional Salesforce developers implement complete business processes.

---

# 📚 Learning Outcomes

By completing Part III, I learned how to:

- Build complete business transactions using Apex.
- Retrieve only the required information using SOQL.
- Validate business rules before modifying records.
- Prevent duplicate applications.
- Create and update Salesforce records using DML.
- Organize business logic into reusable service classes.
- Write clean, maintainable, and scalable Apex code.

---

# 🏢 Sprint Backlog

| Story ID | User Story | Priority |
|----------|------------|----------|
| US-7 | Retrieve Student Information | High |
| US-8 | Retrieve Job Eligibility | High |
| US-9 | Prevent Duplicate Applications | High |
| US-10 | Create Application Record | High |
| US-11 | Update Application Status | Medium |
| US-12 | Return Meaningful Feedback | Medium |

---

# 🔄 Complete Business Transaction

The Placement Management System follows this sequence:

```text
Receive Request
       ↓
Retrieve Student
       ↓
Retrieve Job
       ↓
Check Duplicate
       ↓
Validate Eligibility
       ↓
Create Application
       ↓
Save Record
       ↓
Return Confirmation
```

This represents a complete Salesforce business transaction.

---

# 🚀 Engineering Sprint 7 – Retrieve Student Information

## Business Requirement

Before validating an application, the software must retrieve the student's information.

### Coding Task

Retrieve only the required fields.

```apex
Student__c student = [
    SELECT CGPA__c,
           Branch__c,
           Active_Backlogs__c
    FROM Student__c
    WHERE Id = :studentId
];
```

### Engineering Principle

- Retrieve only required fields.
- Avoid unnecessary queries.
- Improve performance and readability.

---

# 🚀 Engineering Sprint 8 – Retrieve Job Eligibility

## Business Requirement

Retrieve job eligibility criteria before validating applications.

### Required Information

- Minimum CGPA
- Eligible Branch
- Backlog Limit
- Application Deadline

### Coding Task

```apex
Job__c job = [
    SELECT Minimum_CGPA__c,
           Eligible_Branch__c,
           Backlog_Limit__c,
           Application_Deadline__c
    FROM Job__c
    WHERE Id = :jobId
];
```

### Engineering Principle

Only retrieve information required for the current business decision.

---

# 🚀 Engineering Sprint 9 – Prevent Duplicate Applications

## Business Requirement

Students should not apply multiple times for the same job.

### Coding Task

Retrieve existing applications.

```apex
List<Application__c> applications = [

    SELECT Id

    FROM Application__c

    WHERE Student__c = :studentId

    AND Job__c = :jobId

];
```

Validate duplicate.

```apex
if(!applications.isEmpty()){

    return 'Application already exists';

}
```

### Test Scenarios

| Situation | Expected Result |
|-----------|-----------------|
| First Application | Continue |
| Duplicate Application | Reject |
| Different Company | Continue |

---

# 🚀 Engineering Sprint 10 – Create Application

## Business Requirement

After successful validation, create the Application record.

### Coding Task

```apex
Application__c app = new Application__c();

app.Student__c = studentId;
app.Job__c = jobId;
app.Status__c = 'Applied';
app.Application_Date__c = Date.today();

insert app;
```

### Expected Behaviour

A new Application record should be created successfully.

### Engineering Principle

Never perform DML until every business rule has been validated.

---

# 🚀 Engineering Sprint 11 – Update Application Status

## Business Requirement

Recruiters should update the Application status after interviews.

Possible Status Values

- Applied
- Shortlisted
- Interview Scheduled
- Selected
- Rejected

### Coding Task

Retrieve Application.

```apex
Application__c app = [

    SELECT Status__c

    FROM Application__c

    WHERE Id = :applicationId

];
```

Update Status.

```apex
app.Status__c = 'Selected';

update app;
```

### Learning

Update existing records instead of creating duplicate records.

---

# 🚀 Engineering Sprint 12 – Complete Business Transaction

Combine all operations into one complete flow.

```text
Retrieve Student
       ↓
Retrieve Job
       ↓
Check Duplicate
       ↓
Validate Eligibility
       ↓
Create Application
       ↓
Insert Record
       ↓
Display Confirmation
```

This is how enterprise Salesforce applications process business transactions.

---

# 💻 Sample Apex Service Design

## StudentService

Responsible for retrieving Student information.

```apex
public class StudentService{

    public static Student__c getStudent(Id studentId){

        return [

            SELECT CGPA__c,
                   Branch__c,
                   Active_Backlogs__c

            FROM Student__c

            WHERE Id=:studentId

        ];

    }

}
```

---

## JobService

Responsible for retrieving Job details.

```apex
public class JobService{

    public static Job__c getJob(Id jobId){

        return [

            SELECT Minimum_CGPA__c,
                   Eligible_Branch__c,
                   Backlog_Limit__c,
                   Application_Deadline__c

            FROM Job__c

            WHERE Id=:jobId

        ];

    }

}
```

---

## ApplicationService

Responsible for business processing.

```apex
public class ApplicationService{

    public static String submitApplication(Id studentId, Id jobId){

        Student__c student = StudentService.getStudent(studentId);

        Job__c job = JobService.getJob(jobId);

        List<Application__c> existingApps = [

            SELECT Id

            FROM Application__c

            WHERE Student__c=:studentId

            AND Job__c=:jobId

        ];

        if(!existingApps.isEmpty()){

            return 'Application Already Submitted';

        }

        Application__c app = new Application__c(

            Student__c = studentId,

            Job__c = jobId,

            Status__c = 'Applied',

            Application_Date__c = Date.today()

        );

        insert app;

        return 'Application Submitted Successfully';

    }

}
```

---

# 🛠 Debug This! – Engineering Mistakes

## ❌ Repeating SOQL Queries

Problem:

Same query written multiple times.

Solution:

Create reusable service methods.

---

## ❌ DML Before Validation

Wrong

```text
Insert Record
      ↓
Validate
```

Correct

```text
Retrieve
      ↓
Validate
      ↓
Insert
```

---

## ❌ Retrieving Every Field

Wrong

Retrieve unnecessary fields.

Correct

Retrieve only required fields.

---

## ❌ One Huge Method

Bad Practice

One method performing:

- SOQL
- Validation
- Insert
- Update
- Email
- Logging
- Reports

Better Practice

- StudentService
- JobService
- ApplicationService
- NotificationService
- LoggingService

Each class should have a single responsibility.

---

# 🎯 Interview Corner

### Why should SOQL execute before DML?

Because software must retrieve existing business information before deciding whether data should change.

---

### Why should every SOQL query answer one business question?

It improves readability, performance, and maintainability.

---

### Why retrieve only required fields?

- Better Performance
- Lower Memory Usage
- Reduced Governor Limit Consumption

---

### Why should DML happen only after validation?

To prevent invalid or duplicate business records from entering Salesforce.

---

### Why divide responsibilities into service classes?

It makes the application:

- Easier to maintain
- Easier to test
- Easier to extend
- Easier for new developers to understand

---

# 📌 Engineering Best Practices

- Retrieve only required fields.
- Validate before performing DML.
- Prevent duplicate records.
- Keep one responsibility per class.
- Reuse SOQL methods.
- Write readable and maintainable Apex.
- Think about future business requirements.

---

# 📖 Sprint Summary

During Part III of Sprint 5, I learned how professional Salesforce developers combine **SOQL**, **Apex**, and **DML** to implement complete business transactions. I also learned how to organize business logic into reusable service classes, prevent duplicate records, perform validations before database changes, and follow clean coding practices that improve scalability and maintainability.

---

# 🚀 Next Learning

➡️ **Chapter 6 – Apex Triggers: Responding Automatically to Business Events**
