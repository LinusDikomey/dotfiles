
function fish_greeting
end

if test -z "$DISPLAY"
    and test "$XDG_VTNR"
	and test "$XDG_VTNR" -eq 1
	# exec startx
end

function sudo!!
    eval sudo $history[1]
end

set -x --universal SSH_AUTH_SOCK $XDG_RUNTIME_DIR"/ssh-agent.socket"

# Starship prompt

if status is-interactive
    starship init fish | source
end

# aliases
alias ls=eza
alias cat=bat
alias :q=exit
alias du=dust

## git aliases
alias gp=git pull
alias gca="git add . ; git commit"


# notes setup
function note
    ~/sync/s
    ~/sync/notes/edit-daily-note
    ~/sync/s
end

function todo
    ~/sync/s
    nvim ~/sync/notes/todo.md
    ~/sync/s
end
