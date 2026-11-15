# docker.zsh

Docker helpers for zsh. The plugin does nothing when `docker` is not on `PATH`.

| Command | What it does |
| --- | --- |
| `dsh` | Open a shell in a running container |
| `dstop` | Stop all running containers |
| `dexe` | Execute a command in a running container |
| `dim` | List images in a table |
| `dip` | Show a container's IP address |
| `dlog` | Follow a container's logs |
| `dprune [-a] [-v]` | Prune unused resources; `-a` also removes all unused images, `-v` also removes volumes. Asks first. |
| `drm` | Remove stopped containers |
| `dstats` | Show running container statistics |

Aliases: `dco` (`docker compose`), `dcoup-nopull`, `dps`, `dpsa`, `dpsq`. Completions for `dsh`, `dexe`, `dip` and `dlog` are included.

## Install

```sh
git clone https://github.com/devastion/docker.zsh.git ~/.zsh/docker.zsh
echo 'source ~/.zsh/docker.zsh/docker.plugin.zsh' >> ~/.zshrc
```

Load it before `compinit`, or run `compinit` afterwards, so the completions are found.

## Configuration

```zsh
zstyle ':docker:' aliases no   # skip the aliases; set before sourcing
```

When [zalias](https://github.com/devastion/zalias) is loaded first, the aliases are defined through it, with descriptions.

## License

MIT
