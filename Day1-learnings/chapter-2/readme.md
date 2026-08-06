# 🏗 Thinking Like an Architect

> "Every successful software application is built twice—first in the mind of the engineer, and then in the programming language."

---

# 📖 Overview

This chapter introduces the concept of **Software Architecture** in Salesforce application development.

Instead of immediately writing Apex code, the focus is on organizing software into well-defined components, assigning clear responsibilities, and designing applications that are easy to understand, maintain, and extend.

Using the Placement Management System as an example, this chapter explains how professional Salesforce developers think before implementation.

---

# 🎯 Learning Outcomes

After completing this chapter, I learned how to:

- Understand the importance of software architecture.
- Organize software based on business responsibilities.
- Apply the Single Responsibility Principle.
- Separate User Interface, Business Logic, and Database operations.
- Design reusable service classes.
- Prepare software architecture before implementation.

---

# 🏢 Business Scenario

A student submits an application through the Placement Management System.

Although the entire process appears simple, multiple operations happen behind the scenes:

- Receive application
- Verify eligibility
- Save the application
- Send confirmation
- Update reports

Instead of placing all these operations into one class, they should be distributed across specialized software components.

---

# 🏗 What is Software Architecture?

Software Architecture is the process of organizing responsibilities within an application.

A well-designed application separates different responsibilities into different components.

Good architecture helps software become:

- Easier to understand
- Easier to modify
- Easier to test
- Easier to maintain
- Easier to extend

---

# 🔄 Journey of a Student Application

Student
        ↓
Lightning Web Component (User Interface)
        ↓
Application Service (Business Logic)
        ↓
Eligibility Validation
        ↓
Salesforce Database
        ↓
Confirmation to User

Each component performs one specific responsibility.

---

# 🎯 Single Responsibility Principle

One of the most important engineering principles discussed in this chapter is:

> **A component should have one primary responsibility.**

Instead of writing one large class that performs every operation, responsibilities should be separated.

Example:

❌ One Large Class

- Register Students
- Publish Jobs
- Process Applications
- Send Emails
- Generate Reports

✅ Separate Services

- StudentService
- JobService
- ApplicationService

Each class focuses on one business capability.

---

# 🏛 Service Class Design

## StudentService

Responsible for:

- Registering Students
- Updating Student Profiles
- Verifying Academic Information
- Checking Placement Status

---

## JobService

Responsible for:

- Creating Jobs
- Updating Jobs
- Publishing Jobs
- Closing Expired Opportunities

---

## ApplicationService

Responsible for:

- Receiving Applications
- Checking Eligibility
- Preventing Duplicate Applications
- Saving Applications
- Returning Messages to Users

ApplicationService becomes the central business service for application processing.

---

# 💡 Architecture Principles Learned

This chapter emphasizes:

- Organize software before implementation.
- Keep business responsibilities separate.
- Avoid mixing unrelated functionality.
- Design services around business capabilities.
- Good architecture reduces future maintenance effort.

---

# 🧠 Engineering Insights

Important lessons learned:

- Architecture comes before implementation.
- Good design reduces unnecessary code.
- Well-organized software is easier to modify.
- Clear responsibilities improve readability.
- Small changes should require minimal code modifications.

---

# 📝 Think Like an Engineer

Engineering discussion topics covered in this chapter include:

- Which service should implement new business rules?
- Should validations occur before or after saving records?
- How should software adapt when business rules change?
- Which class should be modified when requirements evolve?

These questions encourage developers to think about maintainability rather than only implementation.

---

# 🚀 Skills Gained

- Software Architecture Fundamentals
- Service-Oriented Design
- Single Responsibility Principle
- Separation of Concerns
- Enterprise Software Design
- Salesforce Application Design

---

# 🛠 Design Activities

This chapter focuses on software design rather than implementation.

Activities include:

- Identifying business responsibilities.
- Assigning responsibilities to services.
- Designing service classes.
- Planning architecture before writing Apex.

No Apex implementation is introduced in this chapter.

---

# 📚 Interview Preparation

### Q1. What is Software Architecture?

Software Architecture is the organized structure of an application where each component has a well-defined responsibility.

---

### Q2. Why should responsibilities be separated?

Separating responsibilities improves readability, maintainability, testing, and future enhancements.

---

### Q3. What is the Single Responsibility Principle?

A class or component should perform one primary responsibility only.

---

### Q4. Why should ApplicationService not manage student registration?

Because student registration belongs to StudentService, while ApplicationService should focus only on application-related operations.

---

### Q5. What are the advantages of good software architecture?

- Easier maintenance
- Better readability
- Reduced code duplication
- Improved scalability
- Simpler testing

---

# 📌 Key Takeaways

- Architecture should be designed before coding.
- Every component should have one responsibility.
- Service classes improve software organization.
- Business logic should remain separate from the user interface.
- Good architecture simplifies future changes.

---

# 📖 Chapter Summary

This chapter demonstrates that successful Salesforce applications are designed before they are developed.

Instead of immediately writing Apex code, developers should first understand:

- The business problem
- Software responsibilities
- Application architecture
- Service organization

Only after designing these components should implementation begin.

---

## ⭐ Repository Purpose

This README documents my learning from the **"Thinking Like an Architect"** chapter as part of my Salesforce Developer learning journey.

The chapter strengthened my understanding of software architecture, responsibility-driven design, and service-oriented application development within Salesforce.
