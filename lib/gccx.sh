gccx() {
  local sources=()
  local args=()
  local execute_flag=false
  local flags=(-g -O0 -Wall -Wextra -Werror)
  local has_input_sources=false

  for arg in "$@"; do
    if [[ "$arg" == "--" ]]; then
      execute_flag=true
      continue
    elif [[ "$arg" == "-q" ]]; then
      flags=(-g -O0)
      continue
    fi

    if [[ "$execute_flag" == true ]]; then
      args+=("$arg")
    else
      if [[ -d "$arg" ]]; then
        echo "Directory '$arg' found. Searching recursively..."
        while IFS= read -r -d '' file; do
          sources+=("$file")
        done < <(find "$arg" -name "*.c" -not -path "*/.*" -type f -print0)
        has_input_sources=true
      elif [[ -f "$arg" ]]; then
        sources+=("$arg")
        has_input_sources=true
      else
        echo "Warning: Ignoring '$arg'. Not a valid file or directory." >&2
      fi
    fi
  done

  if [[ "$has_input_sources" == false ]]; then
    echo "No source files or directories provided. Searching recursively from ."
    while IFS= read -r -d '' file; do
      sources+=("$file")
    done < <(find . -name "*.c" -not -path "./.*" -type f -print0)
  fi

  if [[ ${#sources[@]} -eq 0 ]]; then
    echo "Error: No .c files found." >&2
    return 1
  fi

  echo "--- Compiling ---"
  echo "Files: ${sources[*]}"
  echo "Flags: ${flags[*]}"

  gcc "${flags[@]}" -o x0 "${sources[@]}"
  local compile_status=$?

  if [[ $compile_status -ne 0 ]]; then
    echo "Error: Compilation failed." >&2
    return $compile_status
  fi

  echo "Compilation successful: ./x0"

  if [[ "$execute_flag" == true ]]; then
    echo "--- Executing ./x0 ---"
    [[ ${#args[@]} -gt 0 ]] && echo "Runtime args: ${args[*]}"

    ./x0 "${args[@]}"
    local execute_status=$?

    echo "--- Execution finished (code: $execute_status) ---"
    return $execute_status
  fi

  return 0
}
