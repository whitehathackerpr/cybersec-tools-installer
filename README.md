# CyberSec Tools Installer

A comprehensive installer for cybersecurity and penetration testing tools on Ubuntu. This project provides a streamlined way to set up a powerful pentesting environment with a single command.

## Features

- **One-Click Installation**: Install all tools with a single command
- **Progress Tracking**: Visual progress bar and detailed logging
- **Error Handling**: Robust error handling and logging
- **Tool Verification**: Automatic verification of installed tools
- **Configuration Management**: Version control and dependency management
- **Comprehensive Toolset**: Over 50+ security tools across different categories

## Tool Categories

### Network Analysis & Scanning
- **Nmap** - Network scanner
- **Masscan** - Mass IP port scanner
- **Netdiscover** - Network address discovery
- **Wireshark** - Network protocol analyzer
- **Tcpdump** - Network packet analyzer
- **Hping3** - Network security testing
- **Snort** - Network intrusion detection

### Web Security
- **Burp Suite** - Web application security testing
- **OWASP ZAP** - Web application security scanner
- **Nikto** - Web server scanner
- **SQLMap** - Automated SQL injection
- **Gobuster** - Directory/file & DNS busting
- **FFuf** - Fast web fuzzer
- **WPScan** - WordPress vulnerability scanner

### Wireless Security
- **Aircrack-ng** - Wireless network security suite
- **Wifite** - Automated wireless attack tool
- **Reaver** - WPS PIN recovery
- **Kismet** - Wireless network detector
- **Fern-wifi-cracker** - Wireless security auditing

### Password Cracking
- **John the Ripper** - Password cracker
- **Hashcat** - Advanced password recovery
- **Hydra** - Network logon cracker
- **Hash-Identifier** - Hash type identification
- **RainbowCrack** - Password cracking with rainbow tables

### Exploitation
- **Metasploit Framework** - Exploitation framework
- **Exploit-DB** - Exploit database
- **Veil Framework** - Payload generation
- **SET** - Social Engineering Toolkit

### Forensics
- **Autopsy** - Digital forensics platform
- **SleuthKit** - Forensic toolkit
- **Foremost** - File carving
- **Binwalk** - Firmware analysis
- **Volatility** - Memory forensics

### OSINT & Reconnaissance
- **TheHarvester** - Email/subdomain harvesting
- **Sublist3r** - Subdomain enumeration
- **Aquatone** - Website visualization
- **Maltego** - OSINT application
- **SpiderFoot** - OSINT automation
- **Recon-ng** - Web reconnaissance framework

## Quick Start

1. **Download the installer**:
   ```bash
   curl -sSL https://raw.githubusercontent.com/whitehathackerpr/cybersec-tools-installer/main/install.sh | bash
   ```

2. **Or clone and run locally**:
   ```bash
   git clone https://github.com/whitehathackerpr/cybersec-tools-installer.git
   cd cybersec-tools-installer
   chmod +x install.sh
   ./install.sh
   ```

## Installation Process

1. The script will first update your system packages
2. Install all tools from the Ubuntu repositories
3. Install additional tools from GitHub
4. Configure necessary dependencies
5. Verify installations
6. Generate a detailed installation log

## Configuration

The `tools_config.json` file contains:
- Tool versions
- Dependencies
- Installation methods
- Descriptions

You can modify this file to:
- Change tool versions
- Add/remove tools
- Modify dependencies

## Logging

The installation process creates a detailed log file (`cybersec_install.log`) containing:
- Installation progress
- Success/failure status
- Error messages
- Tool verification results

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This tool is for educational and authorized security testing purposes only. The developers are not responsible for any misuse or damage caused by this program. Use these tools responsibly and only on systems you own or have explicit permission to test.

---

[GitHub Repository](https://github.com/whitehathackerpr/cybersec-tools-installer) 