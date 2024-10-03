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

# Wordle Solver (boardle)
boardle() {
    local words_file="words.txt"
    
    # Prompt user for inputs
    read -p "Enter letters that are NOT in the word: " not_in_word
    read -p "Enter letters that ARE in the word but position is unknown (no spaces): " in_word_but_not_pos
    read -p "Enter known letters with their position (e.g. '_a__e' for 2nd and 5th letters known): " known_positions

    # Convert the inputs to usable formats
    # Escape dots for known letters and replace _ with dots
    local known_positions_regex=$(echo "$known_positions" | sed 's/_/./g')

    # Read through the word list, applying the constraints
    grep -v -i -E "[$not_in_word]" $words_file |       # Filter out words with letters that shouldn't be in the word
    grep -i -E "[$in_word_but_not_pos]" |              # Filter words containing letters known but without specific position
    grep -i -E "^$known_positions_regex$"              # Filter words matching the exact positions of known letters
}
# Function to find large files
alias findlarge="find . -type f -exec du -h {} + | sort -rh | head -n 10"

# Git Aliases
alias gs='git status -sb'                      # Short status with branch info
alias gf='git fetch --all --prune'              # Fetch all remotes and prune deleted branches
alias gcmsg='git commit -m'                     # Commit with message
alias gp='git push'                             # Push to the current branch
alias gpl='git pull --rebase'                   # Pull with rebase to avoid unnecessary merge commits
alias gaa='git add --all'                       # Add all changes to the staging area
alias gcm='git checkout main'                   # Checkout the main branch
alias gco='git checkout'                        # Checkout a branch
alias gcb='git checkout -b'                     # Create and switch to a new branch
alias gl='git log --oneline --graph --all'      # Pretty log with graph
alias grm='git branch -d'                       # Remove (delete) a local branch
alias gbd='git branch -D'                       # Force delete a local branch
alias gss='git stash save -u'                   # Stash including untracked files
alias gst='git stash'                           # Stash without options
alias gstp='git stash pop'                    # Apply the most recent stash
alias gsta-index='git stash apply --index'      # Apply and keep index state
alias gcl='git clone'                           # Clone a repository
alias gpo='git push origin'                     # Push to the origin remote
alias gph='git push --force-with-lease'         # Safely force-push to the current branch
alias grhh='git reset --hard HEAD'              # Reset hard to the last commit
alias gclean='git clean -fd'                    # Remove untracked files and directories

# Git Shortcut to add and commit all changes with a message
alias gacm='git add . && git commit -m'

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
