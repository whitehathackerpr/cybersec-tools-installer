#!/bin/bash

# Configuration Backup/Restore Script
# This script handles backup and restoration of tool configurations
# Supports Linux, macOS, and Windows (via WSL or Git Bash)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        *)          echo "unknown";;
    esac
}

OS=$(detect_os)

# Set platform-specific paths and commands
case "$OS" in
    "linux")
        HOME_DIR="$HOME"
        CONFIG_DIR="$HOME/.config"
        OPT_DIR="/opt"
        ;;
    "macos")
        HOME_DIR="$HOME"
        CONFIG_DIR="$HOME/Library/Application Support"
        OPT_DIR="/opt"
        ;;
    "windows")
        # For Windows, we'll use the user's home directory
        if [ -n "$USERPROFILE" ]; then
            HOME_DIR="$USERPROFILE"
        else
            HOME_DIR="$HOME"
        fi
        CONFIG_DIR="$HOME_DIR/AppData/Roaming"
        OPT_DIR="$HOME_DIR/opt"
        ;;
    *)
        echo "Unsupported operating system"
        exit 1
        ;;
esac

# Backup directory
BACKUP_DIR="$HOME_DIR/cybersec_tools_backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"
ENCRYPTED_DIR="$BACKUP_DIR/encrypted"
SCHEDULE_FILE="$BACKUP_DIR/backup_schedule"

# Function to log messages
log_message() {
    echo -e "$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$BACKUP_DIR/backup.log"
}

# Function to create directory if it doesn't exist
ensure_dir() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        log_message "${GREEN}[+]${NC} Created directory: $dir"
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install required dependencies
install_dependencies() {
    case "$OS" in
        "linux")
            if command_exists apt-get; then
                sudo apt-get update
                sudo apt-get install -y openssl tar
            elif command_exists yum; then
                sudo yum install -y openssl tar
            elif command_exists dnf; then
                sudo dnf install -y openssl tar
            fi
            ;;
        "macos")
            if command_exists brew; then
                brew install openssl
            else
                log_message "${YELLOW}[!]${NC} Please install Homebrew and openssl"
                exit 1
            fi
            ;;
        "windows")
            if ! command_exists openssl; then
                log_message "${YELLOW}[!]${NC} Please install OpenSSL for Windows"
                exit 1
            fi
            ;;
    esac
}

# Function to encrypt sensitive files
encrypt_files() {
    local source_dir=$1
    local target_dir=$2
    
    ensure_dir "$ENCRYPTED_DIR"
    
    # Create a random encryption key
    local key_file="$ENCRYPTED_DIR/encryption_key_$TIMESTAMP"
    openssl rand -base64 32 > "$key_file"
    
    # Encrypt sensitive files
    find "$source_dir" -type f \( -name "*.conf" -o -name "*.cfg" -o -name "*.json" -o -name "*.xml" -o -name "*.yml" -o -name "*.yaml" \) | while read -r file; do
        local relative_path="${file#$source_dir/}"
        local encrypted_path="$target_dir/${relative_path}.enc"
        ensure_dir "$(dirname "$encrypted_path")"
        openssl enc -aes-256-cbc -salt -in "$file" -out "$encrypted_path" -pass file:"$key_file"
        log_message "${GREEN}[+]${NC} Encrypted: $file"
    done
    
    # Protect the key file
    chmod 600 "$key_file"
    log_message "${GREEN}[+]${NC} Encryption key stored at: $key_file"
}

# Function to decrypt files
decrypt_files() {
    local source_dir=$1
    local target_dir=$2
    local key_file=$3
    
    if [ ! -f "$key_file" ]; then
        log_message "${RED}[-]${NC} Encryption key not found: $key_file"
        return 1
    fi
    
    find "$source_dir" -type f -name "*.enc" | while read -r file; do
        local relative_path="${file#$source_dir/}"
        local decrypted_path="$target_dir/${relative_path%.enc}"
        ensure_dir "$(dirname "$decrypted_path")"
        openssl enc -aes-256-cbc -d -in "$file" -out "$decrypted_path" -pass file:"$key_file"
        log_message "${GREEN}[+]${NC} Decrypted: $file"
    done
}

# Function to schedule backups
schedule_backup() {
    local frequency=$1
    local time=$2
    
    case "$OS" in
        "linux"|"macos")
            case "$frequency" in
                "daily")
                    local cron_time="$time * * *"
                    ;;
                "weekly")
                    local cron_time="$time * * 0"
                    ;;
                "monthly")
                    local cron_time="$time 1 * *"
                    ;;
                *)
                    log_message "${RED}[-]${NC} Invalid frequency. Use daily, weekly, or monthly"
                    exit 1
                    ;;
            esac
            
            # Add to crontab
            (crontab -l 2>/dev/null; echo "$cron_time $(pwd)/$0 backup") | crontab -
            echo "$frequency $time" > "$SCHEDULE_FILE"
            log_message "${GREEN}[+]${NC} Backup scheduled for $frequency at $time"
            ;;
        "windows")
            log_message "${YELLOW}[!]${NC} Windows scheduling requires Task Scheduler setup. Please configure manually."
            log_message "${BLUE}[*]${NC} Command to run: $(pwd)/$0 backup"
            ;;
    esac
}

