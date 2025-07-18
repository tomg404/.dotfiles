# My dotfiles

## Info
- [Theme for most things](https://github.com/catppuccin/catppuccin)

## Installing main configs
### Automatic (currently only installs to .config)
```bash
./install-configs.sh
```
### Manual
The following commands have to be executed from inside the `~/.dotfiles` directory!
- Install configs to `~/.config` with: 
```bash
stow -v -S app # (uninstall with `-D` instead of `-S`)
``` 
- Install configs to `/etc` with: 
```bash
stow -v -t /etc -S etc
```

## Other configs
#### Firefox
- [remove tabs](https://superuser.com/a/1424494)

## Shell scripts
- use `shellcheck`!
- use `shfmt`!

## Secrets "management"
- secret environment variables go in `~/.dotfiles/zsh/.config/zsh/.secrets` (this file is ignored in `.gitignore`; don't even try)
- it is sourced in `~/.dotfiles/zsh/.config/zsh/.zshrc.local`

## TODOs
- include `st` patches
