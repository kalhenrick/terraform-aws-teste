#!/bin/bash
mkdir -p /tmp/ssm
cd /tmp/ssm
wget https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/debian_amd64/amazon-ssm-agent.deb
dpkg -i amazon-ssm-agent.deb
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

apt update

apt-get install -y s3cmd

apt install -y nginx

cat > /root/upload-log-s3.sh<<"EOF"
for log in $(echo $1 | tr " " "\n")
do
	cat $log | gzip -c | /usr/bin/s3cmd -q put - s3://${bucket_name}/"$(date +"%Y-%m-%d")"/"$(date +"%Y-%m-%d_%H%M%S").gz"
done
EOF

chmod +x /root/upload-log-s3.sh

cat > /etc/logrotate.d/nginx<<"EOF"
/var/log/nginx/*.log {
	daily
	missingok
	rotate 2
	size 25M
	compress
	delaycompress
	notifempty
	create 0640 www-data adm
	sharedscripts
	prerotate
		/root/upload-log-s3.sh "$1"
		if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
			run-parts /etc/logrotate.d/httpd-prerotate; \
		fi \
	endscript
	postrotate
		[ -s /run/nginx.pid ] && kill -USR1 `cat /run/nginx.pid`
	endscript
}
EOF


for ((i=1;i<=100;i++)); do  curl localhost > /dev/null; done

logrotate -f /etc/logrotate.d/nginx