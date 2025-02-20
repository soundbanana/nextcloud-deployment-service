#!/bin/sh

# Script to add a server's SSH key to the known_hosts file with retries

IP_ADDRESS="${1:?Error: Please provide the server IP address as the first argument}"
SSH_DIR="${HOME}/.ssh"
KNOWN_HOSTS_FILE="${SSH_DIR}/known_hosts"
TEMP_ERROR_LOG="/tmp/ssh_keyscan_error.log"

# Ensure the .ssh directory and known_hosts file exist
setup_ssh() {
    mkdir -p "$SSH_DIR"
    touch "$KNOWN_HOSTS_FILE"
    chmod 600 "$KNOWN_HOSTS_FILE"
}

# Attempt to fetch and add the server's SSH key
fetch_key() {
    local ip="$1"
    local attempts=0
    local max_attempts=10
    local retry_delay=5

    echo "Attempting to add ${ip} to known_hosts..."

    while [ $attempts -lt $max_attempts ]; do
        if ssh-keyscan -H "$ip" >> "$KNOWN_HOSTS_FILE" 2> "$TEMP_ERROR_LOG"; then
            echo "Success: ${ip} added to known_hosts."
            return 0
        else
            attempts=$((attempts + 1))
            echo "Attempt ${attempts} failed. Retrying in ${retry_delay} seconds..."
            sleep "$retry_delay"
        fi
    done

    echo "Error: Failed to add ${ip} to known_hosts after ${max_attempts} attempts."
    cat "$TEMP_ERROR_LOG"
    return 1
}

# Clean up temporary files
cleanup() {
    if [ -f "$TEMP_ERROR_LOG" ]; then
        rm -f "$TEMP_ERROR_LOG"
    fi
}

# Main script execution
main() {
    setup_ssh
    if fetch_key "$IP_ADDRESS"; then
        echo "Current known_hosts file:"
        cat "$KNOWN_HOSTS_FILE"
        cleanup
        exit 0
    else
        cleanup
        exit 1
    fi
}

main