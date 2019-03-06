# cat /etc/redhat-release
CentOS release 6.8 (Final)

# uname -rm
2.6.32-642.el6.x86_64 x86_64

yum list bison cmake ncurses-devel opensll-devel gcc gcc-c++
yum install bison cmake ncurses-devel opensll-devel gcc gcc-c++

# rpm -qa mysql bison cmake ncurses-devel opensll-devel gcc gcc-c++
mysql-libs-5.1.73-7.el6.x86_64
gcc-c++-4.4.7-17.el6.x86_64
cmake-2.8.12.2-4.el6.x86_64
bison-2.4.1-5.el6.x86_64
ncurses-devel-5.7-4.20090207.el6.x86_64
gcc-4.4.7-17.el6.x86_64

git clone https://github.com/mysql-inception/inception.git
cd inception
sh  inception_build.sh debug linux

# cd debug/mysql/
# ll
total 32
drwxr-xr-x 2 root root 4096 Apr 12 14:34 bin
drwxr-xr-x 3 root root 4096 Apr 12 14:34 data
drwxr-xr-x 3 root root 4096 Apr 12 14:34 include
drwxr-xr-x 2 root root 4096 Apr 12 14:34 lib
drwxr-xr-x 4 root root 4096 Apr 12 14:34 man
drwxr-xr-x 4 root root 4096 Apr 12 14:34 share
drwxr-xr-x 4 root root 4096 Apr 12 14:34 sql-bench
drwxr-xr-x 3 root root 4096 Apr 12 14:34 support-files

# ll bin
total 22628
-rwxr-xr-x 1 root root 9471761 Apr 12 14:34 Inception
-rwxr-xr-x 1 root root 4219628 Apr 12 14:32 mysql
-rwxr-xr-x 1 root root 9471761 Apr 12 14:34 mysqld-debug

# ll lib/
total 9068
-rw-r--r-- 1 root root 5227784 Apr 12 14:31 libmysqlclient.a
lrwxrwxrwx 1 root root      16 Apr 12 14:34 libmysqlclient_r.a -> libmysqlclient.a
lrwxrwxrwx 1 root root      17 Apr 12 14:34 libmysqlclient_r.so -> libmysqlclient.so
lrwxrwxrwx 1 root root      17 Apr 12 14:34 libmysqlclient_r.so.18 -> libmysqlclient.so
lrwxrwxrwx 1 root root      17 Apr 12 14:34 libmysqlclient_r.so.18.0.0 -> libmysqlclient.so
lrwxrwxrwx 1 root root      20 Apr 12 14:34 libmysqlclient.so -> libmysqlclient.so.18
lrwxrwxrwx 1 root root      24 Apr 12 14:34 libmysqlclient.so.18 -> libmysqlclient.so.18.0.0
-rwxr-xr-x 1 root root 4051503 Apr 12 14:31 libmysqlclient.so.18.0.0

mkdir /usr/local/inception
cp -a mysql/bin /usr/local/inception/
cd /usr/local/inception
mkdir tmp sock log

cat > inc.cnf << EOF
[inception]
general_log=1
general_log_file=/usr/local/mysql/log/inception.log
port=7788
socket=/usr/local/mysql/sock/inc.socket
character-set-client-handshake=0
character-set-server=utf8
inception_remote_backup_host=
inception_remote_backup_port=
inception_remote_system_user=inception
inception_remote_system_password=inception
inception_support_charset=utf8mb4
inception_enable_nullable=0
inception_check_primary_key=1
inception_check_column_comment=1
inception_check_table_comment=1
inception_osc_min_table_size=1
inception_osc_bin_dir=/usr/local/mysql/tmp
inception_osc_chunk_time=0.1
inception_enable_blob_type=1
inception_check_column_default_value=1
EOF

nohup /usr/local/inception/bin/Inception --defaults-file=inc.cnf &

# netstat -lnput | grep -i Inception
tcp        0      0 0.0.0.0:7788                0.0.0.0:*                   LISTEN      19767/Inception 

