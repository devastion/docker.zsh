#!/usr/bin/env zsh
emulate -L zsh
local root=${0:A:h:h} tmp=$(mktemp -d) fails=0
trap 'rm -rf "$tmp"' EXIT
print -r -- '#!/bin/sh
echo "$@" >> "$DOCKER_LOG"
[ "$1" = context ] && echo default
exit 0' > $tmp/docker
chmod +x $tmp/docker
export DOCKER_LOG=$tmp/log PATH="$tmp:$PATH"
fpath=($root/functions $fpath)
autoload -Uz $root/functions/*(N:t)

check() { [[ $2 == $3 ]] && print "ok   $1" || { print "FAIL $1: got '$2' want '$3'"; ((fails++)); } }

dprune -x 2> /dev/null; check 'dprune bad flag' $? 2
: > $DOCKER_LOG; __dockerzsh_confirm() { return 0 }
dprune -a -v > /dev/null; check 'dprune -a -v' "$(tail -1 $DOCKER_LOG)" 'system prune --force -a --volumes'
: > $DOCKER_LOG; dprune > /dev/null; check 'dprune plain' "$(tail -1 $DOCKER_LOG)" 'system prune --force'
dip 2> /dev/null; check 'dip no arg' $? 2
dlog 2> /dev/null; check 'dlog no arg' $? 2
dexe 2> /dev/null; check 'dexe no arg' $? 2
dsh a b 2> /dev/null; check 'dsh two args' $? 2
dip c; [[ "$(<$DOCKER_LOG)" == *"\$name, \$net"* ]]; check "dip uses network name" $? 0
exit $((fails > 0))
