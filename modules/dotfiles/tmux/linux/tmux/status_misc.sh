function prefix_indicator() {
    printf "#{?client_prefix,#[bg=blue]#[fg=#ffffff]#[bold] P ,}#[default]"
}

function mouse_indicator() {
    printf "#{?mouse,,#[bg=red]#[fg=#ffffff]#[bold] M }#[default]"
}

function zoom_indicator() {
    printf "#{?window_zoomed_flag,#[bg=green]#[fg=#ffffff]#[bold] Z ,}#[default]"
}

function sync_indicator() {
    printf "#{?pane_synchronized,#[bg=magenta]#[fg=#ffffff]#[bold] S ,}#[default]"
}

function main() {
    mouse_indicator
    sync_indicator
    zoom_indicator
    prefix_indicator
}

main
