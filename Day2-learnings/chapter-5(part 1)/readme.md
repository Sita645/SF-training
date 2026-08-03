# 📘 Chapter 5 – Part I: Making Software Talk to Data
### Sprint 5 – Retrieving and Managing Information with SOQL

> **"Business decisions are only as good as the information available to make them."**

---

## 🎯 Sprint Objective

In this sprint, I learned how Salesforce applications retrieve information before making business decisions. The focus is on understanding **SOQL (Salesforce Object Query Language)** and why enterprise applications must access the correct data before executing business logic.

---

## 📚 Learning Outcomes

By completing Part I, I understood how to:

- Understand why enterprise applications retrieve data before making decisions.
- Learn the role of **SOQL** in Salesforce.
- Recognize the importance of retrieving only the required information.
- Think of data as a valuable business asset instead of simple database records.
- Identify the information required before implementing business logic.
- Improve problem-solving by asking business-focused questions.

---

# 🏢 Business Scenario

The Placement Management System already validates business rules such as:

- Student eligibility
- Duplicate applications
- Application deadlines

However, the software cannot validate these rules unless it first retrieves the required information from Salesforce.

Example:

When a student clicks **Apply**, the system must first retrieve:

- Student CGPA
- Branch
- Active Backlogs
- Job Eligibility
- Application Deadline
- Existing Applications

Only after retrieving this information can the system decide whether the student is eligible.

---

# 🔍 What is SOQL?

**SOQL (Salesforce Object Query Language)** is used to retrieve records from Salesforce.

Instead of thinking of SOQL as a query language, think of it as **asking Salesforce business questions**.

Example business questions:

- What is this student's CGPA?
- Has the student already applied?
- Which jobs are currently open?
- Which students satisfy the eligibility criteria?

Every SOQL query should answer one business question.

---

# 💡 Engineering Principles Learned

## 1. Retrieve First, Decide Later

Enterprise software follows this sequence:

```text
Retrieve Information
        ↓
Apply Business Logic
        ↓
Make Decision
```

Business logic cannot execute without the required information.

---

## 2. Think Before Writing SOQL

Professional developers never start with code.

Instead, they ask:

> **"What information do I need before making this decision?"**

Only then do they write the SOQL query.

---

## 3. Data Represents Business Value

A Salesforce record is more than just stored information.

For example:

- A Student record represents a student's career.
- A Job record represents an employment opportunity.
- An Application represents a student's future.

Good developers respect business data because it impacts real-world decisions.

---

## 4. Every Query Has a Purpose

Before writing a SOQL query, ask:

> **"Why am I retrieving this information?"**

If the query does not answer a business question, it probably shouldn't exist.

---

# 🧠 Business Questions Before Writing SOQL

Before implementing any query, identify:

- Which Salesforce Object contains the information?
- Which Fields are required?
- Which Record should be retrieved?

Example:

| Business Question | Object |
|-------------------|--------|
| Student CGPA | Student |
| Application Deadline | Job |
| Duplicate Application | Application |

---

# 📌 Key Takeaways

- Retrieve information before making decisions.
- SOQL retrieves records from Salesforce.
- Every query should answer one business question.
- Understand business requirements before writing code.
- Retrieve only the information required for the current operation.
- Think like a consultant before thinking like a programmer.

---

# 📖 Sprint Summary

During Part I of Sprint 5, I learned that enterprise software first retrieves business information before making decisions. I understood how **SOQL** acts as the communication bridge between Apex and Salesforce data, enabling applications to retrieve accurate information for implementing business rules.

---

## 🚀 Next Learning

➡️ **Chapter 5 – Part II: From Information to Action (Understanding DML)**
