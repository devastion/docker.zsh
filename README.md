# docker.zsh

Docker helpers for zsh. The plugin does nothing when `docker` is not on `PATH`.

| Command | What it does |
| --- | --- |
| `dsh [container]` | Open a shell (bash if present, else sh) in a container by name or ID. Without an argument, pick one with `fzf`. |
| `dstop` | Stop all running containers (timeout 5s; see Configuration) |
| `dexe <container> [cmd...]` | Execute a command in a running container; defaults to `/bin/sh` |
| `dim` | List images in a table |
| `dip <container>` | Show a container's IP address per network |
| `dlog <container> [lines]` | Follow a container's logs (default: last 10 lines) |
| `dps [docker ps args]` | List containers in a table (`-q` and `--format` pass straight to `docker ps`) |
| `dprune [-a] [-v]` | Prune unused resources; `-a` also removes all unused images, `-v` also removes volumes. Asks first. |
| `drm [-f]` | Remove exited, created and dead containers. Asks first unless `-f`. |
| `dstats` | Show running container statistics |

Aliases: `dco` (`docker compose`), `dcoup-nopull` (`docker compose up --pull never`), `dpsa` (`dps -a`), `dpsq` (`docker ps -q`). Completions are included for `dexe`, `dip`, `dlog`, `drm`, `dprune` and `dsh`.

Requires `column` (for tables) and, for `dsh` without an argument, `fzf`.

## Install

```sh
git clone https://github.com/devastion/docker.zsh.git ~/.zsh/docker.zsh
echo 'source ~/.zsh/docker.zsh/docker.plugin.zsh' >> ~/.zshrc
```

With a plugin manager, load `devastion/docker.zsh` the usual way (zinit, antidote, sheldon).

Load it before `compinit`, or run `compinit` afterwards, so the completions are found.

## Configuration

```zsh
zstyle ':docker:' aliases no          # skip the aliases; set before sourcing
zstyle ':docker:dstop' timeout 10     # seconds for `docker stop -t` (default 5)
```

When [zalias](https://github.com/devastion/zalias) is loaded first, the aliases are defined through it, with descriptions.

## Testing

Tests use [ShellSpec](https://github.com/shellspec/shellspec) and run under zsh:

```sh
shellspec
```

## License

MIT
