const core = require('@actions/core');
const github = require('@actions/github');

async function run() {
    try {
        const token = core.getInput('token');
        const octokit = github.getOctokit(token);
        const context = github.context;

        if (context.eventName === 'pull_request') {
            const prNumber = context.payload.pull_request.number;

            const reviews = await octokit.rest.pulls.listReviews({
                owner: context.repo.owner,
                repo: context.repo.repo,
                pull_number: prNumber
            });

            const numApprovals = reviews.data.filter(review => review.state === 'APPROVED').length;
            const numRequestedChanges = reviews.data.filter(review => review.state === 'CHANGES_REQUESTED').length;
            const numReviewers = reviews.data.filter(review => review.user.login !== context.payload.pull_request.user.login).length;
            const hasConflicts = context.payload.pull_request.mergeable_state === 'dirty';

            let labels = [];

            if (numApprovals >= numReviewers / 2) {
                labels.push('status:ready-to-merge');
            }

            if (numRequestedChanges > 0) {
                labels.push('status:changes-requested');
            }

            if (hasConflicts) {
                labels.push('status:conflicts-found');
            }

            if (labels.length > 0) {
                await octokit.issues.addLabels({
                    owner: context.repo.owner,
                    repo: context.repo.repo,
                    issue_number: prNumber,
                    labels: labels
                });
            }
        }
    } catch (error) {
        core.setFailed(error.message);
    }
}

run().then(r => console.log(r));
