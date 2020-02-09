![Actions Status](https://github.com/machine-learning-apps/actions-impersonate/workflows/Tests/badge.svg)


# Impersonate a GitHub App With GitHub Actions

#### Note: This Action has been deprecated in favor of [machine-learning-apps/app-token](https://github.com/machine-learning-apps/actions-app-token).  However, we are still keeping this Action up for legacy reasons.  Please head over [to the new version](https://github.com/machine-learning-apps/actions-app-token) of this Action if using this for the first time.

## Why?

Actions have certain limitations.  Many of these limitations are for security and stability reasons, however not all of them are.  Some examples where you might want to impersonate a GitHub App temporarily in your workflow:

- You want an [event to trigger a workflow](https://help.github.com/en/articles/events-that-trigger-workflows) on a specific ref or branch in a way that is not natively supported by Actions.  For example, a pull request comment fires the [issue_comment event](https://help.github.com/en/articles/events-that-trigger-workflows#issue-comment-event-issue_comment) which is sent to the default branch and not the PR's branch.  You can temporarily impersonate a GitHub App to make an event, such as a [label a pull_request](https://help.github.com/en/articles/events-that-trigger-workflows#pull-request-event-pull_request) to trigger a workflow on the right branch. This takes advantage of the fact that Actions cannot create events that trigger workflows, however other Apps can.  

## Pre-requisites

1. If you do not already own a GitHub App you want to impersonate, [create a new GitHub App](https://developer.github.com/apps/building-github-apps/creating-a-github-app/) with your desired permissions.  If only creating a new app for the purposes of impersonation by Actions, you do not need to provide a `Webhook URL or Webhook Secret`

2. Install the App on your repositories. 

## Example Usage

```yaml
name: Demo
on: 
  pull_request:
    type: opened # PRs == Issues in GitHub

jobs:
  demo:
    runs-on: ubuntu-latest
    steps:

        # This step listens to all PR events for the triggering phrase
      - name: listen for PR Comments
        id: prcomm
        uses: machine-learning-apps/actions-impersonate@master
        with:
          APP_PEM: ${{ secrets.APP_PEM }}
          APP_ID: ${{ secrets.APP_ID }}

      # Get App Installation Token From Previous Step
      - name: Get App Installation Token
        if: steps.prcomm.outputs.TRIGGERED == 'true'
        run: |
          echo "This token is masked: ${TOKEN}"
        env: 
          TOKEN: ${{ steps.prcomm.outputs.APP_INSTALLATION_TOKEN }}
```

## Mandatory Inputs

- `APP_PEM`: description: string version of your PEM file used to authenticate as a GitHub App. 

- `APP_ID`: your GitHub App ID.

## Outputs

 - `APP_INSTALLATION_TOKEN`: The [installation access token](https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#authenticating-as-an-installation) for the GitHub App corresponding to the current repository.
