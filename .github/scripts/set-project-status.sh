#!/usr/bin/env bash
# Sets the "Status" field of an issue's card on the organization project.
# Usage: set-project-status.sh <issue-number> <status-option-name>
# Needs: GH_TOKEN with organization Projects read/write; PROJECT_NUMBER; GITHUB_REPOSITORY.
set -euo pipefail

issue="$1"
status="$2"
owner="${GITHUB_REPOSITORY%%/*}"
repo="${GITHUB_REPOSITORY##*/}"

project_json="$(gh api graphql -f query='
  query($owner: String!, $number: Int!) {
    organization(login: $owner) {
      projectV2(number: $number) {
        id
        field(name: "Status") {
          ... on ProjectV2SingleSelectField { id options { id name } }
        }
      }
    }
  }' -f owner="$owner" -F number="$PROJECT_NUMBER")"

project_id="$(jq -r '.data.organization.projectV2.id' <<<"$project_json")"
field_id="$(jq -r '.data.organization.projectV2.field.id' <<<"$project_json")"
option_id="$(jq -r --arg s "$status" '.data.organization.projectV2.field.options[] | select(.name == $s) | .id' <<<"$project_json")"
if [[ -z "$option_id" ]]; then
  echo "::warning::Status option '$status' not found on project #$PROJECT_NUMBER."
  exit 0
fi

issue_id="$(gh api "repos/$owner/$repo/issues/$issue" --jq .node_id)"

# Returns the existing item when the issue is already on the project.
item_id="$(gh api graphql -f query='
  mutation($project: ID!, $content: ID!) {
    addProjectV2ItemById(input: {projectId: $project, contentId: $content}) { item { id } }
  }' -f project="$project_id" -f content="$issue_id" --jq '.data.addProjectV2ItemById.item.id')"

gh api graphql -f query='
  mutation($project: ID!, $item: ID!, $field: ID!, $option: String!) {
    updateProjectV2ItemFieldValue(input: {
      projectId: $project, itemId: $item, fieldId: $field,
      value: {singleSelectOptionId: $option}
    }) { projectV2Item { id } }
  }' -f project="$project_id" -f item="$item_id" -f field="$field_id" -f option="$option_id" > /dev/null

echo "Issue #$issue moved to '$status' on project #$PROJECT_NUMBER."
