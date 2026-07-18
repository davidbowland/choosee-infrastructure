# choosee-infrastructure

## General

**Always commit changes** after completing work unless explicitly told not to.

This is an **infrastructure repo**: AWS SAM / CloudFormation for the choosee
project's shared resources (Cognito user/identity pools, the Lambda deployment
artifact bucket, and the IAM roles/users the sibling `choosee-api` and
`choosee-ui` pipelines assume). There is no application code here — the
Lambda source lives in `choosee-api`, the static site in `choosee-ui`.

## Layout

- `template.yaml` — the SAM/CloudFormation stack (primary artifact).
- `deploy.sh`, `scripts/assumeAdminRole.sh` — deployment and role-assumption
  helpers (shell).
- No `src/`, no jest, no eslint. `lint` is `prettier --write .` only.

## Commands

- **Format:** `npm run lint` (prettier only).
- **Validate template:** `sam validate --lint`
- **Deploy (local/manual):** `npm run deploy` (`./deploy.sh`) — assumes the
  admin role via `scripts/assumeAdminRole.sh` when no argument is passed, then
  `sam deploy`s the test stack. CI deploys via
  `.github/workflows/pipeline.yaml`.
- Never run a deploy that targets production without an explicit request.

## Style

- Prefer **functional, declarative** template composition; avoid copy-paste
  between the testing and production parameter sets — parameterize with
  `Environment`.
- Keep resource logical IDs and parameter names consistent with the sibling
  repos' conventions (clones share shape — drift is entropy, not intent).

## Security (CloudFormation)

- **No secrets in plaintext CFN parameters.** Where a parameter carries an API
  key or token, it MUST have `NoEcho: true`. (This template currently declares
  only `Environment` as a parameter — no secret-bearing parameters exist
  today; keep this rule in mind if one is added.)
- **IAM least privilege:** scope actions to specific resource ARNs. Avoid
  `Resource: '*'` and broad `service:*` actions in runtime roles. Keep the
  scoped SAM policy-template style already used by `PipelineRole` and
  `CloudFormationRole`.
- Do NOT, in this pass, change bucket ACLs/PublicAccessBlock, CloudFront
  OAC/OAI, TLS floors, throttling, DLQs, PITR, or Cognito — those are
  explicitly out of scope. The pipeline's own use of `role/full-access`
  (rather than a scoped role) and the second, apparently-vestigial
  phone-auth Cognito user/identity pool are known, deliberately deferred
  findings — do not "fix" either without an explicit request.

## Hygiene

- `LICENSE` (ISC) present and `"license": "ISC"` in package.json.
- `.github/dependabot.yml` (npm weekly + github-actions weekly).
- `.gitignore` covers `node_modules/`, `.DS_Store`.
