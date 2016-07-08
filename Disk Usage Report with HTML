#!/bin/bash
# HDFS DISK USAGE DAILY REPORT GENERATOR
# LANDING ZONE
# Author : Darshan S Mahendrakar
#


export KRB5CCNAME=/tmp/.krb5cc_`whoami`_$$
export PYTHONPATH=$PYTHONPATH:/users/lzadmin/run/lzoperations/hdfs_disk_usage:
source /platform/env/server_env.sh
source /users/lzadmin/run/lzoperations/hdfs_disk_usage/env.sh

# Clean up Started
clean_up(){
rm -rf $dir_list
rm -rf $final_dir_list
rm -rf $hdfs_count
rm -rf $dfsadmin_report
rm -rf $hdfs_du 
rm -rf $hdfs_own
rm -rf $logfile
}
clean_up

# List directory info
list_up(){
	/usr/bin/kinit hdfs -kt ~/.keytab/hdfs.keytab
        hdfs dfs -ls ${hdfs_raw} | awk -F ' ' '{print $8}' >> ${dir_list}
        hdfs dfs -ls ${hdfs_refined} | awk -F ' ' '{print $8}' >> ${dir_list}
        hdfs dfs -ls ${hdfs_common} | awk -F ' ' '{print $8}' >> ${dir_list}
        hdfs dfs -ls ${hdfs_group} | awk -F ' ' '{print $8}' >> ${dir_list}
        hdfs dfs -ls ${hdfs_user} | awk -F ' ' '{print $8}' >> ${dir_list}
        cat ${dir_list} | awk 'NF' >> ${final_dir_list}
}
list_up
# Collect all disk usage and quotas	
collect_up(){
       for x in `cat ${final_dir_list}` ; do /usr/bin/kinit hdfs -kt /users/lzadmin/.keytab/hdfs.keytab ; hdfs dfs -count -q $x >> ${hdfs_count} ; done
       for x in `cat ${final_dir_list}` ; do /usr/bin/kinit hdfs -kt /users/lzadmin/.keytab/hdfs.keytab; hdfs dfs -du -s $x >> ${hdfs_du} ; done
}
collect_up
# Grab all the directory as -ls 
grab_up(){
      /usr/bin/kinit hdfs -kt ~/.keytab/hdfs.keytab
       hdfs dfs -ls ${hdfs_raw} >> $hdfs_own
       hdfs dfs -ls ${hdfs_refined} >> $hdfs_own
       hdfs dfs -ls ${hdfs_group}  >> $hdfs_own
       hdfs dfs -ls ${hdfs_user}  >> $hdfs_own
       hdfs dfs -ls ${hdfs_common} >> $hdfs_own
       hdfs dfsadmin -report | head -9 >> ${dfsadmin_report}

}
grab_up
log() 
{
    local value=$1
    echo "${value}" >> $logfile
}

rm -rf /var/log/lz/lzadmin/hdfs_diskspace.html
rm -rf /var/log/lz/lzadmin/operation/hdfs_disk_usage/hdfs_diskspace.csv
logfile="/var/log/lz/lzadmin/hdfs_diskspace.html"
csvfile="/var/log/lz/lzadmin/operation/hdfs_disk_usage/hdfs_diskspace.csv"
chmod 755 $logfile
chmod 755 $csvfile

DFS_tage=`cat ${dfsadmin_report} | egrep -w "DFS Used%:" | awk -F ' ' '{print $3}'`
DFS_used=`cat ${dfsadmin_report} | egrep -w "DFS Used:" | awk -F ' ' '{print $4}' | sed -e 's/(//g'`
DFS_size=`cat ${dfsadmin_report} | egrep -w "DFS Used:" | awk -F ' ' '{print $5}' | sed -e 's/)//g'`
TOTAL_DFS=`cat ${dfsadmin_report}  | grep -w "Present Capacity:" | awk -F ' ' '{print $4}' | sed -e 's/(//g'`
TOTAL_DFS_size=`cat ${dfsadmin_report}  | grep -w "Present Capacity:" | awk -F ' ' '{print $5}' | sed -e 's/)//g'`

#	log "From: ${ENV}_HDFS_Report"
#	log "To: $EMAIL_LIST"
#	log "To: darshan.s.mahendrakar@kp.org"
#	log "Subject: $ENV HDFS DISK USAGE REPORT"
#	log "Mime-Version: 1.0"
#	log "Content-Type: text/html"
#	log "<!DOCTYPE html>"
	log "<html>"

	log "<head>"
	log "<style>"
	log "div.title {"
	log "background-color:#278DE7;"
	log "color:black;"
	log "margin:5px;"
	log "padding:5px;"
	log "}"	
	log "</style>"
	log "</head>"
	log "<body>"
	log "<div class="title">"
	log "<h2> KP LANDINGZONE $ENV CLUSTER  </h2>"
	log "<h4> HDFS DISK SPACE QUOTA REPORT `date`</h4>"

