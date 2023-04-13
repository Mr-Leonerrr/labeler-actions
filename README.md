## Label Pull Request Review Action

The Label Pull Request Action is a custom GitHub action that automatically adds labels to a pull request based on its review status. It supports the following conditions:

- If half of the reviews are approved, it adds a `status:ready-to-merge` label.
- If there are conflicts, it adds a `status:conflicts-found` label. (Solution pending to run on pull requests with conflicts)
- If any reviewer has requested changes, it adds a `status:changes-requested` label.

> Note: The action will only add labels, it will not remove any existing labels.

### Inputs

- `github_token` (required): The GitHub token used to authenticate with the API. You can use the `secrets.GITHUB_TOKEN` token.
- `pull_request_number` (required): The number of the pull request to label.
- `ready_to_merge_label` (optional): The label to add when the pull request is approved by half of the reviewers. Default: `status:ready-to-merge`.
- `changes_required_label` (optional): The label to add when the pull request has requested changes. Default: `status:changes-requested`.

### Usage

To use the action in your workflow, you can add the following step:

```yaml
- name: Label pull request reviews
  uses: Mr-Leonerrr/labeler-actions@master
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    pull_request_number: ${{ github.event.pull_request.number }}
```
