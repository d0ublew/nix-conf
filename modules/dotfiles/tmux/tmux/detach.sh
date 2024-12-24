#!/usr/bin/env bash

curr_session=$(tmux display-message -p '#S')
curr_window=$(tmux display-message -p '#W')
popup_session="__pup"
sp_session="__sp"
cmd="${1:-bash}"
window_name="win_${cmd%%* }"

rm -f /tmp/.tmux.sp.detached

if [[ "${curr_session}" == "${sp_session}" ]]; then 
    touch /tmp/.tmux.sp.detached
    exit 0
fi

if [[ "${curr_session}:${cmd}" == "${popup_session}:bash" ]]; then 
        exit 0
fi
if [[ "${curr_session}:${curr_window}" == "${popup_session}:${window_name}" ]]; then 
    exit 0
fi
exit 1
