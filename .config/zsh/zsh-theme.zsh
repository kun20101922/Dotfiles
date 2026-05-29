_git_branch() {
  local branch
  branch=$(git branch --show-current 2>/dev/null)
  [[ -n "$branch" ]] && echo " %{$fg[red]%}(%{$fg[yellow]%}$branch%{$fg[red]%})"
}

# Prompt
setopt PROMPT_SUBST
PROMPT='%{$fg[white]%}%~%{$fg[red]%}$(_git_branch)%{$fg[red]%} %%%{$reset_color%} '
