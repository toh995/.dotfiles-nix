#!/usr/bin/env bash
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/.bash_history"
[[ -f "${HISTFILE}" ]] || \
	mkdir -p "$( dirname "${HISTFILE}" )"
