normf() {
    local USER_42="fcardozo"
    local MAIL_42="fcardozo@student.42.org.br"
    local FORMATTER=$(command -v c_formatter_42 || echo "$HOME/.local/bin/c_formatter_42")

    _generate_42_header() {
        local file=$(basename "$1")
        local now=$(date +"%Y/%m/%d %H:%M:%S")

        cat << 'EOF'
/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
EOF
        printf "/*   %-51s:+:      :+:    :+:   */\n" "$file"
        cat << 'EOF'
/*                                                    +:+ +:+         +:+     */
EOF
        printf "/*   By: %-42s +#+  +:+       +#+        */\n" "$USER_42 <$MAIL_42>"
        cat << 'EOF'
/*                                                +#+#+#+#+#+   +#+           */
EOF
        printf "/*   Created: %s by %-17s#+#    #+#             */\n" "$now" "$USER_42"
        printf "/*   Updated: %s by %-17s###   ########.fr       */\n" "$now" "$USER_42"
        cat << 'EOF'
/*                                                                            */
/* ************************************************************************** */

EOF
    }

    _has_42_header() {
        [[ -f "$1" ]] && head -n 1 "$1" | grep -q "^/\* \*\{74\} \*/$"
    }

    _remove_existing_header() {
        local file="$1"
        local tmp=$(mktemp)

        awk '
            /^\/\* \*+.*\*\/$/ { in_header=1; next }
            in_header && /^\s*$/ { in_header=0; next }
            in_header { next }
            { print }
        ' "$file" > "$tmp"

        mv "$tmp" "$file"
    }

    if [[ $# -eq 0 ]]; then
        echo "Usage: normf <path>"
        return 1
    fi

    if [[ ! -x "$FORMATTER" ]]; then
        echo "Error: c_formatter_42 not found at $FORMATTER"
        return 1
    fi

    for arg in "$@"; do
        local items=()

        if [[ -d "$arg" ]]; then
            while IFS= read -r -d '' file; do
                items+=("$file")
            done < <(find "$arg" -type f \( -name "*.c" -o -name "*.h" \) -print0)
        elif [[ -f "$arg" ]]; then
            items=("$arg")
        else
            echo "$arg not <file/directory>"
            continue
        fi

        for file in "${items[@]}"; do
            [[ -f "$file" ]] || continue

            if _has_42_header "$file"; then
                _remove_existing_header "$file"
            fi

            local tmp=$(mktemp)
            _generate_42_header "$file" > "$tmp"
            cat "$file" >> "$tmp"
            mv "$tmp" "$file"

            if "$FORMATTER" "$file" &>/dev/null; then
                echo "$file [OK]"
            else
                echo "$file [FAIL]"
            fi
        done
    done
}
