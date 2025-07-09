#
#              _            __             
#             (_)___  _____/ /_  __________
#            / / __ \/ ___/ __ \/ ___/ ___/
#     _     / / /_/ (__  ) / / / /  / /__           - supercharged bashrc file
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
    function get_cpu_usg() {
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
    function get_cpu_usg() {
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

# At the top of the file, add a helper function for command checking
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Helper function for feature warnings
feature_warn() {
    echo -e "${YELLOW}Warning: $1 requires $2, which is not available${RESET}" >&2
}

up() {
    local d=""
    for ((i=1; i<=$1; i++)); do
        d="../$d"
    done
    cd "$d" || return
}

# Modify the system monitoring section to be more resilient 
get_cpu_usg() {
    if [[ "$IS_MACOS" == true ]]; then
        if command_exists top; then
            top -l 1 | grep -E "^CPU" | awk '{print $3}' | cut -d'%' -f1
        else
            echo "N/A"
        fi
    else
        if command_exists top; then
            top -bn1 | grep "Cpu(s)" | awk '{print $2}'
        elif command_exists vmstat; then
            vmstat 1 2 | tail -1 | awk '{print 100-$15}'
        else
            echo "N/A"
        fi
    fi
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
ENABLE_CPP_TOOLS=true
ENABLE_SYSTEM_MONITORING=true
ENABLE_GIT_FEATURES=true
ENABLE_WELCOME_MESSAGE=true
ENABLE_NODE_TOOLS=true
ENABLE_QT_TOOLS=true
ENABLE_CMAKE_TOOLS=true
ENABLE_SSH_TOOLS=true
ENABLE_NETWORK_TOOLS=true
ENABLE_HELP_MENU=true

# ================================
#          .bashrc Setup          
# ================================

# -------------------------------
#  General Settings and Aliases
# -------------------------------
# Color prompt (optional)
export PS1='\[\e[0;34m\]\u@\h:\[\e[0;32m\]\w\[\e[m\]\$ '
# Set vim as the default editor
export EDITOR='vim'

# Reload .bashrc
alias reload="source ~/.bashrc"
echo -e "${BOLD_BLUE}bashrc loaded successfully!${RESET}"

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


# System monitoring function (only if enabled)
if [[ -n "$ENABLE_SYSTEM_MONITORING" ]]; then
    system_info() {
        echo -e "${BOLD_BLUE}CPU Usage: ${BOLD_GREEN}$(get_cpu_usg)%${RESET}"
        echo -e "${BOLD_BLUE}Memory Usage: ${BOLD_GREEN}$(get_memory_usage)${RESET}"
        echo -e "${BOLD_BLUE}Disk Usage: ${BOLD_GREEN}$(get_disk_usage)${RESET}"
        echo -e "${BOLD_BLUE}Uptime: ${BOLD_GREEN}$(get_uptime)${RESET}"
    }

fi

# After the existing package dependencies, add:
if [[ "$IS_MACOS" == true ]]; then
    # Additional dev tools:
    # brew install node yarn
    # brew install qt@6
    # brew install cmake ninja
    # brew install rsync
    # brew install nmap
    # brew install fzf
    # brew install ripgrep
    # brew install fd
else
    # Additional dev tools:
    # sudo apt install nodejs npm yarn
    # sudo apt install qt6-base-dev qt6-tools-dev
    # sudo apt install cmake ninja-build
    # sudo apt install rsync
    # sudo apt install nmap
    # sudo apt install fzf
    # sudo apt install ripgrep
    # sudo apt install fd-find
fi

# Add Node.js development tools
if [[ -n "$ENABLE_NODE_TOOLS" ]]; then
    # NPM shortcuts
    alias ni='npm install'              # Install dependencies from package.json
    alias nid='npm install --save-dev'  # Install dev dependency
    alias nig='npm install -g'          # Install package globally
    alias nr='npm run'                  # Run npm script
    alias nrs='npm run start'           # Run start script
    alias nrb='npm run build'           # Run build script
    alias nrt='npm run test'            # Run tests
    alias nrw='npm run watch'           # Run watch script
    
    # Yarn shortcuts
    alias yi='yarn install'             # Install dependencies
    alias ya='yarn add'                 # Add dependency
    alias yad='yarn add --dev'          # Add dev dependency
    alias yag='yarn global add'         # Add global package
    alias yr='yarn run'                 # Run yarn script
    alias ys='yarn start'               # Run start script
    alias yb='yarn build'               # Run build script
    alias yt='yarn test'                # Run tests
    
    # TypeScript shortcuts
    alias tsc='npx tsc'
    alias tsn='npx ts-node'
    
    # Package.json quick edit
    alias pje='$EDITOR package.json'
    
    # List global packages
    alias npmg='npm list -g --depth=0'
    alias yarng='yarn global list'
fi
# Aliases for C++ project build management
if [[ -n "$ENABLE_CPP_TOOLS" ]]; then
    alias build="make -j$CPU_COUNT"         # Build using make with max cores
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
fi

# Qt development tools
if [[ -n "$ENABLE_QT_TOOLS" ]]; then
    # Set Qt paths based on OS
    if [[ "$IS_MACOS" == true ]]; then
        export Qt6_DIR="$(brew --prefix qt@6)"
        export PATH="$Qt6_DIR/bin:$PATH"
    else
        # Common Linux Qt paths
        export Qt6_DIR="/usr/lib/qt6"
        export PATH="$Qt6_DIR/bin:$PATH"
    fi
    
    # Qt Creator aliases
    alias qtc='qtcreator'
    alias qtcp='qtcreator CMakeLists.txt'
    
    # Qt utilities
    alias qm='qmake'
    alias qm6='qmake6'
    alias u6='uic6'
    alias moc6='moc6'
    alias rcc6='rcc6'
    
    # Qt Designer
    alias qtd='designer-qt6'
fi

# CMake tools and shortcuts
if [[ -n "$ENABLE_CMAKE_TOOLS" ]]; then
    mkbuild() { mkdir -p build && cd build; }
    cmakeconf() {
        local build_type=${1:-Debug}
        cmake -DCMAKE_BUILD_TYPE=$build_type -GNinja ..
    }
    alias cmaked='mkbuild && cmakeconf Debug'
    alias cmaker='mkbuild && cmakeconf Release'
    alias cb='ninja -j$CPU_COUNT'
fi

# SSH and remote file management tools
if [[ -n "$ENABLE_SSH_TOOLS" ]]; then
    # SSH agent management
    if [[ "$IS_MACOS" == true ]]; then
        # macOS keychain integration
        ssh-add -A 2>/dev/null
    else
        # Start SSH agent if not running
        if [ -z "$SSH_AUTH_SOCK" ]; then
            eval $(ssh-agent -s)
        fi
    fi
    
    # SSH shortcuts
    # sshadd: Add SSH key to agent
    # Usage: sshadd key_filename
    # Example: sshadd id_rsa
    function sshadd() {
        ssh-add ~/.ssh/"$1"
    }
    
    # SCP/RSYNC helpers
    # scpto: Copy files/directories to remote host
    # Usage: scpto SOURCE_PATH REMOTE_HOST REMOTE_PATH
    # Example: scpto ./local_file.txt server:/home/user/
    function scpto() {
        scp -r "$1" "$2":"$3"
    }
    
    # scpfrom: Copy files/directories from remote host
    # Usage: scpfrom REMOTE_HOST REMOTE_PATH LOCAL_PATH
    # Example: scpfrom server:/home/user/file.txt ./
    function scpfrom() {
        scp -r "$1":"$2" "$3"
    }
    
    # rsyncto: Sync files to remote host with progress
    # Usage: rsyncto SOURCE_PATH REMOTE_HOST REMOTE_PATH
    # Example: rsyncto ./local_dir/ server:/home/user/remote_dir/
    function rsyncto() {
        rsync -avz --progress "$1" "$2":"$3"
    }
    
    # rsyncfrom: Sync files from remote host with progress
    # Usage: rsyncfrom REMOTE_HOST REMOTE_PATH LOCAL_PATH
    # Example: rsyncfrom server:/home/user/remote_dir/ ./local_dir/
    function rsyncfrom() {
        rsync -avz --progress "$1":"$2" "$3"
    }
    
    # SSH config quick edit
    alias sshconf='$EDITOR ~/.ssh/config'
fi

# File and content search tools
if [[ -n "$ENABLE_FILE_TOOLS" ]]; then
    # Find files
    ff() {
        local pattern="${1:-}"
        if [ -z "$pattern" ]; then
            command_exists fzf && find . -type f 2>/dev/null | fzf --preview 'cat {}' || \
            echo "${YELLOW}Usage: ff pattern (e.g., ff '*.cpp')${RESET}"
        else
            find . -type f -iname "*${pattern}*" 2>/dev/null | while read -r file; do
                echo "${GREEN}${file}${RESET}"
            done
        fi
    }
    
    # Find in files
    fc() {
        local pattern="$1"
        [ -z "$pattern" ] && { echo "${YELLOW}Usage: fc 'pattern' [file-pattern]${RESET}"; return 1; }
        
        if command_exists rg; then
            rg --color=always -n "$pattern" 2>/dev/null
        else
            find . -type f -name "${2:-*}" -exec grep -l "$pattern" {} \; 2>/dev/null | \
            while read -r file; do
                echo "${GREEN}${file}${RESET}"
                grep -n --color=always "$pattern" "$file"
                echo ""
            done
        fi
    }

    # fd: Find directories
    # Usage: fd [pattern]
    # Example: fd src or fd build
    function fd() {
        local pattern="${1:-}"
        if [ -z "$pattern" ]; then
            if command_exists fzf; then
                find . -type d 2>/dev/null | fzf --preview 'ls -la {}'
            else
                echo -e "${YELLOW}Usage: fd pattern${RESET}"
                echo -e "${YELLOW}Example: fd src or fd build${RESET}"
                return 1
            fi
        else
            if command_exists fzf; then
                find . -type d -iname "*${pattern}*" 2>/dev/null | fzf --preview 'ls -la {}'
            else
                find . -type d -iname "*${pattern}*" 2>/dev/null | while read -r dir; do
                    echo -e "${GREEN}${dir}${RESET}"
                done
            fi
        fi
    }

    # Quick edit found file
    # Usage: fe [pattern]
    # Example: fe config
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
                echo -e "${YELLOW}Usage: fe pattern${RESET}"
                echo -e "${YELLOW}Example: fe config${RESET}"
                return 1
            else
                # If only one file matches, edit it directly
                local files=($(find . -type f -iname "*$1*" 2>/dev/null))
                if [ ${#files[@]} -eq 0 ]; then
                    echo -e "${RED}No files found matching '$1'${RESET}"
                    return 1
                elif [ ${#files[@]} -eq 1 ]; then
                    file="${files[0]}"
                else
                    # If multiple files match, show them numbered and let user choose
                    echo -e "${YELLOW}Multiple files found:${RESET}"
                    for i in "${!files[@]}"; do
                        echo -e "${GREEN}$((i+1))${RESET}) ${files[$i]}"
                    done
                    read -p "Select file number: " number
                    if [[ "$number" =~ ^[0-9]+$ ]] && [ "$number" -ge 1 ] && [ "$number" -le ${#files[@]} ]; then
                        file="${files[$((number-1))]}"
                    else
                        echo -e "${RED}Invalid selection${RESET}"
                        return 1
                    fi
                fi
            fi
        fi
        [ -n "$file" ] && $EDITOR "$file"
    }
fi

# Modify network-dependent aliases to have offline alternatives
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
fi

# Modify file search to work with basic tools if advanced ones aren't available
if [[ -n "$ENABLE_FILE_TOOLS" ]]; then
    # Basic file search (fallback if fzf isn't available)
    function find_file() {
        if command_exists fzf; then
            fzf
        else
            read -p "Enter search pattern: " pattern
            find . -name "*${pattern}*" 2>/dev/null
        fi
    }
    alias ff='find_file'

    # Basic content search (fallback if ripgrep isn't available)
    function search_content() {
        if command_exists rg; then
            rg --color=always --line-number --no-heading "$@"
        elif command_exists grep; then
            grep -r --color=always -n "$@" .
        else
            feature_warn "Content search" "grep or ripgrep"
        fi
    }
    alias sc='search_content'
fi

# Make git features work with basic git if advanced features aren't available
if [[ -n "$ENABLE_GIT_FEATURES" ]]; then
    if command_exists git; then
        # Basic git aliases that work with older git versions
        alias gs='git status --short'
        alias gl='git log'
        alias ga='git add'
        alias gc='git commit'
        alias gcmsg='git commit -m'
        alias ghead='git rev-parse --abbrev-ref HEAD'
        alias gbranch='git branch --show-current'
        alias gsub='git submodule update --init --recursive'
        alias gsubpull='git submodule update --recursive --remote'
        alias spull='git submodule foreach git pull origin master'
        alias gp='git push'
        alias gpl='git pull'
        alias gcfg='git config --global --edit'
        # Only add advanced aliases if git version supports them
        if git --version | grep -q -E "2\.[0-9]+\.[0-9]+"; then
            alias gaa='git add --all'
            alias gst='git status -sb'
            # ... other advanced git aliases ...
        fi
    else
        feature_warn "Git aliases" "git"
    fi
fi

# Add this section where other functions are defined
if [[ -n "$ENABLE_HELP_MENU" ]]; then
    function help() {
        local filter="$1"
        local show_all=true
        
        if [ -n "$filter" ]; then
            show_all=false
        fi
        
        # Header and filter information
        if $show_all; then
            echo -e "\n${BOLD_BLUE}=== Command Reference ===${RESET}"
            echo -e "${BOLD_RED}To filter by category, run ${BOLD_WHITE}help <filter>${BOLD_RED}. Available filters are:${RESET}"
            echo -e "${BOLD_CYAN}file  git  build  network  system${RESET}\n"
        elif [[ "file navigation" == *"$filter"* ]]; then
            echo -e "\n${BOLD_BLUE}=== Command Reference ===${RESET}\n"
        fi
        
        # File Navigation
        if $show_all || [[ "file navigation" == *"$filter"* ]]; then
            echo -e "${BOLD_GREEN}[ File Navigation ]${RESET}"
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
            echo -e "${BOLD_GREEN}[ Git Commands ]${RESET}"
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
            echo -e "${BOLD_GREEN}[ Build Tools ]${RESET}"
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
            echo -e "${BOLD_GREEN}[ Network Tools ]${RESET}"
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
            echo -e "${BOLD_GREEN}[ System Tools ]${RESET}"
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
            echo -e "${BOLD_BLUE}Use 'man command' for more detailed information about specific commands${RESET}\n"
        elif [ -z "$(help_matches "$filter")" ]; then
            echo -e "\n${BOLD_RED}No matches found for filter: $filter${RESET}"
            echo -e "${BOLD_RED}Available filters are:${RESET}"
            echo -e "${BOLD_CYAN}file  git  build  network  system${RESET}"
            echo -e "\n${BOLD_WHITE}Usage: help <filter>${RESET}\n"
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
    
    # Add alias for quick access
    alias h='help'
fi

# Welcome message (only if enabled)
if [[ -n "$ENABLE_WELCOME_MESSAGE" ]]; then
    welcome_message() {
        echo ""
        if command_exists lolcat; then
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