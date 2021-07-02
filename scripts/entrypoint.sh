#! /usr/bin/env bash

echo "Starting entrypoint..."

[[ ! -e /dev/ppp ]] && sudo mknod /dev/ppp c 108 0

if [ ! -z "${VPN_USERNAME}" ] && [ ! -z "${VPN_PASSWORD}" ] && [ ! -z "${VPN_DOMAIN}" ] && [ ! -z "${VPN_SERVER}" ]; then
	echo "Trying to establish VPN connection..."
	exec netExtender -u ${VPN_USERNAME} -p ${VPN_PASSWORD} -d ${VPN_DOMAIN} ${VPN_SERVER}
else
	echo "No ENV variables provided!"
    return 0
fi