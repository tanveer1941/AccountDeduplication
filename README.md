# Account Deduplication Project

## Overview
This Salesforce Account Deduplication project is designed to identify and merge duplicate accounts based on predefined criteria stored in **Custom Labels**. The deduplication process ensures data integrity by preserving critical information while eliminating redundant records.

## Features
- **Dynamic Deduplication Criteria:** Uses Custom Labels to define matching conditions (e.g., Accounts with the same **Name** and **Phone**).
- **Automated Data Transfer:** Before deleting a duplicate account, missing information is transferred to the account being kept.
- **Audit Trail for Deleted Accounts:** A reference to the retained account is stored in the deleted account under the `Account_Kept__c` field, making it easy to audit via the Recycle Bin.
- **Bulk Processing:** Optimized SOQL queries and Apex logic ensure governor limits are handled efficiently.

## Deduplication Process
1. **Fetch Matching Accounts:**
   - Accounts are queried based on criteria from Custom Labels (e.g., same **Name** and **Phone**).
2. **Determine Which Account to Keep:**
   - Based on business logic, decide which account should be retained.
3. **Transfer Missing Information:**
   - Move data from duplicate accounts to the retained account if fields are empty.
4. **Mark Deleted Accounts:**
   - Populate `Account_Kept__c` on deleted accounts with the ID of the retained account.
5. **Delete Duplicate Accounts:**
   - Remove redundant accounts, keeping only the best-quality record.

## Custom Label Configuration
- **`Deduplication_Criteria`**: Defines the fields used to identify duplicates (e.g., "Name, Phone").

## Auditing & Recovery
To check which account was kept after deletion:
1. Recover the deleted account from the **Recycle Bin**.
2. Check the `Account_Kept__c` field to see which account was retained.

## Deployment & Usage
1. Deploy the Apex classes to your Salesforce org.
2. Configure `Deduplication_Criteria` in **Custom Labels**.
3. Execute the batch class to process duplicate accounts.

## Considerations
- Ensure field-level security and permissions allow updates to all relevant fields.
- Test in a sandbox before deploying to production.
- Schedule the deduplication process during off-peak hours to minimize user impact.

## Future Enhancements
- Extend criteria to include additional fields like Email.
- Add UI component for manual review before merging accounts.
- Implement real-time duplicate detection using triggers.

---
This project ensures data consistency while maintaining an audit trail, making it easier to manage and track deduplicated accounts in Salesforce.

