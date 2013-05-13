PROMPT='%~%{$fg[red]%}$(git_prompt_info)%{$reset_color%} $ '
local rvm_ruby=' %{$fg[red]%}[$(~/.rvm/bin/rvm-prompt i v g s)]%{$reset_color%}'
RPROMPT="${rvm_ruby}"

ZSH_THEME_GIT_PROMPT_PREFIX=" [%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[red]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[red]%}"
