# 🔄 Configuration Backup System

## 📋 Table of Contents
- [Overview](#-overview)
- [Features](#-features)
- [Installation](#-installation)
- [Usage](#-usage)
- [Configuration](#-configuration)
- [Security](#-security)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

## 🌟 Overview

The Configuration Backup System is designed to manage and protect your cybersecurity tools' configurations. It provides automated backup and restoration capabilities for your security tools' settings and data.

## ✨ Features

### 🔒 Security Features
- **AES-256-CBC Encryption** for sensitive configuration files
- **Automatic Key Management** with secure storage
- **Permission Management** for backup files
- **Integrity Verification** using SHA-256 checksums

### 🔄 Backup Features
- **Automated Backups** with scheduling options
- **Incremental Backups** to save space
- **Compression** using tar.gz format
- **Detailed Logging** of all operations
- **Backup Rotation** with configurable retention policies

### 🛠️ Tool Support
- **Network Tools**: nmap, Wireshark, masscan, tcpdump
- **Web Security**: Burp Suite, ZAP, sqlmap, nikto, wpscan
- **Wireless Tools**: Aircrack-ng, Kismet, reaver, wifite
- **Password Tools**: John, Hashcat, hydra
- **Exploitation**: Metasploit, ExploitDB, set
- **Forensics**: Autopsy, Volatility, sleuthkit
- **OSINT**: theHarvester, Sublist3r, recon-ng, amass

## 📥 Installation

### Prerequisites
```bash
# Install required packages
sudo apt update
sudo apt install -y openssl tar
```

### Script Installation
1. Download the script:
```bash
wget https://raw.githubusercontent.com/whitehathackerpr/cybersec-tools-installer/main/config_backup.sh
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

## ⚙️ Configuration

### Backup Locations
- Default: `$HOME/cybersec_tools_backup`
- Custom: Set `BACKUP_DIR` environment variable

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
# Check crontab
crontab -l

# Verify backup schedule
config_backup status
```

### Error Messages
- 🔴 `Permission denied`: Check file permissions
- 🟡 `Disk space low`: Free up space
- 🔵 `Encryption failed`: Check OpenSSL installation
- 🟢 `Schedule conflict`: Check existing schedules

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <sub>Built with ❤️ by the Cybersecurity Tools Team</sub>
</div> 