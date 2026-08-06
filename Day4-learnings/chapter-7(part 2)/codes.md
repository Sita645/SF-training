# 💻 CODES.md – Chapter 7 Part II (Engineering Sprint)

This document contains all the hands-on Apex coding exercises completed during **Chapter 7 – Part II: Engineering Sprint – Designing Bulk-Safe Apex and Triggers**.

The focus of this sprint was to transform single-record Apex into **bulk-safe, scalable, enterprise-ready code** by using collections, Trigger context variables, Sets, Maps, Bulk SOQL, Bulk DML concepts, and Trigger Handler architecture. :contentReference[oaicite:0]{index=0}

---

# 🚀 Sprint 24 – Trigger.new as a Collection

## Objective

Understand that `Trigger.new` is a collection of records instead of a single record.

### Trigger Code

```apex
trigger JobApplicationTrigger on Job_Application__c (
    before insert,
    before update,
    after update
) {

    if (Trigger.isBefore && Trigger.isInsert) {

        System.debug('Number of Records: ' + Trigger.new.size());

        ApplicationTriggerHandler.beforeInsert(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {

        ApplicationTriggerHandler.beforeUpdate(
            Trigger.new,
            Trigger.oldMap
        );
    }

    if (Trigger.isAfter && Trigger.isUpdate) {

        ApplicationTriggerHandler.afterUpdate(
            Trigger.new,
            Trigger.oldMap
        );
    }
}
```

### Skills Practiced

- Trigger.new
- Collections
- Trigger Events

---

# 🚀 Sprint 25 – Collect Student IDs

## Objective

Collect unique Student IDs before querying Salesforce.

### Apex Code

```apex
Set<Id> studentIds = new Set<Id>();

for (Job_Application__c app : applications) {

    if (app.Student__c != null) {

        studentIds.add(app.Student__c);

    }

}
```

### Skills Practiced

- Set
- Remove Duplicates
- Bulk Collection

---

# 🚀 Sprint 26 – Bulk Query Students

## Objective

Retrieve all Students using one SOQL query.

### Apex Code

```apex
Map<Id, Student__c> studentsById =
new Map<Id, Student__c>([
    SELECT Id,
           Name,
           CGPA__c,
           Active_Backlogs__c
    FROM Student__c
    WHERE Id IN :studentIds
]);
```

### Skills Practiced

- Bulk SOQL
- Maps
- SOQL Optimization

---

# 🚀 Sprint 27 – Process Student Records Using Map

## Objective

Retrieve Student records from memory instead of querying repeatedly.

### Apex Code

```apex
for (Job_Application__c app : applications) {

    Student__c student =
        studentsById.get(app.Student__c);

    if (student == null) {

        continue;

    }

    System.debug(student.Name);
}
```

### Skills Practiced

- Map Lookup
- Bulk Processing
- No SOQL Inside Loop

---

# 🚀 Sprint 28 – Collect Job IDs

## Objective

Collect unique Job IDs.

### Apex Code

```apex
Set<Id> jobIds = new Set<Id>();

for (Job_Application__c app : applications) {

    if (app.Job__c != null) {

        jobIds.add(app.Job__c);

    }

}
```

### Skills Practiced

- Set
- Bulk Collection

---

# 🚀 Sprint 29 – Bulk Query Jobs

## Objective

Retrieve all Jobs using one SOQL query.

### Apex Code

```apex
Map<Id, Job__c> jobsById =
new Map<Id, Job__c>([
    SELECT Id,
           Name,
           Minimum_CGPA__c,
           Maximum_Backlogs__c
    FROM Job__c
    WHERE Id IN :jobIds
]);
```

### Skills Practiced

- Bulk SOQL
- Job Map
- Efficient Data Access

---

# 🚀 Sprint 30 – Bulk Eligibility Validation

## Objective

Validate every application using Student and Job Maps.

### Apex Code

```apex
for (Job_Application__c app : applications) {

    Student__c student =
        studentsById.get(app.Student__c);

    Job__c job =
        jobsById.get(app.Job__c);

    if (student == null || job == null) {

        continue;

    }

    if (student.CGPA__c >= job.Minimum_CGPA__c &&
        student.Active_Backlogs__c <= job.Maximum_Backlogs__c) {

        app.Eligibility_Status__c = 'Eligible';

    } else {

        app.Eligibility_Status__c = 'Ineligible';

    }

}
```

### Skills Practiced

- Bulk Validation
- Business Logic
- Map Usage
- No SOQL Inside Loop

---

# 🚀 Sprint 31 – Bulk DML Pattern

## Objective

Understand how to perform one DML operation instead of multiple DML statements.

### Apex Code

