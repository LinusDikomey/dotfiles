# Nushell Environment Config File
#
# version = "0.87.0"

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
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

$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.cargo/bin/')

if $nu.os-info.name == "macos" {
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin/')
}

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
