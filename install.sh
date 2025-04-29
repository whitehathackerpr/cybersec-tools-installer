#!/bin/bash

# CyberSec Tools Installer
# This script installs top cybersecurity and penetration testing tools on Ubuntu.
# Run as root or with sudo privileges.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Use non-interactive frontend to avoid interactive prompts
export DEBIAN_FRONTEND=noninteractive

# Log file
LOG_FILE="cybersec_install.log"
touch $LOG_FILE

# Function to log messages
log_message() {
    echo -e "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function to check if a tool is installed
check_tool() {
    if command -v $1 &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to show progress
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local progress=$((current * width / total))
    
    printf "\r${BLUE}[${NC}"
    printf "%-${progress}s" | tr " " "="
    printf "%-$((width - progress))s" | tr " " " "
    printf "${BLUE}]${NC} ${percentage}%%"
}

TOOLS=(
  "nmap"
  "masscan"
  "netdiscover"
  "dnsenum"
  "dmitry"
  "whatweb"
  "amass"
  "nikto"
  "wpscan"
  "lynis"
  "nuclei"
  "burpsuite"
  "owasp-zap"
  "sqlmap"
  "gobuster"
  "dirb"
  "ffuf"
  "hydra"
  "john"
  "hashcat"
  "medusa"
  "crunch"
  "aircrack-ng"
  "wifite"
  "reaver"
  "kismet"
  "fern-wifi-cracker"
  "metasploit-framework"
  "armitage"
  "exploitdb"
  "veil"
  "beef-xss"
  #"wireshark"
  "ettercap-graphical"
  "bettercap"
  "responder"
  "mitmproxy"
  "mimikatz"
  "crackmapexec"
  "powersploit"
  "empire"
  "autopsy"
  "sleuthkit"
  "foremost"
  "binwalk"
  "volatility"
  "set"
  "eyewitness"
  "netcat"
  "tcpdump"
  "hping3"
  "snort"
  "yersinia"
  #"macchanger"
)

# Update and upgrade system
log_message "${BLUE}[*]${NC} Updating system packages..."
sudo apt update && sudo apt upgrade -y
log_message "${GREEN}[+]${NC} System update complete"

# Install tools with progress tracking
total_tools=${#TOOLS[@]}
current_tool=0

log_message "${BLUE}[*]${NC} Installing tools from apt..."
for tool in "${TOOLS[@]}"; do
    current_tool=$((current_tool + 1))
    show_progress $current_tool $total_tools
    log_message "${YELLOW}[*]${NC} Installing $tool..."
    
    if ! sudo apt install -y $tool 2>> $LOG_FILE; then
        log_message "${RED}[-]${NC} Failed to install $tool"
        continue
    fi
    
    log_message "${GREEN}[+]${NC} $tool installed successfully"
done

# Preconfigure wireshark to disable non-superuser packet capture (to avoid prompt)
#echo "wireshark-common wireshark-common/install-setuid boolean false" | sudo debconf-set-selections

# Metasploit Framework
if ! command -v msfconsole &> /dev/null; then
  echo "[+] Installing Metasploit Framework..."
  curl curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
  echo "[+] Metasploit installed."
else
  echo "[+] Metasploit already installed."
fi

# Burp Suite (Community Edition)
if ! command -v burpsuite &> /dev/null; then
  echo "[+] Downloading Burp Suite Community Edition..."
  wget -O burpsuite.sh "https://portswigger.net/burp/releases/download?product=community&version=2023.12.1&type=Linux"
  chmod +x burpsuite.sh
  ./burpsuite.sh
  echo "[!] Please run ./burpsuite.sh to complete Burp Suite installation (GUI installer)."
else
  echo "[+] Burp Suite already installed or previously downloaded."
fi

# OWASP ZAP
if ! command -v zaproxy &> /dev/null; then
  echo "[+] Installing OWASP ZAP..."
  sudo snap install zaproxy --classic
  echo "[+] OWASP ZAP installed."
else
  echo "[+] OWASP ZAP already installed."
fi

# Exploit-DB
if [ ! -d "/opt/exploitdb" ]; then
  echo "[+] Cloning Exploit-DB..."
  sudo git clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb
  sudo ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit
  echo "[+] Exploit-DB installed."
else
  echo "[+] Exploit-DB already present."
fi

# Veil Framework
if [ ! -d "/opt/Veil" ]; then
  echo "[+] Installing Veil Framework..."
  sudo apt install -y git
  git clone https://github.com/Veil-Framework/Veil.git /opt/Veil
  cd /opt/Veil
  sudo ./Install.sh --silent
  cd -
  echo "[+] Veil Framework installed."
else
  echo "[+] Veil Framework already present."
fi

# TheHarvester installation (GitHub)
if ! command -v theharvester &> /dev/null; then
  echo "[+] Installing TheHarvester..."
  sudo apt install -y python3-pip
  git clone https://github.com/laramies/theHarvester.git /opt/theHarvester
  cd /opt/theHarvester
  sudo pip3 install -r requirements.txt
  cd -
  echo "[+] TheHarvester installed."
else
  echo "[+] TheHarvester already installed."
fi

# Final message
echo -e "\n${GREEN}[+]${NC} Installation complete! Check $LOG_FILE for details"
echo -e "${BLUE}[*]${NC} Some tools may require additional configuration or manual setup"
echo -e "${YELLOW}[!]${NC} Please review the log file for any warnings or errors"
