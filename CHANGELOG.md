# Changelog

All notable changes to the Cybersecurity Tools Installer project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-04-28

### Added
- Selective backup feature for specific tools or categories
- Backup rotation policies with configurable retention
- SHA-256 integrity verification for backups
- System verification checks before operations
- Support for additional tools:
  - Network: masscan, tcpdump
  - Web Security: nikto, wpscan
  - Wireless: reaver, wifite
  - Password: hydra
  - Forensics: sleuthkit
  - OSINT: amass
- Enhanced error handling and logging
- New troubleshooting guides and documentation

### Changed
- Improved encryption key management
- Enhanced documentation structure
- Updated tool versions in tools_config.json
- Streamlined installation process
- Improved cross-platform compatibility

### Fixed
- Permission issues on backup restoration
- Scheduling conflicts on Windows
- Encryption key generation on macOS
- Various minor bugs and improvements

## [1.1.0] - 2024-04-15

### Added
- Automated backup scheduling
- Enhanced cross-platform support
- Detailed operation logging
- Backup compression
- Incremental backup support
- Configuration file validation

### Changed
- Improved installation process
- Enhanced security features
- Updated documentation
- Optimized backup performance

### Fixed
- Installation issues on macOS
- Permission problems on Linux
- Backup scheduling on Windows
- Various minor bugs

## [1.0.0] - 2024-04-01

### Added
- Initial release
- Basic installation support
- Core security tools installation
- Configuration backup and restore
- Basic error handling
- Cross-platform compatibility

[1.2.0]: https://github.com/whitehathackerpr/cybersec-tools-installer/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/whitehathackerpr/cybersec-tools-installer/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/whitehathackerpr/cybersec-tools-installer/releases/tag/v1.0.0 