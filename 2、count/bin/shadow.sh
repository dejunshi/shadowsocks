#!/bin/bash

dirpath=`cd $(dirname $0);pwd`
logpath="`dirname $dirpath`/tmp/tmp.log"


#/bin/date +"%Y-%m-%d" >> $logpath
/bin/netstat -antulp|/bin/grep ESTABLISHED | /bin/grep -oP "(?<=172.31.10.157:)808[0-9. ]+" | /bin/sort -bn | /bin/uniq >> $logpath
#/bin/echo "----------------------" >> $logpath
