FROM debian:bullseye

# Install necessary tools
RUN apt-get update && \
    apt-get install -y haproxy curl iproute2 iptables gnupg && \
    rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | apt-key add - && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor > /usr/share/keyrings/tailscale-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main" | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale && \
    rm -rf /var/lib/apt/lists/* && \
    haproxy -v

# Copy HAProxy configuration
COPY haproxy.cfg /etc/haproxy/haproxy.cfg

# Expose the HAProxy proxy port
EXPOSE 3128

# Expose the Tailscale admin API port (optional, for debugging)
EXPOSE 8088

# Copy startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Start HAProxy and Tailscale
CMD ["/entrypoint.sh"]