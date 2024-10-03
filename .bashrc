# ================================
#          .bashrc Setup          
# ================================

# -------------------------------
#  General Settings and Aliases
# -------------------------------

# Color prompt (optional)
export PS1='\[\e[0;34m\]\u@\h:\[\e[0;32m\]\w\[\e[m\]\$ '

# Aliases for navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias h="cd ~"              # Go to home directory
alias ll="ls -alF"          # Long listing format
alias la="ls -A"            # List all but . and ..
alias l="ls -CF"            # List in columns
alias md="mkdir -p"         # Create directories recursively
alias rd="rmdir"            # Remove directory
alias ~="cd ~"              # Quick access to home
alias home="cd ~"

# Aliases for C++ project build management
alias build="make -j$(nproc)"         # Build using make with max cores
alias clean="make clean"              # Clean the project
alias rebuild="make clean && build"   # Clean and rebuild
alias run="./a.out"                   # Run output after building
alias gpp="g++ -std=c++17"            # Compile with g++ and C++17 standard
alias cppcheck="cppcheck --enable=all" # Static code analysis with cppcheck

# Aliases for version checking of compilers and libraries
alias gccv="gcc --version"            # Check GCC version
alias gppv="g++ --version"            # Check G++ version
alias clangv="clang --version"        # Check Clang version
alias makev="make --version"          # Check make version
alias cmakev="cmake --version"        # Check CMake version
alias glibcv="ldd --version"          # Check glibc version

# -------------------------------
#  ASCII Color Escape Codes
# -------------------------------
# Colors for prompt or echo commands (bold, underline, etc.)

# Primary Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold Text Colors
BOLD_BLACK='\033[1;30m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Underline Text Colors
UNDERLINE_BLACK='\033[4;30m'
UNDERLINE_RED='\033[4;31m'
UNDERLINE_GREEN='\033[4;32m'
UNDERLINE_YELLOW='\033[4;33m'
UNDERLINE_BLUE='\033[4;34m'
UNDERLINE_PURPLE='\033[4;35m'
UNDERLINE_CYAN='\033[4;36m'
UNDERLINE_WHITE='\033[4;37m'

# Neon/Bright Colors
BRIGHT_BLACK='\033[0;90m'
BRIGHT_RED='\033[0;91m'
BRIGHT_GREEN='\033[0;92m'
BRIGHT_YELLOW='\033[0;93m'
BRIGHT_BLUE='\033[0;94m'
BRIGHT_PURPLE='\033[0;95m'
BRIGHT_CYAN='\033[0;96m'
BRIGHT_WHITE='\033[0;97m'

# Reset Color
RESET='\033[0m'

# Example usage: 
# echo -e "${BOLD_GREEN}Success: Compilation finished!${RESET}"

# -------------------------------
#  Useful Functions
# -------------------------------

# Function to go up multiple directories
up() {
    local d=""
    for ((i=1; i<=$1; i++)); do
        d="../$d"
    done
    cd "$d" || return
}

# Function to find large files
alias findlarge="find . -type f -exec du -h {} + | sort -rh | head -n 10"

# Quick Git status alias
alias gst="git status"

# Quick jump to commonly used directories
alias proj="cd ~/projects"
alias doc="cd ~/Documents"
alias dl="cd ~/Downloads"

# -------------------------------
#  Miscellaneous 
# -------------------------------

# Make bash case-insensitive for tab-completion
bind "set completion-ignore-case on"

# Prevents accidentally overwriting files
alias cp="cp -i"
alias mv="mv -i"

# Set vim as the default editor
export EDITOR='vim'

# Reload .bashrc
alias reload="source ~/.bashrc"
echo -e "${BOLD_BLUE}bashrc loaded successfully!${RESET}"

# Add additional configurations below as necessary

# ================================
#  End of bashrc File             
# ================================