默认登录inception方法：
mysql -uroot -h127.0.0.1 -P7788
mysql> inception get variables;
+------------------------------------------+-------------------------------------------+
| Variable_name                            | Value                                     |
+------------------------------------------+-------------------------------------------+
| autocommit                               | OFF                                       |
| bind_address                             | *                                         |
| character_set_system                     | utf8                                      |
| character_sets_dir                       | /usr/local/mysql/share/charsets/          |
| connect_timeout                          | 10                                        |
| date_format                              | %Y-%m-%d                                  |
| datetime_format                          | %Y-%m-%d %H:%i:%s                         |
| general_log                              | ON                                        |
| general_log_file                         | /usr/local/mysql/log/inception.log        |
| inception_check_autoincrement_datatype   | ON                                        |
| inception_check_autoincrement_init_value | ON                                        |
| inception_check_autoincrement_name       | ON                                        |
| inception_check_column_comment           | ON                                        |
| inception_check_column_default_value     | ON                                        |
| inception_check_dml_limit                | ON                                        |
| inception_check_dml_orderby              | ON                                        |
| inception_check_dml_where                | ON                                        |
| inception_check_identifier               | ON                                        |
| inception_check_index_prefix             | ON                                        |
| inception_check_insert_field             | ON                                        |
| inception_check_primary_key              | ON                                        |
| inception_check_table_comment            | ON                                        |
| inception_check_timestamp_default        | ON                                        |
| inception_ddl_support                    | OFF                                       |
| inception_enable_autoincrement_unsigned  | ON                                        |
| inception_enable_blob_type               | ON                                        |
| inception_enable_column_charset          | OFF                                       |
| inception_enable_enum_set_bit            | OFF                                       |
| inception_enable_foreign_key             | OFF                                       |
| inception_enable_identifer_keyword       | OFF                                       |
| inception_enable_not_innodb              | OFF                                       |
| inception_enable_nullable                | OFF                                       |
| inception_enable_orderby_rand            | OFF                                       |
| inception_enable_partition_table         | OFF                                       |
| inception_enable_pk_columns_only_int     | OFF                                       |
| inception_enable_select_star             | OFF                                       |
| inception_enable_sql_statistic           | ON                                        |
| inception_max_char_length                | 16                                        |
| inception_max_key_parts                  | 5                                         |
| inception_max_keys                       | 16                                        |
| inception_max_primary_key_parts          | 5                                         |
| inception_max_update_rows                | 10000                                     |
| inception_merge_alter_table              | ON                                        |
| inception_osc_alter_foreign_keys_method  | none                                      |
| inception_osc_bin_dir                    | /usr/local/mysql/tmp                      |
| inception_osc_check_alter                | ON                                        |
| inception_osc_check_interval             | 5.000000                                  |
| inception_osc_check_replication_filters  | ON                                        |
| inception_osc_chunk_size                 | 1000                                      |
| inception_osc_chunk_size_limit           | 4.000000                                  |
| inception_osc_chunk_time                 | 0.100000                                  |
| inception_osc_critical_thread_connected  | 1000                                      |
| inception_osc_critical_thread_running    | 80                                        |
| inception_osc_drop_new_table             | ON                                        |
| inception_osc_drop_old_table             | ON                                        |
| inception_osc_max_lag                    | 3.000000                                  |
| inception_osc_max_thread_connected       | 1000                                      |
| inception_osc_max_thread_running         | 80                                        |
| inception_osc_min_table_size             | 1                                         |
| inception_osc_on                         | ON                                        |
| inception_osc_print_none                 | ON                                        |
| inception_osc_print_sql                  | ON                                        |
| inception_osc_recursion_method           | processlist                               |
| inception_password                       |                                           |
| inception_read_only                      | OFF                                       |
| inception_remote_backup_host             | 10.180.17.136                             |
| inception_remote_backup_port             | 4312                                      |
| inception_remote_system_password         | *D4100AE1B087A91E29CB935BB7842F0B3908DF34 |
| inception_remote_system_user             | inception                                 |
| inception_support_charset                | utf8mb4                                   |
| inception_user                           |                                           |
| interactive_timeout                      | 28800                                     |
| max_allowed_packet                       | 1073741824                                |
| max_connect_errors                       | 100                                       |
| max_connections                          | 151                                       |
| net_buffer_length                        | 16384                                     |
| net_read_timeout                         | 30                                        |
| net_write_timeout                        | 60                                        |
| port                                     | 7788                                      |
| query_alloc_block_size                   | 8192                                      |
| query_prealloc_size                      | 8192                                      |
| socket                                   | /usr/local/mysql/sock/inc.socket          |
| thread_handling                          | one-thread-per-connection                 |
| thread_stack                             | 262144                                    |
| time_format                              | %H:%i:%s                                  |
| version                                  | Inception2.1.50                           |
| version_comment                          | Source distribution                       |
| version_compile_machine                  | x86_64                                    |
| version_compile_os                       | Linux                                     |
| wait_timeout                             | 28800                                     |
+------------------------------------------+-------------------------------------------+
90 rows in set (0.00 sec)


