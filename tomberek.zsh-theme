setopt hist_ignorealldups

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
function nix_shell() {
  if ps --no-headers -o args $PPID | grep -q nix-shell; then
    echo "%{$fg_bold[green]%}nix-shell:"
  fi
}
function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[magenta]%}ssh:"
  fi
}

function perDir(){
    if [[ $_per_directory_history_is_global == true ]]; then
        echo "G"
    else
        echo "L"
    fi
}
bindkey -M viins 'jj' vi-cmd-mode
# Ctrl Right
bindkey '^[[1;5C' forward-word
# Ctrl Left
bindkey '^[[1;5D' backward-word
bindkey '^[[4D' backward-word
# Ctrl .
bindkey '^[[1;5n' insert-last-word
# Ctrl ,
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '^[[1;5l' copy-earlier-word

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc]-s
bindkey "\es" sudo-command-line

autoload -Uz narrow-to-region
function _history-incremental-preserving-pattern-search-backward
{
  local state
  MARK=CURSOR  # magick, else multiple ^R don't work
  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
  zle end-of-history
  zle history-incremental-pattern-search-backward
  narrow-to-region -R state
}
zle -N _history-incremental-preserving-pattern-search-backward
bindkey "^R" _history-incremental-preserving-pattern-search-backward
bindkey -M isearch "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

foreground-vim() {
  fg %vim
}
zle -N foreground-vim
bindkey '^Z' foreground-vim

PROMPT='$(nix_shell)$(ssh_connection)%(?,%{$fg[green]%},%{$fg[red]%})%? %{$reset_color%}%{$fg[cyan]%}%1~ %{$fg_bold[$NCOLOR]%}%(!.#.$) %{$reset_color%}'


function zle-line-init zle-keymap-select {
    VIMD='%{$fg_bold[$NCOLOR]%}%~%{$reset_color%}:%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}$(perDir)'
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$VIMD"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

ZSH_THEME_GIT_PROMPT_PREFIX="<%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[yellow]%}✗%{$fg[green]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}>"
