source $HOME/.config/zsh/lib/gccx.sh
source $HOME/.config/zsh/lib/normf.sh

kp() {
  [ -z "$1" ] && echo "Uso: kill_port <porta>" && return 1
  pid=$(lsof -ti tcp:$1)
  [ -z "$pid" ] && echo "Nenhum processo encontrado na porta $1" && return 0
  kill -9 $pid && echo "Processo na porta $1 (PID $pid) finalizado"
}

loadenv() {
  [ -z "$1" ] && echo "Usage: load_env /path/to/.env" && return 1
  [ ! -f "$1" ] && echo "File not found: $1" && return 1
  set -a
  . "$1"
  set +a
}
