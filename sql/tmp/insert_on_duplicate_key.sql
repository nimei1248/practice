insert into ... on duplicate key 引发主从不同步：
If you specify an ON DUPLICATE KEY UPDATE clause and a row to be inserted would cause a duplicate value in a UNIQUE index or PRIMARY KEY, an UPDATE of the old row occurs. For example, if column a is declared as UNIQUE and contains the value 1, the following two statements have similar effect:
如果指定ON DUPLICATE KEY UPDATE子句并且要插入的行将在UNIQUE索引或PRIMARY KEY中导致重复值，则会发生旧行的UPDATE

例如，如果列a声明为UNIQUE唯一键并包含值1(即，uk a=1)，则以下两个语句具有类似的效果：
INSERT INTO t1 (a,b,c) VALUES (1,2,3) ON DUPLICATE KEY UPDATE c=c+1;
UPDATE t1 SET c=c+1 WHERE a=1;

如果是自增列:
InnoDB表的效果并不相同，其中a是自动增量列.使用自动增量列，INSERT语句会增加自动增量值，但UPDATE则不会

如果列b也是唯一的，则INSERT等效于此UPDATE语句：a is pk, b is uk
UPDATE t1 SET c=c+1 WHERE a=1 OR b=2 LIMIT 1;
如果a = 1 OR b = 2匹配多行，则只更新一行
通常，您应该尝试避免在具有多个唯一索引的表上使用ON DUPLICATE KEY UPDATE子句

5.7.24 gtid row

mysql> show create table t1\G
*************************** 1. row ***************************
       Table: t1
