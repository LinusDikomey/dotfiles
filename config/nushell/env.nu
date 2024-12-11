# Nushell Environment Config File

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

$env.EDITOR = "hx"

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend '~/.cargo/bin/'
    | prepend '~/dev/llvm/bin/'
    | prepend '~/.local/bin/'
    | prepend '~/dev/scripts/'
)

if $nu.os-info.name == "macos" {
    $env.PATH = ($env.PATH | split row (char esep)
        | prepend $'/opt/homebrew/bin/'
        | prepend $'/opt/homebrew/lib/'
        | prepend '/usr/local/lib/'
        | prepend '/usr/local/bin/'
        | prepend '/Users/linusdikomey/anaconda3/bin/'
        | prepend '/Library/TeX/texbin'
    )
    # this overwrites the variable but it is unset otherwise anyways
    $env.DYLD_LIBRARY_PATH = $"(brew --prefix)/lib"
    $env.LIBRARY_PATH = $"(brew --prefix)/lib"
    $env.SHADERC_LIB_DIR = $"(brew --prefix)/lib"
    $env.RUSTFLAGS = $"-L (brew --prefix)/lib"
    $env.CPATH = $"(brew --prefix)/include"

    # for Nix
    $env.PATH = ($env.PATH | split row (char esep)
        | prepend $"($env.HOME)/.nix-profile/bin"
        | prepend "/nix/var/nix/profiles/default/bin"
        | prepend "/etc/profiles/per-user/linusdikomey/bin"
	| prepend "/run/current-system/sw/bin/"
    )
    $env.NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
}

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
