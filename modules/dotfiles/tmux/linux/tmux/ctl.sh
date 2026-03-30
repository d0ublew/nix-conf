#!/usr/bin/env bash

curr_session=$(tmux display-message -p '#S')
popup_session="__pup"
sp_session="__sp"
cmd="${1:-bash}"
window_name="win_${cmd%%* }"

if [[ ${curr_session} == "${popup_session}" ]] && [[ "${cmd}" != "bash" ]]; then
    tmux new-window -S -t "${curr_session}:" -c "#{pane_current_path}" -n "${window_name}" "${cmd}"
else
    if [[ "${cmd}" == "bash" ]] && ! [ -f /tmp/.tmux.sp.detached ]; then
        tmux display-popup -E -d "#{pane_current_path}" -w 80% -h 80% -- ~/.tmux/sp.sh "${cmd}"
    elif [[ "${cmd}" != "bash" ]]; then
        tmux display-popup -E -d "#{pane_current_path}" -w 80% -h 80% -- ~/.tmux/pup.sh "${cmd}"
    fi
fi
