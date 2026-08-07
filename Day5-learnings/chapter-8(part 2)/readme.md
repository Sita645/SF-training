# Chapter 8 – Part II: Engineering Sprint
# Designing Asynchronous Workflows That Remain Reliable

## 📖 Overview

Part II focuses on applying **Asynchronous Apex** concepts to real-world Salesforce business scenarios. Instead of learning Future, Queueable, Batch, and Scheduled Apex separately, this sprint emphasizes **choosing the correct execution model based on business requirements** and designing reliable, maintainable background processing. :contentReference[oaicite:0]{index=0}

---

# 🎯 Sprint Objective

The objective of this sprint is to learn how to design enterprise-grade asynchronous workflows by:

- Separating immediate work from background work.
- Building Queueable Apex jobs.
- Understanding legacy Future Methods.
- Implementing Queueable chaining.
- Processing large datasets using Batch Apex.
- Scheduling recurring business processes.
- Monitoring asynchronous jobs.
- Designing reliable background systems.
- Defending architectural decisions during interviews. :contentReference[oaicite:1]{index=1}

---

# Engineering Principle

> **"Moving work to the background is easy. Designing background work that remains understandable, testable and reliable is engineering."** :contentReference[oaicite:2]{index=2}

The goal is **not** to learn four different Apex features.

The goal is to answer:

> **Why did you choose this asynchronous mechanism?**

---

# Topics Covered

---

# 1. Transaction Boundary

The first engineering decision is identifying which work must happen immediately and which work can happen later.

Example:

```
Student Accepts Offer
        │
        ▼
Validate Offer
        │
Update Offer
        │
Update Student
        │
Return Confirmation

------------------------------

Background Processing

• External Synchronisation
• Notification Processing
• Analytics
```

Key Learning:

- Protect the user transaction.
- Keep only essential work in the synchronous transaction.
- Move secondary work to the background. :contentReference[oaicite:3]{index=3}

---

# 2. Queueable Apex Design

Business Requirement:

After a student accepts an offer, Salesforce should:

- Return confirmation immediately.
- Perform secondary processing in the background.

Engineering Concepts:

- Queue background work.
- Pass only the required information.
- Keep one responsibility per Queueable class.
- Maintain bulk-safe SOQL and DML.

Example architecture:

```
Accept Offer
      │
Validate
      │
Save Changes
      │
System.enqueueJob()
      │
Return Confirmation

↓

Queueable Apex
```

Key Principle:

> Pass only the required state (such as `offerId`) instead of unnecessary data. :contentReference[oaicite:4]{index=4}

---

# 3. Legacy Future Methods

The sprint introduces an existing Future Method and discusses whether it should be replaced.

Important Learning:

- Existing Future Methods are not automatically wrong.
- Understand the current implementation first.
- Replace only when there is a genuine technical or business reason.

Professional developers maintain existing systems safely instead of rewriting everything. :contentReference[oaicite:5]{index=5}

---

# 4. Queueable Chaining

As business workflows grow, one Queueable job may trigger another.

Example:

```
Offer Accepted
      │
Queue Job A
      │
External Synchronisation
      │
Success
      │
Queue Job B
      │
Notification Preparation
```

Discussion Points:

- What if Job A fails?
- Should Job B execute?
- What happens if the process starts twice?
- How should duplicate processing be prevented?

The sprint introduces the concept of **Queueable chaining** and emphasizes responsibility separation. :contentReference[oaicite:6]{index=6}

---

# 5. Idempotency

Background jobs may execute more than once.

Questions to consider:

- Could duplicate records be created?
- Could duplicate notifications be sent?
- Could statistics be counted twice?

The sprint introduces **Idempotency**.

Definition:

> Can the same operation execute multiple times without producing an incorrect business outcome?

Possible solutions discussed:

- External identifiers
- Synchronisation status
- Transaction references
- Existing record validation :contentReference[oaicite:7]{index=7}

---

# 6. Batch Apex

Business Requirement:

Process 120,000 historical application records safely.

Engineering Process:

### Start

Select only the required records.

Example:

```
Placement_Category__c = NULL
```

### Execute

Salesforce processes records in smaller scopes.

```
120000 Records

↓

Small Batch

↓

Process

↓

Next Batch
```

### Finish

