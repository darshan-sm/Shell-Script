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
10.2.1.58   as1.novalocal  as1  #172.16.2.107   #Medium
10.2.1.56   as2.novalocal  as2  #172.16.2.108   #Medium
10.2.1.57   as3.novalocal  as3  #172.16.2.109   #Medium
10.2.1.65   as4.novalocal  as4  #172.16.3.11    #Large
10.2.1.162  as5.novalocal  as5  #172.16.3.13    #Large
10.2.1.161  as6.novalocal  as6  #172.16.3.12    #Large
10.2.1.83   as7.novalocal  as7  #172.16.0.77    #Large
10.2.1.33   as8.novalocal  as8  #172.16.2.242   #Large
EOF

ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
mkdir -p ~/.ssh/authorized_keys

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

wget http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.2.3.7/ambari.repo
cp ambari.repo /etc/yum.repos.d/ambari.repo

bash
