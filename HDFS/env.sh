#!/bin/bash
source /platform/env/server_env.sh

base="/var/log"
hdfs_raw="/data/raw/"
hdfs_refined="/data/refined/"
hdfs_group="/group/"
hdfs_user="/user/"
hdfs_common="/data/common/"
hdfs_user_hive="${hdfs_user}/hive/warehouse"
csv_logs=${base}/csv_logs
html_logs=${base}/html_logs


# Web Server location
DEV_html_server="http://<hostname>/hdfs_diskspace.html"
TEST_html_server="http://<hostname>/hdfs_diskspace.html"
PROD_html_server="http://<hostname>/hdfs_diskspace.html"


dir_list="$base/list_hdfs_directory"
final_dir_list="${base}/directory.list"
hdfs_count="${base}/directory_hdfs.list"
dfsadmin_report="${base}/hdfs_report.log"
hdfs_du="${base}/directory_hdfs_du.list"
hdfs_own="${base}/directory_own.list"

