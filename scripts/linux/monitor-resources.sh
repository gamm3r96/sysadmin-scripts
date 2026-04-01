
#!/usr/bin/env bash
# =============================================================================
# Script Name:    monitor-resources.sh
# Description:    Simple but useful monitor for CPU, Memory, and Disk usage.
#                 Shows clear warnings if resources are high.
# Author:         Gamm3r96 (browser edition)
# Version:        1.0.0
# =============================================================================

set -euo pipefail
IFS=$'\n\t'

# ---------------- Configuration ----------------
CPU_WARN=80      # Alert if CPU > 80%
MEM_WARN=80      # Alert if Memory > 80%
DISK_WARN=85     # Alert if Disk > 85%

# Colors
if [[ -t 1 ]]; then
    RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' NC=''
fi

log() {
    echo "$(date '+%H:%M:%S') [$1] $2"
}

main() {
    echo -e "\( {GREEN}=== Linux Resource Monitor === \){NC}"
    echo "Running on $(hostname 2>/dev/null || echo 'unknown host')"

    # CPU Usage
    CPU=$(top -bn1 2>/dev/null | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1 || echo "N/A")
    echo -n "CPU Usage : ${CPU}%  "
    if [[ "$CPU" != "N/A" && "$CPU" -gt "$CPU_WARN" ]]; then
        echo -e "\( {RED}HIGH! \){NC}"
    else
        echo -e "\( {GREEN}OK \){NC}"
    fi

    # Memory Usage
    MEM=$(free -m 2>/dev/null | awk 'NR==2 {printf "%.0f", $3*100/$2}' || echo "N/A")
    echo -n "Memory    : ${MEM}%  "
    if [[ "$MEM" != "N/A" && "$MEM" -gt "$MEM_WARN" ]]; then
        echo -e "\( {RED}HIGH! \){NC}"
    else
        echo -e "\( {GREEN}OK \){NC}"
    fi

    # Disk Usage on root (/)
    DISK=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}' | tr -d '%' || echo "N/A")
    echo -n "Disk (/)  : ${DISK}%  "
    if [[ "$DISK" != "N/A" && "$DISK" -gt "$DISK_WARN" ]]; then
        echo -e "\( {RED}CRITICAL! \){NC}"
    else
        echo -e "\( {GREEN}OK \){NC}"
    fi

    echo -e "\n\( {YELLOW}Top 5 processes by CPU: \){NC}"
    ps aux --sort=-%cpu 2>/dev/null | head -n 6 || echo "ps command not available"

    log "INFO" "Resource check completed"
}

main "$@"
