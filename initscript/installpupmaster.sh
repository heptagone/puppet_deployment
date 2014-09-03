#!/bin/bash
#this must be run as deployment user and same username as $user
user=$1

cd /home/$user

curl -sSL https://get.rvm.io | bash

source /home/$user/.rvm/scripts/rvm;

rvm install ruby-1.9.3-p547;rvm use ruby-1.9.3-p547

curl -L https://github.com/puppetlabs/facter/archive/1.6.x.zip -o /home/$user/facter.zip

curl -L https://github.com/puppetlabs/puppet/archive/stable.zip -o /home/$user/puppet-stable.zip




unzip -o /home/$user/facter.zip -d /home/$user/facter


unzip -o /home/$user/puppet-stable.zip -d /home/$user/puppet


cd /home/$user/facter/facter-1.6.x;ruby install.rb

gem install ftools
gem install hiera
gem install msgpack

cd /home/$user/puppet/puppet-stable;sudo ruby install.rb
sudo chown -R $user /etc/puppet;sudo chgrp -R $user /etc/puppet

puppet master --genconfig > /home/$user/puppetconfig

echo "puppet master --verbose --no-daemonize --config ~/puppetconfig" > /home/$user/mpup
chmod 755 /home/$user/mpup
