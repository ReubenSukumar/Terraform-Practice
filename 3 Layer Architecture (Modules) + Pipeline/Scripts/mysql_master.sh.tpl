#!/bin/bash
set -ex
exec > /var/log/user-data.log 2>&1

echo "GTID Master setup starting..."

# Wait for network
until ping -c1 google.com &>/dev/null; do sleep 2; done

# Install MySQL
apt-get update -y
export DEBIAN_FRONTEND=noninteractive
apt-get install -y mysql-server || apt-get install -y default-mysql-server

# Start MySQL
systemctl enable mysql
systemctl start mysql

# Configure GTID (NO [mysqld] block again)
cat <<EOF >> /etc/mysql/mysql.conf.d/mysqld.cnf

# GTID Replication Config
server-id=1
log_bin=mysql-bin
binlog_format=ROW

gtid_mode=ON
enforce_gtid_consistency=ON
log_slave_updates=ON

bind-address=0.0.0.0                                                            
EOF                                                                                 # Allow remote connections (needed for replication)

systemctl restart mysql
sleep 10

# Create replication user
mysql -e "
CREATE USER 'repli'@'20.0.6.%' IDENTIFIED WITH mysql_native_password BY 'root';
GRANT REPLICATION SLAVE ON *.* TO 'repli'@'20.0.6.%';
FLUSH PRIVILEGES;
"

# Create backend user
mysql -e "
CREATE USER 'back'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'back'@'%';
FLUSH PRIVILEGES;
"


# Create DB
mysql -e "CREATE DATABASE IF NOT EXISTS Data_Base_Name;"                            # Define your database name

echo "GTID Master ready"