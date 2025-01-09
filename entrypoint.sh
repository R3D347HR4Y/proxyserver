#!/bin/bash

# Start Tailscale in the background
echo "Starting Tailscale..."
tailscaled --tun=userspace-networking &
sleep 5  # Give tailscaled time to initialize

# Authenticate Tailscale (use authkey for unattended setups)
echo "Authenticating Tailscale..."
tailscale up --authkey=${TAILSCALE_AUTH_KEY} --hostname=${TAILSCALE_HOSTNAME:-"haproxy-server"}
# Verify Tailscale is running
tailscale status

# Start HAProxy
echo "Starting HAProxy..."
haproxy -f /etc/haproxy/haproxy.cfg