备份权限：
SQL> create user inception@'%' identified by 'inception';
Query OK, 0 rows affected (0.02 sec)

SQL> grant create,insert,select on *.* to inception@'%';
Query OK, 0 rows affected (0.01 sec)

SQL> flush privileges;
Query OK, 0 rows affected (0.01 sec)

SQL> show grants for inception@'%';
+--------------------------------------------------------+
| Grants for inception@%                                 |
+--------------------------------------------------------+
| GRANT SELECT, INSERT, CREATE ON *.* TO 'inception'@'%' |
+--------------------------------------------------------+
1 row in set (0.00 sec)


-- 执行 需要带上建表属性，否则报错
# cat sql
/*--user=sys;--password=123;--host=127.0.0.1;--execute=1;--port=3309;*/
inception_magic_start;
set names utf8;
use db1;
CREATE TABLE t8(id int unsigned not null auto_increment comment 'pk' primary key) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment 'table t8';
inception_magic_commit;


# python 3.py                      
['ID', 'stage', 'errlevel', 'stagestatus', 'errormessage', 'SQL', 'Affected_rows', 'sequence', 'backup_dbname', 'execute_time', 'sqlsha1']
1 | CHECKED | 0 | Audit completed | None | 2 | CHECKED | 0 | Audit completed | None | 3 | CHECKED | 1 | Audit completed | Set engine to innodb for table 't8'.
Set charset to one of 'utf8' for table 't8'. |

解决方法:
inception_support_charset=utf8

mysql> inception get variables 'inception_support_charset';
+---------------------------+-------+
| Variable_name             | Value |
+---------------------------+-------+
| inception_support_charset | utf8  |
+---------------------------+-------+
1 row in set (0.00 sec)


# python 3.py 
['ID', 'stage', 'errlevel', 'stagestatus', 'errormessage', 'SQL', 'Affected_rows', 'sequence', 'backup_dbname', 'execute_time', 'sqlsha1']
1 | RERUN | 0 | Execute Successfully | None | 2 | RERUN | 0 | Execute Successfully | None | 3 | EXECUTED | 0 | Execute Successfully
Backup successfully | None |


-- online instance 127.0.0.1:3309
SQL> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| t1            |
| t8            |
+---------------+
2 rows in set (0.00 sec)

SQL> show create table t8\G
*************************** 1. row ***************************
       Table: t8
Create Table: CREATE TABLE `t8` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'pk',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='table t8'
1 row in set (0.00 sec)


-- 备份实例  127.0.0.1:3311
SQL> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| 127_0_0_1_3309_db1 |
| inception          |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
6 rows in set (0.00 sec)

SQL> use 127_0_0_1_3309_db1
Database changed

SQL> show tables;
+------------------------------------+
| Tables_in_127_0_0_1_3309_db1       |
+------------------------------------+
| $_$inception_backup_information$_$ |
| t8                                 |
+------------------------------------+
2 rows in set (0.00 sec)

SQL> show create table t8\G
*************************** 1. row ***************************
       Table: t8
Create Table: CREATE TABLE `t8` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rollback_statement` mediumtext,
  `opid_time` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

SQL> select * from t8;
+----+------------------------+------------------+
| id | rollback_statement     | opid_time        |
+----+------------------------+------------------+
|  1 | DROP TABLE `db1`.`t8`; | 1523678205_338_2 |
+----+------------------------+------------------+
1 row in set (0.00 sec)

SQL> show create table $_$inception_backup_information$_$\G
*************************** 1. row ***************************
       Table: $_$inception_backup_information$_$
Create Table: CREATE TABLE `$_$inception_backup_information$_$` (
  `opid_time` varchar(50) NOT NULL,
  `start_binlog_file` varchar(512) DEFAULT NULL,
  `start_binlog_pos` int(11) DEFAULT NULL,
  `end_binlog_file` varchar(512) DEFAULT NULL,
  `end_binlog_pos` int(11) DEFAULT NULL,
  `sql_statement` text,
  `host` varchar(64) DEFAULT NULL,
  `dbname` varchar(64) DEFAULT NULL,
  `tablename` varchar(64) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `time` timestamp NULL DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`opid_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)


