#!/bin/bash

function send_digest_request()
{
  
}

function get_revision_id()
{
echo "Fetching the latest revision id for the change id $2"
local SIGNUM=$1
local CHANGE_ID=$2
local HTTP_PASSWORD=$3
local REVIEW_RATING=$4
local PAYLOAD='{"message": "Submitting the change using gerrit-api", labels: {"Code-Review": '"${REVIEW_RATING}"'}}'
local BASE_URL="https://gerrit.epk.ericsson.se/a/changes"
local BASIC_AUTH="${SIGNUM}:${HTTP_PASSWORD}"
local REVISION_ID=$(curl -s --digest -u "${BASIC_AUTH}" "${BASE_URL}/${CHANGE_ID}/?o=CURRENT_REVISION" | grep -e "current_revision" | awk '{print $2}' | grep -o "[a-z0-9]\+")
curl -s --digest -u "${BASIC_AUTH}" "${BASE_URL}/${CHANGE_ID}/revisions/${REVISION_ID}/review" -d '"$PAYLOAD"' -H 'Content-Type: application/json' > /dev/null
[[ $? -eq 0 ]] && echo "Changeset reviewed successfully" || echo "Failure: could not set the review"
}

function set_review()
{
echo "Setting the review for $2"
local SIGNUM=$1
local CHANGE_ID=$2
local HTTP_PASSWORD=$3
local REVIEW_RATING=$4
local PAYLOAD='{"message": "Submitting the change using gerrit-api", labels: {"Code-Review": '"${REVIEW_RATING}"'}}'
local BASE_URL="https://gerrit.epk.ericsson.se/a/changes"
local BASIC_AUTH="${SIGNUM}:${HTTP_PASSWORD}"
local REVISION_ID=$(curl -s --digest -u "${BASIC_AUTH}" "${BASE_URL}/${CHANGE_ID}/?o=CURRENT_REVISION" | grep -e "current_revision" | awk '{print $2}' | grep -o "[a-z0-9]\+")
curl -s --digest -u "${BASIC_AUTH}" "${BASE_URL}/${CHANGE_ID}/revisions/${REVISION_ID}/review" -d '"$PAYLOAD"' -H 'Content-Type: application/json' > /dev/null
[[ $? -eq 0 ]] && echo "Changeset reviewed successfully" || echo "Failure: could not set the review"
}

function submit_change()
{
 echo "Submitting the change $1"
 local CHANGE_ID=$1

}
set_review erahbaw 590443 ufBgY33ZH0TWWNL6HBNrcVAGqk4UCqz1OyKk3Lvt5A -1
