typeset -gA GO2_ALIASES=(
  vault /home/fcardozo/Self/x00/_all/_vaults/default
  course /home/fcardozo/Self/x42/course
)

go2() {
  [ -z "$1" ] && echo "Usage: go2 <name>" && return 1

  local target="${GO2_ALIASES[$1]}"
  [ -z "$target" ] && echo "unknown alias $1" >&2 && return 1

  cd "$target" || return 1
}
