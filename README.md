# CyberSec Tools Installer

Automate the installation of the best cybersecurity and penetration testing tools on Ubuntu with a single script. This project is designed for security professionals, students, and enthusiasts who want a quick, reliable way to set up a powerful pentesting environment.

## Tools Included

The `install.sh` script installs the following tools:

- **Nmap** – Network scanner
- **Metasploit Framework** – Exploitation framework
- **Wireshark** – Network protocol analyzer
- **John the Ripper** – Password cracker
- **Burp Suite (Community Edition)** – Web vulnerability scanner
- **OWASP ZAP** – Web application security scanner
- **Aircrack-ng** – Wireless network security
- **Nikto** – Web server scanner
- **Hydra** – Network logon cracker
- **SQLMap** – Automated SQL injection tool
- **Netcat** – Networking utility
- **DNSRecon** – DNS enumeration
- **Exploit-DB** – Exploit database and search tool
- **Veil Framework** – Payload generation framework

## Quick Start

Run the following command to download and execute the installer (requires `curl` and `bash`):

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/cybersec-tools-installer/main/install.sh | bash
```

> **Note:** Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username or the repository owner's username after uploading.

Some tools (like Burp Suite) may require manual steps or GUI interaction during installation. Please follow any on-screen instructions.

## Contributing

Contributions are welcome! To contribute:

1. **Fork** this repository on GitHub.
2. **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR_GITHUB_USERNAME/cybersec-tools-installer.git
   ```
3. **Create a new branch** for your feature or fix:
   ```bash
   git checkout -b feature-name
   ```
4. **Commit** your changes and **push** to your fork.
5. **Open a Pull Request** describing your changes.

Feel free to suggest new tools, improvements, or bug fixes!

## How to Upload to GitHub

1. [Create a new repository](https://github.com/new) named `cybersec-tools-installer` on your GitHub account.
2. On your local machine, initialize the directory (if not already):
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_GITHUB_USERNAME/cybersec-tools-installer.git
   git push -u origin main
   ```
3. Update the one-liner in this README with your GitHub username.

---

**Disclaimer:** Use these tools responsibly and only on systems you own or have explicit permission to test. Unauthorized use is illegal and unethical. 