if [[ $ENV = "DEV" ]]; then	
	log "<h4> <a href="${DEV_html_server}">Click here to open in browser</a> </h4>"
elif [[ $ENV = "TEST" ]]; then
	log "<h4> <a href="${TEST_html_server}">Click here to open in browser</a> </h4>"
else
	log "<h4> <a href="${PROD_html_server}">Click here to open in browser</a> </h4>"
fi	
	log "</div>"
	log "<table border="1" style="width:20%" >"
	log "<tr>"
	log "<td>TOTAL DFS</td>"
	log "<td>${TOTAL_DFS}${TOTAL_DFS_size}</td>"
	log "</tr>"
	log "<tr>"
	log "<td>DFS Used</td>"
	log "<td>${DFS_used}${DFS_size}</td>"
	log "</tr>"
	log "<tr>"
	log "<td>DFS % Used</td>"
	log "<td>${DFS_tage}</td>"
	log "</tr>"
	log "</table>"
	log "<table style="width:100%" >"


	log "<tr>"
	log "<td></td>"
	log "<td></td>"
	log "<td></td>"
	log "<td></td>"
	log "<td></td>"
	log "<td></td>"
	log "<td bgcolor="#808080"><P ALIGN=Center>NO SPACE QUOTA</td>"
	log "<td bgcolor="#40ff00"><P ALIGN=Center><70% GOOD</td>"
	log "<td bgcolor="#FFFF00"><P ALIGN=Center>>70% WARN</td>"
	log "<td bgcolor="#FF0000"><P ALIGN=Center>>90% CRITICAL</td>"
	log "</tr>"

	log "<tr class="blank_row">"
	log "<td bgcolor="#FFFFFF" colspan="7">&nbsp;</td>"
	log "</tr>"

	log "<tr>"
	log "<td><b><font size="2">HDFS PATH</font></b></td>"
	log "<td><b><font size="2">OWNER / GROUP</font></b></td>"
	log "<td><b><font size="2">Dir / File Count</font></b></td>"
	log "<td><b><font size="2">REPLICATION</font></b></td>"
	log "<td><b><font size="2">TOTAL ALLOCATED SPACE</font></b></td>"
	log "<td><b><font size="2">USED SPACE w/o REPLICATION</font></b></td>"
	log "<td><b><font size="2">USED SPACE</font></b></td>"
	log "<td><b><font size="2">AVAILABLE SPACE</font></b></td>"
	log "<td><b><font size="2">'%' USED</font></b></td>"
	log "<td><b><font size="2">STATUS</font></b></td>"
	log "</tr>"
for x in `cat ${final_dir_list}`
do

	dir_name=`cat ${hdfs_count} | grep -w $x | awk -F ' ' '{print $8}'`
	space_quota=`cat ${hdfs_count} | grep -w $x | awk -F ' ' '{print $3}'`
	avail_quota=`cat ${hdfs_count} | grep -w $x | awk -F ' ' '{print $4}'`
	used_space=`cat ${hdfs_du} | grep -w $x | awk -F ' ' '{print $1}'`
	used_space_with_replication=`cat ${hdfs_du} | grep -w $x | awk -F ' ' '{print $2}'`
	owner=`cat ${hdfs_own}  | grep -w $x | awk -F ' ' '{print $3}'`
	group=`cat ${hdfs_own}  | grep -w $x | awk -F ' ' '{print $4}'`
	dir_count=`cat ${hdfs_count} | grep -w $x | awk -F ' ' '{print $5}'`
	file_count=` cat ${hdfs_count} | grep -w $x | awk -F ' ' '{print $6}'`
	if [[ $ENV = "DEV" ]]; then
	replication="2"
	else
	replication="3"
        fi
#######################################
# CSV parameters
	cc_whoami=`whoami`
	cc_dir_part=${x}
	cc_owner=${owner}
	cc_group=${group}
	if [[ $space_quota = "none" ]]; then
		cc_space_quota="-1"
	else
		cc_space_quota=${space_quota}
	fi
	cc_used_space=${used_space}
	cc_used_space_with_rep=${used_space_with_replication}
	if [[ ${avail_quota} = "inf" ]]; then
		cc_avail_space="-1"
	else
		cc_avail_space=${avail_quota}
	fi
	cc_extract_date=$(date +"%m/%d/%Y %H:%M:%S")
	cc_repl_factor="$replication"
	cc_dir_count=${dir_count}
	cc_file_count=${file_count}




