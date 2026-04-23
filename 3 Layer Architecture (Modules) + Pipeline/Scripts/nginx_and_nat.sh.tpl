#!/bin/bash
set -ex
exec > /var/log/user-data.log 2>&1

echo "Starting instance setup..."

# Wait for network
sleep 20

%{ if enable_nat }
echo "Configuring NAT..."

echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-nat.conf
sysctl --system

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent

iptables -t nat -F
iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE

netfilter-persistent save
%{ endif }

%{ if install_nginx }
echo "Installing NGINX and MySQL client..."

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx mysql-client

systemctl enable nginx
systemctl start nginx

rm -f /etc/nginx/sites-enabled/default

cat <<EOF > /etc/nginx/sites-available/app.conf
server {
    listen 80;
    server_name _;

    location /health {
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }

    location / {
        root /var/www/html;
        index index.html;
    }

    location /api/ {
        proxy_pass http://${internal_alb_dns};                                       
        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF                                                                                 # NGINX config with ALB proxy_pass

ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Frontend Server</title>
</head>
<body>
    <h1>NGINX Frontend is running</h1>
    <p>Instance: $(hostname)</p>
</body>
</html>
EOF

systemctl restart nginx
%{ endif }

echo "Setup complete"