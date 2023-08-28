
function fish_greeting
end

if status is-interactive
end

if test -z "$DISPLAY"
    and test "$XDG_VTNR"
	and test "$XDG_VTNR" -eq 1
	exec startx
end

function fish_prompt
    set prompt_exit $status
    if fish_is_root_user
        set_color red
        echo -n '#'
    end
    if test "$prompt_exit" -ne 0
        set_color red
        echo -n "[$prompt_exit] "
    end

    set_color cyan
    echo -n (prompt_pwd)
    # echo -n '~'
    set_color brblue
    echo -n '> '
end

function sudo!!
    eval sudo $history[1]
end

set -x --universal SSH_AUTH_SOCK $XDG_RUNTIME_DIR"/ssh-agent.socket"

# Starship prompt
starship init fish | source

# aliases
alias ls=exa
# alias hx=helix
alias cat=bat

alias :q exit

## git aliases
alias gp=git pull
alias gca="git add . ; git commit"