# Function to remove scheduled backup
remove_schedule() {
    case "$OS" in
        "linux"|"macos")
            crontab -l | grep -v "$0 backup" | crontab -
            rm -f "$SCHEDULE_FILE"
            log_message "${GREEN}[+]${NC} Backup schedule removed"
            ;;
        "windows")
            log_message "${YELLOW}[!]${NC} Please remove the scheduled task manually from Task Scheduler"
            ;;
    esac
}

# Function to create backup
create_backup() {
    log_message "${BLUE}[*]${NC} Creating backup directory..."
    ensure_dir "$BACKUP_PATH"
    
    # Backup network tools
    log_message "\n${BLUE}[*]${NC} Backing up network tools..."
    ensure_dir "$BACKUP_PATH/network"
    cp -r "$HOME_DIR/.nmap" "$BACKUP_PATH/network/" 2>/dev/null
    cp -r "$HOME_DIR/.wireshark" "$BACKUP_PATH/network/" 2>/dev/null
    
    # Backup web security tools
    log_message "\n${BLUE}[*]${NC} Backing up web security tools..."
    ensure_dir "$BACKUP_PATH/web"
    cp -r "$HOME_DIR/.burpsuite" "$BACKUP_PATH/web/" 2>/dev/null
    cp -r "$HOME_DIR/.ZAP" "$BACKUP_PATH/web/" 2>/dev/null
    cp -r "$HOME_DIR/.sqlmap" "$BACKUP_PATH/web/" 2>/dev/null
    
    # Backup wireless tools
    log_message "\n${BLUE}[*]${NC} Backing up wireless tools..."
    ensure_dir "$BACKUP_PATH/wireless"
    cp -r "$HOME_DIR/.aircrack-ng" "$BACKUP_PATH/wireless/" 2>/dev/null
    cp -r "$HOME_DIR/.kismet" "$BACKUP_PATH/wireless/" 2>/dev/null
    
    # Backup password cracking tools
    log_message "\n${BLUE}[*]${NC} Backing up password cracking tools..."
    ensure_dir "$BACKUP_PATH/password"
    cp -r "$HOME_DIR/.john" "$BACKUP_PATH/password/" 2>/dev/null
    cp -r "$HOME_DIR/.hashcat" "$BACKUP_PATH/password/" 2>/dev/null
    
    # Backup exploitation tools
    log_message "\n${BLUE}[*]${NC} Backing up exploitation tools..."
    ensure_dir "$BACKUP_PATH/exploitation"
    cp -r "$HOME_DIR/.msf4" "$BACKUP_PATH/exploitation/" 2>/dev/null
    cp -r "$OPT_DIR/exploitdb" "$BACKUP_PATH/exploitation/" 2>/dev/null
    
    # Backup forensics tools
    log_message "\n${BLUE}[*]${NC} Backing up forensics tools..."
    ensure_dir "$BACKUP_PATH/forensics"
    cp -r "$HOME_DIR/.autopsy" "$BACKUP_PATH/forensics/" 2>/dev/null
    cp -r "$HOME_DIR/.volatility" "$BACKUP_PATH/forensics/" 2>/dev/null
    
    # Backup OSINT tools
    log_message "\n${BLUE}[*]${NC} Backing up OSINT tools..."
    ensure_dir "$BACKUP_PATH/osint"
    cp -r "$OPT_DIR/theHarvester" "$BACKUP_PATH/osint/" 2>/dev/null
    cp -r "$OPT_DIR/Sublist3r" "$BACKUP_PATH/osint/" 2>/dev/null
    cp -r "$OPT_DIR/recon-ng" "$BACKUP_PATH/osint/" 2>/dev/null
    
    # Backup SDR tools
    log_message "\n${BLUE}[*]${NC} Backing up SDR tools..."
    ensure_dir "$BACKUP_PATH/sdr"
    cp -r "$HOME_DIR/.gqrx" "$BACKUP_PATH/sdr/" 2>/dev/null
    cp -r "$HOME_DIR/.sdrangel" "$BACKUP_PATH/sdr/" 2>/dev/null
    
    # Backup phishing tools
    log_message "\n${BLUE}[*]${NC} Backing up phishing tools..."
    ensure_dir "$BACKUP_PATH/phishing"
    cp -r "$OPT_DIR/gophish" "$BACKUP_PATH/phishing/" 2>/dev/null
    cp -r "$OPT_DIR/evilginx2" "$BACKUP_PATH/phishing/" 2>/dev/null
    cp -r "$OPT_DIR/king-phisher" "$BACKUP_PATH/phishing/" 2>/dev/null
    
    # Encrypt sensitive configuration files
    log_message "\n${BLUE}[*]${NC} Encrypting sensitive configuration files..."
    encrypt_files "$BACKUP_PATH" "$BACKUP_PATH/encrypted"
    
    # Create backup archive
    log_message "\n${BLUE}[*]${NC} Creating backup archive..."
    tar -czf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "backup_$TIMESTAMP"
    rm -rf "$BACKUP_PATH"
    
    log_message "${GREEN}[+]${NC} Backup created at $BACKUP_PATH.tar.gz"
}

