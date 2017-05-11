-- 相同SQL，不同索引，查询效率对比


-- mysql version
mysql >select version();
+-----------------+
| version()       |
+-----------------+
| 5.6.27-75.0-log |
+-----------------+
1 row in set (0.00 sec)


-- 表中的行数
mysql >select count(*) from t_game;
+----------+
| count(*) |
+----------+
|   244469 |
+----------+
1 row in set (0.12 sec)


-- 表中除主键外，还有2条新建的索引
mysql >show index from t_game;
+-----------------------+------------+------------------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table                 | Non_unique | Key_name                     | Seq_in_index | Column_name  | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+-----------------------+------------+------------------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| t_game |          0 | PRIMARY                      |            1 | request_id   | A         |      272293 |     NULL | NULL   |      | BTREE      |         |               |
| t_game |          1 | i_id_flag_name_date          |            1 | product_id   | A         |           6 |     NULL | NULL   |      | BTREE      |         |               |
| t_game |          1 | i_id_flag_name_date          |            2 | flag         | A         |          40 |     NULL | NULL   |      | BTREE      |         |               |
| t_game |          1 | i_id_flag_name_date          |            3 | login_name   | A         |       68073 |     NULL | NULL   |      | BTREE      |         |               |
| t_game |          1 | i_id_flag_name_date          |            4 | created_date | A         |      272293 |     NULL | NULL   | YES  | BTREE      |         |               |
| t_game |          1 | i_productid_loginname_crdate |            1 | product_id   | A         |           6 |     NULL | NULL   |      | BTREE      |         |               |
| t_game |          1 | i_productid_loginname_crdate |            2 | login_name   | A         |       54458 |     NULL | NULL   |      | BTREE      |         |               |
| t_game |          1 | i_productid_loginname_crdate |            3 | created_date | A         |      272293 |     NULL | NULL   | YES  | BTREE      |         |               |
+-----------------------+------------+------------------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
8 rows in set (0.00 sec)


-- 索引i_productid_loginname_crdate
mysql > explain extended
SELECT
    COUNT(1)
FROM
    t_game t USE INDEX (I_PRODUCTID_LOGINNAME_CRDATE)
WHERE
    1 = 1 AND t.flag IN (0 , 4, 5)
        AND t.product_id = 'AX18'
        AND t.risk_validate_require = 1
        AND t.risk_validate_status IN (4 , 1, 0);

+----+-------------+-------+------+------------------------------+------------------------------+---------+-------+--------+----------+------------------------------------+
| id | select_type | table | type | possible_keys                | key                          | key_len | ref   | rows   | filtered | Extra                              |
+----+-------------+-------+------+------------------------------+------------------------------+---------+-------+--------+----------+------------------------------------+
|  1 | SIMPLE      | t     | ref  | i_productid_loginname_crdate | i_productid_loginname_crdate | 11      | const | 136159 |   100.00 | Using index condition; Using where |
+----+-------------+-------+------+------------------------------+------------------------------+---------+-------+--------+----------+------------------------------------+
1 row in set, 1 warning (0.00 sec)

*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: t
         type: ref
possible_keys: i_productid_loginname_crdate
          key: i_productid_loginname_crdate
      key_len: 11
          ref: const
         rows: 136166
     filtered: 100.00
        Extra: Using index condition; Using where
1 row in set, 1 warning (0.00 sec)


-- 索引i_id_flag_name_date
mysql > explain extended
SELECT
    COUNT(1)
FROM
    t_game t USE INDEX (I_ID_FLAG_NAME_DATE)
WHERE
    1 = 1 AND t.flag IN (0 , 4, 5)
        AND t.product_id = 'AX18'
        AND t.risk_validate_require = 1
        AND t.risk_validate_status IN (4 , 1, 0);

+----+-------------+-------+-------+---------------------+---------------------+---------+------+------+----------+------------------------------------+
| id | select_type | table | type  | possible_keys       | key                 | key_len | ref  | rows | filtered | Extra                              |
+----+-------------+-------+-------+---------------------+---------------------+---------+------+------+----------+------------------------------------+
|  1 | SIMPLE      | t     | range | i_id_flag_name_date | i_id_flag_name_date | 15      | NULL |    5 |    80.00 | Using index condition; Using where |
+----+-------------+-------+-------+---------------------+---------------------+---------+------+------+----------+------------------------------------+
1 row in set, 1 warning (0.00 sec)

*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: t
         type: range
possible_keys: i_id_flag_name_date
          key: i_id_flag_name_date
      key_len: 15
          ref: NULL
         rows: 5
     filtered: 80.00
        Extra: Using index condition; Using where
