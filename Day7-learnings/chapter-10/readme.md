
# Chapter 10 — Building Components That Think Together

## Salesforce Placement Management System

This chapter focuses on building **well-structured Lightning Web Components (LWC)** that work together as a complete application instead of creating one large component.

The main idea is:

> **Focused Components + Clear Communication = One Coherent Application**

The chapter takes the Student Placement Portal from individual components to a connected application workflow.

---

# 📚 Table of Contents

- [Chapter Overview](#chapter-overview)
- [Learning Objectives](#learning-objectives)
- [Component Architecture](#component-architecture)
- [Parent-to-Child Communication](#parent-to-child-communication)
- [Child-to-Parent Communication](#child-to-parent-communication)
- [Data Ownership](#data-ownership)
- [Events in LWC](#events-in-lwc)
- [Reactive Data and Refresh](#reactive-data-and-refresh)
- [Loading, Empty and Error States](#loading-empty-and-error-states)
- [Reusable Components](#reusable-components)
- [Empty State Component](#empty-state-component)
- [Avoiding God Components](#avoiding-god-components)
- [JobCard Component](#jobcard-component)
- [Student Profile Integration](#student-profile-integration)
- [Apply Workflow](#apply-workflow)
- [Imperative Apex](#imperative-apex)
- [Server-Side Business Validation](#server-side-business-validation)
- [Success and Failure Handling](#success-and-failure-handling)
- [Engineering Sprints](#engineering-sprints)
- [Final Application Flow](#final-application-flow)
- [Definition of Done](#definition-of-done)
- [Repository Structure](#repository-structure)
- [Important LWC Concepts](#important-lwc-concepts)
- [Interview Questions](#interview-questions)
- [Key Takeaways](#key-takeaways)

---

# 📖 Chapter Overview

A Salesforce application should not be designed as one huge Lightning Web Component.

As the Placement Management System grows, it contains different capabilities such as:

- Student Summary
- Student Profile
- Eligible Jobs
- Job Details
- Job Card
- Applications
- Application Card
- Offer Summary
- Status indicators
- Empty states

Each component should have a **clear responsibility**.

The architecture developed in this chapter is:

```text
StudentPortal
│
├── StudentSummary
│
├── StudentProfile
│
├── EligibleJobs
│   ├── JobCard
│   └── EmptyState
│
├── MyApplications
│   ├── ApplicationCard
│   └── EmptyState
│
└── OfferSummary
    └── StatusBadge
````

The parent coordinates the application while child components handle focused responsibilities.

---

# 🎯 Learning Objectives

After completing this chapter, you should understand:

* How to divide a large LWC into meaningful components
* Parent-to-child communication
* Child-to-parent communication
* `@api` properties
* Custom events
* Data ownership
* Component state
* Loading states
* Empty states
* Error states
* Reusable components
* Imperative Apex
* Server-side business validation
* Application submission flow
* Refreshing dependent components
* Component architecture
* Complete user workflow design

---

# 🏗️ Component Architecture

A good LWC application consists of multiple focused components.

Instead of:

```text
StudentPortal
    ↓
Everything
    ↓
Apex
```

we build:

```text
StudentPortal
│
├── StudentSummary
├── StudentProfile
├── EligibleJobs
│   └── JobCard
└── MyApplications
    └── ApplicationCard
```

Each component owns a specific responsibility.

For example:

| Component         | Responsibility                              |
| ----------------- | ------------------------------------------- |
| `StudentPortal`   | Coordinates major sections                  |
| `StudentProfile`  | Displays and updates student information    |
| `EligibleJobs`    | Retrieves and manages eligible jobs         |
| `JobCard`         | Displays one job                            |
| `EmptyState`      | Displays meaningful empty-state information |
| `MyApplications`  | Displays student applications               |
| `ApplicationCard` | Displays one application                    |
| `StatusBadge`     | Displays reusable status information        |

The chapter emphasizes that components should have a **clear responsibility and clear relationship with other components**.

---

# 🔄 Parent-to-Child Communication

Parent-to-child communication is used when:

```text
Parent
   │
   │ Data
   ↓
Child
```

In LWC, public properties are exposed using:

```javascript
@api
```

Example:

```javascript
import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {

    @api job;

}
```

The parent can provide the Job record:

```html
<c-job-card
    job={job}>
</c-job-card>
```

The child receives the information and displays it.

---

# 📌 Why Parent-to-Child Communication Matters

Suppose the parent already has:

```text
Job Id
Company
Role
Package
Location
Deadline
```

There is usually no need for the child to independently retrieve the same record.

Instead:

```text
Salesforce
    ↓
Parent
    ↓
Child
```

This makes data ownership clearer and can avoid unnecessary retrieval.

---

# 🔁 Child-to-Parent Communication

The reverse direction is:

```text
Child
   │
   │ Custom Event
   ↓
Parent
```

A child should not directly modify the parent's state.

For example, a `JobCard` may contain:

```text
[ View Details ]
```

When the student clicks it, the child sends an event.

Example:

```javascript
handleViewDetails() {

    this.dispatchEvent(
        new CustomEvent('viewdetails', {
            detail: {
                jobId: this.job.Id
            }
        })
    );

}
```

The parent listens:

```html
<c-job-card
    job={job}
    onviewdetails={handleViewDetails}>
</c-job-card>
```

The parent then handles the action.

---

# 📡 Custom Events

Custom events provide a clean communication mechanism between child and parent.

The pattern is:

```text
User Action
    ↓
Child Event Handler
    ↓
Custom Event
    ↓
Parent
    ↓
Business Action
```

Example:

```javascript
this.dispatchEvent(
    new CustomEvent('apply', {
        detail: {
            jobId: this.job.Id
        }
    })
);
```

The parent can receive the event:

```javascript
handleApply(event) {

    const jobId = event.detail.jobId;

}
```

---

# 🧠 Data Ownership

A major architectural question is:

> Which component owns the data?

For example:

```text
EligibleJobs
```

may own:

```javascript
jobs = [];
```

The `JobCard` does not need to independently retrieve the complete job list.

Instead:

```text
EligibleJobs
     ↓
JobCard
```

The parent owns the list and passes the required information to the child.

---

# 🔄 Reactive Data and Refresh

One important problem in a real application is stale data.

Example:

```text
Student changes CGPA
        ↓
Student record updated
        ↓
Eligible Jobs still shows old results
```

The Salesforce data may be correct while the UI is stale.

The application therefore needs an appropriate refresh strategy.

Possible approaches include:

* Parent-owned state
* Custom events
* Refreshing wired data
* Lightning Data Service notifications
* Reactive updates
* Re-querying data when genuinely necessary

The correct approach depends on the application's architecture.

---

# 👤 Student Profile → Eligible Jobs

The desired flow is:

```text
Student Profile
      ↓
Student Record Changes
      ↓
Student Summary Refreshes
      ↓
Eligible Jobs Refreshes
```

This ensures that eligibility is based on the student's latest information.

---

# ⏳ Loading, Empty and Error States

A polished Salesforce application should communicate its current state.

For forms and data retrieval, consider:

```text
Loading
Editing
Saving
Success
Error
```

Example:

### Loading

```text
Loading your profile...
```

### Editing

```text
Normal form
```

### Saving

```text
Saving...
```

### Success

```text
Profile updated successfully.
```

### Error

```text
We could not update your profile.
Please review the highlighted fields.
```

The user should never have to guess what the application is doing.

---

# ♻️ Reusable Components

Reusable components should provide a meaningful capability.

Good examples:

```text
jobCard
statusBadge
applicationStatus
emptyState
loadingIndicator
```

Avoid meaningless abstractions such as:

```text
smallBlueBox
tinySection
randomContainer
```

The principle is:

> **Reuse Behaviour, Not Just Markup**

Reuse reduces duplication, but unnecessary abstraction can create additional complexity.

---

# 🧩 Empty State Component

The Eligible Jobs page needs a useful empty state.

Instead of:

```text
No records found.
```

the application can display:

```text
No Eligible Jobs

No eligible opportunities are available right now.
Keep your profile updated and check again
as new companies are added.
```

The reusable component accepts:

* Title
* Message
* Optional Action Label

Example:

```html
<c-empty-state
    title="No Eligible Jobs"
    message="Check again when new opportunities are added.">
</c-empty-state>
```

---

# 📄 Empty State Component API

Example JavaScript:

```javascript
import { LightningElement, api } from 'lwc';

export default class EmptyState extends LightningElement {

    @api title;

    @api message;

    @api actionLabel;

}
```

The parent can therefore control the content.

Example:

```html
<c-empty-state
    title="No Eligible Jobs"
    message="No eligible opportunities are available right now."
    action-label="Update Profile">
</c-empty-state>
```

---

# 🔘 Optional Empty State Action

The child can notify the parent when its action button is clicked.

Child:

```javascript
handleAction() {

    this.dispatchEvent(
        new CustomEvent('action')
    );

}
```

Parent:

```html
<c-empty-state
    title="No Eligible Jobs"
    message="Check again later."
    action-label="Update Profile"
    onaction={handleEmptyStateAction}>
</c-empty-state>
```

Communication:

```text
Child
  ↓
Custom Event
  ↓
Parent
```

---

# ⚠️ Avoiding a God Component

A dangerous architecture is:

```text
StudentPortal
     ↓
Everything
     ↓
Apex
     ↓
Everything
```

The parent may eventually contain:

* All data retrieval
* All state
* All events
* All business logic
* All UI conditions
* All child control

This becomes a **God Component**.

It may work initially but becomes difficult to maintain as the application grows.

---

# ✅ Better Architecture

Instead:

```text
StudentPortal
│
├── StudentSummary
│
├── StudentProfile
│
├── EligibleJobs
│   └── JobCard
│
└── MyApplications
    └── ApplicationCard
```

The parent coordinates.

Children have focused responsibilities.

Communication is explicit.

---

# 💼 JobCard Component

The JobCard represents one meaningful business concept.

It can display:

```text
Company
Job Title
Location
Package
Minimum CGPA
Maximum Backlogs
Application Deadline
```

Example:

```text
Associate Developer

Location: Hyderabad
Package: 8.5 LPA
Minimum CGPA: 7.0
Maximum Backlogs: 0
Application Deadline: 2026-08-20

[ View Details ] [ Apply ]
```

The parent can pass the Job record:

```html
<c-job-card
    job={job}>
</c-job-card>
```

---

# 👨‍🎓 Student Profile

The Student Profile component is responsible for displaying and updating student information.

Typical fields include:

```text
Student Name
Student ID
Department
Email
CGPA
Active Backlogs
Batch Year
```

The profile component should handle:

```text
Load Profile
      ↓
Display Profile
      ↓
Edit Profile
      ↓
Validate
      ↓
Save
      ↓
Success / Error
```

---

# 🔗 Student Profile and Eligibility

Eligibility depends on current student information.

For example:

```text
Student CGPA = 8.2
Active Backlogs = 0
```

Job requirements:

```text
Minimum CGPA = 7.0
Maximum Backlogs = 0
```

The student is eligible.

If the student updates the profile:

```text
CGPA = 6.5
```

the Eligible Jobs list should reflect the new information after the appropriate refresh.

---

# 📝 Apply Workflow

The Apply button connects several layers of the application.

The complete flow is:

```text
Student Clicks Apply
        ↓
LWC Receives Event
        ↓
JavaScript Identifies Job
        ↓
Apex Method Called
        ↓
ApplicationController
        ↓
ApplicationService
        ↓
Retrieve Student
        ↓
Retrieve Job
        ↓
Check Duplicate
        ↓
Validate Eligibility
        ↓
Create Job Application
        ↓
Trigger Automation
        ↓
Background Work if Required
        ↓
Return Result
        ↓
Update Screen
```

This is the central integration workflow of the chapter.

---

# 🎯 Business Logic Must Remain Server-Side

The LWC should not decide:

```text
CGPA >= required CGPA
```

or:

```text
Backlogs <= maximum backlogs
```

The UI should only request:

```text
Student wants to apply for this job.
```

The backend decides whether the request is valid.

This protects business rules across:

* LWC
* APIs
* Batch jobs
* Integrations
* Other future interfaces

---

# ⚡ Imperative Apex

Application submission is a deliberate user action.

Therefore, imperative Apex is appropriate.

Apex controller:

```apex
@AuraEnabled
public static Id submitApplication(Id jobId) {

    return ApplicationService.submitApplication(jobId);

}
```

LWC imports the method:

```javascript
import submitApplication
    from '@salesforce/apex/ApplicationController.submitApplication';
```

Then:

```javascript
async handleApply(event) {

    const jobId =
        event.target.dataset.jobId;

    try {

        const applicationId =
            await submitApplication({
                jobId: jobId
            });

        // Success

    } catch (error) {

        // Failure

    }

}
```

The architecture is:

```text
JavaScript
    ↓
Apex Controller
    ↓
ApplicationService
    ↓
Business Rules
```

---

# 🔄 Wire vs Imperative Apex

A useful mental model:

```text
Reactive Data Requirement
        ↓
      @wire
```

and:

```text
Explicit User Action
        ↓
Imperative Apex
```

Application submission is an explicit user action, so imperative Apex provides control over when the server operation occurs.

---

# ⏳ Apply States

The Apply workflow should have four important states.

## State 1 — Ready

```text
[ APPLY ]
```

## State 2 — Submitting

```text
Submitting...
```

## State 3 — Success

```text
✓ APPLICATION SUBMITTED
```

## State 4 — Failure

```text
Application could not be submitted.

<Useful explanation>
```

Every state should be tested deliberately.

---

# ✅ Success Experience

Do not only write:

```javascript
console.log('Success');
```

The student should receive clear feedback.

Example:

```text
Application submitted successfully.
```

or:

```text
✓ Application Submitted
```

The job card may also change to:

```text
APPLICATION SUBMITTED
```

Every user action should have a clear outcome.

---

# ❌ Failure Experience

Possible failures include:

```text
Deadline expired
Duplicate application
Eligibility changed
Server error
Network problem
```

Do not expose technical errors such as:

```text
System.NullPointerException
```

to the student.

Instead display meaningful messages such as:

```text
Applications for this job are now closed.
```

or:

```text
You have already applied for this opportunity.
```

or:

```text
We could not submit your application.
Please try again or contact the Placement Office.
```

---

# 🛡️ Error Handling Principle

There are two audiences for an error.

## User needs

```text
What happened?
What can I do next?
```

## Developer needs

```text
What failed?
Where?
Why?
What context helps investigation?
```

Never make the user interpret developer debugging information.

---

# 🏃 Engineering Sprints

## Sprint 27 — JobCard Communication

Implemented communication between:

```text
JobCard
   ↓
EligibleJobs
```

through custom events.

---

## Sprint 28 — Student Profile

Implemented the Student Profile component for viewing and updating student information.

---

## Sprint 29 — Consistent Student Experience

Connected profile changes with dependent UI.

The goal was:

```text
Profile Updated
      ↓
Student Record Changes
      ↓
Eligible Jobs Refresh
```

---

## Sprint 30 — Reusable Empty State

Created:

```text
emptyState
```

with:

```text
title
message
actionLabel
```

The component can be reused by different screens.

---

## Sprint 31 — Final Integration Challenge

Connected the major components into one complete application workflow.

The final journey is:

```text
Student Login
      ↓
Student Summary
      ↓
Update Profile
      ↓
Profile Saved
      ↓
Eligible Jobs Refresh
      ↓
Select Job
      ↓
Job Details
      ↓
Apply
      ↓
Application Created
      ↓
My Applications Refresh
      ↓
Student Sees New Status
```

---

# 🧪 Final Testing Scenarios

The following scenarios should be tested.

## Test 1 — Valid Student

```text
Enter valid Student Record ID
        ↓
Check Eligibility
        ↓
Eligible Jobs displayed
```

---

## Test 2 — No Eligible Jobs

```text
Enter valid Student
        ↓
Check Eligibility
        ↓
No eligible jobs
        ↓
Reusable EmptyState displayed
```

---

## Test 3 — Invalid Student

```text
Enter invalid Student ID
        ↓
Check Eligibility
        ↓
Error message
```

---

## Test 4 — Profile Update

```text
Load Profile
        ↓
Edit CGPA / Backlogs
        ↓
Save Profile
        ↓
Success
        ↓
Eligible Jobs refresh
```

---

## Test 5 — Apply

```text
Click Apply
        ↓
Submitting
        ↓
Application Created
        ↓
Success
```

---

## Test 6 — Duplicate Application

```text
Apply
   ↓
Application Created

Apply again
   ↓
Duplicate Error
```

Expected user-facing result:

```text
You have already applied for this opportunity.
```

---

## Test 7 — Expired Job

```text
Job Deadline Passed
        ↓
Apply
        ↓
Application rejected
```

The student should receive a meaningful business message.

---

# 🗂️ Repository Structure

Recommended Chapter 10 repository structure:

```text
Chapter-10-Building-Components-That-Think-Together/
│
├── README.md
│
├── force-app/
│   └── main/
│       └── default/
│           │
│           ├── classes/
│           │   ├── ApplicationController.cls
│           │   ├── ApplicationController.cls-meta.xml
│           │   ├── ApplicationService.cls
│           │   ├── ApplicationService.cls-meta.xml
│           │   ├── EligibleJobsController.cls
│           │   └── EligibleJobsController.cls-meta.xml
│           │
│           ├── triggers/
│           │   └── JobApplicationTrigger.trigger
│           │
│           └── lwc/
│               │
│               ├── eligibleJobs/
│               │   ├── eligibleJobs.html
│               │   ├── eligibleJobs.js
│               │   └── eligibleJobs.js-meta.xml
│               │
│               ├── jobCard/
│               │   ├── jobCard.html
│               │   ├── jobCard.js
│               │   └── jobCard.js-meta.xml
│               │
│               ├── studentProfile/
│               │   ├── studentProfile.html
│               │   ├── studentProfile.js
│               │   └── studentProfile.js-meta.xml
│               │
│               └── emptyState/
│                   ├── emptyState.html
│                   ├── emptyState.js
│                   └── emptyState.js-meta.xml
│
├── codes/
│   ├── ApplicationController.cls
│   ├── ApplicationService.cls
│   ├── EligibleJobsController.cls
│   ├── JobApplicationTrigger.trigger
│   ├── eligibleJobs.html
│   ├── eligibleJobs.js
│   ├── jobCard.html
│   ├── jobCard.js
│   ├── studentProfile.html
│   ├── studentProfile.js
│   ├── emptyState.html
│   └── emptyState.js
│
├── screenshots/
│   ├── sprint-27-jobcard-events.png
│   ├── sprint-28-student-profile.png
│   ├── sprint-29-refresh.png
│   ├── sprint-30-empty-state.png
│   └── sprint-31-final-integration.png
│
└── docs/
    └── architecture.md
```

---

# 🔧 Important Files

## ApplicationController

Responsible for exposing application actions to the UI.

```apex
@AuraEnabled
public static Id submitApplication(Id jobId) {

    return ApplicationService.submitApplication(jobId);

}
```

---

## ApplicationService

Responsible for business logic such as:

* Retrieve student
* Retrieve job
* Check duplicate applications
* Validate eligibility
* Create Job Application
* Enforce business rules

---

## EligibleJobsController

Responsible for exposing eligible-job functionality to the LWC.

---

## eligibleJobs

Responsible for:

* Accepting Student Record ID
* Calling Apex
* Displaying eligible jobs
* Handling loading state
* Handling errors
* Handling empty state
* Coordinating JobCard events

---

## jobCard

Responsible for displaying a single Job and reporting user actions to the parent.

---

## studentProfile

Responsible for:

* Loading Student information
* Editing Student information
* Validating input
* Saving changes
* Reporting successful updates
* Reporting errors

---

## emptyState

Reusable component responsible for displaying meaningful empty-state information.

---

# 🧠 Important LWC Concepts

## `@api`

Used to expose a public property or method from a child component.

Example:

```javascript
@api job;
```

---

## Custom Event

Used for child-to-parent communication.

Example:

```javascript
this.dispatchEvent(
    new CustomEvent('apply', {
        detail: {
            jobId: this.job.Id
        }
    })
);
```

---

## Event Handler

Example:

```javascript
handleApply(event) {

    const jobId = event.detail.jobId;

}
```

---

## Imperative Apex

Used when JavaScript explicitly needs to call Apex.

Example:

```javascript
submitApplication({
    jobId: jobId
});
```

---

## Loading State

Example:

```javascript
isLoading = true;
```

Then:

```javascript
isLoading = false;
```

---

## Empty State

Example:

```javascript
get isEmpty() {

    return !this.isLoading &&
           !this.error &&
           this.jobs.length === 0;

}
```

---

## Error State

Example:

```javascript
this.error =
    'Unable to load eligible jobs. Please try again.';
```

---

# 🏛️ Complete Architecture

The final architecture can be visualized as:

```text
                    Salesforce
                        │
                        ↓
              Application / Apex Layer
                        │
              ┌─────────┴─────────┐
              ↓                   ↓
       Student Data           Job Data
              │                   │
              └─────────┬─────────┘
                        ↓
                  EligibleJobs
                        │
                        ↓
                     JobCard
                   ↙         ↘
             View Details    Apply
                                │
                                ↓
                       ApplicationController
                                │
                                ↓
                       ApplicationService
                                │
                    ┌───────────┼───────────┐
                    ↓           ↓           ↓
                 Student       Job       Duplicate
                    │           │           │
                    └───────────┼───────────┘
                                ↓
                     Job_Application__c
                                │
                                ↓
                       Trigger / Automation
                                │
                                ↓
                         My Applications
```

---

# 🎯 Definition of Done

The Student Placement Portal is complete for this chapter when:

```text
☑ Student can view their profile
☑ Student can update their profile
☑ Profile validation works
☑ Eligible Jobs reflect current student information
☑ Job Cards are reusable
☑ Child components communicate with parents through events
☑ Parents pass information to children deliberately
☑ Application submission works
☑ Duplicate application attempts are handled
☑ My Applications reflects the new application
☑ Loading states are visible
☑ Empty states are meaningful
☑ Errors are handled professionally
☑ Business rules remain server-side
☑ Components have clear responsibilities
☑ Complete data flow can be explained
```

These requirements form the chapter's final Definition of Done. 

---

# 🎤 Interview Questions

## Basic

### 1. What is component communication in LWC?

Component communication is the process of passing information or events between Lightning Web Components.

---

### 2. How does a parent communicate with a child?

Using public properties exposed with:

```javascript
@api
```

---

### 3. How does a child communicate with a parent?

Using custom events:

```javascript
this.dispatchEvent(
    new CustomEvent('eventname')
);
```

---

### 4. What is `@api`?

`@api` exposes a public property or method that can be accessed by a parent component.

---

### 5. What are custom events?

Custom events allow a child component to notify its parent that something happened.

---

# Intermediate

### 6. Why shouldn't a child directly modify parent state?

Because it creates tight coupling and makes data ownership unclear.

The child should communicate through an event and allow the parent to decide what to do.

---

### 7. What is a reusable component?

A component designed around a meaningful capability that can be used by multiple parts of the application.

Examples:

```text
JobCard
EmptyState
StatusBadge
```

---

### 8. What is a God Component?

A component that contains too many responsibilities, including:

* Data retrieval
* State management
* UI logic
* Event handling
* Business logic

Such components become difficult to maintain.

---

### 9. When should you use imperative Apex?

When the Apex operation should execute because of an explicit user action.

Example:

```text
Apply
Save
Delete
Submit
```

---

### 10. Why should business validation remain in Apex?

Because server-side validation protects business rules regardless of which interface invokes the operation.

---

# Advanced

### 11. How would you design communication between EligibleJobs and JobCard?

```text
EligibleJobs
     ↓
@api job
     ↓
JobCard
     ↓
Custom Event
     ↓
EligibleJobs
```

---

### 12. Why should a child avoid retrieving data that the parent already has?

It can cause unnecessary server calls and make data ownership unclear.

---

### 13. How would you handle stale data after a profile update?

Identify:

1. What data changed?
2. Which component owns it?
3. Which components depend on it?
4. What refresh mechanism is appropriate?

Possible solutions include:

* Parent-owned state
* Custom events
* Reactive data
* LDS
* Refreshing wired data
* Re-querying when necessary

---

### 14. How does the Apply workflow work?

```text
User
 ↓
LWC
 ↓
Event Handler
 ↓
Apex Controller
 ↓
ApplicationService
 ↓
Business Validation
 ↓
Job Application
 ↓
Trigger / Automation
 ↓
Result
 ↓
UI
```

---

### 15. Why is architecture important in LWC?

Because a large application becomes difficult to maintain if all functionality is placed in one component.

Focused components provide:

* Clear responsibilities
* Easier debugging
* Reusability
* Better maintainability
* Explicit communication
* Easier testing

---

# 💡 Key Takeaways

## 1. Components should have focused responsibilities

```text
One component
      ↓
One meaningful capability
```

---

## 2. Parent → Child

Use:

```javascript
@api
```

---

## 3. Child → Parent

Use:

```javascript
CustomEvent
```

---

## 4. UI should not own business rules

The UI requests an action.

The server decides whether the action is valid.

```text
UI
 ↓
Request
 ↓
Business Layer
 ↓
Decision
```

---

## 5. Use imperative Apex for explicit actions

For example:

```text
Apply
Save
Submit
Delete
```

---

## 6. Always design application states

A professional UI should communicate:

```text
Loading
Success
Empty
Error
```

---

## 7. Reuse meaningful behaviour

Good:

```text
JobCard
EmptyState
StatusBadge
```

Avoid unnecessary abstraction.

---

## 8. Avoid God Components

Instead of:

```text
One Huge Component
```

build:

```text
Focused Components
       ↓
Clear Communication
       ↓
Coherent Application
```

---

# 🚀 Final Project Outcome

At the end of this chapter, the Placement Management System is no longer a collection of independent screens.

It becomes a connected Salesforce application:

```text
Student
   ↓
Profile
   ↓
Update
   ↓
Refresh
   ↓
Eligible Jobs
   ↓
Job Card
   ↓
Apply
   ↓
Apex
   ↓
Service Layer
   ↓
Business Validation
   ↓
Job Application
   ↓
Automation
   ↓
Application Status
```

The most important engineering lesson from this chapter is:

> **A good application is not one giant component. It is a collection of focused components that cooperate through clear communication.**

---

# 📌 Chapter Completion

**Chapter:** 10 — Building Components That Think Together

**Project:** Student Placement Management System

**Main Technologies:**

* Salesforce
* Lightning Web Components
* JavaScript
* Apex
* SOQL
* Lightning Data Service
* Imperative Apex
* Custom Events
* `@api`
* Salesforce Automation

**Status:**

```text
Chapter 10
├── Component Architecture       ✅
├── Parent → Child Communication ✅
├── Child → Parent Communication ✅
├── JobCard                      ✅
├── Student Profile              ✅
├── Data Refresh                 ✅
├── Reusable Empty State         ✅
├── Apply Workflow               ✅
├── Loading / Empty / Error      ✅
└── Final Integration            ✅
```

---

## 📚 Source

Based on the provided Salesforce training material:

**Chapter 10 – Building Components That Think Together**

The chapter's central architecture guidance covers focused components, explicit communication, reusable components, refresh behaviour, and the final Student Placement Portal integration workflow.  

```

This is the **complete single `README.md`** for the chapter, including the concepts, implementation flow, Sprint 27–31 work, repository structure, testing, architecture, and interview preparation.
```
