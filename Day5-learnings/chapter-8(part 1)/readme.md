# Chapter 8 – Teaching Software to Work in the Background (Part I)

## Sprint 8 – Asynchronous Apex

### 📖 Overview

This chapter introduces the concept of **Asynchronous Apex** and explains how Salesforce performs background processing to improve application responsiveness. The focus is not only on learning the different asynchronous mechanisms but also on understanding **when** each one should be used based on business requirements.

The key engineering principle is:

> **"Good software does the right work. Great software also understands when that work should happen."** :contentReference[oaicite:0]{index=0}

---

## 🎯 Learning Outcomes

By completing this chapter, I learned to:

- Understand synchronous and asynchronous processing.
- Identify business operations that should execute in the background.
- Explain Future Methods, Queueable Apex, Batch Apex, and Scheduled Apex.
- Select the appropriate asynchronous mechanism based on business requirements.
- Understand why Queueable Apex is generally preferred over Future Methods for new development.
- Understand how large data volumes influence architectural decisions.
- Recognize that asynchronous processing still follows Governor Limits.
- Explain asynchronous Apex concepts confidently for Salesforce interviews. :contentReference[oaicite:1]{index=1}

---

# Topics Covered

## 1. Synchronous Processing

Learned how synchronous processing works:

```
User Request
      ↓
Business Logic
      ↓
Validation
      ↓
DML Operation
      ↓
Response
```

- User waits until the transaction completes.
- Best for operations requiring immediate feedback.

Example:

- Student submits an application.
- Eligibility validation.
- Duplicate checking.
- Record creation.

---

## 2. Asynchronous Processing

Learned when work should happen later instead of blocking the user.

```
User Request
      ↓
Essential Work
      ↓
Response

Background Processing
      ↓
Continues Later
```

Examples:

- Sending emails
- External integrations
- Analytics
- Audit creation

---

## 3. Future Methods

Purpose:

Execute simple background work after the current transaction completes.

Characteristics:

- Uses `@future`
- Static methods
- Executes asynchronously
- Common in existing Salesforce applications

Typical Use Cases:

- External API communication
- Sending notifications
- Background updates

---

## 4. Queueable Apex

Purpose:

Provide a richer, structured background job model.

Characteristics:

- Implements `Queueable`
- Supports structured background processing
- Suitable for more complex asynchronous workflows

Typical Use Cases:

- Background processing
- Multiple business operations
- Controlled job execution

---

## 5. Future vs Queueable

The chapter emphasizes choosing based on **business requirements**, not technology.

General guidance:

| Requirement | Suggested Direction |
|-------------|---------------------|
| Existing simple asynchronous code | Future Method |
| New structured background processing | Queueable Apex |
| Need controlled background jobs | Queueable Apex |
| Very large datasets | Batch Apex |
| Time-based execution | Scheduled Apex |

---

## 6. Batch Apex

Purpose:

Process very large datasets efficiently.

Architecture:

```
START
   ↓
EXECUTE
   ↓
FINISH
```

Responsibilities:

- **start()** → Identify records
- **execute()** → Process each batch
- **finish()** → Completion activities

Suitable for:

- Large-volume processing
- Historical data updates
- Bulk record operations

---

## 7. Scheduled Apex

Purpose:

Execute business logic automatically at a specified time.

Example:

```
6:00 AM
    ↓
Scheduled Apex
    ↓
Business Logic
```

Typical Use Cases:

- Daily maintenance
- Expired record processing
- Scheduled reports

---

## 8. Combining Asynchronous Mechanisms

Enterprise applications often combine multiple asynchronous tools.

Example:

```
Scheduled Apex
       ↓
Starts Batch Apex
       ↓
Processes Large Dataset
       ↓
Finish
```

The chapter highlights that real-world Salesforce applications frequently combine different asynchronous mechanisms to solve business problems effectively. :contentReference[oaicite:2]{index=2}

---

# Key Engineering Principles

- Choose technology based on the business requirement.
- Not every task should execute immediately.
- Separate essential work from secondary work.
- Queueable Apex provides a richer job-oriented approach.
- Large datasets require Batch Apex.
- Time-driven processes require Scheduled Apex.
- Asynchronous processing does **not** remove Governor Limits.
- Bulkification and good architecture remain essential. 

---

# Interview Preparation

Important Questions:

- What is synchronous processing?
- What is asynchronous processing?
- Why use asynchronous Apex?
- What is a Future Method?
- What is Queueable Apex?
- Difference between Future and Queueable?
- What is Batch Apex?
- Explain start(), execute(), and finish().
- What is Scheduled Apex?
- Can Scheduled Apex and Batch Apex work together?
- Why doesn't asynchronous Apex remove Governor Limits?
- How do you choose the correct asynchronous mechanism?

---

# Key Takeaways

- Understand **when** work should happen, not just **how** to execute it.
- Use synchronous processing for immediate user responses.
- Use asynchronous processing for secondary work.
- Future Methods are common in existing systems.
- Queueable Apex is preferred for structured new background jobs.
- Batch Apex handles large-volume processing.
- Scheduled Apex executes time-based operations.
- Good architecture depends on selecting the right asynchronous mechanism for each business requirement.

---

## Status

✅ Chapter 8 – Part I Completed

**Next:** Engineering Sprint 8 – Asynchronous Workflows (Part II)
