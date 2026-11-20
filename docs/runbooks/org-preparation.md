# Org Preparation Runbook: Enable Person Accounts

## Purpose
Person Accounts is an org-level feature that cannot be deployed as
metadata. This runbook enables it by hand so that metadata that depends
on it can be deployed.

## When to run
Once per org, **before the first deployment to a new org**.
Already enabled in: DEV, UAT, PROD.

Applies to: any org that does not yet have Person Accounts enabled
(DEV, UAT and PROD already have it; run this runbook for every new org,
including a new DEV org).

In this runbook, replace `<alias>` with the alias of the target org.

## Prerequisites
Check each item before you start:

1. The **Account** object has at least one record type for business accounts.
   If none exists, create it: **Setup → Object Manager → Account →
   Record Types → New**.
   1. In **Step 1. Enter the details** leave **Existing Record Type** as
      **--Master--**, set **Record Type Label** to `Business Borrower` and
      **Record Type Name** to `Business_Borrower`, and tick **Active**
      (it is not ticked by default). Click **Next**.
   2. In **Step 2. Assign page layouts** keep **Apply one layout to all
      profiles**, select **Account Layout** in the page layout list, and
      click **Save**.
2. Every profile that has **Read** permission on Account also has **Read**
   permission on Contact:
   **Setup → Users → Profiles → `<Profile Name>` → Object Settings**.
   A profile without **Read** on Contact (for example **Authenticated
   Website**) is reported as a warning on the **Person Accounts** page and
   does not block enabling.
3. Organization-wide defaults are set so that either Contact is
   **Controlled by Parent**, or both Account and Contact are **Private**:
   **Setup → Sharing Settings → Organization-Wide Defaults**.
4. You are working in the correct org. Run:
   ```
   sf data query --query "SELECT Id, Name FROM Organization" --target-org <alias>
   ```
   Compare the printed **Id** with **Salesforce.com Organization ID** in
   **Setup → Company Information** of the org you intend to change
   (Company Information shows the 15-character form, the query prints
   18 characters; the first 15 characters match). Do not use
   `sf org display`: its output contains an access token.

## ⚠️ WARNING: This change is irreversible
Enabling Person Accounts **cannot be undone or turned off**.
Before continuing, confirm that:
- you are in the correct org;
- this org really needs Person Accounts.

Known consequences:
- **Irreversible.** Once enabled, Person Accounts cannot be disabled in
  that org.
- **Two records per customer.** Each person account consists of an Account
  record and a related Contact record. Person accounts count against both
  account and contact storage.
- **No hierarchies or direct relationships.** Person accounts cannot be
  included in account or contact hierarchies and cannot have direct
  relationships with other accounts or contacts. Indirect relationships
  are possible with Contacts to Multiple Accounts.
- **New fields on Account.** Contact fields are exposed on Account as
  standard `Person*` fields (for example `PersonEmail`) and custom Contact
  fields as `__pc` fields. They appear in reports and list views on Account,
  and stay there even if the org stops using person accounts.
- **Existing Account automation applies.** Creating or editing a person
  account triggers account workflow rules. Triggers, flows and validation
  rules defined on Account also run for person accounts. Review them before
  enabling Person Accounts.
- **Contact sharing depends on the account.** Before enabling, the
  organization-wide defaults must meet Prerequisite 3. After enabling, the
  Contact default can be changed (see Salesforce Help, "Business Contact
  Sharing for Orgs That Use Person Accounts"). A person account has no
  separate contact to share: share the whole account.

## Steps
1. Open **Setup**, type `Person Accounts` in **Quick Find**, and select
   **Person Accounts**. The section **Set Up Person Accounts** lists four
   steps: **Org Impact Acknowledgement**, **Create Accounts Record Type**,
   **Set Read Permissions**, **Set Organization-Wide Sharing**.
2. Next to **Org Impact Acknowledgement**, click **View Org Impacts** and
   review the changes. Select **I understand that enabling this feature
   results in permanent changes to my Salesforce org.** and click
   **Continue**. Return to the **Person Accounts** page.
3. Click **Check Readiness** and confirm that the other three steps are
   marked complete (a warning about profiles without **Read** on Contact
   does not block enabling).
4. Click **Enable Person Accounts**.
5. In the dialog **Enable Person Accounts?** (it starts with "WARNING: You
   can't disable this feature after it's enabled."), click **Enable**. The
   page shows **Person Accounts Enabled** with the **Enabled on:** date.
6. Assign the record types to the profiles that will use them.
   1. **Setup → Users → Profiles →** `<Profile Name>`.
   2. In **Record Type Settings**, find **Accounts** and click **Edit**.
   3. Move **Business Borrower** and **Person Account** from
      **Available Record Types** to **Selected Record Types**.
   4. In **Business Account and Person Account Default Record Types**, set
      **Business Account Default Record Type** to **Business Borrower**
      and **Person Account Default Record Type** to **Person Account**.
      The business default must not be **--Master--**.
   5. Click **Save**.
   6. Repeat for each remaining profile.

## Verification
1. Run:
   ```
   sf data query --query "SELECT Name, IsPersonAccount, PersonContactId FROM Account LIMIT 1" --target-org <alias>
   ```
   Expected: the query succeeds. In an org without Person Accounts it
   fails because the field `IsPersonAccount` does not exist.
2. **Setup → Person Accounts** displays the banner **Person Accounts
   Enabled** with the line **Enabled on:** followed by the date when the
   feature was enabled in this org.
3. In Lightning, open the **Accounts** tab and click **New**. The dialog
   asks to select a record type and offers **Business Borrower** and
   **Person Account**. Click **Cancel**.