Create Table: CREATE TABLE `t1` (
  `a` int(11) NOT NULL AUTO_INCREMENT,
  `c1` varchar(10) DEFAULT NULL,
  `c2` varchar(10) DEFAULT NULL,
  `c3` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`a`),
  UNIQUE KEY `u_c1` (`c1`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

向空表中插入数据 insert into ... on duplicate key uk不冲突的时候，其就是insert，通过解析binlog可以看到：
mysql> select * from t1;
0 row in set (0.00 sec)
mysql> insert into t1(c1,c2,c3) values('a2','b2','c2') ON DUPLICATE KEY UPDATE c3=c3+10;
Query OK, 1 row affected (0.00 sec)

mysql> select * from t1;
+---+------+------+------+
| a | c1   | c2   | c3   |
+---+------+------+------+
| 1 | a2   | b2   | c2   |
+---+------+------+------+
1 row in set (0.00 sec)
binlog:
 26 BEGIN
 27 /*!*/;
 28 # at 301
 29 #181222 18:27:57 server id 941672020  end_log_pos 405 CRC32 0xdd61ed00  Rows_query
 30 # insert into t1(c1,c2,c3) values('a2','b2','c2') ON DUPLICATE KEY UPDATE c3=c3+10
 31 # at 405
 32 #181222 18:27:57 server id 941672020  end_log_pos 469 CRC32 0x7858434e  Table_map: `mysql_platform`.`t1` mapped to number 118
 33 # at 469
 34 #181222 18:27:57 server id 941672020  end_log_pos 518 CRC32 0x8215c1c8  Write_rows: table id 118 flags: STMT_END_F
 35 ### INSERT INTO `mysql_platform`.`t1`
 36 ### SET
 37 ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
 38 ###   @2='a2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 39 ###   @3='b2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 40 ###   @4='c2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 41 # at 518
 42 #181222 18:27:57 server id 941672020  end_log_pos 549 CRC32 0xa64fdf7b  Xid = 580
 43 COMMIT/*!*/;

向表中插入数据 insert into ... on duplicate key uk冲突的时候(插入相同的uk)，此时变成update，通过解析binlog可以看到：

mysql> insert into t1(c1,c2,c3) values('a2','b2','c2') ON DUPLICATE KEY UPDATE c3=c3+10;
Query OK, 2 rows affected (0.00 sec)

mysql> select * from t1;
+---+------+------+------+
| a | c1   | c2   | c3   |
+---+------+------+------+
| 1 | a2   | b2   | 10   |
+---+------+------+------+
1 row in set (0.00 sec)

 51 BEGIN
 52 /*!*/;
 53 # at 696
 54 #181222 18:38:34 server id 941672020  end_log_pos 800 CRC32 0xcc40abef  Rows_query
 55 # insert into t1(c1,c2,c3) values('a2','b2','c2') ON DUPLICATE KEY UPDATE c3=c3+10
 56 # at 800
 57 #181222 18:38:34 server id 941672020  end_log_pos 864 CRC32 0xf6afd7cc  Table_map: `mysql_platform`.`t1` mapped to number 118
 58 # at 864
 59 #181222 18:38:34 server id 941672020  end_log_pos 928 CRC32 0x118c4baf  Update_rows: table id 118 flags: STMT_END_F
 60 ### UPDATE `mysql_platform`.`t1`
 61 ### WHERE
 62 ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
 63 ###   @2='a2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 64 ###   @3='b2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 65 ###   @4='c2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 66 ### SET
 67 ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
 68 ###   @2='a2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 69 ###   @3='b2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 70 ###   @4='10' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 71 # at 928
 72 #181222 18:38:34 server id 941672020  end_log_pos 959 CRC32 0xf91e1600  Xid = 593
 73 COMMIT/*!*/;

证明下面2个SQL是等价的，在已存在的uk上操作时：
INSERT INTO t1 (a,b,c) VALUES (1,2,3) ON DUPLICATE KEY UPDATE c=c+1;
UPDATE t1 SET c=c+1 WHERE a=1;

mysql> select * from t1;
+---+------+------+------+
| a | c1   | c2   | c3   |
+---+------+------+------+
| 1 | a2   | b2   | 10   |
+---+------+------+------+
1 row in set (0.00 sec)

mysql> update t1 set c3=c3+10 where c1='a2';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from t1;
+---+------+------+------+
| a | c1   | c2   | c3   |
+---+------+------+------+
| 1 | a2   | b2   | 20   |
+---+------+------+------+
1 row in set (0.00 sec)
 81 BEGIN
 82 /*!*/;
 83 # at 1106
 84 #181222 18:44:20 server id 941672020  end_log_pos 1166 CRC32 0x6e68e724         Rows_query
 85 # update t1 set c3=c3+10 where c1='a2'
 86 # at 1166
 87 #181222 18:44:20 server id 941672020  end_log_pos 1230 CRC32 0x26be0781         Table_map: `mysql_platform`.`t1` mapped to number 118
 88 # at 1230
 89 #181222 18:44:20 server id 941672020  end_log_pos 1294 CRC32 0x72060f24         Update_rows: table id 118 flags: STMT_END_F
 90 ### UPDATE `mysql_platform`.`t1`
 91 ### WHERE
 92 ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
 93 ###   @2='a2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 94 ###   @3='b2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 95 ###   @4='10' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 96 ### SET
 97 ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
 98 ###   @2='a2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
 99 ###   @3='b2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
100 ###   @4='20' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
101 # at 1294
102 #181222 18:44:20 server id 941672020  end_log_pos 1325 CRC32 0xb1e2e0aa         Xid = 605
103 COMMIT/*!*/;
从上面可以看出binlog格式相同

下面通过将原始数据复原，再次比较：
mysql> select * from t1;
+---+------+------+------+
| a | c1   | c2   | c3   |
+---+------+------+------+
| 1 | a2   | b2   | c2   |
+---+------+------+------+
1 row in set (0.00 sec)

mysql> insert into t1(c1,c2,c3) values('a2','b2','c2') ON DUPLICATE KEY UPDATE c3=c3+10;
Query OK, 2 rows affected (0.00 sec)

mysql> select * from t1;
+---+------+------+------+
| a | c1   | c2   | c3   |
+---+------+------+------+
| 1 | a2   | b2   | 10   |
+---+------+------+------+
1 row in set (0.00 sec)
111 BEGIN
112 /*!*/;
113 # at 1472
114 #181222 18:49:52 server id 941672020  end_log_pos 1576 CRC32 0x088ac8d1         Rows_query
115 # insert into t1(c1,c2,c3) values('a2','b2','c2') ON DUPLICATE KEY UPDATE c3=c3+10
116 # at 1576
117 #181222 18:49:52 server id 941672020  end_log_pos 1640 CRC32 0xb489b901         Table_map: `mysql_platform`.`t1` mapped to number 118
118 # at 1640
119 #181222 18:49:52 server id 941672020  end_log_pos 1704 CRC32 0x53aa2562         Update_rows: table id 118 flags: STMT_END_F
120 ### UPDATE `mysql_platform`.`t1`
121 ### WHERE
122 ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
123 ###   @2='a2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
124 ###   @3='b2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
125 ###   @4='c2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
126 ### SET
127 ###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
128 ###   @2='a2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
129 ###   @3='b2' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
130 ###   @4='10' /* VARSTRING(30) meta=30 nullable=1 is_null=0 */
131 # at 1704
132 #181222 18:49:52 server id 941672020  end_log_pos 1735 CRC32 0x24f2f89f         Xid = 612
133 COMMIT/*!*/;
通过binlog对比发现一模一样


