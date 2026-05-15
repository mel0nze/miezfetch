#!/bin/bash

# colors
RESET='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'

# info
USER=$(whoami)
HOST=$(cat /etc/hostname)
OS=$(uname -s)
KERNEL=$(uname -r)
ARCH=$(uname -m)
UPTIME=$(uptime | sed 's/.*up //' | sed 's/,.*//')
SHELL=$(basename "$SHELL")
DATE=$(date "+%Y-%m-%d %H:%M")

# CPU
CPU=$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | sed 's/^ //' || sysctl -n machdep.cpu.brand_string 2>/dev/null)

# RAM
if [ -f /proc/meminfo ]; then
    MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024) " MB"}')
    MEM_FREE=$(grep MemAvailable /proc/meminfo | awk '{print int($2/1024) " MB"}')
    RAM="$MEM_FREE free / $MEM_TOTAL total"
else
    RAM="N/A"
fi

#GPU



GPU=$(lspci | awk -F ': ' '/VGA compatible controller/ {print $2; exit}')
#printf "GPU: %s\n" "$gpu"



get_packages() {
    local counts=()

    # Debian/Ubuntu
    if command -v dpkg-query &>/dev/null; then
        local n=$(dpkg-query -f '.\n' -W 2>/dev/null | wc -l)
        counts+=("$n (dpkg)")
    fi

    # Arch Linux
    if command -v pacman &>/dev/null; then
        local n=$(pacman -Qq 2>/dev/null | wc -l)
        counts+=("$n (pacman)")
    fi

    # Fedora/RHEL/CentOS (rpm)
    if command -v rpm &>/dev/null; then
        local n=$(rpm -qa 2>/dev/null | wc -l)
        counts+=("$n (rpm)")
    fi

    # Alpine
    if command -v apk &>/dev/null; then
        local n=$(apk info 2>/dev/null | wc -l)
        counts+=("$n (apk)")
    fi

    # Gentoo
    if command -v qlist &>/dev/null; then
        local n=$(qlist -I 2>/dev/null | wc -l)
        counts+=("$n (portage)")
    fi

    # Void Linux
    if command -v xbps-query &>/dev/null; then
        local n=$(xbps-query -l 2>/dev/null | wc -l)
        counts+=("$n (xbps)")
    fi

    # Nix
    if command -v nix-store &>/dev/null; then
        local n=$(nix-store -q --requisites /run/current-system 2>/dev/null | wc -l)
        counts+=("$n (nix)")
    fi

    # Snap
    if command -v snap &>/dev/null; then
        local n=$(snap list 2>/dev/null | tail -n +2 | wc -l)
        counts+=("$n (snap)")
    fi

    # Flatpak
    if command -v flatpak &>/dev/null; then
        local n=$(flatpak list 2>/dev/null | wc -l)
        counts+=("$n (flatpak)")
    fi

    # Homebrew (Linux)
    if command -v brew &>/dev/null; then
        local n=$(brew list 2>/dev/null | wc -l)
        counts+=("$n (brew)")
    fi

    # Join all with ", "
    local IFS=", "
    echo "${counts[*]:-unknown}"
}

PACK=$(get_packages)




# ASCII art and system info

printf "${CYAN}          +MMMML               ${RESET}  ${BOLD}${GREEN}$USER${RESET}@${BOLD}${GREEN}$HOST${RESET}\n"
printf "${CYAN}         PHIIHHIMI             ${RESET}  ---------------                 \n"
printf "${CYAN}         I@IIII@Mf             ${RESET}  ${CYAN}OS:${RESET}       $OS $ARCH\n"
printf "${CYAN}         II/   IML             ${RESET}  ${CYAN}Kernel:${RESET}   $KERNEL\n"
printf "${CYAN}         9\_/*IM.              ${RESET}  ${CYAN}Packages:${RESET} $PACK\n"
printf "${CYAN}       sl        IMM           ${RESET}  ${CYAN}Shell:${RESET}    $SHELL\n"
printf "${CYAN}      dP         *HNL          ${RESET}  ${CYAN}CPU:${RESET}      $CPU\n"
printf "${CYAN}     +9           IHGL         ${RESET}  ${CYAN}RAM:${RESET}      $RAM\n"
printf "${CYAN}    dL             LHHf        ${RESET}  ${CYAN}GPU:${RESET}      $GPU\n"
printf "${CYAN}  _/°°\           l*EFN\_      ${RESET}  ${CYAN}Uptime:${RESET}  $UPTIME\n"
printf "${CYAN}  l    \_         l*     \     ${RESET}  ${CYAN}Date:${RESET}     $DATE\n"
printf "${CYAN}  )      \_      dl       \    ${RESET}\n"
printf "${CYAN}  (_       \dmmGH     _/°°°    ${RESET}\n"
printf "${CYAN}   °°°°°°\_/     (__/°         ${RESET}\n"
printf "${CYAN}                               ${RESET}\n"
printf "${CYAN}                               ${RESET}\n"
printf "${CYAN}                               ${RESET}\n"



# color bar
printf "\n  "
for color in 30 31 32 33 34 35 36 37; do
    printf "\033[${color}m###${RESET}"
done
printf "\n\n"