```apex
List<Job_Application__c> applicationsToUpdate =
new List<Job_Application__c>();

for (Job_Application__c app : applications) {

    if (/* business condition */) {

        applicationsToUpdate.add(app);

    }

}

if (!applicationsToUpdate.isEmpty()) {

    update applicationsToUpdate;

}
```

> **Note:** In a `before insert` Trigger, this pattern is for learning purposes. `Trigger.new` records should not be updated using DML because Salesforce automatically saves field changes during the transaction. :contentReference[oaicite:1]{index=1}

### Skills Practiced

- Bulk DML
- DML Outside Loop
- Governor Limit Awareness

---

# 🚀 Sprint 32 – Trigger.oldMap

## Objective

Compare previous and current record values.

### Apex Code

```apex
for (Job_Application__c app : Trigger.new) {

    Job_Application__c oldApp =
        Trigger.oldMap.get(app.Id);

    System.debug('Old Status: ' +
        oldApp.Application_Status__c);

    System.debug('New Status: ' +
        app.Application_Status__c);

}
```

### Skills Practiced

- Trigger.oldMap
- Change Detection
- Before Update Trigger

---

# 🚀 Sprint 33 – Detect Status Changes

## Objective

Run automation only when the Application Status changes to **Selected**.

### Apex Code

```apex
if (oldApp.Application_Status__c != 'Selected' &&
    app.Application_Status__c == 'Selected') {

    System.debug('New Selection Detected');

}
```

### Skills Practiced

- Business Event Detection
- Old vs New Comparison

---

# 🚀 Sprint 34 – Trigger Handler

## Objective

Move Trigger logic into a dedicated Handler class.

### Apex Code

```apex
public class ApplicationTriggerHandler {

    public static void beforeInsert(
        List<Job_Application__c> applications
    ) {

        ApplicationService.validateApplications(
            applications
        );

    }

}
```

### Skills Practiced

- Trigger Handler Pattern
- Separation of Responsibilities

---

# 🚀 Sprint 35 – Clean Trigger

## Objective

Keep the Trigger small and delegate work.

### Apex Code

```apex
trigger JobApplicationTrigger on Job_Application__c (
    before insert,
    before update,
    after update
) {

    if (Trigger.isBefore && Trigger.isInsert) {

        ApplicationTriggerHandler.beforeInsert(
            Trigger.new
        );

    }

    if (Trigger.isBefore && Trigger.isUpdate) {

        ApplicationTriggerHandler.beforeUpdate(
            Trigger.new,
            Trigger.oldMap
        );

    }

    if (Trigger.isAfter && Trigger.isUpdate) {

        ApplicationTriggerHandler.afterUpdate(
            Trigger.new,
            Trigger.oldMap
        );

    }

}
```

### Skills Practiced

- Clean Trigger Design
- Event Routing
- Trigger Architecture

---

# 🚀 Sprint 36 – Final Enterprise Architecture

## Objective

Complete a bulk-safe Trigger architecture.

### Architecture

```text
JobApplicationTrigger
        │
        ▼
ApplicationTriggerHandler
        │
        ▼
ApplicationService
        │
        ├──────────► StatisticsService
        │
        └──────────► NotificationService
```

### Skills Practiced

- Enterprise Trigger Architecture
- Service Layer Pattern
- Scalable Apex Design

---

# 🛠 Concepts Practiced

Throughout this sprint, I implemented:

- Trigger.new
- Trigger.old
- Trigger.oldMap
- Trigger Context Variables
- Trigger Handler Pattern
- Service Layer Pattern
- Lists
- Sets
- Maps
- Bulk SOQL
- Bulk DML
- Bulk Processing
- Eligibility Validation
- Status Change Detection
- Enterprise Trigger Design

---

# 📚 Learning Outcome

After completing this engineering sprint, I learned how to:

- Build Apex that works for one or hundreds of records.
- Design Triggers using Trigger Handler architecture.
- Process collections instead of single records.
- Retrieve related records efficiently using Bulk SOQL.
- Use Maps for fast in-memory lookups.
- Avoid SOQL and DML inside loops.
- Detect meaningful business changes using Trigger.oldMap.
- Build scalable and maintainable Salesforce applications.

---

# 🚀 Final Engineering Architecture

```text
Trigger
    │
    ▼
Trigger Handler
    │
    ▼
Application Service
    │
    ▼
Bulk SOQL
    │
    ▼
Maps
    │
    ▼
Business Logic
    │
    ▼
Bulk DML (when required)
```

---

## 📌 Summary

Chapter 7 transformed my approach to Apex development by teaching me to think in collections instead of individual records. Through practical implementation of Sets, Maps, Bulk SOQL, Trigger context variables, and Trigger Handler architecture, I learned to design scalable Salesforce applications that follow enterprise development best practices and remain safe under high data volumes.
