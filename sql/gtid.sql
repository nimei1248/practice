环境:
CentOS 6
MySQL 5.6.20

master的binlog会保留7天, 最早的binlog已经被删除
gtid_mode=ON
enforce_gtid_consistency=ON
gtid_next=AUTOMATIC
binlog_format=MIXED
replicate-do-db=db1
replicate-do-table=db1.t1
replicate-do-table=db1.t2

需求:
修改slave的master_host

步骤:
1> 修改slave的master_host之前, 只是修改域名, 域名解析的IP不变, 权限已开通, 端口畅通
mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: a1.b1.com
                  Master_User: rep1
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000071
          Read_Master_Log_Pos: 24735903
               Relay_Log_File: mysql-relay-bin.000359
                Relay_Log_Pos: 24736073
        Relay_Master_Log_File: mysql-bin.000071
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: db1
          Replicate_Ignore_DB: 
           Replicate_Do_Table: db1.t1,db1.t2
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 24735903
              Relay_Log_Space: 24736364
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1133306
                  Master_UUID: 2f95ae0b-8816-11e4-bf96-c81f66be0cd9
             Master_Info_File: /data/3306/mydata/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 2f95ae0b-8816-11e4-bf96-c81f66be0cd9:933921-7871283
            Executed_Gtid_Set: 2f95ae0b-8816-11e4-bf96-c81f66be0cd9:1-950522:950524-1069874:1069876-7871283,
48cb97b2-a1c7-11e7-b71e-0050563a5be6:1-6,
f9614796-8822-11e4-bfea-c81f66bdf749:1-13
                Auto_Position: 1
1 row in set (0.00 sec)


2> change master_host
stop slave;
change master to master_host='a2.b2.com';
start slave;

mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: 
                  Master_Host: a2.b2.com
                  Master_User: rep1
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000071
          Read_Master_Log_Pos: 24735903
               Relay_Log_File: mysql-relay-bin.000359
                Relay_Log_Pos: 4
        Relay_Master_Log_File: mysql-bin.000071
             Slave_IO_Running: No
            Slave_SQL_Running: Yes
              Replicate_Do_DB: db1
          Replicate_Ignore_DB: 
           Replicate_Do_Table: db1.t1,db1.t2
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 24735903
              Relay_Log_Space: 24736364
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: NULL
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 1236
                Last_IO_Error: Got fatal error 1236 from master when reading data from binary log: 'The slave is connecting using CHANGE MASTER TO MASTER_AUTO_POSITION = 1, but the master has purged binary logs containing GTIDs that the slave requires.'
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1133306
                  Master_UUID: 2f95ae0b-8816-11e4-bf96-c81f66be0cd9
             Master_Info_File: /data/3306/mydata/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 180926 13:04:46
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 2f95ae0b-8816-11e4-bf96-c81f66be0cd9:1-950522:950524-1069874:1069876-7871283,
48cb97b2-a1c7-11e7-b71e-0050563a5be6:1-6,
f9614796-8822-11e4-bfea-c81f66bdf749:1-13
                Auto_Position: 1
1 row in set (0.00 sec)


根据官方手册说明调整如下:
https://dev.mysql.com/doc/refman/5.6/en/change-master-to.html

If you specify the MASTER_HOST or MASTER_PORT option, the slave assumes that the master server is different from before (even if the option value is the same as its current value.) In this case, the old values for the master binary log file name and position are considered no longer applicable, so if you do not specify MASTER_LOG_FILE and MASTER_LOG_POS in the statement, MASTER_LOG_FILE='' and MASTER_LOG_POS=4 are silently appended to it.
如果指定MASTER_HOST或MASTER_PORT选项，则从属服务器假定主服务器与以前不同（即使选项值与其当前值相同。）在这种情况下，主二进制日志文件名的旧值和位置被认为不再适用，因此如果您未在语句中指定MASTER_LOG_FILE和MASTER_LOG_POS，则会以静默方式附加MASTER_LOG_FILE =''和MASTER_LOG_POS = 4

mysql> stop slave;
Query OK, 0 rows affected (0.00 sec)

mysql> change master to master_host='a2.b2.com', master_port=3306,master_user='rep1',master_password='abc666', MASTER_LOG_FILE='mysql-bin.000071', MASTER_LOG_POS=24416283,master_auto_position=0; 
Query OK, 0 rows affected, 2 warnings (0.00 sec)

mysql> start slave;
Query OK, 0 rows affected (0.00 sec)

mysql> show slave status\G -- 此时主从复制是正常的

mysql> stop slave;
Query OK, 0 rows affected (0.00 sec)

mysql> change master to master_auto_position=1;
Query OK, 0 rows affected (0.00 sec)

mysql> start slave;
Query OK, 0 rows affected (0.00 sec)

mysql> show slave status\G
报错依旧:
Slave_IO_Running: No
Slave_SQL_Running: Yes
Last_IO_Errno: 1236
Last_IO_Error: Got fatal error 1236 from master when reading data from binary log: 'The slave is connecting using CHANGE MASTER TO MASTER_AUTO_POSITION = 1, but the master has purged binary logs containing GTIDs that the slave requires.'
