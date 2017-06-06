select version();
+-----------------+
| version()       |
+-----------------+
| 5.6.27-75.0-log |
+-----------------+
1 row in set (0.01 sec)


select count(*) as t_xxx from t_withdrawal_requests;                                            
+--------+
| t_xxx  |
+--------+
| 390460 |
+--------+
1 row in set (0.17 sec)


select count(*) as t_yyy from t_validation_result_live;
+--------+
| t_yyy  |
+--------+
| 341851 |
+--------+
1 row in set (0.16 sec)


SELECT
    A.flag FLAG,
    COUNT_FLA,
    A.risk_level VALIDATION_TYPE,
    COUNT_VAL,
    COUNT_ALL
FROM
    (SELECT
        T.flag, T.risk_level, COUNT(1) COUNT_ALL
    FROM
        t_yyy vl
    JOIN t_xxx T ON vl.request_id = T.request_id
    WHERE
        1 = 1 AND T.product_id = 'A01'
            AND vl.pre_validate_finish_date >= STR_TO_DATE('2017-05-22 00:00:00', '%Y-%m-%d %H:%i:%s')
            AND vl.pre_validate_finish_date <= STR_TO_DATE('2017-05-22 23:59:59', '%Y-%m-%d %H:%i:%s')
    GROUP BY T.risk_level , T.flag) A,
    (SELECT
        T1.risk_level, COUNT(1) COUNT_VAL
    FROM
        t_yyy vl
    JOIN t_xxx T1 ON vl.request_id = T1.request_id
    WHERE
        1 = 1 AND T1.product_id = 'A01'
            AND vl.pre_validate_finish_date >= STR_TO_DATE('2017-05-22 00:00:00', '%Y-%m-%d %H:%i:%s')
            AND vl.pre_validate_finish_date <= STR_TO_DATE('2017-05-22 23:59:59', '%Y-%m-%d %H:%i:%s')
    GROUP BY T1.risk_level) B,
    (SELECT
        T2.flag, COUNT(1) COUNT_FLA
    FROM
        t_xxx T2
    LEFT JOIN t_yyy vl ON vl.request_id = T2.request_id
    WHERE
        1 = 1 AND T2.product_id = 'A01'
            AND vl.pre_validate_finish_date >= STR_TO_DATE('2017-05-22 00:00:00', '%Y-%m-%d %H:%i:%s')
            AND vl.pre_validate_finish_date <= STR_TO_DATE('2017-05-22 23:59:59', '%Y-%m-%d %H:%i:%s')
    GROUP BY T2.flag) C
WHERE
    A.flag = C.flag
        AND A.risk_level = B.risk_level;


+----+-------------+------------+--------+---------------------------------------------------------------+---------------------+---------+----------------------+--------+----------+---------------------------------------------------------------------+
| id | select_type | table      | type   | possible_keys                                                 | key                 | key_len | ref                  | rows   | filtered | Extra                                                               |
+----+-------------+------------+--------+---------------------------------------------------------------+---------------------+---------+----------------------+--------+----------+---------------------------------------------------------------------+
|  1 | PRIMARY     | <derived2> | ALL    | NULL                                                          | NULL                | NULL    | NULL                 | 196722 |   100.00 | Using where                                                         |
|  1 | PRIMARY     | <derived3> | ref    | <auto_key0>                                                   | <auto_key0>         | 5       | A.risk_level         |     10 |   100.00 | NULL                                                                |
|  1 | PRIMARY     | <derived4> | ref    | <auto_key0>                                                   | <auto_key0>         | 4       | A.flag               |     10 |   100.00 | NULL                                                                |
|  4 | DERIVED     | T2         | ref    | PRIMARY,i_id_flag_name_date,i_productid_loginname_crdate,idx1 | idx1                | 11      | const                | 196722 |   100.00 | Using where; Using index; Using temporary; Using filesort           |
|  4 | DERIVED     | vl         | eq_ref | index_request_id,i_reqid_finidate                             | index_request_id    | 152     | pncrms.T2.request_id |      1 |   100.00 | Using index condition; Using where                                  |
|  3 | DERIVED     | T1         | ref    | PRIMARY,i_id_flag_name_date,i_productid_loginname_crdate,idx1 | i_id_flag_name_date | 11      | const                | 196722 |   100.00 | Using index condition; Using where; Using temporary; Using filesort |
|  3 | DERIVED     | vl         | eq_ref | index_request_id,i_reqid_finidate                             | index_request_id    | 152     | pncrms.T1.request_id |      1 |   100.00 | Using index condition; Using where                                  |
|  2 | DERIVED     | T          | ref    | PRIMARY,i_id_flag_name_date,i_productid_loginname_crdate,idx1 | i_id_flag_name_date | 11      | const                | 196722 |   100.00 | Using index condition; Using where; Using temporary; Using filesort |
|  2 | DERIVED     | vl         | eq_ref | index_request_id,i_reqid_finidate                             | index_request_id    | 152     | pncrms.T.request_id  |      1 |   100.00 | Using index condition; Using where                                  |
+----+-------------+------------+--------+---------------------------------------------------------------+---------------------+---------+----------------------+--------+----------+---------------------------------------------------------------------+
9 rows in set, 1 warning (0.02 sec)



+------+-----------+-----------------+-----------+-----------+
| FLAG | COUNT_FLA | VALIDATION_TYPE | COUNT_VAL | COUNT_ALL |
+------+-----------+-----------------+-----------+-----------+
|    3 |      1310 |               2 |      1155 |       640 |
|    6 |      1018 |               2 |      1155 |       489 |
|    7 |        67 |               2 |      1155 |        26 |
|    3 |      1310 |               3 |      1210 |       670 |
|    6 |      1018 |               3 |      1210 |       504 |
|    7 |        67 |               3 |      1210 |        36 |
|    6 |      1018 |               4 |        30 |        25 |
|    7 |        67 |               4 |        30 |         5 |
+------+-----------+-----------------+-----------+-----------+
8 rows in set (5.14 sec)