SQL> select * from $_$inception_backup_information$_$\G
*************************** 1. row ***************************
        opid_time: 1523678205_338_2
start_binlog_file: 
 start_binlog_pos: 0
  end_binlog_file: 
   end_binlog_pos: 0
    sql_statement: CREATE TABLE t8(id int unsigned not null auto_increment comment 'pk' primary key) ENGINE=InnoDB DEFAULT CHARSET=utf8 comment 'table t8'
             host: 127.0.0.1
           dbname: db1
        tablename: t8
             port: 3309
             time: 2018-04-14 11:56:45
             type: CREATETABLE
1 row in set (0.00 sec)


SQL> use inception
Database changed

SQL> show tables;
+---------------------+
| Tables_in_inception |
+---------------------+
| statistic           |
+---------------------+
1 row in set (0.00 sec)

SQL> show create table statistic\G
*************************** 1. row ***************************
       Table: statistic
Create Table: CREATE TABLE `statistic` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `optime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usedb` int(11) NOT NULL DEFAULT '0',
  `deleting` int(11) NOT NULL DEFAULT '0',
  `inserting` int(11) NOT NULL DEFAULT '0',
  `updating` int(11) NOT NULL DEFAULT '0',
  `selecting` int(11) NOT NULL DEFAULT '0',
  `altertable` int(11) NOT NULL DEFAULT '0',
  `renaming` int(11) NOT NULL DEFAULT '0',
  `createindex` int(11) NOT NULL DEFAULT '0',
  `dropindex` int(11) NOT NULL DEFAULT '0',
  `addcolumn` int(11) NOT NULL DEFAULT '0',
  `dropcolumn` int(11) NOT NULL DEFAULT '0',
  `changecolumn` int(11) NOT NULL DEFAULT '0',
  `alteroption` int(11) NOT NULL DEFAULT '0',
  `alterconvert` int(11) NOT NULL DEFAULT '0',
  `createtable` int(11) NOT NULL DEFAULT '0',
  `droptable` int(11) NOT NULL DEFAULT '0',
  `createdb` int(11) NOT NULL DEFAULT '0',
  `truncating` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)


SQL> select * from statistic\G
*************************** 1. row ***************************
          id: 1
      optime: 2018-04-14 11:56:45
       usedb: 1
    deleting: 0
   inserting: 0
    updating: 0
   selecting: 0
  altertable: 0
    renaming: 0
 createindex: 0
   dropindex: 0
   addcolumn: 0
  dropcolumn: 0
changecolumn: 0
 alteroption: 0
alterconvert: 0
 createtable: 1
   droptable: 0
    createdb: 0
  truncating: 0
1 row in set (0.00 sec)


name是关键字？
# python 3.py 
['ID', 'stage', 'errlevel', 'stagestatus',    'errormessage', 'SQL', 'Affected_rows', 'sequence', 'backup_dbname', 'execute_time', 'sqlsha1']
  1   | CHECKED | 0         | Audit completed | None          | 2 | CHECKED | 0 | Audit completed | None | 3 | CHECKED | 0 | Audit completed | None | 
  4   | CHECKED | 1         | Audit completed | Identifier 'name' is keyword in MySQL. |

直接在mysql中创建是OK的
SQL> CREATE TABLE t9(id int unsigned not null auto_increment comment 'pk' primary key,name varchar(10) not null default '' comment '姓名') ENGINE=InnoDB CHARSET=utf8 comment 'table t9';
Query OK, 0 rows affected (0.02 sec)


# cat sql 
/*--user=sys;--password=123;--host=127.0.0.1;--execute=1;--port=3309;*/
inception_magic_start;
set names utf8;
create database db3 CHARACTER SET utf8;
use db3;
CREATE TABLE t10(id int unsigned not null auto_increment comment 'pk' primary key,namee varchar(10) not null default '' comment '姓名') ENGINE=InnoDB CHARSET=utf8 comment 'table t10';
inception_magic_commit;

