# Nushell Config File

use ~/.config/nushell/themes/catppuccin-mocha.nu

$env.config = {
    show_banner: false
    rm: { always_trash: true }
    cursor_shape: { emacs: line }
    color_config: (catppuccin-mocha)
    use_kitty_protocol: true
}

source ~/.cache/carapace/init.nu

use ~/.cache/starship/init.nu

alias :q = exit
alias cat = bat
alias icat = kitten icat
alias mv = mv -i # always prompt on overwrite
alias "nix develop" = nix develop --command nu
alias "nix-shell" = nix-shell --command nu
#alias "nix shell" = nix shell --command nu
alias nixr = sudo nixos-rebuild switch --flake ~/dotfiles#default

def take_out_the_trash [] {
    if (not ("~/.local/share/Trash/files" | path exists)) {
        echo "Trash is already empty"
        return
    }
    let file_count = ls ~/.local/share/Trash/files/ | length
    if ($file_count == 0) {
        "Trash is already empty"
    } else {
        let input = (input --numchar 1 $"Do you really want to delete ($file_count) files? \(y/n\)")
        if ($input == "y") {
            rm -rfp ~/.local/share/Trash/*
            echo "Trash was taken out"
        } else {
            echo "Doing nothing"
        }
    }
}
