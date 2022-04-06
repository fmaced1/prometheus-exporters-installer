FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y \ 
    && apt install -y \
        gcc python-dev python3-pip \
        libkrb5-dev krb5-user \
        openssh-server openssh-client sshpass \
        make vim net-tools iputils-ping curl systemd-container \
    && pip3 install --upgrade pip virtualenv ansible pywinrm pywinrm[kerberos]

RUN useradd -rm -d /home/ansible/ -s /bin/bash -g root -G sudo -u 1001 ansible

USER ansible
WORKDIR /home/ansible
USER root