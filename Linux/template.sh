#!/usr/bin/env bash
# =============================================================================
# Script Name:    template.sh
# Description:    Clean, safe, and well-commented template for sysadmin Bash scripts.
#                 Easy to read
# Author:         Gamm3r96 (built in browser)
# Version:        1.0.0
# =============================================================================

# Strict mode - script stops on errors, no undefined variables
set -euo pipefail
IFS=$'\n\t'

# Script info
SCRIPT_NAME="$(basename "$0")"

# Colors for nice output (only works in terminal)
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'  # No color
else
    RED='' GREEN='' YELLOW='' NC=''
fi

# Simple logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2"
}

# Show help
usage() {
    echo "Usage: $SCRIPT_NAME"
    echo "This is a template. Copy it and modify the main section."
    exit 0
}

# Main function - all real work goes here
main() {
    log "INFO" "Starting $SCRIPT_NAME"

    # ==================== YOUR CODE STARTS HERE ====================

    echo -e "\( {GREEN}Hello from sysadmin script! \){NC}"
    echo "Running on: $(hostname 2>/dev/null || echo 'unknown')"

    # Example: show current date and uptime
    echo "Current date: $(date)"
    echo "Uptime: $(uptime)"

    # ==================== YOUR CODE ENDS HERE ======================

    log "SUCCESS" "$SCRIPT_NAME completed successfully!"
}

# Run the main function
main "$@"
