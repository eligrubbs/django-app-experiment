#!/bin/bash

# Script to deploy the glasscap server as part of the CD workflow.
# Assumes you have set RENDER_API_KEY, GLASSCAP_ECR_AWS_REGION, GLASSCAP_ECR_REGISTRY_ID, and GLASSCAP_ECR_REPO_NAME
# environment variables set

set -euo pipefail

# Usage: ./deploy_server.sh <docker_digest> <has_migrations> <webapp_service_id>
if [ $# -lt 3 ]; then
  echo "Usage: $0 <docker_digest> <has_migrations> <webapp_service_id>"
  echo "Example: $0 sha256:abc123... true srv-123"
  exit 1
fi

IMG_BASE_URL="ghcr.io/eligrubbs/django-app-experiment" # TODO: Make programatic to update
IMG="${IMG_BASE_URL}@${1}"
HAS_MIGRATIONS="${2}"
WEBAPP_SERVICE_ID="${3}"


# Configuration
TIMEOUT=300  # 5 minutes timeout
POLL_INTERVAL=5  # Check every 5 seconds


# Function to check deployment status
check_deployment_status() {
  local service_id=$1
  local deploy_id=$2
  local response

  response=$(curl -s -X GET \
    -H "Accept: application/json" \
    -H "Authorization: Bearer ${RENDER_API_KEY}" \
    "https://api.render.com/v1/services/${service_id}/deploys/${deploy_id}" \
    | jq -r '.status' 2>/dev/null)

  echo "$response"
}


# Function to deploy a set of servers
deploy_servers() {
  local -n servers_ref=$1
  local services=${2:-"unknown"}
  local environment=${3:-"unknown"}
  local img="${4:-$IMG}"

  echo "🚀 Starting deployment of ${services} to ${environment}..."

  # Trigger deployments
  local -A deploy_map=()  # Maps service_id to deploy_id
  for server_id in "${servers_ref[@]}"; do
    echo "  Triggering deployment for ${server_id}..."

    # Use webapp to get deploy ID
    deploy_response=$(curl -s -X POST \
      -H "Accept: application/json" \
      -H "Authorization: Bearer ${RENDER_API_KEY}" \
      -H "Content-Type: application/json" \
      -d "{\"imageUrl\":\"${img}\"}" \
      "https://api.render.com/v1/services/${server_id}/deploys")

    deploy_id=$(echo "$deploy_response" | jq -r '.id' 2>/dev/null)
    if [[ "$deploy_id" != "null" && -n "$deploy_id" ]]; then
      deploy_map["$server_id"]="$deploy_id"
      echo "    Deploy ID: ${deploy_id}"
    else
      echo "    ❌ Failed to trigger deployment for ${server_id}"
      echo "    Response: ${deploy_response}"
      exit 1
    fi
  done

  # Wait for deployments to complete
  echo "⏳ Waiting for ${services} in ${environment} deployments to complete..."

  local start_time=$(date +%s)
  local all_complete=false

  while [[ $all_complete == false ]]; do
    all_complete=true

    for server_id in "${!deploy_map[@]}"; do
      deploy_id="${deploy_map[$server_id]}"
      status=$(check_deployment_status "$server_id" "$deploy_id")

      case "$status" in
        "live")
          echo "  ✅ ${server_id}: deployed successfully"
          ;;
        "build_failed"|"update_failed"|"pre_deploy_failed"|"canceled")
          echo "  ❌ ${server_id}: deployment failed with status ${status}"
          exit 1
          ;;
        "created"|"queued"|"build_in_progress"|"update_in_progress"|"pre_deploy_in_progress")
          echo "  🔄 ${server_id}: deployment in progress (${status})"
          all_complete=false
          ;;
        "deactivated")
          echo "  ⚠️  ${server_id}: service is deactivated"
          all_complete=false
          ;;
        *)
          echo "  ⚠️  ${server_id}: unknown status ${status}"
          all_complete=false
          ;;
      esac
    done

    if [[ $all_complete == false ]]; then
      # Check timeout
      local current_time=$(date +%s)
      local elapsed=$((current_time - start_time))

      if [[ $elapsed -gt $TIMEOUT ]]; then
        echo "❌ Deployment timeout after ${TIMEOUT} seconds"
        exit 1
      fi

      echo "  Checking again in ${POLL_INTERVAL} seconds..."
      sleep $POLL_INTERVAL
    fi
  done

  echo "✅ ${services} deployments completed successfully!"
}

# Deploy based on migration status
# Currently don't have any other servers, so both branches look the same.
# Migrations are handled by render.com preDeployCommand that runs a script
if [ "$HAS_MIGRATIONS" = "true" ]; then
  echo "📋 Deploying Webapp first (migrations detected)."

  # Deploy webapp first (runs migrations via preDeployCommand)
  webapp_server=("$WEBAPP_SERVICE_ID")
  deploy_servers webapp_server "webapp" "environment"

  # Deploy workers and playwright workers in parallel
#   pids=()

#   for pid in "${pids[@]}"; do
#     wait "$pid" || exit 1
#   done
else
  echo "📋 Deploying all services in parallel"

  all_servers=("$WEBAPP_SERVICE_ID")

  pids=()
  deploy_servers all_servers "All" "environment" &
  pids+=($!)

  for pid in "${pids[@]}"; do
    wait "$pid" || exit 1
  done
fi

echo "🎉 Deployment completed successfully!"
