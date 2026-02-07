# dotfiles
My nix flake configuration.
Includes NixOS with a Niri Desktop as well as a MacOS and a Raspberry Pi Homelab configuration.

# Setup/Features
- NixOS/nix-darwin
- Configurable nix modules for a flexible config
- Keybindings optimized for the Colemak DH Layout

## Programs
- Niri
- Helix
- Nushell
- ghostty
- waybar
  - Power Menu
  - Weather
  - Calendar
  - Notifications (swaync)
- Zed
- sddm
- ... and many more

# Hosts

| Name    | OS     | Description                        |
| ------- | ------ | ---------------------------------- |
| Saturn  | NixOS  | Main PC                            |
| Mars    | Darwin | MacBook Air                        |
| Titan   | NixOS  | Homelab Raspberry Pi               |
| Neptune | NixOS  | Server VM for some various hosting |

# Installation
Before installing, note that this is my personal configuration and you probably don't want to just
use this because everything is pretty opinionated. If you still want to try it out or use it as a
starting point, follow this section.


Clone this repository to your home folder:
```bash
cd ~
git clone https://github.com/LinusDikomey/dotfiles
```

## Creating your own config
You can create your own host configuration to customize and add your own user.:
```nix
# in hosts/example.nix
{dotfiles, ...}: {
  home-manager.users.${dotfiles.username}.dotfiles = {
    graphical.enable = true;
    coding.enable = true;
  };
}
```
Add your configuration module to hosts/ and use the dotfiles options to configure.
On NixOS, you probably also want to copy in your hardware configuration and add it inline or import it.

Then open flake.nix and add your own user next to the existing ones:
```nix
# in flake.nix next to existing users
users."exampleUser" = {
  key = ""; # add your public ssh key
  # name and email for git:
  name = "";
  email = ""; 
};
```
Then at the bottom, link your config
```nix
# on NixOS:
nixosConfigurations.example = mkNixos ./hosts/example.nix "exampleUser";
# on MacOS:
darwinConfigurations.example = mkDarwin ./hosts/darwin.nix "exampleUser";
```

Then execute the following (replacing saturn with your custom host if you created one):
```bash
# on NixOS:
sudo nixos-rebuild switch --flake ~/dotfiles#example
# on MacOS (after installing nix https://github.com/DeterminateSystems/nix-installer):
nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles#example
```
