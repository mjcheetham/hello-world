#!/bin/sh

# Uname returns "MINGW*" on Windows, "Linux" on Linux, and "Darwin" on macOS.
if [[ "$(uname)" == *"MINGW"* ]]; then
	ext=".exe"
else
	ext=""
fi

hyperfine --warmup 10 \
	-N \
	-n 'Assembly'           './asm/out/asm' \
	-n 'C'                  "./c/out/normal/c${ext}" \
	-n 'C (-O2)'            "./c/out/o2/c${ext}" \
	-n 'C (-O3)'            "./c/out/o3/c${ext}" \
	-n 'C++'                "./cpp/out/normal/cpp${ext}" \
	-n 'C++ (-O3)'           "./cpp/out/o3/cpp${ext}" \
	-n 'Rust'               './rust/out/normal/rust' \
	-n 'Rust (opt-level=3)' './rust/out/o3/rust' \
	-n 'Go'                 './go/out/go' \
	-n '.NET'               'dotnet ./dn/out/normal/dn.dll' \
	-n '.NET (AOT)'         "./dn/out/aot/dn${ext}" \
	-n 'Java'               'java -cp ./java/out Main' \
	-n 'Python'             'python3 ./py/main.py' \
	-n 'Node.js'            'node ./js/main.js' \
	-n 'Deno'               'deno run ./js/main.js' \
	-n 'Deno (compiled)'    "./js/out/deno${ext}" \
	-n 'Bash'               'bash ./sh/main.sh' \
	-n 'Busybox sh'         'busybox.exe sh ./sh/main.sh' \
	-n 'Perl'               'perl ./perl/main.pl' \
	-n 'Ruby'               'ruby ./ruby/main.rb' \
	$@
