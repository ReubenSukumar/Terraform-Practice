#!/bin/bash
set -ex
exec > /var/log/user-data.log 2>&1

echo "GTID Slave setup starting..."

# Wait for network
until ping -c1 google.com &>/dev/null; do sleep 2; done

# Install MySQL
apt-get update -y
export DEBIAN_FRONTEND=noninteractive
apt-get install -y mysql-server || apt-get install -y default-mysql-server

# Start MySQL
systemctl enable mysql
systemctl start mysql

# Configure GTID replication
cat <<EOF >> /etc/mysql/mysql.conf.d/mysqld.cnf

# GTID Config
server-id=2
relay-log=relay-bin

gtid_mode=ON
enforce_gtid_consistency=ON
log_slave_updates=ON
read_only=ON

bind-address=0.0.0.0
EOF

systemctl restart mysql
sleep 15

# Configure replication using Terraform-passed master IP
mysql -e "
CHANGE MASTER TO
  MASTER_HOST='${master_ip}',
  MASTER_USER='repli',
  MASTER_PASSWORD='root',
  MASTER_AUTO_POSITION=1;
"

# Start replication
mysql -e "START SLAVE;"

echo "GTID Slave ready"