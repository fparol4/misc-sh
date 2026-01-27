# WORKSPACE
alias c='clear'
alias n='norminette'
alias exp='explorer.exe'

# PROGRAMS
wg() {
    local TARGET_PATH=$(readlink -f "${1:-$PWD}")
    windsurf --folder-uri "vscode-remote://wsl+Ubuntu-24.04$TARGET_PATH"
}