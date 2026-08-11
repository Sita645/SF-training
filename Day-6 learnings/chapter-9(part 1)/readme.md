# Chapter 9 – Bringing Business Logic to Life

## Sprint 9 – Building User Experiences with Lightning Web Components (LWC)

This chapter focuses on building user experiences in Salesforce using **Lightning Web Components (LWC)**. The main idea is to connect the business logic developed in previous sprints with a simple, interactive user interface. 

---

## 📚 What I Learned

### 1. Role of LWC

* LWC is used to build user interfaces in Salesforce.
* Components should represent **user capabilities**, not just technical code.
* The UI should hide complex Salesforce architecture from users.
* Start with the **user's requirement**, then design the component. 

### 2. User-Centered Component Design

Before creating an LWC, identify:

> **"The user needs to ______."**

Examples:

* View eligible jobs
* View job details
* Apply for a job
* View application status
* View interview schedule
* View offers

A component should have **one clear responsibility**. 

---

## 🧩 LWC Structure

A basic LWC commonly contains:

```text
eligibleJobs/
├── eligibleJobs.html
├── eligibleJobs.js
└── eligibleJobs.js-meta.xml
```

### HTML

Responsible for:

* UI structure
* Headings
* Buttons
* Forms
* Cards
* Lists
* Input fields
* Messages

### JavaScript

Responsible for:

* Component behaviour
* State
* User interactions
* Event handling
* Preparing data
* Calling functionality

### Metadata XML

Responsible for:

* Defining where the component can be used
* Controlling component exposure in Salesforce

**Key principle:** Every file should have a clear responsibility. 

---

## 🚀 Build the Smallest Working Version

The chapter emphasizes incremental development:

```text
Create Component
      ↓
Make It Render
      ↓
Add One Capability
      ↓
Test
      ↓
Add Another Capability
      ↓
Test Again
```

Don't implement data retrieval, filtering, navigation, buttons, notifications, and styling all at once. 

---

## 🔗 Data Binding

Data binding connects JavaScript data with the HTML template.

Example:

```javascript
studentName = 'Ananya';
```

```html
<p>Welcome, {studentName}</p>
```

Conceptually:

```text
JavaScript
    ↓
Component State
    ↓
HTML Template
    ↓
User Interface
```

LWC uses a reactive rendering model so the displayed interface can respond when relevant component state changes. 

---

## 🖱️ Events & User Interaction

Users interact with components through:

* Click
* Type
* Select
* Submit
* Cancel

These actions generate **events**.

Example:

```html
<lightning-button
    label="View Details"
    onclick={handleViewDetails}>
</lightning-button>
```

```javascript
handleViewDetails() {
    // Respond to user's action
}
```

The interaction cycle is:

```text
Software Displays Information
          ↓
User Takes Action
          ↓
Event Occurs
          ↓
Component Responds
          ↓
Screen Changes
```

Events transform a static page into an interactive application. 

---

## 🗄️ Salesforce Data in LWC

Hard-coded data is useful for initial development, but real applications need Salesforce data.

Before writing custom Apex, ask:

> **Can the Salesforce platform already provide what I need?**

This leads to **Lightning Data Service (LDS)** and the **Wire Service**. 

### Lightning Data Service

LDS provides framework-supported ways to work with Salesforce records without requiring custom Apex for every basic operation.

It helps with:

* Record access
* Caching
* Data consistency
* Standard record operations

**Important lesson:** Don't write custom code for something Salesforce already handles effectively. 

---

## 🔌 Wire Service

The Wire Service provides a reactive way for an LWC to receive data.

Conceptually:

```text
Salesforce Data
      ↓
     Wire
      ↓
  Component
      ↓
   Template
```

Example concept from the chapter:

```javascript
import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class StudentSummary extends LightningElement {
    @api recordId;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [
            'Student__c.Name',
            'Student__c.CGPA__c'
        ]
    })
    student;
}
```

The important mental model is:

```text
Record Id
    ↓
Salesforce
    ↓
Student Data
    ↓
Component
    ↓
Screen
```

The chapter emphasizes understanding the **data flow** rather than simply memorizing syntax. 

---

## ⚙️ When Apex Is Required

Apex becomes useful when the UI requires **business logic**, not simply basic record retrieval.

For example, displaying eligible jobs may require:

* Student CGPA
* Student Branch
* Active Backlogs
* Job Criteria
* Application Deadline
* Existing Applications

Architecture:

```text
Eligible Jobs LWC
        ↓
Apex Controller / Service
        ↓
Business Logic
        ↓
SOQL
        ↓
Salesforce Data
```

The LWC should **not recreate business rules** that already exist in the service layer. 

---

## 🏗️ Layered Architecture

The chapter defines the responsibilities as:

| Layer                             | Responsibility                       |
| --------------------------------- | ------------------------------------ |
| **LWC**                           | User interaction                     |
| **Apex Controller / Entry Point** | Connect UI to server-side capability |
| **Service**                       | Business rules                       |
| **Data Access**                   | Retrieve/manage information          |
| **Salesforce**                    | Persist business data                |

Overall flow:

```text
User
 ↓
LWC
 ↓
Apex
 ↓
Service
 ↓
SOQL / DML
 ↓
Salesforce Database
```

### Key Principle

> **The UI Should Not Become the Business Layer.**

