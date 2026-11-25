# Post-deployment steps: borrower data model (#10)

## Purpose
Metadata deployment does not carry profiles, so two settings must be made by hand after the change reaches an org.

## Applies to
UAT and production. DEV was configured by hand during development.

## Prerequisites
- The change from ticket #10 is deployed to the org.
- You are logged in as a System Administrator in the correct org.

## Steps
1. Assign the permission set.
   - Setup → Permission Sets → Borrower Data Model Access → Manage Assignments → Add Assignment.
   - Select the System Administrators who work with borrowers, click Assign, then Done.
2. Assign the page layout to the Business Borrower record type.
   - Setup → Object Manager → Account → Page Layouts → Page Layout Assignment → Edit Assignment.
   - For the System Administrator profile and the Business Borrower record type, select Business Borrower Layout, then Save.
3. Assign the page layout to the Individual Borrower record type.
   - Setup → Object Manager → Person Account → Page Layouts → Page Layout Assignment → Edit Assignment.
   - For the System Administrator profile and the Individual Borrower record type, select Individual Borrower Layout, then Save.

## Verification
1. Accounts → New → Business Borrower: the form shows Tax ID, Risk Grade, Borrower Since, Branch, Blacklisted, Blacklist Reason, Legal Form and Registration Date, and none of Monthly Income, Employment Type, National ID or Age.
2. Accounts → New → Individual Borrower: the form asks for a first and a last name and shows Birthdate, Monthly Income, Employment Type and National ID, and none of Legal Form or Registration Date.
3. Open a saved individual borrower: Age is shown. Open a saved business borrower: Business Age (Years) is shown.