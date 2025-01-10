source .env
docker build -t haproxy-tailscale .
docker run -d --name haproxy-tailscale -p 3128:3128 -p 8404:8404 -e TAILSCALE_AUTH_KEY=${TAILSCALE_AUTH_KEY} haproxy-tailscale
