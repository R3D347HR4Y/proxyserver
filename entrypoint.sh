#!/bin/bash

# Start Tailscale in the background
echo "Starting Tailscale..."
tailscaled --tun=userspace-networking &
sleep 5  # Give tailscaled time to initialize

# Authenticate Tailscale (use authkey for unattended setups)
echo "Authenticating Tailscale..."
if [ -n "$TAILSCALE_AUTH_KEY" ]; then
    tailscale up --authkey=${TAILSCALE_AUTH_KEY} --hostname=${TAILSCALE_HOSTNAME:-"haproxy-server"}
else
    echo "Error: TAILSCALE_AUTH_KEY not provided."
    exit 1
fi

# Verify Tailscale is running
tailscale status

# Start HAProxy
echo "Starting HAProxy..."

haproxy -f /etc/haproxy/haproxy.cfg
