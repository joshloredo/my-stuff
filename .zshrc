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
ENABLE_NODE_TOOLS=true
ENABLE_QT_TOOLS=true
ENABLE_CMAKE_TOOLS=true
ENABLE_SSH_TOOLS=true
ENABLE_NETWORK_TOOLS=true
ENABLE_HELP_MENU=true
ENABLE_FILE_TOOLS=true

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
alias home="cd ~"
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

# Add helper functions near the top after OS detection
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

feature_warn() {
    echo "${YELLOW}Warning: $1 requires $2, which is not available${RESET}" >&2
}

# Add to the Network Tools section
if [[ -n "$ENABLE_NETWORK_TOOLS" ]]; then
    # Public IP (with offline fallback)
    function get_public_ip() {
        if command_exists curl; then
            curl -s --connect-timeout 1 https://api.ipify.org 2>/dev/null || echo "No internet connection"
        else
            feature_warn "Public IP check" "curl"
        fi
    }
    alias myip='get_public_ip'

    # Local IP (more resilient)
    function get_local_ip() {
        if [[ "$IS_MACOS" == true ]]; then
            if command_exists ipconfig; then
                ipconfig getifaddr en0 || ipconfig getifaddr en1
            else
                ifconfig en0 2>/dev/null | grep 'inet ' | awk '{print $2}'
            fi
        else
            hostname -I 2>/dev/null | awk '{print $1}' || \
            ip addr show 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 || \
            ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}'
        fi
    }
    alias localip='get_local_ip'

    # Port management
    function portcheck() {
        if [[ "$IS_MACOS" == true ]]; then
            lsof -i ":$1"
        else
            netstat -tuln | grep ":$1"
        fi
    }

    function killport() {
        if [[ "$IS_MACOS" == true ]]; then
            lsof -ti ":$1" | xargs kill -9
        else
            fuser -k "$1/tcp"
        fi
    }

    # SSH/SCP helpers
    function scpto() {
        scp -r "$1" "$2":"$3"
    }

    function scpfrom() {
        scp -r "$1":"$2" "$3"
    }

    function rsyncto() {
        rsync -avz --progress "$1" "$2":"$3"
    }

    function rsyncfrom() {
        rsync -avz --progress "$1":"$2" "$3"
    }
fi

