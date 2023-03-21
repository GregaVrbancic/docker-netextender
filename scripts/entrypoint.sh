#! /usr/bin/env bash

echo "Starting entrypoint..."

[[ ! -e /dev/ppp ]] && sudo mknod /dev/ppp c 108 0

if [ ! -z "${VPN_USERNAME}" ] && [ ! -z "${VPN_PASSWORD}" ] && [ ! -z "${VPN_DOMAIN}" ] && [ ! -z "${VPN_SERVER}" ]; then

	echo "Trying to establish VPN connection..."

	# exec netExtender -u ${VPN_USERNAME} -p ${VPN_PASSWORD} -d ${VPN_DOMAIN} ${VPN_SERVER}
	if [ ! -z "${ALWAYS_TRUST}" ]; then
		echo "Always trust certificate enabled"
		exec netExtender --always-trust -u ${VPN_USERNAME} -p ${VPN_PASSWORD} -d ${VPN_DOMAIN} ${VPN_SERVER}
	else
		exec netExtender -u ${VPN_USERNAME} -p ${VPN_PASSWORD} -d ${VPN_DOMAIN} ${VPN_SERVER}
	fi

else
	echo "No ENV variables provided! Exiting..."
fi