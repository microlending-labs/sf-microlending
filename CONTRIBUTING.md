# Contributing

## Branch names

Every change belongs to an issue. Cut the branch from an up-to-date `main`:

```bash
git switch main
git pull
git switch -c feature/12-loan-object
```

Format: `<type>/<issue-number>-<short-slug>`

- `type` is one of `feature`, `fix`, `chore`, `docs`
- `issue-number` is the GitHub issue number, without `#`
- `short-slug` is lowercase words separated by hyphens

Examples: `feature/12-loan-object`, `fix/31-repayment-rounding`, `docs/4-org-preparation-runbook`.

One issue has exactly one branch. The release pipeline finds the branch by the issue number, so a second branch for
the same issue blocks the release.

Never branch from `uat` and never merge `uat` into your branch: `uat` contains other people's untested work. CI rejects
pull requests whose branch contains commits from `uat`. If your branch needs a newer `main`, merge `main` into it.

## Commit messages

```
#12 Add Loan__c object with amount and term fields
```

- Start with the issue number.
- Imperative mood ("Add", "Fix", "Remove"), up to 72 characters in the first line.
- Explain *why* in the body when it is not obvious from the change.

## Pull requests

- Target branch: `uat`.
- Fill in every section of the pull request template, including **Post-deployment steps** (write "None" if there are
  none).
- Keep the pull request to one issue.
- Required checks: **Branch rules**, **Code Analyzer**, **Validate against UAT**. A pull request cannot be merged until
  they pass and the reviewer approves.
- Changes under `.github/` need approval from the code owner.
- Pull requests are merged with a merge commit (squash and rebase are disabled): the release pipeline relies on the
  ticket branch commits being present in `uat`.
- After review fixes, push to the same branch; the checks run again.

## Metadata rules

- Retrieve only what the ticket changed, for example
  `sf project retrieve start --metadata CustomObject:Loan__c --target-org lnd-dev`.
- Do not commit profiles. Access is granted through permission sets and permission set groups. If a ticket explicitly
  needs a profile, follow the approach agreed in that ticket.
- Do not commit org-specific values (user names, record IDs, URLs of a particular org).
- Manual steps that metadata cannot cover go to `docs/runbooks/` and are referenced in the pull request.

## Definition of Done

A ticket is done when all of the following are true:

1. The acceptance criteria in the issue are met.
2. The change is in `force-app/` (or `docs/`, `data/`) on the ticket branch; nothing was changed by hand in UAT or
   production.
3. The pull request into `uat` is approved and all required checks are green.
4. Apex code has tests: at least 85% coverage for new classes and triggers, with assertions, including bulk tests
   for triggers.
5. Post-deployment steps, if any, are documented in the pull request and in `docs/runbooks/`.
6. The reviewer tested it in UAT and added the `ready for production` label.
7. The release pipeline deployed it to production, merged it into `main` and closed the issue.

## Release to production

Only the reviewer adds the `ready for production` label. When anyone else adds it, the pipeline removes it and leaves a
comment. The pipeline releases the branch only if everything on it has already been merged into `uat`, so push nothing
to the branch after the last merge into `uat`.

If the release fails (merge conflict with `main`, failing tests in production), the pipeline comments on the issue and
removes the label. Fix the branch, get it through `uat` again, and ask for the label again.
