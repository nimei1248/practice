SELECT 
    customer_product_id AS PRODUCT_ID,
    customer_login_name AS LOGINNAME,
    SUM(DEPOSIT_COUNT) AS DEPOSIT_COUNT,
    SUM(TOTAL_DEPOSIT) AS TOTAL_DEPOSIT,
    SUM(MC_DEPOSIT) AS MC_DEPOSIT,
    SUM(WITHDRAW_COUNT) AS WITHDRAW_COUNT,
    SUM(TOTAL_WITHDRAW) AS TOTAL_WITHDRAW,
    SUM(MC_WITHDRAW) AS MC_WITHDRAW,
    SUM(TOTAL_REBATE) AS TOTAL_REBATE,
    SUM(TOTAL_PROMO) AS TOTAL_PROMO,
    SUM(MODIFY_CREDIT_ADD) AS MODIFY_CREDIT_ADD,
    SUM(MODIFY_CREDIT_SUB) AS MODIFY_CREDIT_SUB,
    SUM(TOTAL_BONUS) AS TOTAL_BONUS,
    SUM(TIMES_BET) AS TIMES_BET,
    SUM(TOTAL_BET_AMOUNT) AS TOTAL_BET_AMOUNT,
    SUM(TOTAL_VALID_AMOUNT) AS TOTAL_VALID_AMOUNT,
    SUM(TOTAL_REMAIN_AMOUNT) AS TOTAL_REMAIN_AMOUNT,
    SUM(TOTAL_WINLOSE_AMOUNT) AS TOTAL_WINLOSE_AMOUNT
FROM
    ((SELECT 
        customer_product_id,
            customer_login_name,
            SUM(deposit_count) AS DEPOSIT_COUNT,
            SUM(deposit_amount) AS TOTAL_DEPOSIT,
            SUM(mc_deposit_amount) AS MC_DEPOSIT,
            SUM(withdraw_count) AS WITHDRAW_COUNT,
            SUM(withdraw_amount) AS TOTAL_WITHDRAW,
            SUM(mc_withdraw_amount) AS MC_WITHDRAW,
            SUM(xm_amount) AS TOTAL_REBATE,
            SUM(promotion_amount) AS TOTAL_PROMO,
            SUM(mc_add_amount) AS MODIFY_CREDIT_ADD,
            SUM(mc_sub_amount) AS MODIFY_CREDIT_SUB,
            0 AS TOTAL_BONUS,
            0 AS TIMES_BET,
            0 AS TOTAL_BET_AMOUNT,
            0 AS TOTAL_VALID_AMOUNT,
            0 AS TOTAL_REMAIN_AMOUNT,
            0 AS TOTAL_WINLOSE_AMOUNT
    FROM
        t1
    WHERE
        1 = 1 AND sum_date >= '2018-07-01'
            AND sum_date <= '2018-07-31'
            AND customer_product_id = 'A01'
    GROUP BY customer_product_id , customer_login_name
    ORDER BY NULL) UNION ALL (SELECT 
        customer_product_id,
            customer_login_name,
            0 AS DEPOSIT_COUNT,
            0 AS TOTAL_DEPOSIT,
            0 AS MC_DEPOSIT,
            0 AS WITHDRAW_COUNT,
            0 AS TOTAL_WITHDRAW,
            0 AS MC_WITHDRAW,
            0 AS TOTAL_REBATE,
            0 AS TOTAL_PROMO,
            0 AS MODIFY_CREDIT_ADD,
            0 AS MODIFY_CREDIT_SUB,
            SUM(total_bonus_amount) AS TOTAL_BONUS,
            SUM(total_bet_times) AS TIMES_BET,
            SUM(total_bet_amount) AS TOTAL_BET_AMOUNT,
            SUM(total_valid_amount) AS TOTAL_VALID_AMOUNT,
            SUM(total_remain_amount) AS TOTAL_REMAIN_AMOUNT,
            SUM(total_win_lost_amount) AS TOTAL_WINLOSE_AMOUNT
    FROM
        t2
    WHERE
        1 = 1 AND stat_date >= '2018-07-01'
            AND stat_date <= '2018-07-31'
            AND customer_product_id = 'A01'
    GROUP BY customer_product_id , customer_login_name
    ORDER BY NULL)) c
GROUP BY customer_product_id , customer_login_name
ORDER BY customer_login_name
LIMIT 50


