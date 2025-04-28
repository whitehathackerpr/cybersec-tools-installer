#!/bin/bash

# Universal CyberSec Tools Installer
# This script installs common cybersecurity and penetration testing tools on any Linux distribution.
# Run as root or with sudo privileges.

set -e

LOGFILE="cybersec_install.log"
exec > >(tee -a $LOGFILE) 2>&1

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# List of tools commonly found in Kali Linux
TOOLS=(
  "nmap"
  "wireshark"
  "john"
  "aircrack-ng"
  "nikto"
  "hydra"
  "sqlmap"
  "netcat"
  "dnsrecon"
  "metasploit-framework"
  "zaproxy"
  "burpsuite"
  "exploitdb"
  "veil"
  "hashcat"
  "wpscan"
  "gobuster"
  "dirb"
  "feroxbuster"
  "set"      # Social-Engineer Toolkit
  "ettercap-graphical"
  "maltego"
  "openvas"
)

# Detect package manager
if command -v apt &> /dev/null; then
  PM="apt"
  UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
  INSTALL_CMD="sudo apt install -y"
elif command -v dnf &> /dev/null; then
  PM="dnf"
  UPDATE_CMD="sudo dnf update -y"
  INSTALL_CMD="sudo dnf install -y"
elif command -v pacman &> /dev/null; then
  PM="pacman"
  UPDATE_CMD="sudo pacman -Syu"
  INSTALL_CMD="sudo pacman -S --noconfirm"
else
  echo "Unsupported package manager. Please use a Linux distribution with apt, dnf, or pacman."
  exit 1
fi

echo "[+] Detected package manager: $PM"

# Update and upgrade the system
echo "[+] Updating the system..."
eval $UPDATE_CMD

# Install tools
echo "[+] Installing cybersecurity tools..."
for tool in "${TOOLS[@]}"; do
  echo "[+] Installing $tool..."
  eval $INSTALL_CMD $tool || echo "[!] Failed to install $tool. Please check manually."
done

# Post-installation steps for specific tools
echo "[+] Performing post-installation steps for specific tools..."

# Metasploit Framework
if ! command -v msfconsole &> /dev/null; then
  echo "[+] Installing Metasploit Framework..."
  curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall | sudo bash
  echo "[+] Metasploit installed."
else
  echo "[+] Metasploit already installed."
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
  sudo git clone https://github.com/Veil-Framework/Veil.git /opt/Veil
  cd /opt/Veil
  sudo ./Install.sh --silent
  cd -
  echo "[+] Veil Framework installed."
else
  echo "[+] Veil Framework already present."
fi

# OWASP ZAP
if ! command -v zaproxy &> /dev/null; then
  echo "[+] Installing OWASP ZAP..."
  if [ "$PM" == "apt" ]; then
    sudo snap install zaproxy --classic
  elif [ "$PM" == "dnf" ] || [ "$PM" == "pacman" ]; then
    echo "[!] Please install OWASP ZAP manually as snap may not be supported."
  fi
  echo "[+] OWASP ZAP installed."
else
  echo "[+] OWASP ZAP already installed."
fi

echo "[+] All tools installation complete! Check $LOGFILE for details."
