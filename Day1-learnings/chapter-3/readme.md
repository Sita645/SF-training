# 💻 Discovering Apex

> "Programming is nothing more than expressing good design in a language that computers can understand."

---

# 📖 Overview

This chapter introduces **Apex**, Salesforce's programming language used to implement business logic.

Instead of treating Apex as something to memorize, the chapter explains that Apex is simply a way of translating well-designed business solutions into executable software.

Using the Placement Management System, the chapter demonstrates how business responsibilities naturally become Apex classes and methods.

---

# 🎯 Learning Outcomes

After completing this chapter, I learned how to:

- Understand the purpose of Apex.
- Convert business responsibilities into Apex classes.
- Create service classes.
- Create methods based on business activities.
- Use parameters to pass business information.
- Design methods that return meaningful results.
- Build software incrementally.

---

# 🏢 Business Scenario

The Placement Management System already has a clear design.

The next step is to implement the following business responsibility:

Student
        ↓
Apply for Job
        ↓
ApplicationService
        ↓
Process Application

This chapter explains how Apex transforms this business process into software.

---

# 💡 What is Apex?

Apex is Salesforce's object-oriented programming language.

It allows developers to:

- Implement business logic.
- Automate business processes.
- Process records.
- Perform validations.
- Interact with Salesforce data.

Instead of memorizing syntax, developers should first understand the business problem and then use Apex to implement the solution.

---

# 🏗 Creating the First Apex Class

The chapter introduces the first service class:

```apex
public class ApplicationService {

}
```

This class represents one business responsibility:

**Processing Job Applications**

A class should not exist simply because Apex requires it.

A class should exist because the business has a responsibility that needs to be implemented.

---

# ⚙ One Responsibility, One Service

The chapter reinforces an important engineering principle:

> **One Responsibility. One Service.**

Example:

| Service | Responsibility |
|----------|----------------|
| StudentService | Student Operations |
| JobService | Job Management |
| ApplicationService | Application Processing |

Each service should focus on one business capability.

---

# 🛠 Creating the First Method

The chapter introduces the first business method.

```apex
public class ApplicationService {

    public void submitApplication(){

    }

}
```

Instead of using technical names such as:

- process()
- execute()
- doWork()

developers should choose method names that clearly describe business activities.

Example:

```text
submitApplication()
```

The method name itself explains what the software is doing.

---

# 📥 Understanding Parameters

A method needs information before it can perform its responsibility.

Example:

```apex
public void submitApplication(Id studentId, Id jobId){

}
```

Parameters represent business information.

In this example:

- Student ID identifies the student.
- Job ID identifies the selected job.

The method now has enough information to process an application.

---

# 📤 Returning Results

After processing an application, software should communicate the outcome clearly.

Possible results include:

- Application Submitted Successfully
- Duplicate Application
- Minimum CGPA Not Satisfied
- Application Deadline Expired
- Maximum Offers Reached

Methods should always return meaningful results so users understand what happened.

---

# 🚀 Incremental Development

One of the key lessons from this chapter is:

> Build small. Test often. Improve continuously.

Professional developers avoid writing very large classes immediately.

Instead they:

1. Build one feature.
2. Test it.
3. Improve it.
4. Add the next feature.

This approach makes software easier to understand and maintain.

---

# 🧠 Engineering Principles Learned

Throughout this chapter, several engineering principles are emphasized:

- Business comes before programming.
- One class should represent one business responsibility.
- Methods should represent business activities.
- Parameters should contain only required information.
- Methods should clearly communicate results.
- Build software incrementally.

---

# 📝 Coding Activities

This chapter introduces the first Apex implementation.

Activities include:

- Create `ApplicationService` class.
- Create `submitApplication()` method.
- Add `studentId` and `jobId` parameters.
- Display meaningful messages.
- Design methods before implementation.

The actual business logic implementation is introduced in the Engineering Sprint.

---

# 🚀 Skills Gained

- Apex Fundamentals
- Apex Class Creation
- Method Design
- Parameter Passing
- Service-Oriented Programming
- Business-Oriented Method Naming
- Incremental Software Development

---

# 📚 Interview Preparation

### Q1. What is Apex?

Apex is Salesforce's object-oriented programming language used to implement business logic, automate processes, and interact with Salesforce data.

---

### Q2. Why should classes represent business responsibilities?

Because each class should focus on solving one business problem, making software easier to understand, maintain, and test.

---

### Q3. Why should method names describe business activities?

Meaningful method names improve readability and allow other developers to understand the purpose of the method without reading its implementation.

---

### Q4. Why are parameters required?

Parameters provide the information needed for a method to perform its business responsibility.

---

### Q5. Why should methods return meaningful results?

Users and developers should clearly understand whether an operation succeeded or failed and why.

---

# 📌 Key Takeaways

- Apex is used to implement business logic.
- Classes represent business services.
- Methods represent business activities.
- Parameters provide required business information.
- Methods should communicate meaningful results.
- Build software incrementally instead of writing large amounts of code at once.

---

# 📖 Chapter Summary

This chapter serves as the bridge between software design and implementation.

Instead of viewing Apex as a programming language to memorize, it presents Apex as a tool for implementing well-designed business solutions.

By understanding how business responsibilities become classes, methods, and parameters, developers can build enterprise Salesforce applications that are scalable, readable, and maintainable.

---

## ⭐ Repository Purpose

This README documents my learning from the **"Discovering Apex"** chapter as part of my Salesforce Developer learning journey.

The chapter helped me understand how business responsibilities are transformed into Apex classes, methods, and business-oriented software components while following professional engineering practices.