Business rules should remain in reusable server-side/service logic so that APIs, batch jobs, and other entry points can use the same rules. 

---

## 🔄 LWC Lifecycle

LWC components have different stages during their lifetime.

Important lifecycle hooks:

```text
constructor()
connectedCallback()
renderedCallback()
disconnectedCallback()
```

### `constructor()`

Component is being created.

### `connectedCallback()`

Component has been inserted into the DOM.

### `renderedCallback()`

Component has rendered.

### `disconnectedCallback()`

Component is removed.

The important interview concept is not just memorizing the names, but understanding **when a particular operation should happen**. 

---

# 🎯 Main Practical Task – Eligible Jobs Component

The first meaningful LWC for the Placement Management System is:

### **Eligible Jobs Component**

The student should be able to:

* Open the component
* View eligible jobs
* See important job information
* Select a job
* View job details

The **Apply** functionality is intentionally postponed to Part II. 

### User Story

> As a student, I want to view jobs for which I am eligible so that I can identify suitable placement opportunities.

Before coding, define:

* User Story
* Required Data
* Component Responsibility
* Server Responsibility
* Business Rules
* Screen Design



---

# 🛠️ Engineering Sprint – Build Eligible Jobs

### Stage 1

Create the component.

```text
Eligible Jobs
```

Deploy and verify.

### Stage 2

Display one hard-coded job card.

### Stage 3

Move hard-coded values into JavaScript properties and bind them to the template.

### Stage 4

Represent and render multiple jobs.

### Stage 5

Retrieve real Salesforce data.

### Stage 6

Connect the component to the existing eligibility logic.

Each stage should be implemented and verified before moving to the next. 

---

# ✅ Definition of Done

Before considering the component complete:

* [x] One clear component responsibility
* [x] No unnecessary duplication of business rules in JavaScript
* [x] Data retrieved intentionally
* [x] Meaningful variable and method names
* [x] User actions handled clearly
* [x] Loading behaviour considered
* [x] Empty data considered
* [x] Error behaviour considered
* [x] Component understandable by another developer



---

# 🖥️ Four UI States

A professional data-driven component should not only handle the success case.

It should consider:

```text
┌─────────┐
│ LOADING │
└─────────┘

┌─────────┐
│ SUCCESS │
└─────────┘

┌─────────┐
│  EMPTY  │
└─────────┘

┌─────────┐
│  ERROR  │
└─────────┘
```

### Loading

What should the student see while data is being retrieved?

### Success

Jobs are available and displayed.

### Empty

No eligible jobs exist. Show a helpful user-friendly message instead of simply displaying `"0 records returned."`

### Error

Something went wrong. Technical details should not unnecessarily be exposed to the user.

The chapter emphasizes that good interfaces are designed for **failure and empty states**, not only the happy path. 

---

# 💡 Key Engineering Principles

### 1. Start With the User

Understand what the user needs before choosing technology.

### 2. Components Represent Capabilities

A component should answer:

> **What can the user accomplish here?**

### 3. Every File Has a Responsibility

HTML, JavaScript, and metadata should each have clear roles.

### 4. Build Incrementally

Create → Test → Extend → Test again.

### 5. Use Platform Capabilities

Use LDS and supported wire mechanisms before writing unnecessary Apex.

### 6. Keep Business Logic Out of UI

LWC handles interaction; Apex/service layers handle business rules.

### 7. Understand Component Timing

Know when initialization, rendering, and cleanup happen.

### 8. Design Beyond the Happy Path

Always consider:

**Loading → Success → Empty → Error**

---

# 🎤 Interview Preparation

After completing this chapter, I should be able to explain:

* What is LWC?
* Why is LWC used in Salesforce?
* What are the main files in an LWC?
* What is the responsibility of HTML in LWC?
* What is the responsibility of JavaScript?
* What is the metadata XML file?
* What is data binding?
* What are events in LWC?
* What is Lightning Data Service?
* What is the Wire Service?
* When should Apex be used with LWC?
* Why shouldn't business logic be placed in JavaScript?
* What is the LWC lifecycle?
* What are `constructor()`, `connectedCallback()`, `renderedCallback()`, and `disconnectedCallback()`?
* How does LWC communicate with Apex?
* Why are loading, empty, success, and error states important?
* How would you design an Eligible Jobs component?

---

# 🧠 Chapter 9 Takeaway

The most important lesson from this chapter is:

```text
User Requirement
       ↓
User Experience
       ↓
Component Design
       ↓
LWC
       ↓
Apex / Service
       ↓
SOQL / DML
       ↓
Salesforce Database
```

**LWC is not just HTML + JavaScript. It is the layer that turns the business capabilities built in Salesforce into experiences that users can actually use.** 

---

## 📁 Suggested GitHub Structure

```text
Chapter-9-Bringing-Business-Logic-to-Life/
│
├── README.md
│
├── Part-1-LWC/
│   ├── eligibleJobs/
│   │   ├── eligibleJobs.html
│   │   ├── eligibleJobs.js
│   │   └── eligibleJobs.js-meta.xml
│   │
│   └── notes.md
│
└── screenshots/
```

**Chapter 9 Part I completed:** LWC fundamentals, component architecture, data binding, events, LDS, Wire Service, Apex integration, lifecycle, Eligible Jobs component design, and professional UI states.
