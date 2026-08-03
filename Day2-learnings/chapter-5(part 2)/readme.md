# 📘 Chapter 5 – Part II: From Information to Action
### Sprint 5 – Understanding DML Through Business Transactions

> **"Information becomes valuable only when software uses it to create meaningful outcomes."**

---

## 🎯 Sprint Objective

In this part of Sprint 5, I learned how Salesforce applications **modify business data** after retrieving and validating information. The focus is on **DML (Data Manipulation Language)** and how enterprise applications complete business transactions by creating and updating records.

---

## 📚 Learning Outcomes

By completing Part II, I understood how to:

- Understand why retrieving data is only half of a business process.
- Learn the purpose of **DML** in Salesforce.
- Create and update Salesforce records using Apex.
- Differentiate between creating new records and updating existing ones.
- Understand why business validation must happen before changing data.
- Build complete business transactions by combining SOQL, Apex, and DML.

---

# 🏢 Business Scenario

The Placement Management System can now:

- Retrieve Student records
- Retrieve Job details
- Validate eligibility
- Check business rules

After all validations succeed, the system must perform a business action.

Example:

A student clicks **Apply**.

The software:

- Retrieves Student information.
- Retrieves Job information.
- Validates eligibility.
- Checks duplicate applications.
- Creates a new Application record.
- Saves the record.
- Displays a confirmation message.

This completes the business transaction.

---

# 🔄 SOQL and DML Together

Enterprise applications perform two major operations:

### Step 1 – Retrieve Information

Using **SOQL**

- Read Student records
- Read Job details
- Read existing Applications

### Step 2 – Modify Information

Using **DML**

- Create new records
- Update existing records
- Delete records when required

SOQL and DML work together to complete every business process.

---

# 💡 Understanding DML

**DML (Data Manipulation Language)** is used to change Salesforce data.

Common DML operations include:

- **Insert** → Create new records
- **Update** → Modify existing records
- **Delete** → Remove records
- **Restore** → Recover deleted records (platform-supported)

These operations allow Salesforce applications to perform real business transactions.

---

# 🔄 Complete Business Transaction

A typical application process follows this sequence:

```text
Student Clicks Apply
        ↓
Retrieve Student Details
        ↓
Retrieve Job Details
        ↓
Validate Eligibility
        ↓
Create Application Record
        ↓
Save Record (DML)
        ↓
Display Confirmation
```

Every step depends on the previous one.

Skipping validation can result in incorrect business data.

---

# 🧠 Create vs Update

Understanding when to create or update records is essential.

### Create New Record

Examples:

- Student Registration
- Company Registration
- Job Posting
- Application Submission

### Update Existing Record

Examples:

- Application Status
- Student Contact Details
- Company Eligibility Criteria
- Interview Results

Professional developers choose the appropriate DML operation based on the business requirement.

---

# ⚠️ Engineering Principles Learned

## 1. Validate Before DML

Business rules should always be verified before changing Salesforce data.

Correct sequence:

```text
Retrieve Information
        ↓
Validate Business Rules
        ↓
Perform DML
```

---

## 2. Technology Follows Business

Developers should never begin by thinking:

> "I need to write an INSERT statement."

Instead, begin with the business requirement:

> "The application should be saved."

Technology is chosen only after understanding the business need.

---

## 3. Respect Business Data

Changing Salesforce records impacts the entire organization.

A single DML operation can:

- Update reports
- Refresh dashboards
- Trigger automation
- Send notifications
- Change business statistics

Professional developers always understand the business impact before modifying data.

---

# 📌 Key Takeaways

- Retrieving information alone does not complete a business process.
- DML is responsible for creating and updating business records.
- Business validation should always occur before DML.
- Create records only when new information is introduced.
- Update records when existing information changes.
- Think about the business impact before modifying Salesforce data.

---

# 📖 Sprint Summary

During Part II of Sprint 5, I learned how enterprise applications transform retrieved information into meaningful business actions using **DML**. By combining **SOQL**, **Apex business logic**, and **DML**, Salesforce applications can complete end-to-end business transactions while maintaining data accuracy and business integrity.

---

## 🚀 Next Learning

➡️ **Chapter 5 – Part III: Engineering Sprint – Building Complete Business Transactions with SOQL, DML and Apex**