1 row in set, 1 warning (0.00 sec)



相同的SQL，2个不同的索引，产生差别也很大，不知道哪个更优？
I_PRODUCTID_LOGINNAME_CRDATE:  rows 136159   filtered 100.00  type ref
I_ID_FLAG_NAME_DATE:           rows 5        filtered 80.00   type range



-- 查看表实际走的索引
mysql > explain format = json
SELECT
    COUNT(1)
FROM
    t_game t USE INDEX (I_PRODUCTID_LOGINNAME_CRDATE)
WHERE
    1 = 1 AND t.flag IN (0 , 4, 5)
        AND t.product_id = 'AX18'
        AND t.risk_validate_require = 1
        AND t.risk_validate_status IN (4 , 1, 0);

*************************** 1. row ***************************
EXPLAIN: {
  "query_block": {
    "select_id": 1,
    "table": {
      "table_name": "t",
      "access_type": "ref",
      "possible_keys": [
        "i_productid_loginname_crdate"
      ],
      "key": "i_productid_loginname_crdate",
      "used_key_parts": [
        "product_id"
      ],
      "key_length": "11",
      "ref": [
        "const"
      ],
      "rows": 136187,
      "filtered": 100,
      "index_condition": "(`db1`.`t`.`product_id` = 'AX18')",
      "attached_condition": "((`db1`.`t`.`risk_validate_require` = 1) and (`db1`.`t`.`flag` in (0,4,5)) and (`db1`.`t`.`risk_validate_status` in (4,1,0)))"
    }
  }
}
1 row in set, 1 warning (0.00 sec)



mysql > explain format = json
SELECT
    COUNT(1)
FROM
    t_game t USE INDEX (I_ID_FLAG_NAME_DATE)
WHERE
    1 = 1 AND t.flag IN (0 , 4, 5)
        AND t.product_id = 'AX18'
        AND t.risk_validate_require = 1
        AND t.risk_validate_status IN (4 , 1, 0);

*************************** 1. row ***************************
EXPLAIN: {
  "query_block": {
    "select_id": 1,
    "table": {
      "table_name": "t",
      "access_type": "range",
      "possible_keys": [
        "i_id_flag_name_date"
      ],
      "key": "i_id_flag_name_date",
      "used_key_parts": [
        "product_id",
        "flag"
      ],
      "key_length": "15",
      "rows": 5,
      "filtered": 80,
      "index_condition": "((`db1`.`t`.`flag` in (0,4,5)) and (`db1`.`t`.`product_id` = 'AX18'))",
      "attached_condition": "((`db1`.`t`.`risk_validate_require` = 1) and (`db1`.`t`.`risk_validate_status` in (4,1,0)))"
    }
  }
}
1 row in set, 1 warning (0.00 sec)


对比发现，一个索引使用了2个字段，一个索引使用了1个字段



-- 执行2条sql
mysql >
SELECT
    COUNT(1)
FROM
    t_game t USE INDEX (I_ID_FLAG_NAME_DATE)
WHERE
    1 = 1 AND t.flag IN (0 , 4, 5)
        AND t.product_id = 'AX18'
        AND t.risk_validate_require = 1
        AND t.risk_validate_status IN (4 , 1, 0);

*************************** 1. row ***************************
COUNT(1): 7
1 row in set (0.00 sec)



mysql >
SELECT
    COUNT(1)
FROM
    t_game t USE INDEX (I_PRODUCTID_LOGINNAME_CRDATE)
WHERE
    1 = 1 AND t.flag IN (0 , 4, 5)
        AND t.product_id = 'AX18'
        AND t.risk_validate_require = 1
        AND t.risk_validate_status IN (4 , 1, 0);

*************************** 1. row ***************************
COUNT(1): 4
1 row in set (0.77 sec)




-- 5.7 测试  索引都是一样
[26 root@localhost 17:47:43 (optsql)]
db> select version();
+---------------+
| version()     |
+---------------+
| 5.7.17-13-log |
+---------------+
1 row in set (0.00 sec)


[28 root@localhost 17:48:43 (optsql)]
db> select count(1) from t_game;
+----------+
| count(1) |
+----------+
|   246078 |
+----------+
1 row in set (0.06 sec)

