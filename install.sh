#!/bin/bash

# Complete Cybersecurity Tools Installer for Ubuntu
# Installs tools for penetration testing, forensics, and cybersecurity tasks.

set -e

# Categories and their tools
declare -A TOOLS=(
  ["Information Gathering"]="nmap masscan netdiscover theharvester dnsenum dmitry whatweb amass"
  ["Vulnerability Analysis & Scanning"]="nikto wpscan lynis nuclei"
  ["Web Application Testing"]="burpsuite owasp-zap sqlmap gobuster dirb ffuf"
  ["Password Attacks"]="hydra john hashcat medusa crunch seclists"
  ["Wireless Attacks"]="aircrack-ng wifite reaver kismet fern-wifi-cracker"
  ["Exploitation Tools"]="metasploit-framework armitage exploitdb veil beef-xss"
  ["Sniffing & Spoofing"]="wireshark ettercap-graphical bettercap responder mitmproxy"
  ["Post-Exploitation"]="mimikatz crackmapexec powersploit empire"
  ["Forensics"]="autopsy sleuthkit foremost binwalk volatility"
  ["Reporting & Social Engineering"]="set eyewitness"
  ["Other Essentials"]="netcat tcpdump hping3 snort yersinia macchanger"
)

# Banner
echo "=============================="
echo " Complete CyberSec Installer"
echo "=============================="
echo "[+] Installing tools for cybersecurity and penetration testing."

# Update and upgrade the system
echo "[+] Updating system..."
sudo apt update && sudo apt upgrade -y

# Function to install tools via apt
install_tools() {
  local category=$1
  local tools=$2
  echo "[+] Installing $category tools..."
  for tool in $tools; do
    echo "[+] Installing $tool..."
    sudo apt install -y $tool || echo "[!] Failed to install $tool. Check for issues."
  done
}

# Install tools for each category
for category in "${!TOOLS[@]}"; do
  install_tools "$category" "${TOOLS[$category]}"
done

# Additional tools not in APT repository
echo "[+] Installing additional tools..."

# Metasploit Framework
if ! command -v msfconsole &> /dev/null; then
  echo "[+] Installing Metasploit Framework..."
  curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall | sudo bash
else
  echo "[+] Metasploit is already installed."
fi

# Burp Suite
if ! command -v burpsuite &> /dev/null; then
  echo "[+] Downloading Burp Suite Community Edition..."
  wget -O burpsuite.sh "https://portswigger.net/burp/releases/download?product=community&version=latest&type=Linux"
  chmod +x burpsuite.sh
  echo "[!] Run ./burpsuite.sh to complete Burp Suite installation (GUI installer)."
else
  echo "[+] Burp Suite already installed."
fi

# OWASP ZAP
if ! command -v zaproxy &> /dev/null; then
  echo "[+] Installing OWASP ZAP..."
  sudo snap install zaproxy --classic
else
  echo "[+] OWASP ZAP already installed."
fi

# Exploit-DB
if [ ! -d "/opt/exploitdb" ]; then
  echo "[+] Cloning Exploit-DB..."
  sudo git clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb
  sudo ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit
else
  echo "[+] Exploit-DB already present."
fi

# Veil Framework
if [ ! -d "/opt/Veil" ]; then
  echo "[+] Cloning and installing Veil Framework..."
  sudo git clone https://github.com/Veil-Framework/Veil.git /opt/Veil
  cd /opt/Veil
  sudo ./Install.sh --silent || echo "[!] Veil installation may need manual intervention."
  cd -
else
  echo "[+] Veil Framework already present."
fi

# Social-Engineer Toolkit (SET)
if [ ! -d "/opt/set" ]; then
  echo "[+] Installing Social-Engineer Toolkit..."
  sudo git clone https://github.com/trustedsec/social-engineer-toolkit.git /opt/set
  cd /opt/set
  sudo ./setup.py install
  cd -
else
  echo "[+] Social-Engineer Toolkit already present."
fi

# Beef-XSS
if [ ! -d "/opt/beef" ]; then
  echo "[+] Installing Beef-XSS..."
  sudo git clone https://github.com/beefproject/beef.git /opt/beef
  cd /opt/beef
  ./install
  cd -
else
  echo "[+] Beef-XSS already present."
fi

# Autopsy
if ! command -v autopsy &> /dev/null; then
  echo "[+] Installing Autopsy..."
  sudo apt install -y sleuthkit autopsy
else
  echo "[+] Autopsy already installed."
fi

# Python tools
echo "[+] Installing Python tools..."
pip3 install xsrfprobe wfuzz crackmapexec impacket-scripts

# Netcat installation (fix)
echo "[+] Installing netcat..."
if ! dpkg -l | grep -qw netcat; then
  sudo apt install -y netcat-openbsd || sudo apt install -y netcat-traditional
  echo "[+] Netcat installed."
else
  echo "[+] Netcat already installed."
fi

echo "[+] All tools installed successfully!"
echo "=============================="
echo " Installation Complete!"
echo "=============================="
