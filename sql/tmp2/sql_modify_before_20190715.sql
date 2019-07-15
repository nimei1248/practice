UPDATE same_a_table AS t1 
SET 
    first_count = (SELECT 
            first_count
        FROM
            (SELECT 
                COUNT(1) AS first_count
            FROM
                same_a_table AS t2
            WHERE
                parent_id = 199707010701
                    AND product_id = 'bike') firstCount),
    sec_count = (SELECT 
            sec_count
        FROM
            (SELECT 
                COUNT(1) AS sec_count
            FROM
                same_a_table AS t3
            WHERE
                parent_id IN (SELECT 
                        customer_id
                    FROM
                        same_a_table AS t4
                    WHERE
                        parent_id = 199707010701
                            AND product_id = 'bike')
                    AND product_id = 'bike') secCount),
    thr_count = (SELECT 
            thr_count
        FROM
            (SELECT 
                COUNT(1) AS thr_count
            FROM
                same_a_table AS t5
            WHERE
                parent_id IN (SELECT 
                        customer_id
                    FROM
                        same_a_table AS t6
                    WHERE
                        parent_id IN (SELECT 
                                customer_id
                            FROM
                                same_a_table AS t7
                            WHERE
                                parent_id = 199707010701
                                    AND product_id = 'bike')
                            AND product_id = 'bike')
                    AND product_id = 'bike') thrCount)
WHERE
    product_id = 'bike'
        AND customer_id = 199707010701
		

第3部分查询比较慢thr_count:
SQL> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ 
select count(1) AS `thr_count` 
from 
    `db1`.`same_a_table` `t7` 
	join `db1`.`same_a_table` `t6` 
	join `db1`.`same_a_table` `t5` 
where 
    ((`db1`.`t5`.`parent_id` = `db1`.`t6`.`customer_id`) 
	and (`db1`.`t7`.`customer_id` = `db1`.`t6`.`parent_id`) 
	and (`db1`.`t7`.`parent_id` = 199707010701) 
	and (`db1`.`t5`.`product_id` = 'bike') 
	and (`db1`.`t6`.`product_id` = 'bike') 
	and (`db1`.`t7`.`product_id` = 'bike'))
1 row in set (0.00 sec)

