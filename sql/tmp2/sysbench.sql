sysbench /usr/share/sysbench/tests/include/oltp_legacy/oltp.lua \
--oltp-test-mode=complex \
--oltp-tables-count=100 \
--oltp-table-size=1000000 \
--oltp-read-only=off \
--oltp-dist-type=uniform \
--init-rng=on \
--max-requests=0 \
--randtype=special \
--randseed=0 \
--randspec-iter=12 \
--randspec-pct=1 \
--randspec-res=75 \
--events=0 \
--warmup-time=0 \
--rate=0 \
--threads=20 \
--threadstack-size=32K \
--thread-init-timeout=30 \
--time=1800 \
--report-interval=10 \
--precentile=99 \
--db-driver=mysql \
--mysql-table-engine=innodb \
--mysql-host=127.0.0.1 \
--mysql-port=\
--mysql-user=\
--mysql-password=\
--mysql-db=roses \  -- 需要提前创建好db,否则会报错如下
--verbosity=5 \
prepare
sysbench 1.0.15 (using bundled LuaJIT 2.1.0-beta2)
