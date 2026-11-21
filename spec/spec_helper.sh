# shellcheck shell=sh
# Loaded by ShellSpec (running under zsh). Plugin code is zsh-only, so it is
# loaded from inside a function that switches to zsh emulation.

load_plugin() {
  emulate -L zsh
  fpath=("${SHELLSPEC_PROJECT_ROOT}/functions" $fpath)
  autoload -Uz "${SHELLSPEC_PROJECT_ROOT}"/functions/*(N:t)
}

# Put a fake `docker` first on PATH that logs its arguments to $DOCKER_LOG.
stub_docker() {
  mkdir -p "${SHELLSPEC_TMPBASE}/bin"
  DOCKER_LOG="${SHELLSPEC_TMPBASE}/docker.log"
  : > "${DOCKER_LOG}"
  export DOCKER_LOG
  cat > "${SHELLSPEC_TMPBASE}/bin/docker" <<'STUB'
#!/bin/sh
echo "$@" >> "$DOCKER_LOG"
[ "$1" = context ] && echo default
exit 0
STUB
  chmod +x "${SHELLSPEC_TMPBASE}/bin/docker"
  PATH="${SHELLSPEC_TMPBASE}/bin:${PATH}"
  rehash
}

last_docker_call() {
  tail -n 1 "${DOCKER_LOG}"
}

spec_helper_precheck() {
  load_plugin
}
