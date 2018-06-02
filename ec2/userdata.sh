#!/bin/bash -x

## SCRIPT ==>
mkdir /opt/scripts
cat << EOF >> /opt/scripts/up-commands.sh
#!/bin/bash
sleep 60 && shutdown now
EOF
chmod +x /opt/scripts/*.sh
sudo su - ec2-user -c 'cd /opt/scripts && ./up-commands.sh'
## SCRIPT <==