# cat 3.py 
#!/usr/bin/python
#-*-coding: utf-8-*-


import json
import os
import MySQLdb


from MySQLdb.constants.CLIENT import MULTI_STATEMENTS,MULTI_RESULTS

file_object = open('sql')
try:
    all_the_text = file_object.read()
finally:
    file_object.close()

try:
    conn=MySQLdb.connect(host='127.0.0.1',user='root',passwd='',db='',port=7788,client_flag=MULTI_STATEMENTS|MULTI_RESULTS)
    cur=conn.cursor()
    ret=cur.execute(all_the_text)
    num_fields = len(cur.description) 
    field_names = [i[0] for i in cur.description]
    result=cur.fetchall()
    cur.close()
    conn.close()

    print field_names
    for row in result:
        print row[0], "|",row[1],"|",row[2],"|",row[3],"|",row[4],"|",
        row[5],"|",row[6],"|",row[7],"|",row[8],"|",row[9],"|",row[10]
except MySQLdb.Error,e:
     print "Mysql Error %d: %s" % (e.args[0], e.args[1])



Yearning install：
-- 安装相应python依赖库
# cat /usr/local/yearning/src/requirements.txt   
Django==2.0.1
django-cors-headers==2.1.0
djangorestframework==3.7.7
djangorestframework-jwt==1.11.0
PyMySQL==0.8.0
sqlparse==0.2.4
python-docx==0.8.6
ldap3==2.4.1

cd /usr/local/yearning/src/
pip3 install -r requirements.txt


-- 先配置好deploy.conf，否则下面步骤会报错
[mysql]
db = 所创建的库名
address = 数据库地址
port = 数据库端口
password = 数据库密码
username = 数据库用户

[host] -- 与nginx监听地址一致
ipaddress = 服务器ip地址:端口 (涉及跨域十分重要!!设置不正确将无法登陆!!)
            如 本机地址为192.168.1.2 nginx设置端口为80
            则应填写为 192.168.1.2:80 之后通过该地址访问平台。

[Inception]
ip = Inception地址
port = Inception端口
user = Inception用户名
password  = Inception密码
backupdb = 备份数据库地址
backupport = 备份数据库端口
backupuser = 备份数据库用户名
backuppassword = 备份数据库密码

[LDAP] LDAP相关设置
LDAP_SERVER = LDAP服务地址
LDAP_SCBASE = LDAP dc 设置 如 dc=xxx,dc=com
LDAP_DOMAIN = LDAP域名 如 xxx.com
LDAP_TYPE = 1  1 通过域名进行ldap认证  0 通过uid进行ldap认证

[email] 邮箱推送相关设置
username = 邮箱发件账号 如 xxxx@163.com
password = 邮箱发件账号密码
smtp_server = 邮箱stmp地址, 具体地址请咨询对应邮箱提供者


# cat deploy.conf
[mysql]
db = yearning
address = 127.0.0.1
port = 3312
username = 
password = 123


[host]
ipaddress = 127.0.0.1:8081


[Inception]
ip = 127.0.0.1
port = 7788
user = root
password  =
backupdb = 127.0.0.1
backupport = 3311
backupuser = inception
backuppassword = 


[LDAP]
LDAP_SERVER =
LDAP_SCBASE =
LDAP_DOMAIN =
LDAP_TYPE = 1


[email]
username =
password =
smtp_server =
smtp_port = 25


[sql]
limit = 1000


[webhook]
dingding =


-- 初始化数据库
# python3 manage.py makemigrations core
Migrations for 'core':
  core/migrations/0001_initial.py
    - Create model Account
    - Create model applygrained
    - Create model DatabaseList
    - Create model globalpermissions
    - Create model grained
    - Create model SqlDictionary
    - Create model SqlOrder
    - Create model SqlRecord
    - Create model Todolist
    - Create model Usermessage

# python3 manage.py migrate core 
Operations to perform:
  Apply all migrations: core
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0001_initial... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying core.0001_initial... OK
  

-- 添加初始化用户
# echo "from core.models import Account;Account.objects.create_user(username='admin', password='admin123.', group='admin',is_staff=1)" | python3 manage.py shell


