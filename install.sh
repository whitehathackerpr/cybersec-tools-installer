#!/bin/bash

# CyberSec Tools Installer
# This script installs top cybersecurity and penetration testing tools on Ubuntu.
# Run as root or with sudo privileges.

set -e

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
)

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

echo "[+] Installing tools from apt..."
for tool in "${TOOLS[@]}"; do
  echo "[+] Installing $tool..."
  sudo apt install -y $tool
  echo "[+] $tool installed."
done

# Metasploit Framework
if ! command -v msfconsole &> /dev/null; then
  echo "[+] Installing Metasploit Framework..."
  curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall | sudo bash
  echo "[+] Metasploit installed."
else
  echo "[+] Metasploit already installed."
fi

# Burp Suite (Community Edition)
if ! command -v burpsuite &> /dev/null; then
  echo "[+] Downloading Burp Suite Community Edition..."
  wget -O burpsuite.sh "https://portswigger.net/burp/releases/download?product=community&version=2023.12.1&type=Linux"
  chmod +x burpsuite.sh
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

echo "[+] All tools installation complete!" 