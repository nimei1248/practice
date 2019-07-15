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