-- 初始化权限
# echo "from core.models import grained;grained.objects.get_or_create(username='admin', permissions={'person': [], 'ddl': '1', 'ddlcon': [], 'dml': '1', 'dmlcon': [], 'dic': '1', 'diccon': [], 'dicedit': '0', 'query': '1', 'querycon': [], 'user': '1', 'base': '1', 'dicexport': '0'})" | python3 manage.py shell


-- 初始化后的数据 yearning的数据库
[11 sys@127.0.0.1 127.0.0.1:3312 2018-04-14_16:26:49_6_HKT (yearning)]
SQL> show tables;
+-------------------------------+
| Tables_in_yearning            |
+-------------------------------+
| auth_group                    |
| auth_group_permissions        |
| auth_permission               |
| core_account                  |
| core_account_groups           |
| core_account_user_permissions |
| core_applygrained             |
| core_databaselist             |
| core_globalpermissions        |
| core_grained                  |
| core_sqldictionary            |
| core_sqlorder                 |
| core_sqlrecord                |
| core_todolist                 |
| core_usermessage              |
| django_content_type           |
| django_migrations             |
+-------------------------------+
17 rows in set (0.00 sec)


-- 复制编译好的静态文件到nginx html目录下(如自行更改Nginx静态路径地址则将静态文件复制到对应静态文件目录下)
# cp -a webpage/dist/* /usr/local/nginx/html/

# cat yearning.conf 
server {
        listen 8081;
        server_name $host;
        root   /usr/local/nginx/html/yearning;
        index  index.html index.htm;


        location = /favicon.ico
        {
           access_log off;
           log_not_found off;
        }


        access_log  /usr/local/nginx/logs/yearning.log webaccess;
}


-- 重启nginx
# /etc/init.d/nginx restart
Restarting nginx (via systemctl):                          [  OK  ]


-- 启动django
# python3 manage.py runserver 0.0.0.0:8080
Performing system checks...

System check identified no issues (0 silenced).
April 14, 2018 - 16:15:18
Django version 2.0.1, using settings 'settingConf.settings'
Starting development server at http://0.0.0.0:8080/
Quit the server with CONTROL-C.



如果重复初始化错误，则可以，因为密码要求6位：
django.db.utils.IntegrityError: (1062, "Duplicate entry 'admin' for key 'username'")

# echo "from core.models import Account;Account.objects.create_user(username='admin', password='admin123.', group='admin',is_staff=1)" | python3 manage.py shell


SQL> select * from core_account\G
*************************** 1. row ***************************
          id: 1
    password: pbkdf2_sha256$100000$YRvkHFA2x85N$HYXpjRZnBSb08xQesbDbz5cDqjwf8L+Isw3Zwq0xDGM=
  last_login: NULL
is_superuser: 0
    username: admin
  first_name: 
   last_name: 
       email: 
    is_staff: 1
   is_active: 1
 date_joined: 2018-04-14 08:06:53.117001
       group: admin
  department: 
1 row in set (0.00 sec)

SQL> create table core_account_20180414 like core_account;
Query OK, 0 rows affected (0.02 sec)

SQL> insert into core_account_20180414 select * from core_account    
    -> ;
Query OK, 1 row affected (0.01 sec)
Records: 1  Duplicates: 0  Warnings: 0

SQL> delete from core_account;       
Query OK, 1 row affected (0.01 sec)



-- 登录
浏览器访问：http://127.0.0.1:8081/
admin
admin123

无法登陆，发现后台程序python监听的是8000
Request URL:http://127.0.0.1:8000/api-token-auth/
Request Headers
Provisional headers are shown
Access-Control-Request-Headers:accept, content-type
Access-Control-Request-Method:POST
Origin:http://127.0.0.1:8081
Referer:http://127.0.0.1:8081/
User-Agent:Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36


# python3 manage.py runserver 0.0.0.0:8000
再次访问登录OK

原因可能是前端页面中写死了：
# grep 8000 webpage/src/libs/util.js
util.url = 'http://' + document.domain + ':8000/api/v1'
util.auth = 'http://' + document.domain + ':8000/api-token-auth/'


