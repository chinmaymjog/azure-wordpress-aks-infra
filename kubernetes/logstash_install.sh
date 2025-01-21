#!/bin/bash
sudo update-crypto-policies --set LEGACY
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat <<EOF > logstash.repo
[logstash-8.x]
name=Elastic repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
cat logstash.repo | sudo tee /etc/yum.repos.d/logstash.repo
sudo sudo yum update -y
sudo sudo install logstash -y
sudo systemctl enable logstash
cat <<EOF > logstash.conf
# AKS -> Logstash -> Elasticsearch pipeline.

input {
  syslog {
    port => 1514
  }
}

output {
  elasticsearch {
    #hosts => ["<PUT URL FOR ELASTIC CLOUD>"]
    #index => "<DEFINE INDEX FORMAT>-%{+YYYY.MM.dd}"
    #user => "elastic"
    #password => "changeme"
  }
}
EOF
cat logstash.conf | sudo tee /etc/logstash/conf.d/logstash.conf
cd /usr/share/logstash/
sudo ./bin/logstash-plugin install logstash-input-syslog
sudo firewall-cmd --permanent --add-port=1514/udp
sudo firewall-cmd --permanent --add-port=1514/tcp
sudo firewall-cmd --reload
#sudo systemctl restart logstash.service