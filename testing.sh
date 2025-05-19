#!/usr/bin/env bash
# DVPanel Test Installer UI-Only Version
# This version does NOT install anything.

# Color functions
printf "\033c"
echo_cyan()    { printf '\033[1;36m%b\033[0m\n' "$@"; }
echo_red()     { printf '\033[1;31m%b\033[0m\n' "$@"; }
echo_green()   { printf '\033[1;32m%b\033[0m\n' "$@"; }
echo_yellow()  { printf '\033[1;33m%b\033[0m\n' "$@"; }
echo_cyan_n()  { printf '\033[1;36m%b\033[0m' "$@"; }

# Print banner
echo_cyan "
################################################################
################################################################
###     _______      _______        _   _ ______ _           ###
###    |  __ \\ \\    / /  __ \\ /\\   | \\ | |  ____| |          ###
###    | |  | \\ \\  / /| |__) /  \\  |  \\| | |__  | |          ###
###    | |  | |\\ \\/ / |  ___/ /\\ \\ |     |  __| | |          ###
###    | |__| | \\  /  | |  / ____ \\| |\\  | |____| |____      ###
###    |_____/   \\/   |_| /_/    \\_\\_| \\_|______|______|     ###
###                                                          ###
###       Welcome to the DVPanel TEST Installer (UI Only)    ###
###                                                          ###
################################################################
################################################################
"

# Simulate owner credentials generation
generate_random_string() {
  tr -dc 'A-Za-z0-9' </dev/urandom | head -c 9
}

OWNER_USERNAME="owner$(generate_random_string)"
OWNER_PASSWORD="$(generate_random_string)"
SESSION_PASSWORD="$(generate_random_string)$(generate_random_string)"
INSTALLATION_CODE="$(generate_random_string)$(generate_random_string)"

# Fake shimmer effect
shimmer() {
  local text="$1"
  local delay=0.05
  local colors=('\033[1;32m' '\033[1;36m')
  local n=${#text}

  for ((i = 0; i < n; i++)); do
    local c="${text:$i:1}"
    local color="${colors[i % ${#colors[@]}]}"
    echo -ne "${color}${c}\033[0m"
    sleep "$delay"
  done
  echo ""
}

# Simulate final output
LAN_IP="127.0.0.1"
LOG_FILE="/tmp/dvpanel_test_install_log.txt"

echo ""
shimmer "=== FINAL OUTPUT ==="
echo_green "🎉 DVPanel UI Test Complete! (Nothing was installed)"
echo ""
echo_yellow "➡ Web Interface (Simulated):       http://${LAN_IP}:23333"
echo_yellow "➡ Daemon WebSocket (Simulated):    ws://${LAN_IP}:24444"
echo ""
echo_yellow "🔑 Owner Login:"
echo_yellow "  ➤ Username: ${OWNER_USERNAME}"
echo_yellow "  ➤ Password: ${OWNER_PASSWORD}"
echo ""
echo_cyan "📘 Docs: https://dvpanel.com/docs"
echo_cyan "🧠 Router Help: https://dvpanel.com/routers"
echo ""
echo_cyan "🔥 Firewall Rule Template:"
echo "sudo ufw allow 23333/tcp"
echo "sudo ufw allow 24444/tcp"
echo ""
echo_green "✅ Test mode completed successfully (No changes made)"
echo ""

exit 0
