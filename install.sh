#!/bin/bash

# CyberSec Tools Installer
# This script installs top cybersecurity and penetration testing tools on Ubuntu.
# Run as root or with sudo privileges.

set -e

# Use non-interactive frontend to avoid interactive prompts
export DEBIAN_FRONTEND=noninteractive

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
  "wireshark"
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
  "macchanger"
)

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

echo "[+] Installing tools from apt..."
for tool in "${TOOLS[@]}"; do
  echo "[+] Installing $tool..."
  sudo apt install -y $tool
  echo "[+] $tool installed."
done

# Preconfigure wireshark to disable non-superuser packet capture (to avoid prompt)
echo "wireshark-common wireshark-common/install-setuid boolean false" | sudo debconf-set-selections

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

echo "[+] All tools installation complete!"
