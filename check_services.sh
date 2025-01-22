#!/bin/bash


# Define the services to check
services=("cloudreve" "pzserver" "mcserver" "zerotier-one" "ts" "valheim")

# Define the JSON file path
json_file="/home/breynald/StatusCheck/status_log.json"

# Get the current timestamp
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Function to check the status of a service
check_service_status() {
  service_name=$1
  if systemctl is-active --quiet $service_name; then
    echo "active"
  else
    echo "inactive"
  fi
}

# Function to remove records older than one month
remove_old_records() {
  jq 'with_entries(
    .value |= map(
        select(
            (now - (.timestamp | strptime("%Y-%m-%d %H:%M:%S") | mktime) < 2592000)
        )
    )
  )' $json_file > tmp.$$.json && mv tmp.$$.json $json_file
}


# Initialize the JSON file if it doesn't exist or is empty
if [[ ! -f $json_file ]] || [[ ! -s $json_file ]]; then
  echo "{}" > $json_file
fi


# Remove old records
remove_old_records

# Iterate over each service and update the JSON file
for service in "${services[@]}"; do
  status=$(check_service_status $service)
  jq --arg service "$service" --arg timestamp "$timestamp" --arg status "$status" \
    '.[$service] += [{"timestamp": $timestamp, "status": $status}]' $json_file > tmp.$$.json && mv tmp.$$.json $json_file
done
