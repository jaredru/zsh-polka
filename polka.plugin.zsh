
#
# Polka
#

# define our expansion function
polka-try-expand() {
    if [[ $CURSOR = $#BUFFER && $BUFFER =~ "^\.\.([0-9]*)$" ]]; then
        BUFFER="cd ../"

        for ((i = 1; i < ${match[1]:-0}; i++)); do
            BUFFER+="../";
        done

        zle end-of-line
        return 0
    fi

    return 1
}

# for a space, insert the character if we fail the expansion
polka-handle-space() {
    if ! polka-try-expand; then
        zle self-insert
    fi
}

# for enter, accept the line regardless of the expansion result
polka-handle-enter() {
    polka-try-expand
    zle accept-line
}

# in order to bind the functions, we need to create widgets for them
zle -N polka-handle-space
zle -N polka-handle-enter

# bind our functions to <SPACE> and <CR>
bindkey " "  polka-handle-space
bindkey "^M" polka-handle-enter

