#
#              _            __             
#             (_)___  _____/ /_  __________
#            / / __ \/ ___/ __ \/ ___/ ___/
#     _     / / /_/ (__  ) / / / /  / /__           - supercharged zshrc file
#    (_)  _/ /\____/____/_/ /_/_/   \___/  
#       /___/                              
#
# ================================
#        Dependencies Setup        
# ================================
# Comment out any ENABLE_* variables to disable features requiring those dependencies

# Detect OS and set system-specific variables
if [[ "$(uname)" == "Darwin" ]]; then
    export IS_MACOS=true
    export IS_LINUX=false
    export PACKAGE_MANAGER="brew"
    export PACKAGE_INSTALL="brew install"
    export CPU_COUNT=$(sysctl -n hw.ncpu)
    
    # System monitoring commands for macOS
    function get_cpu_usage() {
        top -l 1 | grep -E "^CPU" | awk '{print $3}' | cut -d'%' -f1
    }
    
    function get_memory_usage() {
        memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5"%"}'
    }
    
    function get_disk_usage() {
        df -h / | awk 'NR==2{print $5}'
    }
    
    function get_uptime() {
        uptime | awk '{print $3,$4,$5}' | sed 's/,//g'
    }
    
elif [[ "$(uname)" == "Linux" ]]; then
    export IS_MACOS=false
    export IS_LINUX=true
    export PACKAGE_MANAGER="apt"
    export PACKAGE_INSTALL="sudo apt install"
    export CPU_COUNT=$(nproc)
    
    # System monitoring commands for Linux
    function get_cpu_usage() {
        top -bn1 | grep "Cpu(s)" | awk '{print $2}'
    }
    
    function get_memory_usage() {
        free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2}'
    }
    
    function get_disk_usage() {
        df -h / | awk 'NR==2{print $5}'
    }
    
    function get_uptime() {
        uptime -p
    }
fi

# Required Dependencies (will use $PACKAGE_INSTALL based on OS):
# oh-my-zsh:        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# zsh-autosuggestions: git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# zsh-syntax-highlighting: git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Package Dependencies:
if [[ "$IS_MACOS" == true ]]; then
    # Install Homebrew first:
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    #
    # Then install required packages:
    # brew install coreutils
    # brew install --cask docker
    # brew install kubectl vim git gcc cppcheck cmake
    # brew install lolcat
    # Note: make & clang included with Xcode Command Line Tools
else
    # Install required packages:
    # sudo apt update
    # sudo apt install docker.io kubectl vim git make build-essential cppcheck clang cmake procps
    # sudo apt install lolcat
fi

# Feature toggles - Comment out to disable related functionality
ENABLE_OHMYZSH=true
ENABLE_CPP_TOOLS=true
ENABLE_DOCKER=true
ENABLE_KUBERNETES=true
ENABLE_SYSTEM_MONITORING=true
ENABLE_GIT_FEATURES=true
ENABLE_WELCOME_MESSAGE=true

# ================================
#          .zshrc Setup           
# ================================

# Oh-my-zsh configuration (only if enabled)
if [[ -n "$ENABLE_OHMYZSH" ]]; then
    export ZSH="$HOME/.oh-my-zsh"
    ZSH_THEME="robbyrussell"
    
    # Base plugins that should always be available
    plugins=(
        history
        colored-man-pages
        command-not-found
    )
    
    # Conditionally add plugins if they exist
    [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]] && plugins+=(zsh-autosuggestions)
    [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]] && plugins+=(zsh-syntax-highlighting)
    [[ -n "$ENABLE_GIT_FEATURES" ]] && plugins+=(git)
    [[ -n "$ENABLE_DOCKER" ]] && plugins+=(docker)
    [[ -n "$ENABLE_KUBERNETES" ]] && plugins+=(kubectl)
    
    source $ZSH/oh-my-zsh.sh
fi

# -------------------------------
#  General Settings and Aliases
# -------------------------------

# Navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias h="cd ~"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias md="mkdir -p"
alias rd="rmdir"
alias ~="cd ~"
alias home="cd ~"

# C++ project build management (only if enabled)
if [[ -n "$ENABLE_CPP_TOOLS" ]]; then
    alias build="make -j$CPU_COUNT"
    
    alias clean="make clean"
    alias rebuild="make clean && build"
    alias run="./a.out"
    alias gpp="g++ -std=c++17"
    alias cppcheck="cppcheck --enable=all"
    
    # Version checking aliases
    alias gccv="gcc --version"
    alias gppv="g++ --version"
    alias clangv="clang --version"
    alias makev="make --version"
    alias cmakev="cmake --version"
    alias glibcv="ldd --version"
fi

# -------------------------------
#  ASCII Color Escape Codes
# -------------------------------

# Primary Colors
BLACK=$fg[black]
RED=$fg[red]
GREEN=$fg[green]
YELLOW=$fg[yellow]
BLUE=$fg[blue]
PURPLE=$fg[magenta]
CYAN=$fg[cyan]
WHITE=$fg[white]

# Bold Text Colors
BOLD_BLACK=$fg_bold[black]
BOLD_RED=$fg_bold[red]
BOLD_GREEN=$fg_bold[green]
BOLD_YELLOW=$fg_bold[yellow]
BOLD_BLUE=$fg_bold[blue]
BOLD_PURPLE=$fg_bold[magenta]
BOLD_CYAN=$fg_bold[cyan]
BOLD_WHITE=$fg_bold[white]