# Calculation
if [[ ${used_space_with_replication} = "0" ]]; then
	USP_WITHREP="0 bytes"
else
	USP_WITHREP=`echo "$used_space_with_replication" | awk '{ sum=$1 ; hum[1024**4]="Tb"; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**4; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'`
fi

if [[ $space_quota = "none" ]]; then
	if [[  $used_space = "0" ]]; then
		y="0"
	else
		y=`echo "$used_space" | awk '{ sum=$1 ; hum[1024**4]="Tb"; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**4; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'`
	fi

	log "<tr>"
	log "<td bgcolor="#808080"><font size="2">${dir_name}</font></td>"
	log "<td bgcolor="#808080"><font size="2">${owner} / ${group}</font></td>"
	log "<td bgcolor="#808080"><font size="2">$dir_count / $file_count</font></td>"
	log "<td bgcolor="#808080"><font size="2">$replication</font></td>"
	log "<td bgcolor="#808080"><font size="2">0</font></td>"
	log "<td bgcolor="#808080"><font size="2">${y}</font></td>"
	log "<td bgcolor="#808080"><font size="2">${USP_WITHREP}</font></td>"
	log "<td bgcolor="#808080"><font size="2">0</font></td>"
	log "<td bgcolor="#808080"><font size="2">0%</font></td>"
	log "<td bgcolor="#808080"><font size="2">NO SPACE QUOTA</font></td>"
	log "</tr>"

cc_percent="0%"
cc_status="No Space Quota"
	echo "${cc_whoami},${ENV},$cc_dir_part,$cc_owner,$cc_group,$cc_space_quota,$cc_used_space,$cc_used_space_with_rep,$cc_avail_space,$cc_repl_factor,$cc_dir_count,$cc_file_count,$cc_percent,$cc_status,$cc_extract_date" >> $csvfile
#	echo "${cc_whoami},$cc_dir_part,$cc_owner,$cc_group,$cc_space_quota,$cc_used_space,$cc_used_space_with_rep,$cc_avail_space,$cc_repl_factor,$cc_dir_count,$cc_file_count,$cc_percent,$cc_status,$cc_extract_date"
:
else

	x=`echo "$space_quota" | awk '{ sum=$1 ; hum[1024**4]="Tb"; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**4; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'`

	y=`echo "$used_space" | awk '{ sum=$1 ; hum[1024**4]="Tb"; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**4; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'`
	z=`echo "$avail_quota" | awk '{ sum=$1 ; hum[1024**4]="Tb"; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**4; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'`
	if [[ ${used_space} != "0" ]]; then
		a=`/usr/bin/python -c "import decimalpy; decimalpy.calculator($used_space_with_replication, $space_quota)"`
		#a=$(echo "scale=3;($used_space/$space_quota)*100" |bc)
	else
		a="0"
	fi
	#echo $a
	value=${a%.*}

if [[ ${value} -ge 90 ]];then

	log "<tr>"
	log "<td bgcolor="#FF0000"><font size="2">${dir_name}</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">${owner} / ${group}</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">${dir_count} / ${file_count}</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">${replication}</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">${x}</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">${y}</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">${USP_WITHREP}</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">${z}</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">${value}%</font></td>"
	log "<td bgcolor="#FF0000"><font size="2">CRITICAL</font></td>"
	log "</tr>"

	cc_percent="$value%"
	cc_status="CRITICAL"
echo "${cc_whoami},${ENV},$cc_dir_part,$cc_owner,$cc_group,$cc_space_quota,$cc_used_space,$cc_used_space_with_rep,$cc_avail_space,$cc_repl_factor,$cc_dir_count,$cc_file_count,${value}%,$cc_status,$cc_extract_date" >> $csvfile
#echo "${cc_whoami},$cc_dir_part,$cc_owner,$cc_group,$cc_space_quota,$cc_used_space,$cc_used_space_with_rep,$cc_avail_space,$cc_repl_factor,$cc_dir_count,$cc_file_count,${value}%,$cc_status,$cc_extract_date" 

elif [[ ${value} -ge 70 ]];then

	log "<tr>"
	log "<td bgcolor="#FFFF00"><font size="2">${dir_name}</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">${owner} / ${group}</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">${dir_count} / ${file_count}</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">${replication}</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">${x}</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">${y}</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">${USP_WITHREP}</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">${z}</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">${value}%</font></td>"
	log "<td bgcolor="#FFFF00"><font size="2">WARN</font></td>"
	log "</tr>"
	cc_percent="$value%"
	cc_status="WARN"
	echo "${cc_whoami},${ENV},$cc_dir_part,$cc_owner,$cc_group,$cc_space_quota,$cc_used_space,$cc_used_space_with_rep,$cc_avail_space,$cc_repl_factor,$cc_dir_count,$cc_file_count,${cc_percent},$cc_status,$cc_extract_date" >> $csvfile
