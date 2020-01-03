#!/usr/bin/bash
#author Ten.J
systemctl stop firewalld &> /dev/null
setenforce 0 &> /dev/null

qjpath=`pwd`


#ELK-filebeat所需用到的所有tar包
logstash_tar='filebeat-6.5.4-linux-x86_64.tar.gz'



if [ ! -e $qjpath/$logstash_tar ]
then
	yum -y install wget
	wget https://artifacts.elastic.co/downloads/beats/filebeat/$logstash_tar
fi


sleep 1
#配置filebeat
echo '开始配置filebeat。。。'
tar xf $qjpath/$logstash_tar -C /usr/local/
mv /usr/local/filebeat-6.5.4-linux-x86_64 /usr/local/filebeat

#kafka集群的ip
k_ip1='172.31.138.132'
k_ip2='172.31.138.133'
k_ip3='172.31.138.131'

echo 'filebeat.prospectors:
- input_type: log
  paths:
    -  /var/log/*.log


output.kafka:   
  hosts: ["'$k_ip1':9092","'$k_ip2':9092","'$k_ip3':9092"]
  topic: "all_log_test"
' > /usr/local/filebeat/filebeat.yml

#启动
/usr/local/filebeat/filebeat -e -c /usr/local/filebeat/filebeat.yml

sleep 3
echo 'filebeat已启动'












