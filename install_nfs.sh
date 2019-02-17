#!/bin/bash
mkdir -p /datastore/nfs
chmod -R 755 /datastore/nfs
chown nfsnobody:nfsnobody /datastore/nfs
echo '/exports/nfsshare               *(rw,sync,fsid=0,crossmnt,no_subtree_check,no_root_squash)' > /etc/exports
echo '/datastore/nfs/      /exports/nfsshare/  none    bind' >> /etc/fstab
mkdir -p /exports/nfsshare/
mount -a
service nfs start
chkconfig nfs on


