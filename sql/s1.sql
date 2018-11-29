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
        OR (u.mobile_phone = '138abc')
        OR (u.last_login_ip = '1.1.1.1')
        OR (c.card_num = 'xxxxxx'))
        AND (u.id NOT IN (SELECT 
            user_id
        FROM
            t3
        WHERE
            relate_user_id = '1000'))



