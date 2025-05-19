#!/bin/bash
# DVPanel update script with fallback install option

# Color functions
echo_red()    { printf '\033[1;31m%b\033[0m\n' "$@"; }
echo_green()  { printf '\033[1;32m%b\033[0m\n' "$@"; }
echo_yellow() { printf '\033[1;33m%b\033[0m\n' "$@"; }
echo_cyan()   { printf '\033[1;36m%b\033[0m\n' "$@"; }

# Root check
if [ "$(id -u)" -ne 0 ]; then
  echo_red "[!] This script must be run as root. Use: sudo bash $0"
  exit 1
fi

# Check for required files
if [ ! -f /usr/bin/env.txt/.env.local ] || [ ! -d /usr/bin/env.txt/.dvpanel_data ]; then
  echo_red "[X] Fatal Error: Missing .env.local or .dvpanel_data from /usr/bin/env.txt"
  echo_yellow "[?] We could not detect a DVPanel installation."

  read -p "Would you like to install the latest version of DVPanel instead? (Y/N): " confirm
  case "$confirm" in
    [Yy]* )
      echo_cyan "[~] Installing the latest version of DVPanel..."
      curl -fsSL https://scripts.dvpanel.com/latest-panel/update.sh | bash
      if [ $? -eq 0 ]; then
        echo_green "[✓] DVPanel installed successfully."
      else
        echo_red "[X] Installation failed."
      fi
      exit 0
      ;;
    * )
      echo_red "[x] Exiting without making changes."
      exit 1
      ;;
  esac
fi

# If files found, continue with standard update
echo_yellow "[~] Backing up current environment..."
mkdir -p /usr/bin/env.txt
cp .env.local /usr/bin/env.txt/.env.local
cp -r .dvpanel_data /usr/bin/env.txt/.dvpanel_data

echo_yellow "[~] Removing old install..."
rm -rf /opt/dvpanel

echo_yellow "[~] Updating DVPanel core..."
curl -fsSL https://scripts.dvpanel.com/latest-panel/update.sh | bash

echo_yellow "[~] Reinstalling Node modules..."
cd /opt/dvpanel || exit 1
npm install --omit=dev > /dev/null 2>&1

echo_yellow "[~] Restoring configuration and data..."
cp /usr/bin/env.txt/.env.local .env.local
cp -r /usr/bin/env.txt/.dvpanel_data .dvpanel_data

# Optional: Echo update info if present
if [ -f ./update.txt ]; then
  echo_green "[✓] Update complete!"
  echo_cyan "[Update Notes]"
  cat ./update.txt
else
  echo_green "[✓] DVPanel updated successfully and safely."
fi
