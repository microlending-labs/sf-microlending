## Ticket

<!-- Issue number. Do not use "Closes #N": the release pipeline closes the issue after the production deployment. -->

Ticket: #

## What changed

<!-- Short list of the metadata and code changed, and why. -->

## Acceptance criteria verified in DEV

<!-- One line per criterion of the ticket, by number: verified / not applicable, and how. -->

- AC1:

## How to test in UAT

<!-- Steps the reviewer follows in UAT, with the expected result for each. Refer to criteria by number. -->

1.

## Deliverables

<!-- Everything the ticket's Deliverables section asks for in the PR description. -->

## Post-deployment steps

<!-- Manual steps after deployment (permission set assignment, settings, data). Link the runbook in docs/runbooks/. Write "None" if there are none. -->

None

## Checklist

- [ ] Branch is cut from `main` and named `<type>/<issue>-<slug>`
- [ ] Only metadata related to this ticket is included; no profiles
- [ ] Apex changes have tests with assertions (85%+ coverage for new code)
- [ ] Post-deployment steps are documented