# Function to restore backup
restore_backup() {
    local backup_file=$1
    
    if [ ! -f "$backup_file" ]; then
        log_message "${RED}[-]${NC} Backup file not found: $backup_file"
        exit 1
    fi
    
    log_message "${BLUE}[*]${NC} Extracting backup..."
    tar -xzf "$backup_file" -C "$BACKUP_DIR"
    local backup_dir=$(tar -tzf "$backup_file" | head -1 | cut -f1 -d"/")
    
    # Find the encryption key
    local key_file=$(find "$BACKUP_DIR/$backup_dir" -name "encryption_key_*" | head -1)
    if [ -n "$key_file" ]; then
        log_message "${BLUE}[*]${NC} Decrypting sensitive files..."
        decrypt_files "$BACKUP_DIR/$backup_dir/encrypted" "$BACKUP_DIR/$backup_dir" "$key_file"
    fi
    
    # Restore network tools
    log_message "\n${BLUE}[*]${NC} Restoring network tools..."
    cp -r "$BACKUP_DIR/$backup_dir/network/.nmap" "$HOME_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/network/.wireshark" "$HOME_DIR/" 2>/dev/null
    
    # Restore web security tools
    log_message "\n${BLUE}[*]${NC} Restoring web security tools..."
    cp -r "$BACKUP_DIR/$backup_dir/web/.burpsuite" "$HOME_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/web/.ZAP" "$HOME_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/web/.sqlmap" "$HOME_DIR/" 2>/dev/null
    
    # Restore wireless tools
    log_message "\n${BLUE}[*]${NC} Restoring wireless tools..."
    cp -r "$BACKUP_DIR/$backup_dir/wireless/.aircrack-ng" "$HOME_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/wireless/.kismet" "$HOME_DIR/" 2>/dev/null
    
    # Restore password cracking tools
    log_message "\n${BLUE}[*]${NC} Restoring password cracking tools..."
    cp -r "$BACKUP_DIR/$backup_dir/password/.john" "$HOME_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/password/.hashcat" "$HOME_DIR/" 2>/dev/null
    
    # Restore exploitation tools
    log_message "\n${BLUE}[*]${NC} Restoring exploitation tools..."
    cp -r "$BACKUP_DIR/$backup_dir/exploitation/.msf4" "$HOME_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/exploitation/exploitdb" "$OPT_DIR/" 2>/dev/null
    
    # Restore forensics tools
    log_message "\n${BLUE}[*]${NC} Restoring forensics tools..."
    cp -r "$BACKUP_DIR/$backup_dir/forensics/.autopsy" "$HOME_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/forensics/.volatility" "$HOME_DIR/" 2>/dev/null
    
    # Restore OSINT tools
    log_message "\n${BLUE}[*]${NC} Restoring OSINT tools..."
    cp -r "$BACKUP_DIR/$backup_dir/osint/theHarvester" "$OPT_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/osint/Sublist3r" "$OPT_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/osint/recon-ng" "$OPT_DIR/" 2>/dev/null
    
    # Restore SDR tools
    log_message "\n${BLUE}[*]${NC} Restoring SDR tools..."
    cp -r "$BACKUP_DIR/$backup_dir/sdr/.gqrx" "$HOME_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/sdr/.sdrangel" "$HOME_DIR/" 2>/dev/null
    
    # Restore phishing tools
    log_message "\n${BLUE}[*]${NC} Restoring phishing tools..."
    cp -r "$BACKUP_DIR/$backup_dir/phishing/gophish" "$OPT_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/phishing/evilginx2" "$OPT_DIR/" 2>/dev/null
    cp -r "$BACKUP_DIR/$backup_dir/phishing/king-phisher" "$OPT_DIR/" 2>/dev/null
    
    # Clean up
    rm -rf "$BACKUP_DIR/$backup_dir"
    
    log_message "${GREEN}[+]${NC} Backup restored successfully"
}

# Main script
if [ ! -d "$BACKUP_DIR" ]; then
    ensure_dir "$BACKUP_DIR"
fi

# Install dependencies if needed
install_dependencies

case "$1" in
    "backup")
        create_backup
        ;;
    "restore")
        if [ -z "$2" ]; then
            echo -e "${RED}[-]${NC} Please specify backup file to restore"
            exit 1
        fi
        restore_backup "$2"
        ;;
    "list")
        echo -e "${BLUE}[*]${NC} Available backups:"
        ls -1 "$BACKUP_DIR"/*.tar.gz 2>/dev/null || echo "No backups found"
        ;;
    "schedule")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 schedule {daily|weekly|monthly} {HH:MM}"
            exit 1
        fi
        schedule_backup "$2" "$3"
        ;;
    "unschedule")
        remove_schedule
        ;;
    *)
        echo "Usage: $0 {backup|restore <backup_file>|list|schedule <frequency> <time>|unschedule}"
        exit 1
        ;;
esac 