Perform completion activities:

- Notify administrator
- Generate summary
- Start another process

Important Principle:

- Never perform DML inside loops.
- Bulkification remains essential. 

---

# 7. Batch Size Engineering

The sprint explains that there is **no universal batch size**.

Batch size depends on:

- Query complexity
- CPU usage
- Heap usage
- DML operations
- Callouts
- Business logic
- Related records

Professional answer:

> "It depends upon the workload." :contentReference[oaicite:9]{index=9}

---

# 8. Scheduled Apex

Business Requirement:

Every morning:

- Find expired jobs.
- Update their status.

Simple Architecture:

```
6:00 AM

↓

Scheduled Apex

↓

Process Jobs
```

For large datasets:

```
Scheduled Apex

↓

Batch Apex

↓

Large Dataset Processing
```

Responsibilities:

- Scheduled Apex → WHEN
- Batch Apex → HOW
- Service Layer → BUSINESS RULES

Clean architecture separates responsibilities. :contentReference[oaicite:10]{index=10}

---

# 9. Monitoring Background Jobs

Background processing requires monitoring.

Developers should know:

- Was the job submitted?
- Is it waiting?
- Is it running?
- Did it complete?
- Did it fail?
- Were errors encountered?

Salesforce provides monitoring through:

- AsyncApexJob

Engineering Principle:

Reliable systems must be observable. :contentReference[oaicite:11]{index=11}

---

# 10. Error Handling

Enterprise systems must plan for failure.

Possible failures:

- Network issues
- External service failures
- Data inconsistencies
- Governor Limit exceptions
- Record conflicts

Professional developers ask:

> What should the business experience when this process fails?

The sprint introduces **partial success** using concepts such as:

```apex
Database.update(records, false);
```

while emphasizing that partial success should only be used when it matches the business rule. :contentReference[oaicite:12]{index=12}

---

# 11. Architecture Review

The sprint reviews poor asynchronous designs.

Examples:

❌ Batch Apex for immediate validation

❌ Future Method for 300,000 records

❌ Scheduled Apex directly processing huge datasets

❌ One Queueable class performing many unrelated responsibilities

❌ Moving inefficient code into Queueable without fixing the underlying design

The lesson:

> Technology should follow business requirements, not replace good engineering. :contentReference[oaicite:13]{index=13}

---

# Engineering Principles Learned

- Protect the user transaction.
- Separate synchronous and asynchronous work.
- Keep Queueable classes focused on one responsibility.
- Think about retries and duplicate execution.
- Design for monitoring and failure handling.
- Batch size is an engineering decision.
- Scheduled Apex defines **when** work happens.
- Batch Apex defines **how** large datasets are processed.
- Asynchronous Apex still requires bulkification and Governor Limit awareness. :contentReference[oaicite:14]{index=14}

---

# Interview Preparation

Expected Questions:

- Why should work be moved to the background?
- What is a transaction boundary?
- Why pass only `offerId` to Queueable Apex?
- Should every Future Method be replaced?
- What is Queueable chaining?
- What is Idempotency?
- Explain Batch Apex lifecycle.
- How do you choose Batch size?
- Why combine Scheduled Apex with Batch Apex?
- How do you monitor asynchronous jobs?
- What happens when an asynchronous job fails?
- What is partial success?
- Why doesn't asynchronous Apex eliminate Governor Limits?
- How would you design a reliable asynchronous architecture? :contentReference[oaicite:15]{index=15}

---

# Key Takeaways

- Choose asynchronous mechanisms based on business workload.
- Protect user experience by separating immediate and secondary work.
- Queueable Apex is suitable for structured background processing.
- Existing Future Methods should be evaluated before replacement.
- Batch Apex processes large datasets efficiently.
- Scheduled Apex initiates time-based business processes.
- Background systems require monitoring, retries, and error handling.
- Professional Salesforce developers justify architectural decisions instead of simply naming Apex features. :contentReference[oaicite:16]{index=16}

---

# Status

✅ Chapter 8 – Part II Completed

### Next Chapter

**Chapter 9 – Lightning Web Components (LWC)**

In the next sprint, the focus moves from server-side Apex to building interactive user interfaces using HTML, JavaScript, and Salesforce data. :contentReference[oaicite:17]{index=17}
