#!/bin/bash

#deployment username $1
#deployment new hostname $2
#copytoslave original user $3

#Assign existing hostname to $hostn
hostn=$(cat /etc/hostname)

#Display existing hostname
echo "Existing hostname is $hostn"

#Ask for new hostname $newhost
echo "New hostname: $2"

#change hostname in /etc/hosts & /etc/hostname
sudo sed -i "s/$hostn/$2/g" /etc/hosts
sudo sed -i "s/$hostn/$2/g" /etc/hostname
echo "127.0.0.1    $2" | sudo tee -a /etc/hosts
#display new hostname
echo "Your new hostname is $2"

RunningUser=`whoami`
echo "Commands are running as $RunningUser"

sudo apt-get update -y
sudo apt-get install ruby-msgpack tree nmap curl vim git wget curl libpq-dev expect libpcre++-dev openvpn unzip htop tree screen liblzo2-dev libpam-dev -y


sudo mv /etc/localtime /etc/localtime.bak
sudo ln -s /usr/share/zoneinfo/America/New_York  /etc/localtime
sudo ntpdate pool.ntp.org

cat bash_profile_append >> ~/.bash_profile
cat bash_profile_append | sudo tee -a /home/$1/.bash_profile
sudo chmod 644 /home/$1/.bash_profile
sudo chown $1 /home/$1/.bash_profile
sudo chgrp $1 /home/$1/.bash_profile

sudo -s <<EOF
cat  /home/$3/hosts >>  /etc/hosts
EOF

sudo cp ~/sshd_config /etc/ssh/sshd_config
#sudo /etc/init.d/ssh restart
eval `ssh-agent -s`
chmod 400 ./readonly_private_key
ssh-add ./readonly_private_key

sudo useradd -d /home/$1 -m $1 -s /bin/bash
sudo -H -u $1 bash  -c "mkdir /home/$1/.ssh"
sudo cp /home/$RunningUser/authorized_keys /home/$1/.ssh/authorized_keys
sudo chmod 400 $1 /home/$1/.ssh/authorized_keys
sudo chown $1 /home/$1/.ssh/authorized_keys
sudo chown $1 /home/$1/.ssh/authorized_keys
echo -e "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> /home/$1/.ssh/config

echo "$1 ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
