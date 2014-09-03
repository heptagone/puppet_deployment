puppet_deployment
=================

My deployment strategy for puppet master and agent. Works on ubuntu 12 & 14 LTS. Untested for other distros

The meat and bones of my deployment strategies is contained in the initscript directory

The target server's user must have a user (such as root) that can perform sudo commands passwordlessly. In aws popular ubuntu release, the user 'ubuntu' has such access, but in other environments such as digital ocean or ramnode, root will do.

authorized_keys file's content should have the authorized public key that will be used as the deployment user's public key

The hosts file must only contain the hosts entry for the puppet master.


Deploying the base script and puppet agent
==========================================

First you must run the copytoslave.sh from your local machine from which you will deploy with 4 parameter as such:

1. user with root access to the deployment box
2. fqdn of deployment box
3. username of deloyment user that will be created
4. hostname that you wish to apply to this box
5. location of private ssh key (if the private ssh key is not valid for this host that is ok, as you will be prompted for password)

An example of this would be 

user@mylaptop:~$ ./copytoslave.sh root 192.168.0.11 myuser webserver ~/.ssh/id_rsa

You should now be able to run puppet agent as root user or with sudo. Never run pupet agent as the deployment user!!!

myuser@webserver:~$ sudo puppet agent --verbose --no-deamonize



Deploying puppet master
=======================


Run the copytoslave.sh for the tager host on which puppet master is to be applied

Scp over the file installpupmaster.sh to the deployment user's home directory (scp should not ask you for a password if you ran copytoslave.sh successfully)

Run the command as the depoyment user:

myuser@puppet:~$ ./installpupmaster.sh myuser


Puppet master must always run under the deployment's user access

myuser@puppet:~$ puppet server --verbose --no-daemonize &> mpup.log &
