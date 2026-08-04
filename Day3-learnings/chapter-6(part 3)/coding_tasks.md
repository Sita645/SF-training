# 💻 Chapter 6 – Part III Coding Tasks

## Engineering Sprint Implementation

This document contains the practical implementation tasks completed during Sprint 6.

---

# 🚀 Engineering Sprint 13

## Requirement

Automatically validate a new Application before it is saved.

### Implementation

- Created `ApplicationTrigger`
- Delegated validation to `ApplicationService`

### Trigger

```apex
trigger ApplicationTrigger on Application__c (before insert) {

    ApplicationService.validateApplications(Trigger.new);

}
```

---

# 🚀 Engineering Sprint 14

## Requirement

Automatically update placement statistics when an Application status changes to **Selected**.

### Implementation

- Created `StatisticsService`
- Trigger delegates statistics update

```apex
StatisticsService.updateStatistics(
    Trigger.new,
    Trigger.oldMap
);
```

---

# 🚀 Engineering Sprint 15

## Requirement

Automatically send notifications for important placement events.

### Implementation

- Created `NotificationService`
- Trigger delegates notification processing

```apex
NotificationService.sendNotifications(
    Trigger.new,
    Trigger.oldMap
);
```

---

# 🚀 Engineering Sprint 16

## Requirement

Support future business requirements without modifying the Trigger.

### Implementation

Created a dedicated `AlumniService`.

```apex
AlumniService.notifyAlumni(
    Trigger.new,
    Trigger.oldMap
);
```

The Trigger architecture remained unchanged while supporting the new requirement.

---

# 🏗 Final Trigger Flow

```text
Application Created / Updated
            │
            ▼
Application Trigger
            │
            ▼
Application Service
            │
 ┌──────────┼─────────────┐
 ▼          ▼             ▼
Statistics  Notification  Alumni
 Service      Service      Service
```

---

# 📂 Files Implemented

- ApplicationTrigger.cls
- ApplicationService.cls
- StatisticsService.cls
- NotificationService.cls
- AlumniService.cls

---

# 🧪 Validation

The implementation was verified using:

- Sample Application records
- Debug Logs (`System.debug()`)
- Trigger execution during record insert and update
- Service delegation for each business event

---

# 📸 Screenshots

Include the following screenshots:

- ApplicationTrigger
- ApplicationService
- StatisticsService
- NotificationService
- AlumniService
- Debug Log – Validation
- Debug Log – Statistics Update
- Debug Log – Notification
- Debug Log – Alumni Notification
