unalias g 2>/dev/null

g() {
  if [[ $# -eq 0 ]]; then
    git status -sb
    return
  fi

  local cmd="$1"
  shift

  case "$cmd" in
    p) git push "$@" ;;
    f) git fetch "$@" ;;
    c) git commit "$@" ;;
    ck) git checkout "$@" ;;
    s) git status -sb "$@" ;;
    st) git stash "$@" ;;
    up)
      local ts msg
      ts=$(date '+%Y-%m-%d %H:%M:%S')
      msg="(${ts})"
      if [[ $# -gt 0 ]]; then
        msg="$*"
      fi

      git add -A || return 1
      if git diff --cached --quiet; then
        echo "No changes to commit."
        return 0
      fi
      git commit -m "$msg" && git push
      ;;
    *)
      git "$cmd" "$@"
      ;;
  esac
}

# Optional shorthand aliases
alias gp='git push'
alias gf='git fetch'
alias gc='git commit'
alias gck='git checkout'
alias gs='git stash'
