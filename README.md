## Label Pull Request Action

The Label Pull Request Action is a custom GitHub action that automatically adds labels to a pull request based on its review status. It supports the following conditions:

- If half of the reviews are approved, it adds a `status:ready-to-merge` label.
- If there are conflicts, it adds a `status:conflicts-found` label.
- If any reviewer has requested changes, it adds a `status:changes-requested` label.

### Inputs

- `github-token` (required): The GitHub token used to authenticate with the API. You can use the `secrets.GITHUB_TOKEN` token.

### Usage

To use the action in your workflow, you can add the following step:

```yaml
- name: Label pull request
  uses: Mr-Leonerrr/labeler-actions@master
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
    pull-request-number: ${{ github.event.pull_request.number }}
```