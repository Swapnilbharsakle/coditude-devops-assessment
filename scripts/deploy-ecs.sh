#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?AWS_REGION is required}"
: "${ENVIRONMENT:?ENVIRONMENT is required}"
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:-$(aws sts get-caller-identity --query Account --output text)}"
: "${IMAGE_TAG:?IMAGE_TAG is required}"

CLUSTER="coditude-${ENVIRONMENT}"
REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

update_service() {
  local service="$1"
  local family="$2"
  local repository="$3"

  local image="${REGISTRY}/coditude/${ENVIRONMENT}/${repository}:${IMAGE_TAG}"
  local task_json
  task_json="$(mktemp)"

  aws ecs describe-task-definition \
    --region "${AWS_REGION}" \
    --task-definition "${family}" \
    --query taskDefinition > "${task_json}"

  jq --arg image "${image}" \
    'del(.taskDefinitionArn,.revision,.status,.requiresAttributes,.compatibilities,.registeredAt,.registeredBy)\n     | .containerDefinitions[0].image = $image' \
    "${task_json}" > "${task_json}.new"

  task_definition_arn="$(aws ecs register-task-definition \
    --region "${AWS_REGION}" \
    --cli-input-json "file://${task_json}.new" \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text)"

  aws ecs update-service \
    --region "${AWS_REGION}" \
    --cluster "${CLUSTER}" \
    --service "${service}" \
    --task-definition "${task_definition_arn}" \
    --force-new-deployment >/dev/null

  echo "Updated ${service} to ${task_definition_arn}"
  rm -f "${task_json}" "${task_json}.new"
}

update_service "coditude-${ENVIRONMENT}-frontend" "coditude-${ENVIRONMENT}-frontend" frontend
update_service "coditude-${ENVIRONMENT}-backend" "coditude-${ENVIRONMENT}-backend" backend
