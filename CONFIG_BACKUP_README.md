# 🔄 Cybersecurity Tools Configuration Backup System

## 📋 Table of Contents
- [Overview](#-overview)
- [Features](#-features)
- [Supported Platforms](#-supported-platforms)
- [Installation](#-installation)
- [Usage](#-usage)
- [Configuration](#-configuration)
- [Security](#-security)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## 🌟 Overview

The Configuration Backup System is a powerful tool designed to manage and protect your cybersecurity tools' configurations across multiple platforms. It provides automated backup, encryption, and restoration capabilities for your security tools' settings and data.

## ✨ Features

### 🔒 Security Features
- **AES-256-CBC Encryption** for sensitive configuration files
- **Automatic Key Management** with secure storage
- **Platform-Specific Security** implementations
- **Permission Management** for backup files

### 🔄 Backup Features
- **Automated Backups** with scheduling options
- **Cross-Platform Support** (Linux, macOS, Windows)
- **Incremental Backups** to save space
- **Compression** using tar.gz format
- **Detailed Logging** of all operations

### 🛠️ Tool Support
- **Network Tools**: nmap, Wireshark
- **Web Security**: Burp Suite, ZAP, sqlmap
- **Wireless Tools**: Aircrack-ng, Kismet
- **Password Tools**: John, Hashcat
- **Exploitation**: Metasploit, ExploitDB
- **Forensics**: Autopsy, Volatility
- **OSINT**: theHarvester, Sublist3r, recon-ng
- **SDR**: GQRX, SDRangel
- **Phishing**: GoPhish, Evilginx2, King-Phisher

## 💻 Supported Platforms

### 🐧 Linux
- Ubuntu/Debian
- Fedora/RHEL
- Arch Linux
- Kali Linux

### 🍎 macOS
- macOS 10.15+
- Requires Homebrew for dependencies

### 🪟 Windows
- Windows 10/11
- WSL (Windows Subsystem for Linux)
- Git Bash
- Requires OpenSSL installation

## 📥 Installation

### Prerequisites
```bash
# Linux (Debian/Ubuntu)
sudo apt update
sudo apt install -y openssl tar

# Linux (Fedora/RHEL)
sudo dnf install -y openssl tar

# macOS
brew install openssl

# Windows
# Download and install OpenSSL from https://slproweb.com/products/Win32OpenSSL.html
```

### Script Installation
1. Download the script:
```bash
wget https://raw.githubusercontent.com/your-repo/config_backup.sh
```

2. Make it executable:
```bash
chmod +x config_backup.sh
```

3. Move to a system path:
```bash
sudo mv config_backup.sh /usr/local/bin/config_backup
```

## 🚀 Usage

### Basic Commands
```bash
# Create a backup
config_backup backup

# Restore from backup
config_backup restore /path/to/backup.tar.gz

# List available backups
config_backup list
```

### Scheduling Backups
```bash
# Schedule daily backup at 2:30 AM
config_backup schedule daily 02:30

# Schedule weekly backup at 3:00 AM on Sundays
config_backup schedule weekly 03:00

# Schedule monthly backup at 4:00 AM on the 1st
config_backup schedule monthly 04:00

# Remove schedule
config_backup unschedule
```

### Windows-Specific Usage
```powershell
# Using Git Bash
./config_backup.sh backup

# Using WSL
wsl ./config_backup.sh backup

# Using PowerShell
bash ./config_backup.sh backup
```

## ⚙️ Configuration

### Backup Locations
- Linux: `$HOME/cybersec_tools_backup`
- macOS: `$HOME/cybersec_tools_backup`
- Windows: `%USERPROFILE%\cybersec_tools_backup`

### Configuration Files
- Backup schedule: `backup_schedule`
- Log file: `backup.log`
- Encryption keys: `encrypted/encryption_key_*`

### Environment Variables
```bash
# Custom backup location
export BACKUP_DIR="/custom/path/to/backups"

# Custom encryption settings
export ENCRYPTION_ALGORITHM="aes-256-cbc"
```

## 🔐 Security

### Encryption Details
- Algorithm: AES-256-CBC
- Key Generation: Random 32-byte keys
- Key Storage: Protected with 600 permissions
- Salt: Random salt for each file

### Security Best Practices
1. Store encryption keys securely
2. Use strong passwords for encrypted backups
3. Regularly rotate backup encryption keys
4. Monitor backup access logs
5. Implement backup verification

## 🐛 Troubleshooting

### Common Issues

#### Backup Fails
```bash
# Check permissions
ls -la $BACKUP_DIR

# Check disk space
df -h

# Check logs
tail -f $BACKUP_DIR/backup.log
```

#### Restoration Issues
```bash
# Verify backup integrity
tar -tzf backup.tar.gz

# Check encryption key
ls -la $BACKUP_DIR/encrypted/
```

#### Scheduling Problems
```bash
# Check crontab (Linux/macOS)
crontab -l

# Check Task Scheduler (Windows)
taskschd.msc
```

### Error Messages
- 🔴 `Permission denied`: Check file permissions
- 🟡 `Disk space low`: Free up space
- 🔵 `Encryption failed`: Check OpenSSL installation
- 🟢 `Schedule conflict`: Check existing schedules

## 🤝 Contributing

### How to Contribute
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Development Setup
```bash
# Clone repository
git clone https://github.com/your-repo/cybersec-tools-installer.git

# Create virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Testing
```bash
# Run tests
./test_config_backup.sh

# Check code style
flake8 config_backup.sh
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support, please:
1. Check the [issues](https://github.com/your-repo/cybersec-tools-installer/issues)
2. Join our [Discord](https://discord.gg/your-server)
3. Email support@your-domain.com

---

<div align="center">
  <sub>Built with ❤️ by the Cybersecurity Tools Team</sub>
</div> 