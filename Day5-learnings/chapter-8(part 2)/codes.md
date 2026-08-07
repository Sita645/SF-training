# Chapter 8 – Codes.md
# Engineering Sprint – Asynchronous Apex

This file contains all the Apex code examples covered in **Chapter 8 – Engineering Sprint**.

---

# 1. Future Method

```apex
public class ApplicationFutureHandler {

    @future(callout=true)
    public static void sendApplicationToExternalSystem(Id applicationId){

        System.debug('Sending Application : ' + applicationId);

    }

}
```

---

# 2. Queueable Apex

```apex
public class OfferPostProcessingJob implements Queueable {

    private Id offerId;

    public OfferPostProcessingJob(Id offerId){
        this.offerId = offerId;
    }

    public void execute(QueueableContext context){

        System.debug('Processing Offer : ' + offerId);

    }

}
```

---

# 3. Execute Queueable Apex

```apex
Id sampleOfferId = '001000000000001AAA';

System.enqueueJob(
    new OfferPostProcessingJob(sampleOfferId)
);
```

---

# 4. Queueable Chaining

## PlacementNotificationJob

```apex
public class PlacementNotificationJob implements Queueable {

    public void execute(QueueableContext context){

        System.debug('Preparing Notifications');

    }

}
```

---

## Updated OfferPostProcessingJob

```apex
public class OfferPostProcessingJob implements Queueable {

    private Id offerId;

    public OfferPostProcessingJob(Id offerId){
        this.offerId = offerId;
    }

    public void execute(QueueableContext context){

        System.debug('Processing Offer : ' + offerId);

        System.enqueueJob(
            new PlacementNotificationJob()
        );

    }

}
```

---

# 5. Batch Apex

```apex
public class PlacementCategoryBatch implements Database.Batchable<SObject>{

    public Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator(
            'SELECT Id FROM Account'
        );

    }

    public void execute(Database.BatchableContext bc,
                        List<SObject> scope){

        System.debug(
            'Processing Batch : ' + scope.size()
        );

    }

    public void finish(Database.BatchableContext bc){

        System.debug('Batch Finished');

    }

}
```

---

# 6. Execute Batch Apex

```apex
Database.executeBatch(
    new PlacementCategoryBatch(),
    200
);
```

---

# 7. Scheduled Apex

```apex
public class ExpiredJobScheduler implements Schedulable {

    public void execute(SchedulableContext context){

        System.debug('Running Scheduled Job');

    }

}
```

---

# 8. Schedule Apex Job

```apex
String cronExp = '0 0 6 * * ?';

System.schedule(
    'Morning Job',
    cronExp,
    new ExpiredJobScheduler()
);
```

---

# 9. Scheduled Apex + Batch Apex

```apex
public class ExpiredJobScheduler implements Schedulable {

    public void execute(SchedulableContext context){

        Database.executeBatch(
            new PlacementCategoryBatch(),
            200
        );

    }

}
```

---

# 10. Debug Statements

```apex
System.debug('Processing Offer');
```

```apex
System.debug('Sending Application');
```

```apex
System.debug('Processing Batch');
```

```apex
System.debug('Batch Finished');
```

```apex
System.debug('Running Scheduled Job');
```

---

# Key Syntax Summary

## Future Method

```apex
@future(callout=true)
public static void methodName(Id recordId){

}
```

---

## Queueable Apex

```apex
public class MyJob implements Queueable{

    public void execute(QueueableContext context){

    }

}
```

---

## Execute Queueable

```apex
System.enqueueJob(new MyJob());
```

---

## Batch Apex

```apex
public class MyBatch
implements Database.Batchable<SObject>{

    public Database.QueryLocator start(Database.BatchableContext bc){}

    public void execute(Database.BatchableContext bc,
                         List<SObject> scope){}

    public void finish(Database.BatchableContext bc){}

}
```

---

## Execute Batch

```apex
Database.executeBatch(
    new MyBatch(),
    200
);
```

---

## Scheduled Apex

```apex
public class MyScheduler
implements Schedulable{

    public void execute(SchedulableContext context){

    }

}
```

---

## Schedule Job

```apex
System.schedule(
    'Job Name',
    cronExpression,
    new MyScheduler()
);
```

---

# Concepts Covered

- Future Methods
- Queueable Apex
- Queueable Chaining
- Batch Apex
- Batch Execution
- Scheduled Apex
- Scheduling Jobs
- Scheduled Apex with Batch Apex
- Debugging Background Jobs

---

## Status

✅ Chapter 8 – Engineering Sprint Code Examples Completed
