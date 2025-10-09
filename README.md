Awesome — I dug through the repo structure and put together a clean, ready-to-drop-in `README.md` for you. If you want me to tweak tone, add screenshots/GIFs, or include OS-specific package commands, just holler.

```markdown
# dev-dotfiles

Development dotfiles for a pleasant terminal setup across workstations and containers.

> Includes configs for Neovim (Lua), Zsh, Tmux, Starship, Lazygit and btop. The repo’s primary code is Lua (for Neovim), with a bit of shell. :contentReference[oaicite:0]{index=0}

---

## What’s inside

```

btop/           → ~/.config/btop
lazygit/        → ~/.config/lazygit
neovim/         → My Custom Neovim Repo (Lua)
starship/       → ~/.config (Starship prompt)
tmux/           → ~/.config/tmux
zsh/            → Zsh configuration
install.sh      → helper script to set things up

````

Repo layout derived from the GitHub tree. Exact file paths map to standard `$XDG_CONFIG_HOME` locations for each tool. :contentReference[oaicite:1]{index=1}

---

## Prerequisites

Make sure the following are installed (use your system package manager):

- **git**
- **zsh**
- **tmux**
- **neovim**
- **starship**
- **lazygit**
- **btop**

> The repo focuses on these tools; languages on GitHub indicate Neovim config is in Lua. :contentReference[oaicite:2]{index=2}

---

## Quick start

```bash
# 1) Clone
git clone https://github.com/hinriksnaer/dev-dotfiles.git
cd dev-dotfiles

# 2) Run the installer (if you prefer manual linking, see below)
#    Review the script before running.
bash install.sh
````

> The repository includes an `install.sh` script intended to help set things up. Open and review it to see exactly what it links or installs on your system. ([GitHub][1])

---

## Updating

```bash
cd ~/path/to/dev-dotfiles
git pull
# re-run install.sh if it manages links, or re-link manually if needed
```

---

## Troubleshooting

* **Configs not picked up?** Double-check symlink targets and that your tools reference the expected paths (e.g., Neovim uses `~/.config/nvim`).
* **Permission issues?** If your system requires it, run link steps without `sudo` so files remain owned by your user.
* **Conflicts with existing dotfiles?** Back up or move your old files before linking.

---

## Contributing

PRs and issues welcome. Keep changes tool-scoped (e.g., Neovim tweaks under `neovim/`, shell changes under `zsh/`, etc.).

---


## Credits

Built by @hinriksnaer. Repo overview and directory list referenced from the GitHub source. ([GitHub][1])

```

If you want, I can open the `install.sh` and each tool’s config to document exactly what gets linked/installed and any Neovim plugins or Tmux keybindings—just say the word and I’ll expand the README with those details.
```

[1]: https://github.com/hinriksnaer/dev-dotfiles "GitHub - hinriksnaer/dev-dotfiles: Development dotfiles used for terminal configurations accross different workstations and containers"
