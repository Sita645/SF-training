# 🚀 Engineering Sprint – Part II

> "Good software is built one small, testable step at a time."

---

# 📖 Overview

This engineering sprint focuses on transforming software design into a working Salesforce application using Apex.

Unlike the previous chapters that introduced business logic, architecture, and Apex fundamentals, this sprint provides a structured implementation roadmap for building the **ApplicationService** of a Placement Management System.

The sprint follows an incremental approach where every feature is developed, tested, and improved before moving to the next step.

---

# 🎯 Learning Objectives

After completing this sprint, I learned how to:

- Create an Apex service class.
- Design business methods.
- Query Salesforce data using SOQL.
- Prevent duplicate job applications.
- Validate business rules.
- Insert records using DML.
- Handle application processing step by step.
- Build business logic incrementally.

---

# 🏢 Business Scenario

A student wants to apply for a job through the Placement Management System.

Before accepting the application, the system must verify:

- Has the student already applied?
- Is the student eligible?
- Can the application be saved?

Only after these validations should the application be stored in Salesforce.

---

# 🛠 Sprint Roadmap

The engineering sprint is divided into small implementation tasks.

---

## Sprint 1 – Create the Service Class

Create the foundation of the application.

```apex
public class ApplicationService {

}
```

Purpose:

- Create a dedicated service responsible for handling job applications.

---

## Sprint 2 – Create the Business Method

Create the first business method.

```apex
public void submitApplication(Id studentId, Id jobId){

}
```

Purpose:

- Represent the business activity of submitting a job application.
- Accept the required business information.

---

## Sprint 3 – Receive the Request

Initially, verify that the method executes successfully.

Example:

```apex
System.debug('Application Received Successfully');
```

Purpose:

- Confirm that the request reaches the service.
- Test method execution using Execute Anonymous.

---

## Sprint 4 – Query Salesforce Data

Retrieve the required records before making decisions.

Retrieve:

- Student
- Job

Purpose:

- Access CGPA
- Access Active Backlogs
- Access Minimum CGPA
- Access Maximum Backlogs

This information is required before validating eligibility.

---

## Sprint 5 – Prevent Duplicate Applications

Before saving a new application, check whether one already exists.

Business Flow

Student Applies
        ↓
Search Existing Applications
        ↓
Already Applied?

YES → Reject

NO → Continue

Purpose:

- Prevent duplicate job applications.
- Maintain data consistency.

---

## Sprint 6 – Validate Eligibility

Compare the student's academic information with the job requirements.

Validate:

- Student CGPA
- Student Active Backlogs
- Job Minimum CGPA
- Job Maximum Backlogs

Purpose:

Only eligible students should continue to the next step.

---

## Sprint 7 – Save the Application

After all validations pass:

Create a Job Application record.

Save it using DML.

Purpose:

Persist the application in Salesforce.

---

## Sprint 8 – Complete the Business Workflow

Final business process:

Student Clicks Apply
        ↓
Receive Request
        ↓
Query Student
        ↓
Query Job
        ↓
Check Duplicate
        ↓
Validate Eligibility
        ↓
Save Job Application
        ↓
Return Success Message

---

# 💡 Engineering Principles Learned

The sprint emphasizes several important software engineering principles.

### Build Incrementally

Develop one feature at a time.

Avoid implementing everything in one attempt.

---

### Test Frequently

Every small feature should be tested before moving forward.

Examples:

- Test Apex Class
- Test Method
- Test SOQL
- Test DML

---

### Keep Responsibilities Clear

ApplicationService should focus only on processing applications.

Responsibilities unrelated to applications should remain in their own service classes.

---

### Validate Before Saving

Software should never save invalid business data.

Every application should pass business validations before insertion.

---

# 🚀 Hands-on Activities Completed

During this sprint, I practiced:

- Creating an Apex class.
- Creating business methods.
- Executing Apex using Execute Anonymous.
- Writing SOQL queries.
- Querying custom Salesforce objects.
- Comparing business values.
- Implementing eligibility validation.
- Checking duplicate applications.
- Inserting records using DML.

---

# 🧠 Skills Gained

- Apex Programming
- SOQL
- DML Operations
- Business Logic Implementation
- Data Validation
- Salesforce Debugging
- Execute Anonymous
- Enterprise Coding Practices

---

# 📚 Interview Preparation

### Q1. Why should business logic be implemented step by step?

Developing incrementally makes software easier to understand, debug, and maintain.

---

### Q2. Why should applications be checked for duplicates?

To prevent inconsistent data and ensure a student cannot apply multiple times for the same job.

---

### Q3. Why should eligibility be validated before saving?

To ensure only students who satisfy business rules can successfully submit applications.

---

### Q4. Why is SOQL required before DML?

SOQL retrieves the information needed for business decisions, while DML saves validated records into Salesforce.

---

### Q5. What is the purpose of Execute Anonymous?

Execute Anonymous allows developers to test Apex code quickly without building a user interface.

---

# 📌 Key Takeaways

- Enterprise applications should be built incrementally.
- Business rules should be validated before saving data.
- SOQL retrieves information required for decision-making.
- DML persists validated business data.
- Small, testable units produce maintainable software.
- ApplicationService becomes the central component responsible for processing job applications.

---

# 📖 Chapter Summary

This engineering sprint demonstrates how enterprise Salesforce applications are developed using an incremental approach.

Instead of building an entire application at once, developers create small features, validate each feature independently, and gradually combine them into a complete business workflow.

The sprint also reinforces the connection between business requirements, Apex implementation, SOQL, DML, and enterprise software engineering practices.

---

## ⭐ Repository Purpose

This README documents my learning from the **"Engineering Sprint – Part II"** chapter as part of my Salesforce Developer learning journey.

This sprint provided hands-on experience in implementing business logic using Apex, SOQL, DML, and structured development practices while building the ApplicationService for a Placement Management System.
