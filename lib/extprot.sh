extprot() {
    local target="$1"
    [[ ! -f "$target" ]] && return 1

    local cleaned_content
    cleaned_content=$(perl -0777 -pe 's/\/\*.*?\*\///gs; s/\/\/.*$//gm' "$target")

    # 1. Simple Typedefs (non-block)
    echo "$cleaned_content" | grep -P '^\s*typedef\s+(?!struct|enum|union)\S.*?;' | sed 's/^[[:space:]]*//'

    # 2. Block Types (struct, enum, union) - No extra spacing inside/between
    local block_regex='(?s)(typedef\s+)?(struct|enum|union)\s+\w*\s*\{.*?\}\s*\w*\s*;'
    echo "$cleaned_content" | grep -Pzo "$block_regex" | tr '\0' '\n' | sed '/^$/d'

    # 3. Function Prototypes - Line break only between distinct functions
    echo "$cleaned_content" | \
        perl -0777 -pe 's/\n+/ /g' | \
        grep -Po '[a-zA-Z_][\w\s\*]+\s+[a-zA-Z_]\w*\s*\([^)]*\)\s*\{' | \
        sed 's/\s*{/;/g' | \
        perl -pe 's/\s+/ /g; s/^ //; s/; /;\n/g'
}
