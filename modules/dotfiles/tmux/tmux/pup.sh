#!/usr/bin/env bash

curr_session=$(tmux display-message -p '#S')
curr_window=$(tmux display-message -p '#W')
popup_session="__pup"
cmd="${1:-bash}"
window_name="win_${cmd%%* }"

if ! tmux has-session -t "$popup_session" 2> /dev/null; then
    tmux new-session -d -s "$popup_session" -n "${window_name}" "${cmd}" 2> /dev/null
    tmux set-option -s -t "$popup_session" status off
    # tmux set-option -s -t "$popup_session" prefix None
fi

tmux new-window -S -t "${popup_session}:" -c "#{pane_current_path}" -n "${window_name}" "${cmd}"
if [[ ${curr_session} != "${popup_session}" ]]; then
    tmux attach -t "${popup_session}:${window_name}" > /dev/null
fi

