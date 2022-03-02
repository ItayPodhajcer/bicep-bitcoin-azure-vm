#!/bin/bash
blkid --match-token TYPE=xfs /dev/nvme0n1 || mkfs --type xfs -f /dev/nvme0n1
mkdir /home/{0}/.bitcoin
mkdir /run/bitcoind
mount /dev/nvme0n1 /home/{0}/.bitcoin
chown {0}:{0} /home/{0}/.bitcoin
chown {0}:{0} /run/bitcoind
cd /home/{0}/.bitcoin
wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0-x86_64-linux-gnu.tar.gz
tar -xzf ./bitcoin-22.0-x86_64-linux-gnu.tar.gz
rm ./bitcoin-22.0-x86_64-linux-gnu.tar.gz
echo "
server=1
rpcuser=admin
rpcpassword={1}
" > /home/{0}/.bitcoin/bitcoin.conf
echo "/dev/nvme0n1 ~/.bitcoin xfs defaults,nofail 0 2" >> /etc/fstab
echo "{2}" > /etc/systemd/system/bitcoind.service
systemctl daemon-reload
systemctl enable bitcoin.service
systemctl start bitcoin.service