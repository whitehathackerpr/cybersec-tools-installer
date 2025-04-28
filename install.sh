#!/bin/bash

# Enhanced CyberSec Tools Installer
# Installs common cybersecurity tools across Linux distributions
# Run as root or with sudo privileges.

set -e

APT_TOOLS=(
  "nmap"          # Network scanning
  "wireshark"     # Packet analyzer
  "john"          # Password cracker
  "aircrack-ng"   # Wireless security
  "nikto"         # Web server scanner
  "hydra"         # Login brute-forcer
  "sqlmap"        # SQL injection tool
  "netcat"        # Networking utility
  "dnsrecon"      # DNS enumeration
  "hashcat"       # Password recovery
  "wpscan"        # WordPress scanner
  "gobuster"      # Directory brute-forcing
  "feroxbuster"   # Web directory brute-forcing
  "dirb"          # Directory brute-forcing
  "curl"          # Command-line HTTP client
  "tcpdump"       # Packet capture
  "zsh"           # Shell (optional but useful)
  "vlc"           # Media player for analysis
)

SNAP_TOOLS=(
  "zaproxy --classic"   # OWASP ZAP
)

GIT_TOOLS=(
  "https://github.com/offensive-security/exploitdb.git /opt/exploitdb"  # Exploit-DB
  "https://github.com/Veil-Framework/Veil.git /opt/Veil"               # Veil Framework
  "https://github.com/trustedsec/social-engineer-toolkit.git /opt/set" # Social-Engineer Toolkit
)

echo "[+] Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "[+] Installing tools via APT..."
for tool in "${APT_TOOLS[@]}"; do
  echo "[+] Installing $tool..."
  sudo apt install -y $tool
done

echo "[+] Installing tools via Snap..."
for tool in "${SNAP_TOOLS[@]}"; do
  echo "[+] Installing $tool..."
  sudo snap install $tool
done

echo "[+] Cloning tools from GitHub..."
for git_tool in "${GIT_TOOLS[@]}"; do
  repo=$(echo $git_tool | awk '{print $1}')
  path=$(echo $git_tool | awk '{print $2}')
  if [ ! -d "$path" ]; then
    echo "[+] Cloning $repo..."
    sudo git clone "$repo" "$path"
  else
    echo "[+] $repo already cloned."
  fi
done

echo "[+] Setting up Metasploit Framework..."
if ! command -v msfconsole &> /dev/null; then
  curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall | sudo bash
else
  echo "[+] Metasploit is already installed."
fi

echo "[+] Downloading Burp Suite Community Edition..."
if ! command -v burpsuite &> /dev/null; then
  wget -O burpsuite.sh "https://portswigger.net/burp/releases/download?product=community&version=latest&type=Linux"
  chmod +x burpsuite.sh
  echo "[!] Run ./burpsuite.sh to complete Burp Suite installation (GUI installer)."
else
  echo "[+] Burp Suite already installed."
fi

echo "[+] Installing Python packages for additional tools..."
sudo apt install -y python3-pip
pip3 install --upgrade pip
pip3 install xsrfprobe wfuzz

echo "[+] Configuring Exploit-DB..."
if [ -d "/opt/exploitdb" ]; then
  sudo ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit
fi

echo "[+] Setting up Veil Framework..."
if [ -d "/opt/Veil" ]; then
  cd /opt/Veil
  sudo ./Install.sh --silent || echo "[!] Veil installation needs manual review."
  cd -
fi

echo "[+] Setting up Social-Engineer Toolkit (SET)..."
if [ -d "/opt/set" ]; then
  cd /opt/set
  sudo ./setup.py install
  cd -
fi

echo "[+] Cybersecurity tools installation complete!"
