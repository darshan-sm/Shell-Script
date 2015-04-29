#!/bin/bash

#Author: Darshan S Mahendrakar
#Email: darshan.sm@cloudwick.com
#Date: 04-24-2015
clear
echo "Please Enter your Desired Hostname"
  read HOSTNAME

	cat /etc/sysconfig/network | grep NETWORKING > /tmp/hostname.txt
	echo HOSTNAME=$HOSTNAME >> /tmp/hostname.txt
	cat /tmp/hostname.txt > /etc/sysconfig/network

  hostname $HOSTNAME
  rm -fr /tmp/hostname.txt
#END

passwd <<EOF
dell
dell
EOF

cat > /etc/hosts <<\EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.2.1.146 kdc.novalocal  kdc  #172.16.2.109
EOF

ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
touch  ~/.ssh/authorized_keys


chkconfig iptables off
/etc/init.d/iptables stop
chkconfig iptables --list 

chkconfig ip6tables off
/etc/init.d/ip6tables stop
chkconfig ip6tables --list

yum install -y ntp ntpupdate
chkconfig ntpd on
ntpdate pool.ntp.org
/etc/init.d/ntpd start

setenforce 0
cat > /etc/sysconfig/selinux <<\EOF
SELINUX=disabled
SELINUXTYPE=targeted
EOF

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.rpm -O jdk-7u45-linux-x64.rpm
 
 
 rpm -ivh jdk-7u45-linux-x64.rpm
 
alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_45/bin/java 200000
 
cat > /etc/profile.d/java.sh <<\EOF
 export JAVA_HOME=/usr/java/jdk1.7.0_45
 export PATH=$PATH:$JAVA_HOME/bin
EOF

mkdir  /usr/share/java

yum install mysql-connector-java* -y

wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.tar.gz
tar -xvzf mysql-connector-java-5.1.35.tar.gz
mkdir  /usr/share/java
cp mysql-connector-java-5.1.35/mysql-connector-java-5.1.35-bin.jar /usr/share/java/
rm -rf mysql-connector-java-5.1.35.tar.gz
rm -rf mysql-connector-java-5.1.35
rm -rf ambari.repo
rm -rf jdk-7u45-linux-x64.rpm
rm -rf mysql-connector-java-5.1.35.tar.gz
rm -rf mysql-connector-java-5.1.35

echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled 
cat > /etc/rc.local <<\EOF
#!/bin/sh
touch /var/lock/subsys/local

#disable THP at boot time
 if test -f /sys/kernel/mm/redhat_transparent_hugepage/enabled; then
       echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
          fi
EOF
yum update -y 
bash
