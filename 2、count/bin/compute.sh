#!/bin/bash

dirpath=`cd $(dirname $0);pwd`
logpath="`dirname $dirpath`/tmp/tmp.log"

log="`dirname $dirpath`/log/shadow.log"

/bin/date +"%Y-%m-%d" >> $log
/bin/cat $logpath | sort -bn | uniq >> $log
/bin/echo "----------------------" >> $log

rm -rf $logpath
