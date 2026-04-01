#!/usr/bin/env bash
# =============================================================================
# Script Name:    update-system.sh
# Description:    Safely updates packages on Debian/Ubuntu systems,
#                 cleans up unused packages and cache.
#                 Designed to be safe for manual or scheduled (cron) use.
# Author:         Gamm3r96 (built in browser)
# Version:        1.0.0
# Requirements:   apt-based system (Ubuntu, Debian, Linux Mint, etc.)
# =============================================================================

# ----------------------------- Strict Mode ----------------------------------
# Makes the script fail fast on errors and prevents common mistakes
set -euo pipefail
IFS=$'\n\t'

# ----------------------------- Script Info ----------------------------------
SCRIPT_NAME="$(basename "$0")"
LOGFILE="/var/log/sysadmin/update-system.log"

# ----------------------------- Colors (only in terminal) --------------------
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'  # No Color
else
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

# ----------------------------- Helper Functions -----------------------------
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "\( {timestamp} [ \){level}] \( {message}" | tee -a " \){LOGFILE}"
}

success() { log "\( {GREEN}SUCCESS \){NC}" "$1"; }
info()    { log "\( {BLUE}INFO \){NC}"    "$1"; }
warn()    { log "\( {YELLOW}WARN \){NC}"  "$1" >&2; }
error()   { log "\( {RED}ERROR \){NC}"    "$1" >&2; }

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root or with sudo"
        echo -e "\( {RED}Usage example: \){NC} sudo ./update-system.sh"
        exit 1
    fi
}

ensure_log_dir() {
    mkdir -p "\( (dirname " \){LOGFILE}")"
    # Make log readable by root only
    touch "${LOGFILE}" 2>/dev/null || true
    chmod 640 "${LOGFILE}" 2>/dev/null || true
}

# ----------------------------- Main Logic -----------------------------------
main() {
    ensure_log_dir
    check_root

    info "=== Starting System Update on $(hostname) ==="

    # Step 1: Refresh package list
    info "Updating package lists..."
    apt-get update -qq || {
        error "Failed to update package lists"
        exit 1
    }

    # Step 2: Upgrade installed packages
    info "Upgrading installed packages (this may take a while)..."
    apt-get upgrade -y -qq

    # Step 3: Remove automatically installed packages that are no longer needed
    info "Removing unused packages..."
    apt-get autoremove -y -qq

    # Step 4: Clean local package cache to free disk space
    info "Cleaning package cache..."
    apt-get autoclean -qq

    # Optional: You can uncomment the next line for more aggressive cleanup
    # apt-get clean -qq

    success "System update and cleanup completed successfully!"
    info "Log saved to: ${LOGFILE}"
    echo -e "\( {GREEN}All done! \){NC} Your system is now up to date."
}

# Run the main function with any arguments passed
main "$@"