# Reset Color
RESET=$reset_color

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
    
    read "?Enter letters that are NOT in the word: " not_in_word
    read "?Enter letters that ARE in the word but position is unknown (no spaces): " in_word_but_not_pos
    read "?Enter known letters with their position (e.g. '_a__e' for 2nd and 5th letters known): " known_positions

    local known_positions_regex=$(echo "$known_positions" | sed 's/_/./g')

    grep -v -i -E "[$not_in_word]" $words_file |
    grep -i -E "[$in_word_but_not_pos]" |
    grep -i -E "^$known_positions_regex$"
}

# Find large files
alias findlarge="find . -type f -exec du -h {} + | sort -rh | head -n 10"

# Git Aliases (only if enabled)
if [[ -n "$ENABLE_GIT_FEATURES" ]]; then
    alias gs='git status -sb'
    alias gf='git fetch --all --prune'
    alias gcmsg='git commit -m'
    alias gp='git push'
    alias gpl='git pull --rebase'
    alias gaa='git add --all'
    alias gcm='git checkout main'
    alias gco='git checkout'
    alias gcb='git checkout -b'
    alias gl='git log --oneline --graph --all'
    alias grm='git branch -d'
    alias gbd='git branch -D'
    alias gss='git stash save -u'
    alias gst='git stash'
    alias gstp='git stash pop'
    alias gsta-index='git stash apply --index'
    alias gcl='git clone'
    alias gpo='git push origin'
    alias gph='git push --force-with-lease'
    alias grhh='git reset --hard HEAD'
    alias gclean='git clean -fd'
    alias gacm='git add . && git commit -m'
fi

# -------------------------------
#  Miscellaneous 
# -------------------------------

# Safety aliases
alias cp="cp -i"
alias mv="mv -i"

# Set vim as default editor
export EDITOR='vim'

# Reload zshrc
alias reload="source ~/.zshrc"

# System monitoring function (only if enabled)
if [[ -n "$ENABLE_SYSTEM_MONITORING" ]]; then
    system_info() {
        echo "${BOLD_BLUE}CPU Usage: ${BOLD_GREEN}$(get_cpu_usage)%${RESET}"
        echo "${BOLD_BLUE}Memory Usage: ${BOLD_GREEN}$(get_memory_usage)${RESET}"
        echo "${BOLD_BLUE}Disk Usage: ${BOLD_GREEN}$(get_disk_usage)${RESET}"
        echo "${BOLD_BLUE}Uptime: ${BOLD_GREEN}$(get_uptime)${RESET}"
    }
fi

# Welcome message (only if enabled)
if [[ -n "$ENABLE_WELCOME_MESSAGE" ]]; then
    welcome_message() {
        echo ""
        # Check if lolcat is installed
        if command -v lolcat >/dev/null 2>&1; then
            cat << "EOF" | lolcat -a -d 1
.::    .   .:::.,::::::   :::       .,-:::::     ...     .        :  .,::::::  
';;,  ;;  ;;;' ;;;;''''   ;;;     ,;;;'````'  .;;;;;;;.  ;;,.    ;;; ;;;;''''  
 '[[, [[, [['   [[cccc    [[[     [[[        ,[[     \[[,[[[[, ,[[[[, [[cccc   
   Y$c$$$c$P    $$""""    $$'     $$$        $$$,     $$$$$$$$$$$"$$$ $$""""   
    "88"888     888oo,__ o88oo,.__`88bo,__,o,"888,_ _,88P888 Y88" 888o888oo,__ 
     "M "M"     """"YUMMM""""YUMMM  "YUMMMMMP" "YMMMMMP" MMM  M'  "MMM""""YUMMM
EOF
        else
            echo "${BOLD_CYAN}"
            cat << "EOF"
.::    .   .:::.,::::::   :::       .,-:::::     ...     .        :  .,::::::  
';;,  ;;  ;;;' ;;;;''''   ;;;     ,;;;'````'  .;;;;;;;.  ;;,.    ;;; ;;;;''''  
 '[[, [[, [['   [[cccc    [[[     [[[        ,[[     \[[,[[[[, ,[[[[, [[cccc   
   Y$c$$$c$P    $$""""    $$'     $$$        $$$,     $$$$$$$$$$$"$$$ $$""""   
    "88"888     888oo,__ o88oo,.__`88bo,__,o,"888,_ _,88P888 Y88" 888o888oo,__ 
     "M "M"     """"YUMMM""""YUMMM  "YUMMMMMP" "YMMMMMP" MMM  M'  "MMM""""YUMMM
EOF
            echo "${RESET}"
        fi
        echo "${BOLD_PURPLE}$(date '+%H:%M:%S')${RESET} on ${BOLD_GREEN}$(date '+%b %d')${RESET} ${BOLD_YELLOW}• Get to work! 🚀${RESET}"
        echo ""
    }
    
    # Execute welcome message on shell start
    welcome_message
fi

# Custom prompt with git information and current time
PROMPT='${BOLD_GREEN}%n@%m${RESET}:${BOLD_BLUE}%~${RESET}$(git_prompt_info) ${BOLD_YELLOW}[%T]${RESET}
$ '

# ================================
#  End of zshrc File             
# ================================ 