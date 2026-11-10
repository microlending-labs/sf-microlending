# sf-microlending

Salesforce implementation for **Riverbend Microfinance**, a lender that issues small loans to both individuals and
businesses. The project is run like a real delivery team: work comes in as GitHub issues, every change goes through a
pull request and code review, is tested in UAT and is released to production by the pipeline.

## Environments

| Environment | Org | Who uses it | How changes get there |
|-------------|-----|-------------|-----------------------|
| Development | one Developer Edition per developer (alias `lnd-dev`) | the developer | built by hand or deployed from the ticket branch |
| UAT | shared Developer Edition | reviewer, for acceptance testing | automatically, when a pull request is merged into `uat` |
| Production | shared Developer Edition | end users | automatically, when the reviewer labels the ticket `ready for production` |

There are no sandboxes: every environment is a separate Developer Edition org.

## Branches

| Branch | Contains | Deployed to |
|--------|----------|-------------|
| `main` | exactly what is in production | Production |
| `uat` | everything currently under acceptance testing | UAT |
| `<type>/<issue>-<slug>` | one ticket | your dev org |

Ticket branches are always cut from `main`, never from `uat`. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Delivery flow

1. Pick up an issue on the project board and move it to **In Progress**.
2. Create a branch from `main` named after the issue, build the change in your dev org, retrieve it into
   `force-app/`, commit.
3. Open a pull request into `uat`. CI runs Salesforce Code Analyzer and a check-only deployment with local Apex tests
   against the UAT org. Move the card to **Code Review**.
4. After review approval the pull request is merged and the pipeline deploys `uat` to the UAT org. Move the card to
   **In UAT**.
5. The reviewer tests in UAT. If it passes, the reviewer adds the `ready for production` label to the issue.
6. The release pipeline merges the ticket branch into `main`, deploys the result to production with local Apex tests,
   pushes `main`, deletes the ticket branch and closes the issue. The card moves to **Done**.

If UAT testing fails, the issue goes back to **Reopened** with a comment; fix it on the same ticket branch and open a
new pull request into `uat`.

## Repository layout

```
force-app/main/default/   Salesforce metadata (source format)
data/                     sample data and data plans
docs/runbooks/            manual steps that metadata cannot cover (org setup, post-deployment steps)
.github/                  CI/CD workflows, issue and pull request templates, CODEOWNERS
```

## Prerequisites

- [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli) (`sf`)
- [Visual Studio Code](https://code.visualstudio.com/) with the Salesforce Extension Pack
- Git and a GitHub account with access to this repository
- A Developer Edition org of your own: <https://developer.salesforce.com/signup>

Do not run `sf` commands through an anonymizing VPN or proxy: Salesforce freezes users who connect to the API that way
([help article 005318944](https://help.salesforce.com/s/articleView?id=005318944&type=1)).
