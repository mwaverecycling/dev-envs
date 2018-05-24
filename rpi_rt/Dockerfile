FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

# install common dependencies
RUN apt update && apt upgrade -y

RUN apt install -y \
    locales \
    curl \
    lsb-release \
    openssh-server \
    sudo \
    python

# ensure we have the en_US.UTF-8 locale available
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# setup the vagrant user
RUN if ! getent passwd vagrant; then useradd -d /home/vagrant -m -s /bin/bash vagrant; fi \
    && echo vagrant:vagrant | chpasswd \
    && echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir -p /etc/sudoers.d \
    && echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant \
    && chmod 0440 /etc/sudoers.d/vagrant

# add the vagrant insecure public key
RUN mkdir -p /home/vagrant/.ssh \
    && chmod 0700 /home/vagrant/.ssh \
    && wget --no-check-certificate \
      https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
      -O /home/vagrant/.ssh/authorized_keys \
    && chmod 0600 /home/vagrant/.ssh/authorized_keys \
    && chown -R vagrant /home/vagrant/.ssh

# don't clean packages, we might be using vagrant-cachier
RUN rm /etc/apt/apt.conf.d/docker-clean

# run sshd in the foreground
CMD /usr/sbin/sshd -D \
    -o UseDNS=no \
    -o UsePAM=no \
    -o PasswordAuthentication=yes \
    -o UsePrivilegeSeparation=no \
    -o PidFile=/tmp/sshd.pid
