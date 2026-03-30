#!/usr/bin/env bash

curr_session=$(tmux display-message -p '#S')
curr_window=$(tmux display-message -p '#W')
sp_session="__sp"
cmd="${1:-bash}"

if ! tmux has-session -t "$sp_session" 2> /dev/null; then
    tmux new-session -d -s "$sp_session" "${cmd}" 2> /dev/null
    # tmux set-option -s -t "$sp_session" status off
    # tmux set-option -s -t "$sp_session" prefix None
fi

tmux attach -t "${sp_session}" > /dev/null
