gccx() {
  local sources=()
  local args=()
  local execute_flag=false
  local flags=(-g -O0 -Wall -Wextra -Werror)
  local has_input_sources=false
  local lib_archives=()

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
        while IFS= read -r -d '' file; do
          sources+=("$file")
        done < <(find "$arg" -type f -name "*.c" -not -path "*/.*" -print0)
        has_input_sources=true
      elif [[ -f "$arg" ]]; then
        sources+=("$arg")
        has_input_sources=true
      else
        echo "Warning: Ignoring '$arg'. Not a valid file or directory." >&2
      fi
    fi
  done

  # If no sources provided, search from current dir
  if [[ "$has_input_sources" == false ]]; then
    echo "No source files or directories provided. Searching recursively from ."
    while IFS= read -r -d '' file; do
      sources+=("$file")
    done < <(find . -type f -name "*.c" -not -path "./.*" -print0)
  fi

  if [[ ${#sources[@]} -eq 0 ]]; then
    echo "Error: No .c files found." >&2
    return 1
  fi

  if [[ -d "./lib" ]]; then
    while IFS= read -r -d '' a; do
      lib_archives+=("$a")
    done < <(find ./lib -maxdepth 1 -type f -name "*.a" -print0)
  fi

  if [[ -d "./lib" ]]; then
    flags+=(-I./include)
  fi

  gcc "${flags[@]}" -o x0 "${sources[@]}" "${lib_archives[@]}"
  local compile_status=$?

  if [[ $compile_status -ne 0 ]]; then
    echo "Error: Compilation failed." >&2
    return $compile_status
  fi

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