t1:
KEY `i_cpi_sumdate` (`customer_product_id`,`sum_date`),
KEY `i_a` (`customer_product_id`,`customer_login_name`,`sum_date`)
`customer_product_id`,`customer_login_name`,`sum_date`(varchar,varchar,date)


t2:
KEY `i_cpi_statdate` (`customer_product_id`,`stat_date`),
KEY `i_a` (`customer_product_id`,`customer_login_name`,`stat_date`)
`customer_product_id`,`customer_login_name`,`stat_date`(varchar,varchar,date)


+----+-------------+-----------------------+------------+-------+--------------------------------------------+----------------+---------+------+--------+----------+--------------------------------------------------------+
| id | select_type | table                 | partitions | type  | possible_keys                              | key            | key_len | ref  | rows   | filtered | Extra                                                  |
+----+-------------+-----------------------+------------+-------+--------------------------------------------+----------------+---------+------+--------+----------+--------------------------------------------------------+
|  1 | PRIMARY     | <derived2>            | NULL       | ALL   | NULL                                       | NULL           | NULL    | NULL |  73928 |   100.00 | Using temporary; Using filesort                        |
|  2 | DERIVED     | t1                    | NULL       | range | PRIMARY,last_update,i_cpi_sumdate,i_a  | i_cpi_sumdate  | 35      | NULL | 309494 |   100.00 | Using index condition; Using temporary; Using filesort |
|  3 | UNION       | t2                    | NULL       | range | PRIMARY,last_update,i_cpi_statdate,i_a | i_cpi_statdate | 35      | NULL | 355996 |   100.00 | Using index condition; Using temporary; Using filesort |
+----+-------------+-----------------------+------------+-------+--------------------------------------------+----------------+---------+------+--------+----------+--------------------------------------------------------+
3 rows in set, 1 warning (0.00 sec)


SQL> select count(*) from t1;
+----------+
| count(*) |
+----------+
| 32946150 |
+----------+
1 row in set (11.76 sec)

SQL> select count(*) from t2;
+----------+
| count(*) |
+----------+
|  8286281 |
+----------+
1 row in set (6.22 sec)


SQL> select @@tmp_table_size;
+------------------+
| @@tmp_table_size |
+------------------+
|        138412032 |
+------------------+
1 row in set (0.00 sec)

SQL> select @@max_heap_table_size;
+-----------------------+
| @@max_heap_table_size |
+-----------------------+
|             138412032 |
+-----------------------+
1 row in set (0.00 sec)


+----+-------------+-----------------------+------------+------+--------------------------------------------+---------+---------+-------+----------+----------+---------------------------------+
| id | select_type | table                 | partitions | type | possible_keys                              | key     | key_len | ref   | rows     | filtered | Extra                           |
+----+-------------+-----------------------+------------+------+--------------------------------------------+---------+---------+-------+----------+----------+---------------------------------+
|  1 | PRIMARY     | <derived2>            | NULL       | ALL  | NULL                                       | NULL    | NULL    | NULL  |  1442072 |   100.00 | Using temporary; Using filesort |
|  2 | DERIVED     | t_customer_summary    | NULL       | ref  | PRIMARY,last_update,i_cpi_sumdate,i_a      | i_a | 32      | const | 10235612 |    11.11 | Using index condition           |
|  3 | UNION       | t_game_orders_summary | NULL       | ref  | PRIMARY,last_update,i_cpi_statdate,i_a     | i_a | 32      | const |  2745644 |    11.11 | Using index condition           |
+----+-------------+-----------------------+------------+------+--------------------------------------------+---------+---------+-------+----------+----------+---------------------------------+
3 rows in set, 1 warning (0.01 sec)



SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `c`.`customer_product_id` AS `PRODUCT_ID`,`c`.`customer_login_name` AS `LOGINNAME`,sum(`c`.`DEPOSIT_COUNT`) AS `DEPOSIT_COUNT`,sum(`c`.`TOTAL_DEPOSIT`) AS `TOTAL_DEPOSIT`,sum(`c`.`MC_DEPOSIT`) AS `MC_DEPOSIT`,sum(`c`.`WITHDRAW_COUNT`) AS `WITHDRAW_COUNT`,sum(`c`.`TOTAL_WITHDRAW`) AS `TOTAL_WITHDRAW`,sum(`c`.`MC_WITHDRAW`) AS `MC_WITHDRAW`,sum(`c`.`TOTAL_REBATE`) AS `TOTAL_REBATE`,sum(`c`.`TOTAL_PROMO`) AS `TOTAL_PROMO`,sum(`c`.`MODIFY_CREDIT_ADD`) AS `MODIFY_CREDIT_ADD`,sum(`c`.`MODIFY_CREDIT_SUB`) AS `MODIFY_CREDIT_SUB`,sum(`c`.`TOTAL_BONUS`) AS `TOTAL_BONUS`,sum(`c`.`TIMES_BET`) AS `TIMES_BET`,sum(`c`.`TOTAL_BET_AMOUNT`) AS `TOTAL_BET_AMOUNT`,sum(`c`.`TOTAL_VALID_AMOUNT`) AS `TOTAL_VALID_AMOUNT`,sum(`c`.`TOTAL_REMAIN_AMOUNT`) AS `TOTAL_REMAIN_AMOUNT`,sum(`c`.`TOTAL_WINLOSE_AMOUNT`) AS `TOTAL_WINLOSE_AMOUNT` from ((/* select#2 */ select `db1`.`t1`.`customer_product_id` AS `customer_product_id`,`db1`.`t1`.`customer_login_name` AS `customer_login_name`,sum(`db1`.`t1`.`deposit_count`) AS `DEPOSIT_COUNT`,sum(`db1`.`t1`.`deposit_amount`) AS `TOTAL_DEPOSIT`,sum(`db1`.`t1`.`mc_deposit_amount`) AS `MC_DEPOSIT`,sum(`db1`.`t1`.`withdraw_count`) AS `WITHDRAW_COUNT`,sum(`db1`.`t1`.`withdraw_amount`) AS `TOTAL_WITHDRAW`,sum(`db1`.`t1`.`mc_withdraw_amount`) AS `MC_WITHDRAW`,sum(`db1`.`t1`.`xm_amount`) AS `TOTAL_REBATE`,sum(`db1`.`t1`.`promotion_amount`) AS `TOTAL_PROMO`,sum(`db1`.`t1`.`mc_add_amount`) AS `MODIFY_CREDIT_ADD`,sum(`db1`.`t1`.`mc_sub_amount`) AS `MODIFY_CREDIT_SUB`,0 AS `TOTAL_BONUS`,0 AS `TIMES_BET`,0 AS `TOTAL_BET_AMOUNT`,0 AS `TOTAL_VALID_AMOUNT`,0 AS `TOTAL_REMAIN_AMOUNT`,0 AS `TOTAL_WINLOSE_AMOUNT` from `db1`.`t1` where ((`db1`.`t1`.`sum_date` >= '2018-07-01') and (`db1`.`t1`.`sum_date` <= '2018-07-31') and (`db1`.`t1`.`customer_product_id` = 'A01')) group by `db1`.`t1`.`customer_product_id`,`db1`.`t1`.`customer_login_name`) union all (/* select#3 */ select `db1`.`t2`.`customer_product_id` AS `customer_product_id`,`db1`.`t2`.`customer_login_name` AS `customer_login_name`,0 AS `DEPOSIT_COUNT`,0 AS `TOTAL_DEPOSIT`,0 AS `MC_DEPOSIT`,0 AS `WITHDRAW_COUNT`,0 AS `TOTAL_WITHDRAW`,0 AS `MC_WITHDRAW`,0 AS `TOTAL_REBATE`,0 AS `TOTAL_PROMO`,0 AS `MODIFY_CREDIT_ADD`,0 AS `MODIFY_CREDIT_SUB`,sum(`db1`.`t2`.`total_bonus_amount`) AS `TOTAL_BONUS`,sum(`db1`.`t2`.`total_bet_times`) AS `TIMES_BET`,sum(`db1`.`t2`.`total_bet_amount`) AS `TOTAL_BET_AMOUNT`,sum(`db1`.`t2`.`total_valid_amount`) AS `TOTAL_VALID_AMOUNT`,sum(`db1`.`t2`.`total_remain_amount`) AS `TOTAL_REMAIN_AMOUNT`,sum(`db1`.`t2`.`total_win_lost_amount`) AS `TOTAL_WINLOSE_AMOUNT` from `db1`.`t2` where ((`db1`.`t2`.`stat_date` >= '2018-07-01') and (`db1`.`t2`.`stat_date` <= '2018-07-31') and (`db1`.`t2`.`customer_product_id` = 'A01')) group by `db1`.`t2`.`customer_product_id`,`db1`.`t2`.`customer_login_name`)) `c` group by `c`.`customer_product_id`,`c`.`customer_login_name` order by `c`.`customer_login_name` limit 50
1 row in set (0.00 sec)
