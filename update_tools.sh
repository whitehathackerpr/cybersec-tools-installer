#!/bin/bash

# Tool Update Script
# This script updates all installed cybersecurity tools

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="tool_update.log"
touch $LOG_FILE

# Function to log messages
log_message() {
    echo -e "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function to update apt packages
update_apt_packages() {
    log_message "${BLUE}[*]${NC} Updating APT packages..."
    sudo apt update && sudo apt upgrade -y
    log_message "${GREEN}[+]${NC} APT packages updated"
}

# Function to update pip packages
update_pip_packages() {
    log_message "${BLUE}[*]${NC} Updating Python packages..."
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
    log_message "${GREEN}[+]${NC} Python packages updated"
}

# Function to update Go packages
update_go_packages() {
    log_message "${BLUE}[*]${NC} Updating Go packages..."
    go get -u all
    log_message "${GREEN}[+]${NC} Go packages updated"
}

# Function to update GitHub repositories
update_github_repo() {
    local repo_path=$1
    local repo_name=$2
    
    if [ -d "$repo_path" ]; then
        log_message "${BLUE}[*]${NC} Updating $repo_name..."
        cd "$repo_path"
        git pull
        if [ -f "requirements.txt" ]; then
            pip3 install -r requirements.txt
        fi
        cd -
        log_message "${GREEN}[+]${NC} $repo_name updated"
    else
        log_message "${YELLOW}[!]${NC} $repo_name not found at $repo_path"
    fi
}

# Update system packages
update_apt_packages

# Update Python packages
update_pip_packages

# Update Go packages
if command -v go &> /dev/null; then
    update_go_packages
fi

# Update GitHub repositories
log_message "\n${BLUE}[*]${NC} Updating GitHub repositories..."

# Update security tools
update_github_repo "/opt/theHarvester" "TheHarvester"
update_github_repo "/opt/Sublist3r" "Sublist3r"
update_github_repo "/opt/recon-ng" "Recon-ng"
update_github_repo "/opt/exploitdb" "Exploit-DB"
update_github_repo "/opt/Veil" "Veil Framework"

# Update phishing tools
update_github_repo "/opt/gophish" "Gophish"
update_github_repo "/opt/evilginx2" "Evilginx2"
update_github_repo "/opt/king-phisher" "King-Phisher"

# Update Metasploit Framework
if command -v msfupdate &> /dev/null; then
    log_message "${BLUE}[*]${NC} Updating Metasploit Framework..."
    sudo msfupdate
    log_message "${GREEN}[+]${NC} Metasploit Framework updated"
fi

# Update Burp Suite
if [ -f "burpsuite.sh" ]; then
    log_message "${BLUE}[*]${NC} Checking Burp Suite updates..."
    wget -O burpsuite.sh "https://portswigger.net/burp/releases/download?product=community&version=latest&type=Linux"
    chmod +x burpsuite.sh
    log_message "${GREEN}[+]${NC} Burp Suite updated"
fi

# Update OWASP ZAP
if command -v zaproxy &> /dev/null; then
    log_message "${BLUE}[*]${NC} Updating OWASP ZAP..."
    sudo snap refresh zaproxy
    log_message "${GREEN}[+]${NC} OWASP ZAP updated"
fi

# Final message
log_message "\n${GREEN}[+]${NC} Update process complete. Check $LOG_FILE for details." 