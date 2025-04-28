#!/bin/bash

# Tool Removal Script
# This script safely removes installed cybersecurity tools and their configurations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="tool_removal.log"
touch $LOG_FILE

# Function to log messages
log_message() {
    echo -e "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function to remove apt package
remove_apt_package() {
    local package=$1
    log_message "${BLUE}[*]${NC} Removing $package..."
    sudo apt remove -y $package
    sudo apt autoremove -y
    log_message "${GREEN}[+]${NC} $package removed"
}

# Function to remove pip package
remove_pip_package() {
    local package=$1
    log_message "${BLUE}[*]${NC} Removing Python package $package..."
    pip3 uninstall -y $package
    log_message "${GREEN}[+]${NC} Python package $package removed"
}

# Function to remove GitHub repository
remove_github_repo() {
    local repo_path=$1
    local repo_name=$2
    
    if [ -d "$repo_path" ]; then
        log_message "${BLUE}[*]${NC} Removing $repo_name..."
        sudo rm -rf "$repo_path"
        log_message "${GREEN}[+]${NC} $repo_name removed"
    else
        log_message "${YELLOW}[!]${NC} $repo_name not found at $repo_path"
    fi
}

# Function to remove configuration files
remove_config_files() {
    local tool=$1
    local config_paths=("$HOME/.config/$tool" "/etc/$tool" "$HOME/.$tool")
    
    for path in "${config_paths[@]}"; do
        if [ -d "$path" ] || [ -f "$path" ]; then
            log_message "${BLUE}[*]${NC} Removing configuration files for $tool..."
            sudo rm -rf "$path"
            log_message "${GREEN}[+]${NC} Configuration files for $tool removed"
        fi
    done
}

# Main removal process
echo -e "${YELLOW}[!]${NC} This script will remove cybersecurity tools and their configurations."
echo -e "${YELLOW}[!]${NC} Please make sure you have backed up any important data."
read -p "Do you want to continue? (y/n) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_message "${RED}[-]${NC} Removal process cancelled by user"
    exit 1
fi

# Remove network tools
log_message "\n${BLUE}[*]${NC} Removing network tools..."
remove_apt_package "nmap"
remove_apt_package "masscan"
remove_apt_package "wireshark"
remove_apt_package "tcpdump"

# Remove web security tools
log_message "\n${BLUE}[*]${NC} Removing web security tools..."
remove_apt_package "burpsuite"
remove_apt_package "owasp-zap"
remove_apt_package "sqlmap"
remove_apt_package "nikto"

# Remove wireless tools
log_message "\n${BLUE}[*]${NC} Removing wireless tools..."
remove_apt_package "aircrack-ng"
remove_apt_package "reaver"
remove_apt_package "kismet"

# Remove password cracking tools
log_message "\n${BLUE}[*]${NC} Removing password cracking tools..."
remove_apt_package "john"
remove_apt_package "hashcat"
remove_apt_package "hydra"

# Remove exploitation tools
log_message "\n${BLUE}[*]${NC} Removing exploitation tools..."
remove_apt_package "metasploit-framework"
remove_github_repo "/opt/exploitdb" "Exploit-DB"
remove_github_repo "/opt/Veil" "Veil Framework"

# Remove forensics tools
log_message "\n${BLUE}[*]${NC} Removing forensics tools..."
remove_apt_package "autopsy"
remove_apt_package "binwalk"
remove_apt_package "volatility"

# Remove OSINT tools
log_message "\n${BLUE}[*]${NC} Removing OSINT tools..."
remove_github_repo "/opt/theHarvester" "TheHarvester"
remove_github_repo "/opt/Sublist3r" "Sublist3r"
remove_github_repo "/opt/recon-ng" "Recon-ng"

# Remove SDR tools
log_message "\n${BLUE}[*]${NC} Removing SDR tools..."
remove_apt_package "rtl-sdr"
remove_apt_package "gqrx"
remove_apt_package "sdrangel"

# Remove phishing tools
log_message "\n${BLUE}[*]${NC} Removing phishing tools..."
remove_github_repo "/opt/gophish" "Gophish"
remove_github_repo "/opt/evilginx2" "Evilginx2"
remove_github_repo "/opt/king-phisher" "King-Phisher"

# Clean up system
log_message "\n${BLUE}[*]${NC} Cleaning up system..."
sudo apt autoremove -y
sudo apt clean
sudo apt autoclean

# Final message
log_message "\n${GREEN}[+]${NC} Removal process complete. Check $LOG_FILE for details." 