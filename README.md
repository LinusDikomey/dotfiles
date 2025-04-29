# dotfiles
My nix flake configuration. Includes a NixOS Hyprland Desktop as well as a MacOS and a Raspberry Pi Homelab configuration.

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

# Hosts

| Name   | OS     | Description          |
| ------ | ------ | -------------------- |
| Saturn | NixOS  | Main PC              |
| Mars   | Darwin | MacBook Air          |
| Titan  | NixOS  | Homelab Raspberry Pi |

# Installation
Execute the following (on NixOS):
```bash
cd ~
git clone https://github.com/LinusDikomey/dotfiles
sudo nixos-rebuild switch --flake ~/dotfiles#saturn
```
After that, everything *should* work as expected.

You might want to create your own host with your own hardware-configuration.nix.