# Add File Tools section
if [[ -n "$ENABLE_FILE_TOOLS" ]]; then
    # ff: Find files by name pattern
    # Usage: ff [pattern]
    function ff() {
        local pattern="${1:-}"
        if [ -z "$pattern" ]; then
            if command_exists fzf; then
                find . -type f 2>/dev/null | fzf --preview 'cat {}'
            else
                echo "${YELLOW}Usage: ff pattern${RESET}"
                echo "${YELLOW}Example: ff '*.cpp' or ff config${RESET}"
                return 1
            fi
        else
            if command_exists fzf; then
                find . -type f -iname "*${pattern}*" 2>/dev/null | fzf --preview 'cat {}'
            else
                find . -type f -iname "*${pattern}*" 2>/dev/null | while read -r file; do
                    echo "${GREEN}${file}${RESET}"
                done
            fi
        fi
    }

    # fc: Find content in files
    # Usage: fc "search pattern" [file pattern]
    function fc() {
        local search_pattern="$1"
        local file_pattern="${2:-*}"
        
        if [ -z "$search_pattern" ]; then
            echo "${YELLOW}Usage: fc 'search pattern' [file pattern]${RESET}"
            echo "${YELLOW}Example: fc 'main' '*.cpp' or fc 'TODO'${RESET}"
            return 1
        fi

        if command_exists rg; then
            if command_exists fzf; then
                rg --color=always -l "$search_pattern" 2>/dev/null | \
                fzf --preview "rg --color=always -n '$search_pattern' {}"
            else
                rg --color=always -n "$search_pattern" 2>/dev/null
            fi
        else
            if command_exists fzf; then
                find . -type f -name "$file_pattern" -exec grep -l "$search_pattern" {} \; 2>/dev/null | \
                fzf --preview "grep -n --color=always '$search_pattern' {}"
            else
                find . -type f -name "$file_pattern" -exec grep -l "$search_pattern" {} \; 2>/dev/null | \
                while read -r file; do
                    echo "${GREEN}${file}${RESET}"
                    grep -n --color=always "$search_pattern" "$file"
                    echo ""
                done
            fi
        fi
    }

    # fd: Find directories
    # Usage: fd [pattern]
    function fd() {
        local pattern="${1:-}"
        if [ -z "$pattern" ]; then
            if command_exists fzf; then
                find . -type d 2>/dev/null | fzf --preview 'ls -la {}'
            else
                echo "${YELLOW}Usage: fd pattern${RESET}"
                echo "${YELLOW}Example: fd src or fd build${RESET}"
                return 1
            fi
        else
            if command_exists fzf; then
                find . -type d -iname "*${pattern}*" 2>/dev/null | fzf --preview 'ls -la {}'
            else
                find . -type d -iname "*${pattern}*" 2>/dev/null | while read -r dir; do
                    echo "${GREEN}${dir}${RESET}"
                done
            fi
        fi
    }

    # fe: Find and edit file
    # Usage: fe [pattern]
    function fe() {
        local file
        if command_exists fzf; then
            if [ -z "$1" ]; then
                file=$(find . -type f 2>/dev/null | fzf --preview 'cat {}')
            else
                file=$(find . -type f -iname "*$1*" 2>/dev/null | fzf --preview 'cat {}')
            fi
        else
            if [ -z "$1" ]; then
                echo "${YELLOW}Usage: fe pattern${RESET}"
                echo "${YELLOW}Example: fe config${RESET}"
                return 1
            else
                local files=($(find . -type f -iname "*$1*" 2>/dev/null))
                if [ ${#files[@]} -eq 0 ]; then
                    echo "${RED}No files found matching '$1'${RESET}"
                    return 1
                elif [ ${#files[@]} -eq 1 ]; then
                    file="${files[0]}"
                else
                    echo "${YELLOW}Multiple files found:${RESET}"
                    for i in "${!files[@]}"; do
                        echo "${GREEN}$((i+1))${RESET}) ${files[$i]}"
                    done
                    read "?Select file number: " number
                    if [[ "$number" =~ ^[0-9]+$ ]] && [ "$number" -ge 1 ] && [ "$number" -le ${#files[@]} ]; then
                        file="${files[$((number-1))]}"
                    else
                        echo "${RED}Invalid selection${RESET}"
                        return 1
                    fi
                fi
            fi
        fi
        [ -n "$file" ] && $EDITOR "$file"
    }
fi

# Add Help Menu system
if [[ -n "$ENABLE_HELP_MENU" ]]; then
    function help() {
        local filter="$1"
        local show_all=true
        
        if [ -n "$filter" ]; then
            show_all=false
        fi
        
        # Header and filter information
        if $show_all; then
            echo "\n${BOLD_BLUE}=== Command Reference ===${RESET}"
            echo "${BOLD_RED}To filter by category, run ${BOLD_WHITE}help <filter>${BOLD_RED}. Available filters are:${RESET}"
            echo "${BOLD_CYAN}file  git  build  network  system${RESET}\n"
        elif [[ "file navigation" == *"$filter"* ]]; then
            echo "\n${BOLD_BLUE}=== Command Reference ===${RESET}\n"
        fi
        
        # File Navigation
        if $show_all || [[ "file navigation" == *"$filter"* ]]; then
            echo "${BOLD_GREEN}[ File Navigation ]${RESET}"
            printf "%-20s %-30s    %-20s %-30s\n" \
                "ff pattern" "find files by name" \
                "fd pattern" "find directories" \
                "fc pattern" "find in file contents" \
                "fe pattern" "find and edit file" \
                "up n" "go up n directories" \
                "md dirname" "create directory" \
                ".." "go up one directory" \
                "..." "go up two directories"
            echo ""
        fi
        
        # Git Commands
        if $show_all || [[ "git" == *"$filter"* ]]; then
            echo "${BOLD_GREEN}[ Git Commands ]${RESET}"
            printf "%-20s %-30s    %-20s %-30s\n" \
                "gs" "git status" \
                "gl" "git log graph" \
                "gp" "git push" \
                "gpl" "git pull" \
                "gcmsg 'msg'" "commit with message" \
                "gaa" "git add all" \
                "gco branch" "checkout branch" \
                "gcb branch" "create/checkout branch"
            echo ""
        fi
        
        # Build Tools
        if $show_all || [[ "build" == *"$filter"* ]]; then
            echo "${BOLD_GREEN}[ Build Tools ]${RESET}"
            printf "%-20s %-30s    %-20s %-30s\n" \
                "build" "make with all cores" \
                "clean" "make clean" \
                "rebuild" "clean and rebuild" \
                "cmaked" "cmake debug build" \
                "cmaker" "cmake release build" \
                "cb" "cmake build" \
                "ct" "cmake test" \
                "cr" "cmake run"
            echo ""
        fi
        
        # Network Tools
        if $show_all || [[ "network" == *"$filter"* ]]; then
            echo "${BOLD_GREEN}[ Network Tools ]${RESET}"
            printf "%-20s %-30s    %-20s %-30s\n" \
                "myip" "show public IP" \
                "localip" "show local IP" \
                "portcheck num" "check port usage" \
                "killport num" "kill port process" \
                "scpto src dst" "copy to remote" \
                "scpfrom src dst" "copy from remote" \
                "rsyncto src dst" "sync to remote" \
                "rsyncfrom src dst" "sync from remote"
            echo ""
        fi
        
        # System Tools
        if $show_all || [[ "system" == *"$filter"* ]]; then
            echo "${BOLD_GREEN}[ System Tools ]${RESET}"
            printf "%-20s %-30s    %-20s %-30s\n" \
                "ll" "detailed list" \
                "la" "list all files" \
                "findlarge" "find large files" \
                "system_info" "show system status" \
                "reload" "reload shell config" \
                "home" "go to home dir" \
                "md name" "mkdir -p name" \
                "rd name" "remove directory"
            echo ""
        fi
        
        # Footer modified to only show man page reminder when showing all
        if $show_all; then
            echo "${BOLD_BLUE}Use 'man command' for more detailed information about specific commands${RESET}\n"
        elif [ -z "$(help_matches "$filter")" ]; then
            echo "\n${BOLD_RED}No matches found for filter: $filter${RESET}"
            echo "${BOLD_RED}Available filters are:${RESET}"
            echo "${BOLD_CYAN}file  git  build  network  system${RESET}"
            echo "\n${BOLD_WHITE}Usage: help <filter>${RESET}\n"
        fi
    }
    
    # Helper function to check if filter matches any category
    function help_matches() {
        local filter="$1"
        local found=false
        [[ "file navigation" == *"$filter"* ]] && found=true
        [[ "git" == *"$filter"* ]] && found=true
        [[ "build" == *"$filter"* ]] && found=true
        [[ "network" == *"$filter"* ]] && found=true
        [[ "system" == *"$filter"* ]] && found=true
        echo "$found"
    }
    
    # Add aliases for quick access
    alias h='help'
fi 