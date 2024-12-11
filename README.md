# dotfiles
My configuration files. Productive Hyprland NixOS system. Some programs also used on MacOS.
# Setup/Features
- NixOS
- Hyprland Window Manager
- Keybindings optimized for the Colemak DH Layout
- Nushell
- Ghostty Terminal
- waybar
  - Power Menu
  - Weather
  - Calendar
  - Notifications (Dunst)
- Helix
# Installation
Install via the Nix flake after adding your `hardware-configuration.nix` into this folder.
```bash
cd ~ && git clone https://github.com/LinusDikomey/dotfiles && cp /etc/nix/hardware-configuration.nix dotfiles/ && sudo nixos-rebuild switch --flake ~/dotfiles#default
```
After that, everything *should* work as expected.
