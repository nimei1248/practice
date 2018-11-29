SELECT 
    u.id,
    u.username,
    u.real_name,
    u.mobile_phone,
    u.last_login_ip AS ip,
    u.device_id
FROM
    t1 u
        LEFT JOIN
    t2 c ON u.id = c.user_id
WHERE
    ((u.real_name = 'xxx')
        OR (u.mobile_phone = 'xxx')
        OR (u.last_login_ip = 'xxx')
        OR (c.card_num = 'xxxxxx'))
        AND (u.id NOT IN (SELECT 
            user_id
        FROM
            t3
        WHERE
            relate_user_id = '1000'))



+----+-------------+------------------------+------------+------+--------------------------------------------+-------+---------+------------+--------+----------+--------------------------+
| id | select_type | table                  | partitions | type | possible_keys                              | key   | key_len | ref        | rows   | filtered | Extra                    |
+----+-------------+------------------------+------------+------+--------------------------------------------+-------+---------+------------+--------+----------+--------------------------+
|  1 | PRIMARY     | u                      | NULL       | ALL  | i_last_login_ip,i_real_name,i_mobile_phone | NULL  | NULL    | NULL       | 546926 |   100.00 | Using where              |
|  1 | PRIMARY     | c                      | NULL       | ref  | i_aaa                                      | i_aaa | 5       | db1.u.id   |      1 |   100.00 | Using where; Using index |
|  2 | SUBQUERY    | t3                     | NULL       | ref  | i_user_id_group_id,i_aaa                   | i_aaa | 5       | const      |      1 |   100.00 | NULL                     |
+----+-------------+------------------------+------------+------+--------------------------------------------+-------+---------+------------+--------+----------+--------------------------+
3 rows in set, 1 warning (0.00 sec)



SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `db1`.`u`.`id` AS `id`,`db1`.`u`.`username` AS `username`,`db1`.`u`.`real_name` AS `real_name`,`db1`.`u`.`mobile_phone` AS `mobile_phone`,`db1`.`u`.`last_login_ip` AS `ip`,`db1`.`u`.`device_id` AS `device_id` from `db1`.`t1` `u` left join `db1`.`t2` `c` on((`db1`.`c`.`user_id` = `db1`.`u`.`id`)) where (((`db1`.`u`.`real_name` = 'xxx') or (`db1`.`u`.`mobile_phone` = 'xxx') or (`db1`.`u`.`last_login_ip` = 'xxx') or (`db1`.`c`.`card_num` = 'xxx')) and (not(<in_optimizer>(`db1`.`u`.`id`,`db1`.`u`.`id` in ( <materialize> (/* select#2 */ select `db1`.`t3`.`user_id` from `db1`.`t3` where (`db1`.`t3`.`relate_user_id` = '1000') ), <primary_index_lookup>(`db1`.`u`.`id` in <temporary table> on <auto_key> where ((`db1`.`u`.`id` = `materialized-subquery`.`user_id`))))))))
1 row in set (0.00 sec)



