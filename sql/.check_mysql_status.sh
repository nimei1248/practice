#!/bin/bash


echo
echo "Welcome to MySQL Server, make sure all of the check result is OK"
echo


echo "[1.check who is login]"
w
echo -e '\n'


echo "[2.check disk free]"
df -hT | grep -v 'Filesystem.*Type.*Size'|sort -rn -k 6|head -n 3
echo -e '\n'


echo "[3.check memory and swap]"
echo "show memory & swap usage, check if memory leak"
free -h
echo -e '\n'


echo "[4.check which prog's load is high]"
#ps -eo pid,pcpu,size,rss,cmd | sort -rn -k 2 | head -n 5 | grep -iv 'PID.*CPU.*SIZE'
#ps ux | grep mysqld | egrep -v 'ps|-bash|grep'
ps ux | grep 'bin/mysqld' | grep 'socket' | awk -F '[ =  ]*' '{print $27"  "$10,$3,$4,$13,$25,$17,$2}' | sort
echo -e '\n'


echo "[5.check MySQL status]"
#mysqladmin pr | egrep -v 'Sleep|\-\-\-\-\-' | sort -rn -k 12 | head -n 5
mysqladmin -u sys -pabc123 -S /mysqldata/inst1/sock/mysql.sock pr 2>/dev/null | egrep -v 'Sleep|\-\-\-\-\-' | sort -rn -k 12
