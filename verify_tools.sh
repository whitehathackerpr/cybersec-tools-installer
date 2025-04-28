#!/bin/bash

# Tool Verification Script
# This script verifies the installation and versions of cybersecurity tools

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="tool_verification.log"
touch $LOG_FILE

# Function to log messages
log_message() {
    echo -e "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function to check tool version
check_version() {
    local tool=$1
    local version_cmd=$2
    
    if command -v $tool &> /dev/null; then
        version=$($version_cmd 2>&1 | head -n 1)
        log_message "${GREEN}[+]${NC} $tool is installed: $version"
        return 0
    else
        log_message "${RED}[-]${NC} $tool is not installed"
        return 1
    fi
}

# Function to check GitHub tool
check_github_tool() {
    local tool=$1
    local path=$2
    
    if [ -d "$path" ]; then
        log_message "${GREEN}[+]${NC} $tool is installed at $path"
        return 0
    else
        log_message "${RED}[-]${NC} $tool is not installed"
        return 1
    fi
}

# Check system information
log_message "${BLUE}[*]${NC} System Information:"
log_message "OS: $(uname -a)"
log_message "Kernel: $(uname -r)"
log_message "Architecture: $(uname -m)"

# Check package manager
log_message "\n${BLUE}[*]${NC} Package Manager:"
if command -v apt &> /dev/null; then
    log_message "${GREEN}[+]${NC} APT is available"
    log_message "APT Version: $(apt --version | head -n 1)"
else
    log_message "${RED}[-]${NC} APT is not available"
fi

# Check Python environment
log_message "\n${BLUE}[*]${NC} Python Environment:"
check_version "python3" "python3 --version"
check_version "pip3" "pip3 --version"

# Check Go environment
log_message "\n${BLUE}[*]${NC} Go Environment:"
check_version "go" "go version"

# Check network tools
log_message "\n${BLUE}[*]${NC} Network Tools:"
check_version "nmap" "nmap --version"
check_version "masscan" "masscan --version"
check_version "wireshark" "wireshark --version"
check_version "tcpdump" "tcpdump --version"

# Check web security tools
log_message "\n${BLUE}[*]${NC} Web Security Tools:"
check_version "burpsuite" "java -jar /usr/share/burpsuite/burpsuite.jar --version"
check_version "zap" "zap.sh -version"
check_version "sqlmap" "sqlmap --version"
check_version "nikto" "nikto -Version"

# Check wireless tools
log_message "\n${BLUE}[*]${NC} Wireless Tools:"
check_version "aircrack-ng" "aircrack-ng --version"
check_version "reaver" "reaver --version"
check_version "kismet" "kismet --version"

# Check password cracking tools
log_message "\n${BLUE}[*]${NC} Password Cracking Tools:"
check_version "john" "john --version"
check_version "hashcat" "hashcat --version"
check_version "hydra" "hydra --version"

# Check exploitation tools
log_message "\n${BLUE}[*]${NC} Exploitation Tools:"
check_version "msfconsole" "msfconsole --version"
check_github_tool "exploitdb" "/opt/exploitdb"
check_github_tool "veil" "/opt/Veil"

# Check forensics tools
log_message "\n${BLUE}[*]${NC} Forensics Tools:"
check_version "autopsy" "autopsy --version"
check_version "binwalk" "binwalk --version"
check_version "volatility" "vol.py --version"

# Check OSINT tools
log_message "\n${BLUE}[*]${NC} OSINT Tools:"
check_github_tool "theHarvester" "/opt/theHarvester"
check_github_tool "sublist3r" "/opt/Sublist3r"
check_github_tool "recon-ng" "/opt/recon-ng"

# Check SDR tools
log_message "\n${BLUE}[*]${NC} SDR Tools:"
check_version "rtl_433" "rtl_433 -h"
check_version "gqrx" "gqrx --version"
check_version "sdrangel" "sdrangel --version"

# Check phishing tools
log_message "\n${BLUE}[*]${NC} Phishing Tools:"
check_github_tool "gophish" "/opt/gophish"
check_github_tool "evilginx2" "/opt/evilginx2"
check_github_tool "king-phisher" "/opt/king-phisher"

# Final summary
log_message "\n${BLUE}[*]${NC} Verification complete. Check $LOG_FILE for details." 