[29 root@localhost 17:49:59 (optsql)]
db> show index from t_game;
+--------+------------+------------------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+-----------
| Table  | Non_unique | Key_name                     | Seq_in_index | Column_name  | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comm
+--------+------------+------------------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+-----------
| t_game |          0 | PRIMARY                      |            1 | request_id   | A         |      241092 |     NULL | NULL   |      | BTREE      |         |           
| t_game |          1 | i_id_flag_name_date          |            1 | product_id   | A         |           3 |     NULL | NULL   |      | BTREE      |         |           
| t_game |          1 | i_id_flag_name_date          |            2 | flag         | A         |          20 |     NULL | NULL   |      | BTREE      |         |           
| t_game |          1 | i_id_flag_name_date          |            3 | login_name   | A         |       37453 |     NULL | NULL   |      | BTREE      |         |           
| t_game |          1 | i_id_flag_name_date          |            4 | created_date | A         |      241092 |     NULL | NULL   | YES  | BTREE      |         |           
| t_game |          1 | i_productid_loginname_crdate |            1 | product_id   | A         |           3 |     NULL | NULL   |      | BTREE      |         |           
| t_game |          1 | i_productid_loginname_crdate |            2 | login_name   | A         |       16786 |     NULL | NULL   |      | BTREE      |         |           
| t_game |          1 | i_productid_loginname_crdate |            3 | created_date | A         |      241092 |     NULL | NULL   | YES  | BTREE      |         |           
+--------+------------+------------------------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+-----------
8 rows in set (0.00 sec)


[30 root@localhost 17:50:22 (optsql)]
db> explain               
    -> SELECT                         
    ->     COUNT(1)                   
    -> FROM                          
    ->     t_game t USE INDEX (i_productid_loginname_crdate)
    -> WHERE                          
    ->     1 = 1 AND t.flag IN (0 , 4, 5)     
    ->       AND t.product_id = 'AX18'                     
    ->      AND t.risk_validate_require = 1
    ->      AND t.risk_validate_status IN (4 , 1, 0);
+----+-------------+-------+------------+------+------------------------------+------------------------------+---------+-------+--------+----------+-------------+
| id | select_type | table | partitions | type | possible_keys                | key                          | key_len | ref   | rows   | filtered | Extra       |
+----+-------------+-------+------------+------+------------------------------+------------------------------+---------+-------+--------+----------+-------------+
|  1 | SIMPLE      | t     | NULL       | ref  | i_productid_loginname_crdate | i_productid_loginname_crdate | 11      | const | 120546 |     0.90 | Using where |
+----+-------------+-------+------------+------+------------------------------+------------------------------+---------+-------+--------+----------+-------------+
1 row in set, 1 warning (0.00 sec)


[31 root@localhost 17:51:43 (optsql)]
db> explain               
    -> SELECT                         
    ->     COUNT(1)                   
    -> FROM                          
    ->     t_game t USE INDEX (I_ID_FLAG_NAME_DATE)
    -> WHERE                          
    ->     1 = 1 AND t.flag IN (0 , 4, 5)     
    ->       AND t.product_id = 'AX18'                     
    ->      AND t.risk_validate_require = 1
    ->      AND t.risk_validate_status IN (4 , 1, 0);
+----+-------------+-------+------------+-------+---------------------+---------------------+---------+------+------+----------+------------------------------------+
| id | select_type | table | partitions | type  | possible_keys       | key                 | key_len | ref  | rows | filtered | Extra                              |
+----+-------------+-------+------------+-------+---------------------+---------------------+---------+------+------+----------+------------------------------------+
|  1 | SIMPLE      | t     | NULL       | range | i_id_flag_name_date | i_id_flag_name_date | 15      | NULL |    7 |     3.00 | Using index condition; Using where |
+----+-------------+-------+------------+-------+---------------------+---------------------+---------+------+------+----------+------------------------------------+
1 row in set, 1 warning (0.00 sec)



-- 执行VS
[38 root@localhost 17:59:28 (optsql)]
db> SELECT                         
    ->     COUNT(1)                   
    -> FROM                          
    ->     t_game t USE INDEX (i_id_flag_name_date)
    -> WHERE                          
    ->     1 = 1 AND t.flag IN (0 , 4, 5)     
    ->       AND t.product_id = 'AX18'                     
    ->      AND t.risk_validate_require = 1
    ->      AND t.risk_validate_status IN (4 , 1, 0);
+----------+
| COUNT(1) |
+----------+
|        3 |
+----------+
1 row in set (0.00 sec)


[39 root@localhost 17:59:39 (optsql)]
db> SELECT                         
    ->     COUNT(1)                   
    -> FROM                          
    ->     t_game t USE INDEX (i_productid_loginname_crdate)
    -> WHERE                          
    ->     1 = 1 AND t.flag IN (0 , 4, 5)     
    ->       AND t.product_id = 'AX18'                     
    ->      AND t.risk_validate_require = 1
    ->      AND t.risk_validate_status IN (4 , 1, 0);
+----------+
| COUNT(1) |
+----------+
|        3 |
+----------+
1 row in set (0.26 sec)
