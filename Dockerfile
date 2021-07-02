FROM ubuntu:focal

LABEL maintainer="Grega Vrbančič <grega.vrbancic@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV NETEXTENDER_URL "https://software.sonicwall.com/NetExtender/NetExtender.Linux-10.2.824.x86_64.tgz"
ARG UID="1100"
ENV UID ${UID}
ARG USERNAME="netextender"
ENV USERNAME ${USERNAME}

USER root

WORKDIR /tmp

RUN apt-get update && \
    apt-get -y --no-install-recommends install ca-certificates file curl sudo ppp ipppd iptables iproute2 net-tools kmod iputils-ping telnet && \
    curl ${NETEXTENDER_URL} | tar xz && \
	cd netExtenderClient && \
		sed -i -e "s@read -p '  Set pppd to run as root.*@REPLY='Y'@g" install && \
		chmod +x ./install && \
		./install > /dev/null && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mknod /dev/ppp c 108 0

RUN useradd -u ${UID} -m -U ${USERNAME} && \
	echo "${USERNAME} ALL=(ALL) NOPASSWD: /sbin/iptables, /bin/mknod" >> /etc/sudoers

COPY scripts/entrypoint.sh /

RUN chown ${USERNAME}:${USERNAME} /entrypoint.sh && \
	chmod +x /entrypoint.sh

USER ${USERNAME}

ENTRYPOINT "/entrypoint.sh"