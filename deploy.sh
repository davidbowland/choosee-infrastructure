#!/usr/bin/env bash

# Stop immediately on error
set -e

if [[ -z "$1" ]]; then
  $(./scripts/assumeAdminRole.sh)
fi

# Deploy infrastructure

sam deploy --stack-name choosee-infrastructure-test \
  --template-file template.yaml --region us-east-2 \
  --capabilities CAPABILITY_NAMED_IAM \
  --no-fail-on-empty-changeset \
  --parameter-overrides Environment=test
