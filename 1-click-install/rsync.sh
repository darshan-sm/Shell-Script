#!/bin/bash
set -x
#IFS=":"
LIST="datanode1.novalocal datanode1.novalocal"
for i in $LIST; do
ssh root@$i ' wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jdk-7u45-linux-x64.rpm -O jdk-7u45-linux-x64.rpm
rpm -ivh jdk-7u45-linux-x64.rpm
alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_45/bin/java 200000
cat > /etc/profile.d/java.sh <<\EOF
 export JAVA_HOME=/usr/java/jdk1.7.0_45
 export PATH=$PATH:$JAVA_HOME/bin
EOF
 '
done
