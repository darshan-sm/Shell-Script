#!/bin/bash

#Author: Darshan S Mahendrakar
#Email: darshan.sm@cloudwick.com
#Date: 02-01-2016
clear
echo "Please Enter your Desired Hostname"
  read HOSTNAME

	sudo cat /etc/sysconfig/network | grep NETWORKING > /tmp/hostname.txt
	sudo echo HOSTNAME=$HOSTNAME >> /tmp/hostname.txt
	sudo cat /tmp/hostname.txt > /etc/sysconfig/network

  hostname $HOSTNAME
  rm -fr /tmp/hostname.txt
#END

sudo passwd <<EOF
admin
admin
EOF

sudo cat > /etc/hosts <<\EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.2.1.146 kdc.novalocal  kdc  #172.16.2.109
EOF

sudo yum -y install policycoreutils-python
sudo semanage fcontext -a -t ssh_home_t "/var/opt/gitlab/.ssh/authorized_keys"
sudo /etc/init.d/sshd restart

ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
touch  ~/.ssh/authorized_keys


sudo chkconfig iptables off
sudo /etc/init.d/iptables stop
sudo chkconfig iptables --list 

sudo chkconfig ip6tables off
sudo /etc/init.d/ip6tables stop
sudo chkconfig ip6tables --list

sudo yum install -y ntp ntpupdate
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo /etc/init.d/ntpd start

sudo setenforce 0
sudo cat > /etc/sysconfig/selinux <<\EOF
SELINUX=disabled
SELINUXTYPE=targeted
EOF

sudo wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.rpm -O jdk-7u45-linux-x64.rpm
 
 
 rpm -ivh jdk-7u45-linux-x64.rpm
 
sudo alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_45/bin/java 200000
 
sudo cat > /etc/profile.d/java.sh <<\EOF
 export JAVA_HOME=/usr/java/jdk1.7.0_45
 export PATH=$PATH:$JAVA_HOME/bin
EOF

sudo mkdir  /usr/share/java

sudo yum install mysql-connector-java* -y

sudo wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.tar.gz
sudo tar -xvzf mysql-connector-java-5.1.35.tar.gz
sudo cp mysql-connector-java-5.1.35/mysql-connector-java-5.1.35-bin.jar /usr/share/java/
sudo rm -rf mysql-connector-java-5.1.35.tar.gz
sudo rm -rf mysql-connector-java-5.1.35
sudo rm -rf ambari.repo
sudo rm -rf jdk-7u45-linux-x64.rpm
sudo rm -rf mysql-connector-java-5.1.35.tar.gz
sudo rm -rf mysql-connector-java-5.1.35

sudo echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled 
sudo cat > /etc/rc.local <<\EOF
#!/bin/sh
touch /var/lock/subsys/local

#disable THP at boot time
 if test -f /sys/kernel/mm/redhat_transparent_hugepage/enabled; then
       echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
          fi
EOF
sudo yum update -y 
bash
