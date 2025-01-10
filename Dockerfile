FROM debian:bullseye

# Install curl, gpg, and HAProxy 3.0
RUN apt-get update && \
    apt-get install -y curl iproute2 iptables gnupg && \
    curl https://haproxy.debian.net/bernat.debian.org.gpg \
    | gpg --dearmor > /usr/share/keyrings/haproxy.debian.net.gpg && \
    echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" \
    http://haproxy.debian.net bullseye-backports-3.0 main \
    > /etc/apt/sources.list.d/haproxy.list


# Install necessary tools
RUN apt-get update && \
    apt-get install -y haproxy=3.0.\* && \
    rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | apt-key add - && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor > /usr/share/keyrings/tailscale-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main" | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale && \
    rm -rf /var/lib/apt/lists/*

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