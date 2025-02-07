# My dotfiles

## Important configs
* Terminal: `zsh`, `kitty`, `tmux`, `nvim`
* DE: `i3`, `polybar`, `picom`, `rofi`, `dunst`

## Installing configs
### Automatic (currently only installs to .config)
```bash
./install-configs.sh
```
### Manual
The following commands have to be executed from inside the `~/.dotfiles` directory!
* Install configs to `~/.config` with: `stow -v -S app` (uninstall with `-D` instead of `-S`)
* Install configs to `/etc` with: `stow -v -t /etc -S etc`

## Theme
* [Catppucchin Macchiato](https://github.com/catppuccin/catppuccin)

## Shell scripts
* use `shellcheck`!
* use `shfmt`!

## Secrets "management"
* secret environment variables go in `~/.dotfiles/zsh/.config/zsh/.secrets` (this file is ignored in `.gitignore`; don't even try)
* this file is sourced in `~/.dotfiles/zsh/.config/zsh/.zshrc.local`

---

## TODOs
### Fix first
* ~~renew nvim config~~
* ~~dunst config~~

### Fix some time
* ~~secrets management~~