# vim connections.py
1111     def _request_authentication(self):
1112         # https://dev.mysql.com/doc/internals/en/connection-phase-packets.html#packet-Protocol::HandshakeResponse
1113         #if int(self.server_version.split('.', 1)[0]) >= 5:
1114         #    self.client_flag |= CLIENT.MULTI_RESULTS
1115 
1116         try:
1117             if int(self.server_version.split('.', 1)[0]) >= 5:
1118                 self.client_flag |= CLIENT.MULTI_RESULTS
1119         except:
1120             if self.server_version.split('.', 1)[0] >= 'Inception2':
1121                 self.client_flag |= CLIENT.MULTI_RESULTS

# vim cursors.py
344         #if self._result and (self._result.has_next or not self._result.warning_count):
345         if self._result:
346             return

-- 重启python程序：
# nohup python3 manage.py runserver 0.0.0.0:8000 &


-- 修改管理员帐户的字典属性修改权限报错，解决方法：
2018-04-14 16:55:55,524 [Thread-18:140229177759488]                       [django.request:118] [ERROR]- Internal Server Error: /api/v1/apply_grained/
Traceback (most recent call last):
  File "/usr/local/python3/lib/python3.6/site-packages/django/core/handlers/exception.py", line 35, in inner
    response = get_response(request)
  File "/usr/local/python3/lib/python3.6/site-packages/django/core/handlers/base.py", line 128, in _get_response
    response = self.process_exception_by_middleware(e, request)
  File "/usr/local/python3/lib/python3.6/site-packages/django/core/handlers/base.py", line 126, in _get_response
    response = wrapped_callback(request, *callback_args, **callback_kwargs)
  File "/usr/local/python3/lib/python3.6/site-packages/django/views/decorators/csrf.py", line 54, in wrapped_view
    return view_func(*args, **kwargs)
  File "/usr/local/python3/lib/python3.6/site-packages/django/views/generic/base.py", line 69, in view
    return self.dispatch(request, *args, **kwargs)
  File "/usr/local/python3/lib/python3.6/site-packages/rest_framework/views.py", line 494, in dispatch
    response = self.handle_exception(exc)
  File "/usr/local/python3/lib/python3.6/site-packages/rest_framework/views.py", line 454, in handle_exception
    self.raise_uncaught_exception(exc)
  File "/usr/local/python3/lib/python3.6/site-packages/rest_framework/views.py", line 491, in dispatch
    response = handler(request, *args, **kwargs)
  File "/usr/local/yearning/src/core/api/applygrained.py", line 77, in post
    thread = threading.Thread(target=push_message, args=({'to_user': request.user, 'workid': work_id}, 2, request.user, mail.email, work_id, '已提交'))
AttributeError: 'NoneType' object has no attribute 'email'

[email]
username = aa@qq.com
password =
smtp_server = 
smtp_port = 25

或者在界面给管理员添加邮箱地址


-- 表
SQL> select * from core_account;
+----+--------------------------------------------------------------------------------+------------+--------------+----------+------------+-----------+---------------+----------+-----------+----------------------------+-------+------------+
| id | password                                                                       | last_login | is_superuser | username | first_name | last_name | email         | is_staff | is_active | date_joined                | group | department |
+----+--------------------------------------------------------------------------------+------------+--------------+----------+------------+-----------+---------------+----------+-----------+----------------------------+-------+------------+
|  3 | pbkdf2_sha256$100000$HnYUTJ2UTAs7$/IbY/LO8miC0psybwLNEpag2ovlX0QTBi0RqE8bkYYs= | NULL       |            0 | admin    |            |           | shaw@iv66.net |        1 |         1 | 2018-04-14 08:28:34.635853 | admin | DBA        |
|  4 | pbkdf2_sha256$100000$TJu5BkljmvgA$nOSehqR22ueDHhSJ5AYqeneXcHPMbSSaCnarouWOC7o= | NULL       |            0 | b2       |            |           | b2@iv66.net   |        0 |         1 | 2018-04-14 08:45:11.550806 | guest | TSG        |
|  5 | pbkdf2_sha256$100000$ulQOq2h23YeM$4O7nWAfXV1f3Gi/VPC+SxEn5Avs5trgfMwQv/oRECPA= | NULL       |            0 | shaw     |            |           | shaw@iv66.net |        1 |         1 | 2018-04-14 08:46:00.094448 | admin | TSG_DBA    |
+----+--------------------------------------------------------------------------------+------------+--------------+----------+------------+-----------+---------------+----------+-----------+----------------------------+-------+------------+
3 rows in set (0.00 sec)

