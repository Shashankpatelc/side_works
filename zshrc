# ============================
# Parrot/Kali Hacker Zsh Setup
# ============================

autoload -U compinit && compinit
autoload -U colors && colors

# History
HISTSIZE=100000
SAVEHIST=200000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE APPEND_HISTORY INC_APPEND_HISTORY

# Aliases
alias ll='ls -lh'
alias la='ls -lha'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias _='sudo'
alias please='sudo'

# Prompt — Kali style
if [[ $EUID -eq 0 ]]; then
  PROMPT='%F{21}┌──(%F{9}root%F{cyan}@%m%F{green})─[%F{green}%~%F{21}]
└──╼ %F{yellow}# %f'
else
  PROMPT='%F{20}┌──(%F{white}%B%n%F{45}@%b%F{white}%B%m%F{21}%b)─[%F{green}%B%~%F{20}%b]
└──> %F{51}$ %f'
fi

# Enable Zsh plugins (syntax highlighting, autosuggestions)
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.zsh_custom}
[[ -d ${ZSH_CUSTOM}/zsh-autosuggestions ]] || git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/zsh-autosuggestions
[[ -d ${ZSH_CUSTOM}/zsh-syntax-highlighting ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/zsh-syntax-highlighting
source ${ZSH_CUSTOM}/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true
source ${ZSH_CUSTOM}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true

# Path safety
export PATH="$HOME/bin:$PATH"

