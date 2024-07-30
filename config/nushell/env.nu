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

$env.EDITOR = nvim

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend '~/.cargo/bin/'
    | prepend '~/dev/llvm/17-cross/bin/'
)

if $nu.os-info.name == "macos" {
    $env.PATH = ($env.PATH | split row (char esep)
        | prepend $'/opt/homebrew/bin/'
        | prepend $'/opt/homebrew/lib/'
        | prepend '/usr/local/lib/'
        | prepend '/usr/local/bin/'
    )
    # this overwrites the variable but it is unset otherwise anyways
    $env.DYLD_LIBRARY_PATH = $"(brew --prefix)/lib"
    $env.SHADERC_LIB_DIR = $"(brew --prefix)/lib"
    $env.RUSTFLAGS = "-L /opt/homebrew/lib/"
}

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
