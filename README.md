# SonicWall NetExtender VPN Client

Dockerized SonicWall NetExtender VPN Client. Image is based on the ubuntu:focal official image.

## Required environmental variables

| Variable  | Description | Required/Optional |
|---|---|---|
| VPN_SERVER | URL to your VPN server (i.e. vpn.yourserver.com) | Required |
| VPN_DOMAIN | Your domain (i.e. LocalDomain) | Required |
| VPN_USERNAME | Your VPN username | Required |
| VPN_PASSWORD | Your VPN password | Optional |


## Running as container

Run using the following command:

```docker run --name netextender -e VPN_USERNAME=<vpn-username> -e VPN_PASSWORD=<vpn-password> -e VPN_DOMAIN=<vpn-domain> -e VPN_SERVER=<vpn-server> gregsi/docker-netextender```

## Running using docker-compose

Bellow is given the docker-compose example where the VPN service is utilized to connect to VPN server and where some dummy service can use the VPN service to connect to some host inside VPN.

```
version: "3.9"

services:  

  vpn:
    privileged: true
    cap_add:
      - net_admin
    image: gregsi/docker-netextender
    security_opt:
      - label:disable
    stdin_open: true
    tty: true
    environment:
      - VPN_SERVER=<vpn-server>
      - VPN_DOMAIN=<vpn-domain>
      - VPN_USERNAME=<vpn-username>
      - VPN_PASSWORD=<vpn-password>
    dns:
      - 8.8.8.8
    networks:
      - default
  
  # your service utilizing the VPN
  your_service:
    image: your_service_image
    network_mode: "service:vpn"
```