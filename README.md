# HAProxy-Tailscale Proxy Server

A Docker-based solution that combines HAProxy with Tailscale to create a secure, scalable proxy server. This setup allows you to run an HTTP proxy that routes traffic through Tailscale's secure network.

## Features

- HTTP proxy server running on port 3128
- Secure networking via Tailscale
- Load balancing capabilities
- Automatic Tailscale authentication
- Support for multiple backend SOCKS proxies

## Prerequisites

- Docker
- Tailscale account
- Tailscale authkey (generate from Tailscale admin console)

## Environment Variables

- `TAILSCALE_AUTH_KEY`: Your Tailscale authentication key (required)
- `TAILSCALE_HOSTNAME`: Custom hostname for the Tailscale node (default: "haproxy-server")

## Quick Start

1. Clone this repository:

```bash
git clone https://github.com/R3D347HR4Y/proxyserver
cd proxyserver
```

2. Build the Docker image:

```bash
docker build -t haproxy-tailscale .
```

3. Run the container:

```bash
docker run -d \
--name haproxy-tailscale \
--restart always \
-p 3128:3128 \
-e TAILSCALE_AUTH_KEY=<your-tailscale-auth-key> \
server-side-proxy-with-tailscale
```

## Configuration

### HAProxy Configuration

The HAProxy configuration file (`haproxy.cfg`) is set up with:

- Frontend HTTP proxy on port 3128
- Backend SOCKS proxies with source-based sticky sessions
- Support for up to 10 backend proxy servers

You can modify the configuration by editing the `haproxy.cfg` file before building the Docker image.

### Tailscale Configuration

The container automatically:

- Starts Tailscale in userspace networking mode
- Authenticates using the provided authkey
- Advertises itself as an exit node

## Usage

Once running, configure your client to use the proxy:

```
Proxy Address: <container-ip>:3128
Proxy Type: HTTP
```

## Monitoring

You can check the Tailscale connection status by executing:

```bash
docker exec haproxy-tailscale tailscale status
```

Use the Tailscale admin API exposed on port 8088 (optional).

```bash
curl http://localhost:8088/debug
```

## Security Considerations

- Always use a secure Tailscale authkey and rotate it regularly
- Keep your Docker image and base systems updated
- Monitor proxy usage and implement appropriate access controls

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
