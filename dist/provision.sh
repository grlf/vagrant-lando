#!/usr/bin/env bash
set -euo pipefail

LANDO_VERSION=${LANDO_VERSION:-v3.0.0-rc.23}

# Install Docker.
if ! hash docker > /dev/null 2>&1; then
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
	sudo apt-get update

	sudo apt-get -qq install -y docker-ce docker-ce-cli containerd.io
	sudo usermod -a -G docker vagrant

        #Up max count for elasticsearch
        sudo sh -c 'echo vm.max_map_count=262144 > /etc/sysctl.conf'
        sudo sysctl --system
fi

# Install Lando.
if ! hash lando > /dev/null 2>&1; then
  printf "Downloading Lando version %s...\n" ${LANDO_VERSION}
	wget -O /tmp/lando.deb https://github.com/lando/lando/releases/download/${LANDO_VERSION}/lando-${LANDO_VERSION}.deb
	sudo dpkg -i /tmp/lando.deb
	rm /tmp/lando.deb
	sudo mkdir -p /home/vagrant/.lando/keys
	sudo chown vagrant:vagrant /home/vagrant/.lando
	sudo chown vagrant:vagrant /home/vagrant/.lando/keys
fi
