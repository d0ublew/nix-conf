#!/bin/bash

function ipv4() {
	printf "#[fg=black,bg=blue,bold] W #[fg=#ffffff,bg=brightblack,bold] %s #[default]" "$(ip address show en0 | rg -oP '(?<=inet ).*(?= brd)' | cut -d '/' -f1)"
}

function sep() {
	printf " | "
}

function session_name() {
	# printf "#[fg=green]#S #[default]> "
	# printf "#[fg=black,bg=white,bold] #S #[default]"
	printf "#[fg=#ffffff,bg=brightblack,bold] #S #[default]"
}

function main() {
	session_name
    printf " "
    ipv4
}

# Calling the main function which will call the other functions.
main
