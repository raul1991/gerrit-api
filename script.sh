#!/bin/bash

# internal utility methods
local SIGNUM="erahbaw"
local HTTP_PASSWORD="ufBgY33ZH0TWWNL6HBNrcVAGqk4UCqz1OyKk3Lvt5A"
local BASIC_AUTH="${SIGNUM}:${HTTP_PASSWORD}"
local BASE_URL="https://gerrit.epk.ericsson.se/a"

function __prepare_digest_request_str()
{
local URL="$1"
local TYPE="$2"
local PAYLOAD="$3"
local HEADER=''
case "$2" in
        "POST"|"post"|"p")
                if [[ -z "$PAYLOAD" ]];then 
			echo "Expecting a json payload as third argument"
			exit 1
		else
                	HEADER='Content-Type: application/json'
                	echo "curl -s --digest -u ${BASIC_AUTH} -X POST \"${BASE_URL}${URL}\" -d \"${PAYLOAD}\" -H \"${HEADER}\""
		fi
         	;;
        "GET"|"get"|"g")
		echo "curl -s --digest -u ${BASIC_AUTH} -X GET \"${BASE_URL}${URL}\""
                ;;
        *)
                echo "Error: Unsupported request type found. Only Get/Post request supported."
                ;;
esac
}

function __get_revision_id()
{
local CHANGE_ID=$1
local URL="/changes/${CHANGE_ID}/?o=CURRENT_REVISION"
local COMMAND_STR=$(__prepare_digest_request_str "${URL}" "g")
local REVISION_ID=$(eval ${COMMAND_STR} | grep -e "current_revision" | awk '{print $2}' | grep -o "[a-z0-9]\+")
[[ $? -eq 0 ]] && echo "${REVISION_ID}" || return 1
}

# utility methods end here.

function set_review_for_latest_revision()
{
echo "Giving $2 for the change id: $1"
local CHANGE_ID=$1
local REVIEW_RATING="$2"
local PAYLOAD='{"labels": {"Code-Review": '"${REVIEW_RATING}"'}}'
local REVISION_ID=$(__get_revision_id "${CHANGE_ID}")
local URL="/changes/${CHANGE_ID}/revisions/${REVISION_ID}/review"
# execute the command string
local COMMAND_STR=$(__prepare_digest_request_str "${URL}" "p" "${PAYLOAD}")
eval "${COMMAND_STR}"
[[ $? -eq 0 ]] && echo "Changeset reviewed successfully" || echo "Failure: could not set the review"
}

function submit_change()
{
 echo "Submitting the change $1"
 local CHANGE_ID=$1
 local URL="/changes/${CHANGE_ID}/submit"
 local COMMAND_STR=$(__prepare_digest_request_str "${URL}" "p" '{"wait_for_merge": true}')
 eval "${COMMAND_STR}"
 [[ $? -eq 0 ]] && echo "Change $1 submitted successfully" || echo "Failure: change could not be submitted"
}

# Examples calls
# set review
#set_review_for_latest_revision 590443 2

# get current revision change
#rev_id=$(__get_revision_id 590443)

# submit the change
#submit_change 590443
