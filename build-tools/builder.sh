#!/bin/bash

# Function to display the main menu
show_menu() {
    echo "========== Makefile Builder =========="
    echo "1. Set C++ Standard Version"
    echo "2. Set Compiler (gcc/clang)"
    echo "3. Set Executable Name"
    echo "4. Add Header Files"
    echo "5. Build"
    echo "6. Quit"
    echo "======================================"
}

# Variables to store user input
cpp_version="c++11"
compiler="g++"
executable="a.out"
headers=""

# Function to handle C++ standard version selection
set_cpp_version() {
    echo "Enter the C++ standard version (e.g., c++11, c++14, c++17, c++20):"
    read cpp_version
    echo "C++ version set to $cpp_version"
}

# Function to select compiler (gcc or clang)
set_compiler() {
    echo "Select compiler:"
    echo "1. g++ (GCC)"
    echo "2. clang++ (Clang)"
    read compiler_choice
    case $compiler_choice in
        1) compiler="g++"; echo "Compiler set to g++ (GCC)";;
        2) compiler="clang++"; echo "Compiler set to clang++ (Clang)";;
        *) echo "Invalid choice, defaulting to g++ (GCC)";;
    esac
}

# Function to set the name of the executable
set_executable_name() {
    echo "Enter the executable name:"
    read executable
    echo "Executable name set to $executable"
}

# Function to add header files
add_headers() {
    echo "Enter header files (space-separated, e.g., header1.h header2.h):"
    read headers
    echo "Headers set to $headers"
}

# Function to generate the Makefile
generate_makefile() {
    echo "Generating Makefile..."
    cat <<EOL > Makefile
CXX = $compiler
CXXFLAGS = -std=$cpp_version
EXEC = $executable
HEADERS = $headers
SOURCES = \$(wildcard *.cpp)

all: \$(EXEC)

\$(EXEC): \$(SOURCES) \$(HEADERS)
	\$(CXX) \$(CXXFLAGS) -o \$(EXEC) \$(SOURCES)

clean:
	rm -f \$(EXEC)

EOL
    echo "Makefile generated."
}

# Function to build the project and capture output
build_project() {
    generate_makefile
    echo "Building the project..."
    make &> build.log

    # Check if the build was successful
    if [ $? -eq 0 ]; then
        echo "Build successful! Output saved to build.log."
    else
        echo "Build failed. Check build.log for details."
    fi
}

# Main script loop
while true; do
    show_menu
    echo "Enter your choice:"
    read choice
    case $choice in
        1) set_cpp_version;;
        2) set_compiler;;
        3) set_executable_name;;
        4) add_headers;;
        5) build_project;;
        6) echo "Exiting..."; break;;
        *) echo "Invalid choice, please select again.";;
    esac
done