SQL> select * from core_grained;
+----+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| id | username | permissions                                                                                                                                                                            |
+----+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|  1 | admin    | {'person': [], 'ddl': '1', 'ddlcon': [], 'dml': '1', 'dmlcon': [], 'dic': '1', 'diccon': [], 'dicedit': '1', 'query': '1', 'querycon': [], 'user': '1', 'base': '1', 'dicexport': '0'} |
|  2 | b2       | {'ddl': '0', 'ddlcon': [], 'dml': '0', 'dmlcon': [], 'dic': '0', 'diccon': [], 'dicedit': '0', 'query': '0', 'querycon': [], 'user': '0', 'base': '0', 'dicexport': '0', 'person': []} |
|  3 | shaw     | {'ddl': '0', 'ddlcon': [], 'dml': '0', 'dmlcon': [], 'dic': '0', 'diccon': [], 'dicedit': '0', 'query': '0', 'querycon': [], 'user': '0', 'base': '0', 'dicexport': '0', 'person': []} |
+----+----------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
3 rows in set (0.00 sec)

SQL> select * from django_content_type;
+----+--------------+-------------------+
| id | app_label    | model             |
+----+--------------+-------------------+
|  2 | auth         | group             |
|  1 | auth         | permission        |
|  3 | contenttypes | contenttype       |
|  4 | core         | account           |
|  5 | core         | applygrained      |
|  6 | core         | databaselist      |
|  7 | core         | globalpermissions |
|  8 | core         | grained           |
|  9 | core         | sqldictionary     |
| 10 | core         | sqlorder          |
| 11 | core         | sqlrecord         |
| 12 | core         | todolist          |
| 13 | core         | usermessage       |
+----+--------------+-------------------+
13 rows in set (0.00 sec)

SQL> select * from django_migrations;
+----+--------------+------------------------------------------+----------------------------+
| id | app          | name                                     | applied                    |
+----+--------------+------------------------------------------+----------------------------+
|  1 | contenttypes | 0001_initial                             | 2018-04-14 08:04:05.466485 |
|  2 | contenttypes | 0002_remove_content_type_name            | 2018-04-14 08:04:05.544337 |
|  3 | auth         | 0001_initial                             | 2018-04-14 08:04:05.739832 |
|  4 | auth         | 0002_alter_permission_name_max_length    | 2018-04-14 08:04:05.780653 |
|  5 | auth         | 0003_alter_user_email_max_length         | 2018-04-14 08:04:05.791103 |
|  6 | auth         | 0004_alter_user_username_opts            | 2018-04-14 08:04:05.800481 |
|  7 | auth         | 0005_alter_user_last_login_null          | 2018-04-14 08:04:05.809330 |
|  8 | auth         | 0006_require_contenttypes_0002           | 2018-04-14 08:04:05.814800 |
|  9 | auth         | 0007_alter_validators_add_error_messages | 2018-04-14 08:04:05.823331 |
| 10 | auth         | 0008_alter_user_username_max_length      | 2018-04-14 08:04:05.832073 |
| 11 | auth         | 0009_alter_user_last_name_max_length     | 2018-04-14 08:04:05.840512 |
| 12 | core         | 0001_initial                             | 2018-04-14 08:04:06.323516 |
+----+--------------+------------------------------------------+----------------------------+
12 rows in set (0.00 sec)


-- 机房信息是在代码中写死的，静态页面
# grep util.computer_room webpage/src/libs/util.js
util.computer_room = ['AWS', 'Aliyun', 'Own', 'Other']

# grep -o AWS dist/static/js/*                              
dist/static/js/app.5fc2ca1c341f9ad5ac3f.js:AWS
dist/static/js/app.5fc2ca1c341f9ad5ac3f.js.map:AWS
dist/static/js/app.5fc2ca1c341f9ad5ac3f.js.map:AWS
dist/static/js/vendor.337cbb60bb212f873493.js.map:AWS

o.computer_room=["eastern","globe","AWS","Aliyun","Own","Other"]

仅需修改.js文件即可：
source code: vim dist/static/js/app.5fc2ca1c341f9ad5ac3f.js
vim /usr/local/nginx/html/yearning/static/js/app.5fc2ca1c341f9ad5ac3f.js



http://127.0.0.1:8081/
