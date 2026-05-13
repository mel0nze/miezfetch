#!/bin/sh

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






# ASCII art and system info

printf "${CYAN}          +MMMML               ${RESET}  ${BOLD}${GREEN}$USER${RESET}@${BOLD}${GREEN}$HOST${RESET}\n"
printf "${CYAN}         PHIIHHIMI             ${RESET}  ------------------                 \n"
printf "${CYAN}         I@IIII@Mf             ${RESET}  ${CYAN}OS:${RESET}      $OS $ARCH\n"
printf "${CYAN}         II/   IML             ${RESET}  ${CYAN}Kernel:${RESET}  $KERNEL\n"
printf "${CYAN}         9\_/*IM.              ${RESET}  ${CYAN}Uptime:${RESET}  $UPTIME\n"
printf "${CYAN}       sl        IMM           ${RESET}  ${CYAN}Shell:${RESET}   $SHELL\n"
printf "${CYAN}      dP         *HNL          ${RESET}  ${CYAN}CPU:${RESET}     $CPU\n"
printf "${CYAN}     +9           IHGL         ${RESET}  ${CYAN}RAM:${RESET}     $RAM\n"
printf "${CYAN}    dL             LHHf        ${RESET}  ${CYAN}GPU:${RESET}     $GPU\n"
printf "${CYAN}  _/°°\           l*EFN\       ${RESET}  ${CYAN}Date:${RESET}    $DATE\n"
printf "${CYAN}  l      \b_         l*    \_     ${RESET}\n"
printf "${CYAN}  )        \*    dl       \    ${RESET}\n"
printf "${CYAN}  (_        \dmmGH    _/°°°    ${RESET}\n"
printf "${CYAN}   °°°°°°\_/    (__/°          ${RESET}\n"
printf "${CYAN}                               ${RESET}\n"
printf "${CYAN}                               ${RESET}\n"
printf "${CYAN}                               ${RESET}\n"





# color bar
printf "\n  "
for color in 30 31 32 33 34 35 36 37; do
    printf "\033[${color}m###${RESET}"
done
printf "\n\n"
