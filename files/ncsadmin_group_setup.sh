#!/bin/bash
sudo groupadd ncsadmin
sudo groupadd ncsoper
sudo usermod -a -G ncsadmin root
sudo usermod -a -G ncsadmin vagrant
sudo chgrp -R ncsadmin /opt/ncs
sudo chgrp -R ncsadmin /var/opt/ncs
sudo chgrp -R ncsadmin /var/log/ncs
sudo chgrp -R ncsadmin /opt/ncs/current/ncsrc
sudo chgrp -R ncsadmin /opt/ncs/current/bin
sudo chgrp -R ncsadmin /opt/ncs/downloads
sudo echo 'source /opt/ncs/current/ncsrc' >> /home/vagrant/.bashrc 