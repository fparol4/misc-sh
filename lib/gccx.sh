function gccx() {
	local srcs=()
	local lib_srcs=()
	local exec_args=()
	local comp_args=()
	local program="main.c"
	local output="exec"
	local flags=(-g -O0)
	local execute=false
	local verbose=false
	local persist=false
	local has_input=false
	local use_valgrind=false
	local parsing_exec_args=false

	if [[ "$verbose" == true && ${#exec_args[@]} -gt 0 ]]; then
		echo "--- GCCX (START) - x42 ---"
	fi

	for arg in "$@"; do
		if [[ "$parsing_exec_args" == true ]]; then
			exec_args+=("$arg")
			continue
		fi

		if [[ "$arg" == "--" ]]; then
			parsing_exec_args=true
			execute=true
			continue
		elif [[ "$arg" == "--v" ]]; then
			parsing_exec_args=true
			use_valgrind=true
			execute=true
			continue
		elif [[ "$arg" == "-h" ]]; then
			echo "Usage: gccx [files/dirs] [options] [-- [args]]"
			echo "  -h      Show help"
			echo "  -v      Verbose output"
			echo "  -w      Enable warnings (-Wall -Wextra -Werror)"
			echo "  -p      Persist output executable"
			echo "  -mlx    Link MinilibX"
			echo "  -fsan   Enable AddressSanitizer"
			echo "  --      Execute binary with arguments"
			echo "  --v     Execute with Valgrind"
			return 0
		elif [[ "$arg" == "-v" ]]; then
			verbose=true
			continue
		elif [[ "$arg" == "-w" ]]; then
			flags+=(-Wall -Wextra -Werror)
			continue
		elif [[ "$arg" == "-p" ]]; then
			persist=true
			continue
		elif [[ "$arg" == "-mlx" ]]; then
			flags+=(-lXext -lX11 -lm -lz)
			continue
		elif [[ "$arg" == "-fsan" ]]; then
			flags+=("-fsanitize=address" "-g3")
			continue
		fi

		if [[ -d "$arg" ]]; then
			while IFS= read -r -d '' file; do
				srcs+=("$file")
			done < <(find "$arg" -type f -name "*.c" -not -path "*/.*" -print0)
			has_input=true
		elif [[ -f "$arg" ]]; then
			srcs+=("$arg")
			has_input=true
		else
			comp_args+=("$arg")
		fi
	done

	if [[ "$has_input" == false ]]; then
		if [[ "$verbose" == true ]]; then echo ">> No input. Searching $program + src/"; fi
		if [[ -f "$program" ]]; then srcs+=("$program"); fi
		if [[ -d "src" ]]; then
			while IFS= read -r -d '' file; do
				srcs+=("$file")
			done < <(find "src" -type f -name "*.c" -print0)
		fi
	fi

	if [[ ${#srcs[@]} -eq 0 ]]; then
		echo ">> ERROR: No .c source file" >&2
		return 1
	fi

	if [[ -d "./lib" ]]; then
		if [[ "$verbose" == true ]]; then echo ">> lib/ found - Including content"; fi
		while IFS= read -r dir; do
			flags+=("-I$dir")
		done < <(find "./lib" -type f -name "*.h" -exec dirname {} + | sort -u)
		while IFS= read -r -d '' file; do
			lib_srcs+=("$file")
		# (include files) -o -name "*.o" -o -name "*.c"
		done < <(find "./lib" -type f \( -name "*.a" \) -print0)
	fi

	if [[ "$verbose" == true ]]; then
		echo ">> Compiler Flags: ${flags[*]}"
		if [[ ${#comp_args[@]} -gt 0 ]]; then echo ">> Compiler Arguments: ${comp_args[*]}"; fi
		if [[ ${#lib_srcs[@]} -gt 0 ]]; then echo ">> Compiler Library: ${lib_srcs[*]}"; fi
		echo ">> Compiler Sources: ${srcs[*]}"
		echo ">> Compiler Command: gcc ${srcs[*]} ${lib_srcs[*]} ${flags[*]} ${comp_args[*]} -o $output"
	fi

    gcc "${srcs[@]}" "${lib_srcs[@]}" "${flags[@]}" "${comp_args[@]}" -o "$output"
	local comp_success=$?

	if [[ $comp_success -ne 0 ]]; then
		echo ">> ERROR: compilation failed"
		return $comp_success
	fi

	if [[ "$execute" == true ]]; then
		local cmd_runner=("./$output")

		if [[ "$verbose" == true && ${#exec_args[@]} -gt 0 ]]; then
			echo ">> Execution Arguments: ${exec_args[*]}"
		fi

		if [[ "$use_valgrind" == true ]]; then
			echo "--- Executing with Valgrind ---"
			cmd_runner=("valgrind" "--leak-check=full" "--show-leak-kinds=all" "--track-origins=yes" "./$output")
		else
			echo "--- Executing ./$output ---"
		fi

		local start_time=$(date +%s%3N)
		"${cmd_runner[@]}" "${exec_args[@]}"
		local exec_success=$?
		local end_time=$(date +%s%3N)

		if [[ $exec_success -gt 128 ]]; then
			local sig=$((exec_success - 128))
			case $sig in
				11) echo ">> ERROR: Segmentation fault (SIGSEGV)" >&2 ;;
				6) echo ">> ERROR: Aborted (SIGABRT)" >&2 ;;
				7) echo ">> ERROR: Bus error (SIGBUS)" >&2 ;;
				8) echo ">> ERROR: Floating point exception (SIGFPE)" >&2 ;;
				4) echo ">> ERROR: Illegal instruction (SIGILL)" >&2 ;;
				*) echo ">> ERROR: Terminated by signal $sig" >&2 ;;
			esac
		fi

		echo "--- Execution finished (code: $exec_success, $((end_time - start_time)) ms) ---"

		if [[ "$use_valgrind" == true ]]; then
			rm -f "gmon.out"
		fi

		if [[ "$persist" == false ]]; then
			rm -f "$output"
		fi

		return $exec_success
	fi
}
