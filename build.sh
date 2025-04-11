#!/bin/sh

if [ -d "out" ] && [ "$1" == "--force" ]; then
	rm -rf out
fi

_OS=$(uname)
if [ "$_OS" = "Linux" ]; then
	_OS="linux"
elif [ "$_OS" = "Darwin" ]; then
	_OS="macos"
elif [[ "$_OS" == *"MINGW"* ]]; then
	_OS="windows"
else
	echo "Unsupported OS: $_OS"
	exit 1
fi

_arch=$(uname -m)
if [ "$_arch" = "x86_64" ]; then
	_arch="x86_64"
elif [ "$_arch" = "aarch64" ]; then
	_arch="arm64"
else
	echo "Unsupported architecture: $_arch"
	exit 1
fi

echo "Building Assembly (${_OS}; ${_arch}) application..."
mkdir -p asm/out
as --64 -o asm/out/asm.o asm/${_OS}/${_arch}.asm
if [ "$_OS" = "windows" ]; then
    ld -o asm/out/asm asm/out/asm.o -lkernel32
else
    ld -o asm/out/asm asm/out/asm.o
fi

mkdir -p c/out/normal
echo "Building C application..."
${CC:-cc} c/main.c -O0 -o c/out/normal/c

echo "Building C (-O2) application..."
mkdir -p c/out/o2
${CC:-cc} c/main.c -O2 -o c/out/o2/c

echo "Building C (-O3) application..."
mkdir -p c/out/o3
${CC:-cc} c/main.c -O3 -o c/out/o3/c

echo "Building C++ application..."
mkdir -p cpp/out/normal
${CXX:-g++} cpp/main.cpp -o cpp/out/normal/cpp

echo "Building C++ (-O3) application..."
mkdir -p cpp/out/o3
${CXX:-g++} cpp/main.cpp -O3 -o cpp/out/o3/cpp

echo "Building Rust application..."
mkdir -p rust/out/normal
rustc rust/main.rs -o rust/out/normal/rust

echo "Building Rust (O3) application..."
mkdir -p rust/out/o3
rustc rust/main.rs -C opt-level=3 -o rust/out/o3/rust

echo "Building Go application..."
go build -o go/out/go go/main.go

echo "Building .NET application..."
dotnet build dn -o dn/out/normal -c Release -v quiet --nologo

echo "Building .NET (AOT) application..."
dotnet publish dn -o dn/out/aot -p:PublishAot=true -v quiet --nologo

echo "Building Java application..."
javac java/Main.java -d java/out

echo "Building JavaScript (Deno) application..."
deno compile --quiet --output js/out/deno js/main.js
