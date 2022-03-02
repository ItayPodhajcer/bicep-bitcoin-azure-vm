[Unit]
Description=Bitcoin daemon

After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/home/{0}/.bitcoin/bitcoin-22.0/bin/bitcoind -daemonwait \
                                                       -pid=/run/bitcoind/bitcoind.pid \
                                                       -datadir=/home/{0}/.bitcoin \
                                                       -conf=/home/{0}/.bitcoin/bitcoin.conf
Type=forking
PIDFile=/run/bitcoind/bitcoind.pid
Restart=on-failure
TimeoutStartSec=infinity
TimeoutStopSec=600

User={0}
Group={0}

[Install]
WantedBy=multi-user.target