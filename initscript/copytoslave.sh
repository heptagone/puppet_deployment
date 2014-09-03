#!/bin/bash
#
#$1 is first argv is the username with home directory as: /home/username/
#$2 is hostname

echo "USER: $1"
echo "DEST: $2"
echo "DEPPLOYMENT USER: $3"
echo "DEPLOYMENT HOSTNAME: $4"   
echo "key file $5"

echo "creating home directory"
ssh $1@$2 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 "sudo -H -u $1 bash  -c 'mkdir /home/$1'" 
echo "fixing permissions"
ssh $1@$2 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 "sudo -H -u $1 bash  -c 'chown $1 /home/$1 &'"
ssh $1@$2 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 "sudo -H -u $1 bash  -c 'chgrp $1 /home/$1 &'"

echo "COPY FILES OVER!!"

/usr/bin/scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -v -i $5 ./authorized_keys $1@$2:/home/$1/authorized_keys 
/usr/bin/scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -v -i $5 ./baseinstall.sh $1@$2:/home/$1/baseinstall.sh 
/usr/bin/scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -v -i $5 ./sshd_config $1@$2:/home/$1/sshd_config
/usr/bin/scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -v -i $5 ./hosts $1@$2:/home/$1/hosts
/usr/bin/scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -v -i $5 ./bash_profile_append $1@$2:/home/$1/bash_profile_append
/usr/bin/scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -v -i $5 ./installpupagent.sh $1@$2:/home/$1/installpupagent.sh


ssh $1@$2 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 "/bin/bash /home/$1/baseinstall.sh $3 $4 $1" -v

ssh $1@$2 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 "/bin/bash /home/$1/installpupagent.sh" -v


ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 $3@puppet "puppet ca destroy $4"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 $3@$2 "sudo puppet agent --verbose --no-daemonize &> ~/spup.log &"
echo "sleeping for 20 seconds before signing certificate"
sleep 20
echo "killing puppet on new deployment"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 $3@$2 "sudo pkill -f pup;sudo pkill -f ruby"
echo "signing cert"
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $5 $3@puppet "puppet ca sign $4"
