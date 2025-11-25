# Parrot/Kali Hacker Zsh Setup — complete, safe, fast
# --------------------------------------------------

# Only run interactive config for interactive shells
[[ -o interactive ]] || return

# ---- Basic environment ----
export TERM="xterm-256color"
export CLICOLOR=1
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
HISTSIZE=100000
SAVEHIST=200000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY

# ---- Simple colors & compinit ----
autoload -U colors && colors 2>/dev/null || true
autoload -U compinit && compinit -u 2>/dev/null || true

# ---- Minimal LS_COLORS for speed ----
export LS_COLORS='di=1;34:fi=0;37:ln=1;36:or=1;31:mi=1;31:ex=1;32:pi=0;33:so=1;35:bd=1;33:cd=1;33:su=37;41:sg=30;43:tw=30;42:ow=34;42:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.xz=1;31:*.7z=1;31:*.rar=1;31:*.deb=1;31:*.rpm=1;31:*.jar=1;31:*.jpg=1;35:*.jpeg=1;35:*.gif=1;35:*.bmp=1;35:*.png=1;35:*.svg=1;35:*.mp4=1;35:*.mkv=1;35:*.avi=1;35:*.mov=1;35:*.webm=1;35:*.mp3=0;36:*.flac=0;36:*.wav=0;36:*.ogg=0;36:*.m4a=0;36:*.pdf=0;33:*.txt=0;33:*.doc=0;33:*.docx=0;33:*.log=0;90:*.sh=0;92:*.bash=0;92:*.zsh=0;92:*.py=0;93:*.js=0;93:*.ts=0;93:*.java=0;93:*.c=0;93:*.cpp=0;93:*.go=0;93:*.rs=0;93:*.rb=0;93:*.php=0;93:*.html=0;96:*.css=0;96:*.json=0;96:*.xml=0;96:*.yaml=0;96:*.yml=0;96:*.md=0;96:*.conf=0;96:*.cfg=0;96:*.ini=0;96:*.toml=0;96:*.o=0;90:*.so=0;90:*.pyc=0;90:*.class=0;90:*.exe=1;32:*.apk=1;32:*~=0;90:*.bak=0;90:*.tmp=0;90:*.swp=0;90'


# ---- Helpful helpers & functions ----
precmd() { echo }   # blank line before prompt

auto_ls() {
  emulate -L zsh
  if command -v ls >/dev/null 2>&1; then
    ls --color=auto --group-directories-first
  else
    command ls
  fi
}
chpwd_functions+=(auto_ls)

lsd() { tree -C -L ${1:-2} --dirsfirst 2>/dev/null || ls -CF --group-directories-first; }

preview() {
  if command -v bat >/dev/null 2>&1; then
    bat --style=numbers,changes --color=always "$@"
  else
    cat "$@"
  fi
}

pwd() { builtin pwd | sed "s|$HOME|~|" | GREP_COLORS='ms=01;36' grep --color=always '.*' }

extract() {
  if [ -z "$1" ]; then
    echo "Usage: extract <file>"
    return 1
  fi
  if [ ! -f "$1" ]; then
    echo "'$1' is not a valid file"
    return 1
  fi
  case "$1" in
    *.tar.bz2)   tar xjf "$1"     ;;
    *.tar.gz)    tar xzf "$1"     ;;
    *.bz2)       bunzip2 "$1"     ;;
    *.rar)       unrar x "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xf "$1"      ;;
    *.tbz2)      tar xjf "$1"     ;;
    *.tgz)       tar xzf "$1"     ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *)           echo "'$1' cannot be extracted via extract()" ;;
  esac
}

# ---- Aliases ----
alias ll='ls -lh --color=auto --group-directories-first'
alias la='ls -lha --color=auto --group-directories-first'
alias l='ls -CF --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias _='sudo'
alias please='sudo'

alias tree='tree -C'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --color=always'
alias gd='git diff --color=always'

alias df='df -h --output=source,size,used,avail,pcent,target'
alias free='free -h'
alias psa='ps auxf'
psg() { ps aux | grep -v grep | grep -i -e VSZ -e "$@"; }

# ---- Prompt (Kali/Parrot style) ----

if [[ $EUID -eq 0 ]]; then
  PROMPT=$'%F{21}┌──(%F{9}root%F{cyan}@%m%F{green})─[%F{green}%~%F{21}]\n└──╼ %F{yellow}# %f'
else
  PROMPT=$'%F{20}┌──(%F{white}%B%n%F{45}@%b%F{white}%B%m%F{21}%b)─[%F{green}%B%~%F{20}%b]\n└──> %F{51}$ %f'
fi

# ---- ZSH Syntax Highlighting styles (optional colors) ----
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=green'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=red'
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow,bold'

# ---- Plugin handling (safe) ----
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.zsh_custom}
mkdir -p "$ZSH_CUSTOM"

_zsh_ensure_clone() {
  local repo="$1" dest="$2"
  if [[ -z "$repo" || -z "$dest" ]]; then return 1; fi
  if [[ ! -d "$dest" ]]; then
    git clone --depth=1 "$repo" "$dest" 2>/dev/null || return 1
  fi
}

_zsh_ensure_clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/zsh-autosuggestions"
_zsh_ensure_clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/zsh-syntax-highlighting"

[[ -f "$ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# ---- fzf integration (if installed) ----
if command -v fzf >/dev/null 2>&1; then
  [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
  [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || true
  if [[ -z "$(bindkey -L | grep '\\C-r')" ]]; then
    source <(fzf --completion 2>/dev/null) 2>/dev/null || true
  fi
fi

# ---- Async-ish completion speedups ----
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zsh/cache"
mkdir -p "$HOME/.zsh/cache"
if (( $+commands[zcompile] )); then
  compinit -C 2>/dev/null || compinit 2>/dev/null || true
fi

# ---- Plugin updater helper ----
zsh_plugin_update() {
  local dir
  for dir in "$ZSH_CUSTOM"/*; do
    if [[ -d "$dir/.git" ]]; then
      printf "Updating: %s\n" "$dir"
      git -C "$dir" pull --ff-only --quiet || printf "Failed: %s\n" "$dir"
    fi
  done
}
alias zsh-plugin-update='zsh_plugin_update'

# ---- fnm / node version manager support (safe) ----
FNM_PATH="$HOME/.local/share/fnm"
if [[ -d "$FNM_PATH" ]]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env 2>/dev/null)" 2>/dev/null || true
fi

# ---- Optional visual tools (commented) ----
# sudo apt install bat exa fd-find ripgrep fzf -y
# alias cat='bat'
# alias ls='exa --icons --group-directories-first'
# alias ll='exa -lh --icons --group-directories-first'

# ---- Source local env if present (safe) ----
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# ---- Done ----
echo "Zsh ready — plugins: $( [[ -d $ZSH_CUSTOM/zsh-autosuggestions ]] && echo autosuggestions || true ) $( [[ -d $ZSH_CUSTOM/zsh-syntax-highlighting ]] && echo syntax-highlighting || true )"

