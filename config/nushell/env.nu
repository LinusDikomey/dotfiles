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

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend '~/.cargo/bin/'
    | prepend '~/dev/llvm/17/bin/'
)

if $nu.os-info.name == "macos" {
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin/')
}

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
