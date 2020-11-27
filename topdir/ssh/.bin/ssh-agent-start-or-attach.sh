#!/usr/bin/env bash

# This script must be sourced.

if SSH_AGENT_PID=$(pgrep --uid $(whoami) --newest --exact ssh-agent); then
    SSH_AUTH_SOCK=$(printf '%s' /tmp/ssh*/agent.$((SSH_AGENT_PID - 1)))
    export SSH_AGENT_PID
    export SSH_AUTH_SOCK
else
    eval $(ssh-agent)
fi