#	echo "${cc_whoami},$cc_dir_part,$cc_owner,$cc_group,$cc_space_quota,$cc_used_space,$cc_used_space_with_rep,$cc_avail_space,$cc_repl_factor,$cc_dir_count,$cc_file_count,${cc_percent},$cc_status,$cc_extract_date" 
else
	log "<tr>"
	log "<td><font size="2">${dir_name}</font></td>"
	log "<td><font size="2">${owner} / ${group}</font></td>"
	log "<td><font size="2">${dir_count} / ${file_count}</font></td>"
	log "<td><font size="2">${replication}</font></td>"
	log "<td><font size="2">${x}</font></td>"
if [[ $used_space = "0" ]];
then 
	log "<td><font size="2">0 bytes</font></td>"
else
	log "<td><font size="2">${y}</font></td>"
fi
	log "<td><font size="2">${USP_WITHREP}</font></td>"
	log "<td><font size="2">${z}</font></td>"
	log "<td><font size="2">${value}%</font></td>"
	log "<td bgcolor="#40ff00"><font size="2">GOOD</font></td>"
	log "</tr>"
	cc_percent="$value%"
	cc_status="GOOD"
echo "${cc_whoami},${ENV},$cc_dir_part,$cc_owner,$cc_group,$cc_space_quota,$cc_used_space,$cc_used_space_with_rep,$cc_avail_space,$cc_repl_factor,$cc_dir_count,$cc_file_count,${cc_percent},$cc_status,$cc_extract_date" >> $csvfile
#echo "${cc_whoami},$cc_dir_part,$cc_owner,$cc_group,$cc_space_quota,$cc_used_space,$cc_used_space_with_rep,$cc_avail_space,$cc_repl_factor,$cc_dir_count,$cc_file_count,${cc_percent},$cc_status,$cc_extract_date"
fi
fi

done
	log "</table>"
	log "</body>"
	log "</html>"

#sh /users/lzadmin/run/lzoperations/hdfs_disk_usage/mysql_upload.sh $csvfile
sh /users/lzadmin/run/lzoperations/hdfs_disk_usage/mysql_upload.sh $csvfile
cat $logfile | /usr/lib/sendmail -t

##########
# moving data to pzxnvm58.nndc.kp.org
newcsv_filename=$csv_logs/hdfs_disk_usage_${ENV}_$(date +"%m%d%Y_%H%M%S").csv
mv ${csvfile} ${newcsv_filename}
scp ${newcsv_filename} ${DEV_MYSQL_HOST}:~/data/disk_usage

backup_html=${html_logs}/hdfs_disk_usage_report_${ENV}_$(date +"%m%d%Y_%H%M%S").html
if [[ `cat ${newcsv_filename} | grep CRITICAL | wc -l` -gt 0 ]]; then
	echo "From: HDFS_USAGE_${ENV}" >> ${backup_html}
	echo "To: $EMAIL_LIST_FTE" >> ${backup_html}
	echo "Subject: $ENV CRITITAL HDFS DISK USAGE REPORT" >> ${backup_html}
	echo "Mime-Version: 1.0" >> ${backup_html}
	echo "Content-Type: text/html" >> ${backup_html}
	echo "<!DOCTYPE html>" >> ${backup_html}

elif [[ `cat ${newcsv_filename} | grep WARN | wc -l` -gt 0 ]]; then
	echo "From: HDFS_USAGE_${ENV}" >> ${backup_html}
	echo "To: $EMAIL_LIST_FTE" >> ${backup_html}
	echo "Subject: $ENV CRITITAL HDFS DISK USAGE REPORT" >> ${backup_html}
	echo "Mime-Version: 1.0" >> ${backup_html}
	echo "Content-Type: text/html" >> ${backup_html}
	echo "<!DOCTYPE html>" >> ${backup_html}


else
	echo "From: HDFS_USAGE_${ENV}" >> ${backup_html}
	echo "To: $EMAIL_LIST" >> ${backup_html}
	echo "Subject: $ENV HDFS DISK USAGE REPORT" >> ${backup_html}
	echo "Mime-Version: 1.0" >> ${backup_html}
	echo "Content-Type: text/html" >> ${backup_html}
	echo "<!DOCTYPE html>" >> ${backup_html}

fi

cat $logfile >> $backup_html
chmod 755 $newcsv_filename
chmod 755 $backup_html
cat $backup_html | /usr/lib/sendmail -t

kdestroy
exit 0
