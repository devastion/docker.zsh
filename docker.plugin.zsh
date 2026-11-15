0=${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}
0=${${(M)0:#/*}:-$PWD/$0}

((${+commands[docker]})) || return 0

((${fpath[(Ie)${0:h}/functions]})) || fpath=("${0:h}/functions" $fpath)
((${fpath[(Ie)${0:h}/completions]})) || fpath=("${0:h}/completions" $fpath)
autoload -Uz -- "${0:h}"/functions/*(N:t)

if zstyle -T ':docker:' aliases; then
  () {
    local def flags description name value
    local -a defs=(
      'e|Run Docker Compose|dco|docker compose'
      'e|Start Docker Compose services without pulling images|dcoup-nopull|docker compose up --pull never'
      '|List running Docker containers in a table|dps|__dockerzsh_list_containers'
      '|List all Docker containers in a table|dpsa|__dockerzsh_list_containers -a'
      '|Print running Docker container IDs|dpsq|docker ps -q'
    )
    for def in "${defs[@]}"; do
      IFS='|' read -r flags description name value <<< "${def}"
      if ((${+functions[zalias]})); then
        zalias ${flags:+-$flags} -d "${description}" "${name}=${value}"
      else
        alias "${name}=${value}"
      fi
    done
  }
fi
