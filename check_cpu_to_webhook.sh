#!/bin/bash

# Get the machine's name and IP address
name=$(hostname)
ip=$(hostname -I | awk '{print $1}')

# Format the message to be sent to Slack
message="Machine Name: $name\nIP Address: $ip"

# Set the variables for the message
CustomerName="Example Customer"
subscriptionName="Example Subscription"
EventType="Example Event Type"
ResourceType="Example Resource Type"
ResourceCount="Example Resource Count"
CreateTime="Example Create Time"
ResourceName="Example Resource Name"

# Set the body JSON structure
body='{
  "@type": "MessageCard",
  "@context": "http://schema.org/extensions",
  "themeColor": "0076D7",
  "summary": "요청 이름",
  "sections": [
    {
      "activityTitle": "알람 이름",
      "wrap": true,
      "markdown": true,
      "facts": [
        {"name": "CustomerName", "value": "'"$CustomerName"'"},
        {"name": "SubscriptionName", "value": "'"$subscriptionName"'"},
        {"name": "Event Type", "value": "'"$EventType"'"},
        {"name": "ResourceType", "value": "'"$ResourceType"'"},
        {"name": "ResourceCount", "value": "'"$ResourceCount"'"},
        {"name": "CreateTime", "value": "'"$CreateTime"'"},
        {"name": "ResourceName", "value": "'"$ResourceName"'"}
      ],
      "activitySubtitle": "MSP manager",
      "activityImage": "https://monthlyreportappkey.blob.core.windows.net/image/cloocus_logo.png"
    }
  ]
}'

# Define your Slack webhook URL
slack_webhook_url="https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX"
teams_webhook_url=""
threshold=1

while true; do
  cpu_usage=$(top -bn1 | awk 'NR>7{s+=$9}END{print s}')

  if (( $(echo "$cpu_usage > $threshold" | bc -l) )); then
    echo "CPU usage is above $threshold%: $cpu_usage%"
    # Add your notification logic here (e.g., send an email, trigger an alert, etc.)
  fi

  sleep 1
  # Send the message to Slack
  curl -X POST -H 'Content-type: application/json' --data "$body" "$slack_webhook_url"
  curl -X POST -H 'Content-type: application/json' --data "$body" "$teams_webhook_url"
done