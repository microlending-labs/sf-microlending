# Org Preparation Runbook: Enable Person Accounts

## Purpose
Person Accounts is an org-level feature that cannot be deployed as
metadata. This runbook enables it by hand so that metadata that depends
on it can be deployed.

## When to run
Once per org, **before the first deployment to a new org**.
Already enabled in: DEV, UAT, PROD.

In this runbook, replace `<alias>` with the alias of the target org.

## Prerequisites
Check each item before you start:

1. The **Account** object has at least one record type.
   If none exists, create a Business Account record type:
   **Setup → Object Manager → Account → Record Types → New**.
2. Every profile that has **Read** permission on Account also has **Read**
   permission on Contact:
   **Setup → Users → Profiles → `<Profile Name>` → Object Settings**.
3. Organization-wide defaults are set so that either Contact is
   **Controlled by Parent**, or both Account and Contact are **Private**:
   **Setup → Sharing Settings → Organization-Wide Defaults**.
4. You are working in the correct org:
   `sf org display --target-org <alias>`

## ⚠️ WARNING: This change is irreversible
Enabling Person Accounts **cannot be undone or turned off**.
Before continuing, confirm that:
- you are in the correct org;
- this org really needs Person Accounts.

Known consequences:
- **Irreversible.** Once enabled, Person Accounts cannot be disabled in
  that org.
- **Two records per customer.** Each person account consists of an Account
  record and a related Contact record.
- **New fields on Account.** Contact fields are exposed on Account as
  standard `Person*` fields (for example `PersonEmail`) and custom Contact
  fields as `__pc` fields. They appear in reports and list views on Account.
- **Existing Account automation applies.** Triggers, flows and validation
  rules defined on Account also run for person accounts. Review them before enabling Person Accounts.
- **Contact sharing depends on the account.** The organization-wide
  defaults must meet Prerequisite 3 before enabling.

## Steps
1. Open **Setup**, type `Person Accounts` in **Quick Find**, and select
   **Person Accounts**.
2. Confirm that every item in the activation checklist is marked complete.
3. Click **View Org Impacts**, review the changes, select the
   acknowledgment checkbox, and confirm. Return to the **Person Accounts**
   page.
4. Click **Enable Person Accounts**.
5. In the confirmation dialog, click **Enable**.
6. Assign the **Person Account** record type to the profiles that will use
   it.
   1. **Setup → Users → Profiles →** `<Profile Name>`.
   2. In **Record Type Settings**, find **Accounts** and click **Edit**.
   3. Move **Person Account** from **Available Record Types** to
      **Selected Record Types**.
   4. Verify that **Person Account Default Record Type** is **Person Account**
      and **Business Account Default Record Type** is not **--Master--**.
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
   Enabled** with the line **Enabled on:** followed by the date when the feature was enabled in this org.