#!/usr/bin/env bash

function ipv4() {
	printf "#[fg=yellow]%s#[default]" "$(ip address show eth0 | grep -oP '(?<=inet ).*(?= brd)')"
}

function sep() {
	printf " | "
}

function session_name() {
	# printf "#[fg=green]#S #[default]> "
	# printf "#[fg=brightblack]#[fg=brightwhite,bg=brightblack,bold] #S #[default]#[fg=brightblack,nobold,noitalics,nounderscore] "
	printf "#[fg=#ffffff,bg=brightblack,bold] #S #[default]"
}

function main() {
	session_name
	printf " "
}

# Calling the main function which will call the other functions.
main
