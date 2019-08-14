1>
select login_name,head_img_url
		from t1
		where id in (216370,219758)

SQL> desc select login_name,head_img_url from t1 where id in ( 216370,219758 );
+----+-------------+-------------------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
| id | select_type | table             | partitions | type  | possible_keys | key     | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-------------------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | t1 | NULL       | range | PRIMARY       | PRIMARY | 8       | NULL |    2 |   100.00 | Using where |
+----+-------------+-------------------+------------+-------+---------------+---------+---------+------+------+----------+-------------+
1 row in set, 1 warning (0.00 sec)



2>
select login_name,head_img_url
		from t1
		where id in (
		select max(id)
		from t1
        where customer_id in ('zd00051i9','zd0005dpp')
		group by customer_id order by null) -- 216370,219758

SQL> desc select login_name,head_img_url
    -> from t1
    -> where id in (
    -> select max(id)
    -> from t1
    ->         where customer_id in ('zd00051i9','zd0005dpp')
    -> group by customer_id order by null
    -> );
+----+-------------+-------------------+------------+-------+---------------+-------+---------+------+--------+----------+--------------------------+
| id | select_type | table             | partitions | type  | possible_keys | key   | key_len | ref  | rows   | filtered | Extra                    |
+----+-------------+-------------------+------------+-------+---------------+-------+---------+------+--------+----------+--------------------------+
|  1 | PRIMARY     | t1 | NULL       | ALL   | NULL          | NULL  | NULL    | NULL | 530995 |   100.00 | Using where              |
|  2 | SUBQUERY    | t1 | NULL       | range | i_bbb,i_aaa   | i_aaa | 152     | NULL |      2 |   100.00 | Using where; Using index |
+----+-------------+-------------------+------------+-------+---------------+-------+---------+------+--------+----------+--------------------------+
2 rows in set, 1 warning (0.00 sec)


SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `db1`.`t1`.`login_name` AS `login_name`,`db1`.`t1`.`head_img_url` AS `head_img_url` from `db1`.`t1` where <in_optimizer>(`db1`.`t1`.`id`,`db1`.`t1`.`id` in ( <materialize> (/* select#2 */ select max(`db1`.`t1`.`id`) from `db1`.`t1` where (`db1`.`t1`.`customer_id` in ('zd00051i9','zd0005dpp')) group by `db1`.`t1`.`customer_id` having 1 ), <primary_index_lookup>(`db1`.`t1`.`id` in <temporary table> on <auto_key> where ((`db1`.`t1`.`id` = `materialized-subquery`.`max(id)`)))))
1 row in set (0.00 sec)


SQL> select @@optimizer_switch\G
*************************** 1. row ***************************
@@optimizer_switch: index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on,index_condition_pushdown=on,mrr=on,mrr_cost_based=on,block_nested_loop=on,batched_key_access=off,materialization=on,semijoin=on,loosescan=on,firstmatch=on,duplicateweedout=on,subquery_materialization_cost_based=on,use_index_extensions=on,condition_fanout_filter=on,derived_merge=on
1 row in set (0.00 sec)

set session optimizer_switch='materialization=off';
set session optimizer_switch='subquery_materialization_cost_based=on';

SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `db1`.`t1`.`login_name` AS `login_name`,`db1`.`t1`.`head_img_url` AS `head_img_url` from `db1`.`t1` where <in_optimizer>(`db1`.`t1`.`id`,<exists>(/* select#2 */ select 1 from `db1`.`t1` where (`db1`.`t1`.`customer_id` in ('zd00051i9','zd0005dpp')) group by `db1`.`t1`.`customer_id` having (<cache>(`db1`.`t1`.`id`) = <ref_null_helper>(max(`db1`.`t1`.`id`)))))
1 row in set (0.00 sec)


SQL> select login_name,head_img_url from t1 where id in ( select max(id) from t1 where customer_id in ('zd00051i9','zd0005dpp') group by customer_id order by null );    
+-----------------+--------------+
| login_name      | head_img_url |
+-----------------+--------------+
| aaa    |              |
| xxx       |              |
+-----------------+--------------+
2 rows in set (2.67 sec)

SQL> set session optimizer_switch='materialization=on';
Query OK, 0 rows affected (0.00 sec)

SQL> select login_name,head_img_url from t1 where id in ( select max(id) from t1 where customer_id in ('zd00051i9','zd0005dpp') group by customer_id order by null );
+-----------------+--------------+
| login_name      | head_img_url |
+-----------------+--------------+
| aaa    |              |
| xxx       |              |
+-----------------+--------------+
2 rows in set (0.31 sec)
