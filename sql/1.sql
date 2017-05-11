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
GFROM
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
mysql > explain json = format
SELECT
    COUNT(1)
GFROM
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
