#!/bin/sh

#https://wiki.debian.org/NFSServerSetup

apt-get install nfs-kernel-server nfs-common


mkdir -p /srv/nfs
echo "/srv/nfs localhost(rw,sync,no_subtree_check,no_root_squash,insecure)" >> /etc/exports 
systemctl restart nfs-kernel-server.service 
#/etc/init.d/nfs-kernel-server reload
#exportfs -a

