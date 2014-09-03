#!/bin/bash
#This installs the puppet agent to run with root permissions

sudo -s <<EOF

apt-get install -y ruby1.9.3

cd /root
wget https://github.com/puppetlabs/facter/archive/1.6.x.zip;

curl -L https://github.com/puppetlabs/puppet/archive/stable.zip -o /root/puppet-stable.zip


cd /root
unzip -o 1.6.x.zip;unzip -o puppet-stable.zip -d puppet

cd /root/facter-1.6.x;ruby install.rb

cd /root
curl -L https://github.com/puppetlabs/hiera/archive/stable.zip -o /root/hiera.zip
unzip -o hiera.zip
cd /root/hiera-stable;ruby install.rb

cd /root/puppet/puppet-stable;ruby install.rb


EOF
