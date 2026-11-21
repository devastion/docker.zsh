# shellcheck shell=sh

Describe 'docker'
  BeforeEach 'load_plugin' 'stub_docker'

  Describe 'dprune'
    Before '_dockerzsh_confirm() { return 0; }'

    It 'rejects an unknown flag'
      When call dprune -x
      The status should eq 2
      The stderr should be present
    End

    It 'prunes with --force by default'
      When call dprune
      The output should include 'Docker context: default'
      The result of function last_docker_call should eq 'system prune --force'
    End

    It 'passes -a and --volumes'
      When call dprune -a -v
      The output should include 'Docker context: default'
      The result of function last_docker_call should eq 'system prune --force -a --volumes'
    End
  End

  Describe 'argument validation'
    Parameters
      dip
      dlog
      dexe
    End

    It "$1 without arguments is a usage error"
      When call "$1"
      The status should eq 2
      The stderr should be present
    End
  End

  It 'drm rejects extra arguments'
    When call drm x
    The status should eq 2
    The stderr should be present
  End

  It 'dsh rejects two arguments'
    When call dsh a b
    The status should eq 2
    The stderr should be present
  End

  It 'dsh passes a name or ID straight to docker exec'
    When call dsh abc123
    The status should be success
    The contents of file "${DOCKER_LOG}" should include 'exec -e TERM -e COLORTERM -i abc123 sh -c'
  End

  It 'dsh reports when no container is running and none is named'
    fzf() { :; }
    When call dsh
    The status should eq 1
    The stderr should include 'No docker containers running!'
  End

  It 'dexe defaults to /bin/sh and skips -t without a TTY'
    When call dexe c
    The status should be success
    The contents of file "${DOCKER_LOG}" should eq 'exec -i c /bin/sh'
  End

  It 'dexe passes the command through'
    When call dexe c ls -l
    The status should be success
    The contents of file "${DOCKER_LOG}" should eq 'exec -i c ls -l'
  End

  It 'dlog defaults to 10 lines'
    When call dlog c
    The status should be success
    The contents of file "${DOCKER_LOG}" should eq 'logs --follow --tail 10 c'
  End

  It 'dlog rejects a non-numeric line count'
    When call dlog c abc
    The status should eq 2
    The stderr should be present
  End

  It 'dstop reports when nothing is running'
    When call dstop
    The status should eq 1
    The stderr should include 'No docker containers running'
  End

  It 'drm reports when there is nothing to remove'
    When call drm
    The status should be success
    The output should include 'No containers to remove'
  End

  It 'dps -q skips the table'
    When call dps -q
    The status should be success
    The contents of file "${DOCKER_LOG}" should eq 'ps -q'
  End

  It 'dim builds a table query'
    When call dim
    The status should be success
    The contents of file "${DOCKER_LOG}" should include 'images --format {{or .Repository "-"}}'
  End

  It 'dip prints each network by name'
    When call dip c
    The status should be success
    The contents of file "${DOCKER_LOG}" should include '$name, $net'
  End
End
