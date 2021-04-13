#
#                          CEC ZSHELL THEME
#
########################################################################
#
#                           Chris Cummins
#                       http://chriscummins.cc
#                    Thursday 25th September 2014
#
#                  GNU General Public License v3.0
#                http://www.gnu.org/copyleft/gpl.html
#
########################################################################
#

# Print a newline between every command.
# To disable, comment out this line.
precmd() { print "" }


# Function to format the path of the current working directory.
#
__cec_zsh_theme_cwd() {
    # Two options here, uncomment the one you want to use:
    # -----------------
    # (1) Use `scp`-style paths where $HOME is assumed, so that "src" means
    #     "~/src", and paths outside of $HOME are as-written.
    #
    pwd=${PWD/#$HOME\//}
    pwd=${pwd/#$HOME/}
    # -----------------
    # (2) Or always use the full path, but rewrite s/$HOME/~/:
    #
    # pwd=${PWD/$HOME/~}
    # -----------------
    echo "$(tput bold)$(tput setaf 1)${pwd}$(tput sgr0)"
}

# Get the prompt prefix, e.g. "$", "#", "(dev) *$", etc.
#
__cec_zsh_theme_prefix() {
    local prefix=''

    # Prefix promt with [GPU:$CUDA_VISIBLE_DEVICES], if set.
    if [ ! -z ${CUDA_VISIBLE_DEVICES+x} ]; then
        if [ -z "${CUDA_VISIBLE_DEVICES}" ]; then
            prefix="[GPU:none] "
        else
            prefix="[GPU:$CUDA_VISIBLE_DEVICES] "
        fi
    fi

    # Prefix prompt with ($ENV) environment variable, if set. This
    # can be used be scripts which spawn subshells in order to
    # indicate a non-standard environment.
    [ $ENV ] && { prefix="$prefix($(basename $ENV)) " }

    # Prefix prompt with ($VIRTUAL_ENV) environment variable, if set. This
    # is used for python development. See:
    #   https://python-guide-pt-br.readthedocs.io/en/latest/dev/virtualenvs/
    [ $VIRTUAL_ENV ] && { prefix="$prefix($(basename $VIRTUAL_ENV)) " }

    # Set pound sign "#" or dollar sign "$" prefix character depending
    # on whether we're superuser or a normal user, respectively.
    if (( $UID != 0 )); then
        prefix="$prefix$"
    else
        prefix="$prefix#"
    fi

    echo "$prefix"
}

# Print a given string in a colour depending on the contents of the
# string.
#
__cec_zsh_theme_colourise() {
    local string="$1"
    local total=2
    local i

    # Sum the ASCII values of the characters in the string
    for (( i=0; i < ${#string}; i++ )); do
        total=$((total+$(printf '%d' \'${string:$i:1})))
    done

    # Convert integer into a colour code in the range [1,7]
    local modcode=$((1 + $(expr $total % 7)))

    # Set colour code
    local color=$(tput setaf $modcode)

    echo "$color$1$reset_color"
}


__cec_zsh_theme_exit_status='\
%(?..%{$fg_bold[red]%}% Previous command exited with return code $? %{$reset_color%}
)'


# Left hand side prompt.
#
# Shows the return code (if non-zero) of the previous command, the
# username and hostname, current directory, and git version control
# status.
PROMPT="$__cec_zsh_theme_exit_status"'\
$(tput bold)$(__cec_zsh_theme_colourise $USER)\
@\
$(tput bold)$(__cec_zsh_theme_colourise $HOST)\
:$(__cec_zsh_theme_cwd)\
$(git_prompt_info) \
at $(date "+%H:%M:%S").\

$(__cec_zsh_theme_prefix) '


# Right hand prompt.
#
# Show the current time in HH:MM:SS format.
# RPROMPT="$(date '+%H:%M:%S')"


ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"
