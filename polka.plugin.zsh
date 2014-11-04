
#
# Polka
#

polka-try-expand() {
    # if the cursor is at the end of the buffer,
    # and the buffer matches the form "..%d"
    if [[ $CURSOR = $#BUFFER && $BUFFER =~ "^\.\.([0-9]*)$" ]]; then
        BUFFER="cd ../"

        for ((i = 1; i < ${match[1]:-0}; i++)); do
            BUFFER+="../";
        done

        # move the cursor to the end of the line
        zle end-of-line
        return 0
    fi

    return 1
}

polka-handle-space() {
    # if the expansion failed, just insert the space
    if ! polka-try-expand; then
        zle self-insert
    fi
}

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

