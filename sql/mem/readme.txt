全路径：
# python ps_mem.py -s -S

# python ps_mem.py 
 Private  +   Shared  =  RAM used       Program

  4.0 KiB +  23.0 KiB =  27.0 KiB       portreserve
  4.0 KiB +  45.5 KiB =  49.5 KiB       hald-addon-acpi
  4.0 KiB +  70.5 KiB =  74.5 KiB       hald-addon-input
  4.0 KiB +  80.0 KiB =  84.0 KiB       hald-runner
132.0 KiB +  40.5 KiB = 172.5 KiB       crond
  4.0 KiB + 174.5 KiB = 178.5 KiB       VGAuthService
144.0 KiB +  35.5 KiB = 179.5 KiB       dbus-daemon
328.0 KiB +  59.0 KiB = 387.0 KiB       init
312.0 KiB +  80.0 KiB = 392.0 KiB       udevd (3)
164.0 KiB + 280.5 KiB = 444.5 KiB       master
360.0 KiB + 120.0 KiB = 480.0 KiB       mingetty (6)
440.0 KiB + 149.5 KiB = 589.5 KiB       su
324.0 KiB + 281.5 KiB = 605.5 KiB       qmgr
336.0 KiB + 307.0 KiB = 643.0 KiB       mysqld_safe (2)
748.0 KiB + 164.5 KiB = 912.5 KiB       hald
  1.1 MiB + 277.5 KiB =   1.3 MiB       pickup
  1.2 MiB + 278.5 KiB =   1.5 MiB       cleanup
  1.4 MiB + 438.5 KiB =   1.8 MiB       local
  1.2 MiB + 663.0 KiB =   1.9 MiB       bash (3)
  2.1 MiB + 218.5 KiB =   2.3 MiB       vmtoolsd
  1.8 MiB + 729.0 KiB =   2.5 MiB       bounce (2)
  3.5 MiB +   1.5 MiB =   5.0 MiB       sshd (3)
  5.5 MiB +  57.0 KiB =   5.5 MiB       rsyslogd
  8.2 MiB +  67.5 KiB =   8.3 MiB       docker
  8.9 MiB + 196.5 KiB =   9.1 MiB       SolarWinds.Agent.JobEngine.Plugin
 11.3 MiB +  98.0 KiB =  11.4 MiB       mcollectived
 12.3 MiB + 298.5 KiB =  12.6 MiB       snmpd
 19.9 MiB + 319.5 KiB =  20.2 MiB       swiagent
 19.8 MiB + 978.0 KiB =  20.8 MiB       mycli
  1.8 GiB + 531.0 KiB =   1.8 GiB       jsvc (2)
  4.8 GiB + 694.0 KiB =   4.8 GiB       mysqld (2)
---------------------------------
                          6.7 GiB
=================================


虚拟内存：
# python ps_mem.py -S 
 Private  +   Shared  =  RAM used   Swap used   Program

  4.0 KiB +  23.0 KiB =  27.0 KiB   100.0 KiB   portreserve
  4.0 KiB +  45.5 KiB =  49.5 KiB   156.0 KiB   hald-addon-acpi
  4.0 KiB +  70.5 KiB =  74.5 KiB   176.0 KiB   hald-addon-input
  4.0 KiB +  80.0 KiB =  84.0 KiB   220.0 KiB   hald-runner
132.0 KiB +  40.5 KiB = 172.5 KiB   508.0 KiB   crond
  4.0 KiB + 174.5 KiB = 178.5 KiB     2.8 MiB   VGAuthService
144.0 KiB +  35.5 KiB = 179.5 KiB   124.0 KiB   dbus-daemon
328.0 KiB +  59.0 KiB = 387.0 KiB    72.0 KiB   init
312.0 KiB +  80.0 KiB = 392.0 KiB     1.5 MiB   udevd (3)
164.0 KiB + 280.5 KiB = 444.5 KiB   852.0 KiB   master
360.0 KiB + 120.0 KiB = 480.0 KiB   144.0 KiB   mingetty (6)
440.0 KiB + 149.5 KiB = 589.5 KiB     0.0 KiB   su
324.0 KiB + 281.5 KiB = 605.5 KiB   824.0 KiB   qmgr
336.0 KiB + 307.0 KiB = 643.0 KiB   336.0 KiB   mysqld_safe (2)
748.0 KiB + 164.5 KiB = 912.5 KiB   404.0 KiB   hald
  1.1 MiB + 277.5 KiB =   1.3 MiB     0.0 KiB   pickup
  1.2 MiB + 278.5 KiB =   1.5 MiB     0.0 KiB   cleanup
  1.4 MiB + 438.5 KiB =   1.8 MiB     0.0 KiB   local
  1.2 MiB + 663.0 KiB =   1.9 MiB     0.0 KiB   bash (3)
  2.1 MiB + 218.5 KiB =   2.3 MiB     2.2 MiB   vmtoolsd
  1.8 MiB + 729.0 KiB =   2.5 MiB     0.0 KiB   bounce (2)
  3.5 MiB +   1.5 MiB =   5.0 MiB   612.0 KiB   sshd (3)
  5.5 MiB +  57.0 KiB =   5.5 MiB   324.0 KiB   rsyslogd
  8.2 MiB +  67.5 KiB =   8.3 MiB   216.0 KiB   docker
  8.9 MiB + 196.5 KiB =   9.1 MiB   420.0 KiB   SolarWinds.Agent.JobEngine.Plugin
 11.3 MiB +  98.0 KiB =  11.4 MiB   312.0 KiB   mcollectived
 12.3 MiB + 298.5 KiB =  12.6 MiB     2.7 MiB   snmpd
 19.9 MiB + 319.5 KiB =  20.2 MiB     3.0 MiB   swiagent
 19.8 MiB + 978.0 KiB =  20.8 MiB     0.0 KiB   mycli
  1.8 GiB + 531.0 KiB =   1.8 GiB    99.4 MiB   jsvc (2)
  4.8 GiB + 694.0 KiB =   4.8 GiB     1.4 GiB   mysqld (2)
---------------------------------------------
                          6.7 GiB     1.6 GiB
=============================================


显示指定pid内存使用：
# python ps_mem.py -s -S -p 2960,1837
 Private  +   Shared  =  RAM used   Swap used   Program

  5.5 MiB +  58.0 KiB =   5.5 MiB   324.0 KiB   /sbin/rsyslogd -i /var/run/syslogd.pid -c 5
  8.2 MiB +  71.5 KiB =   8.3 MiB   216.0 KiB   /usr/bin/docker -d
---------------------------------------------
                         13.8 MiB   540.0 KiB
=============================================


每2秒显示一次：
# python ps_mem.py -s -S -p 2960,1837 -w 2
 Private  +   Shared  =  RAM used   Swap used   Program

  5.5 MiB +  57.0 KiB =   5.5 MiB   324.0 KiB   /sbin/rsyslogd -i /var/run/syslogd.pid -c 5
  8.2 MiB +  68.5 KiB =   8.3 MiB   216.0 KiB   /usr/bin/docker -d
---------------------------------------------
                         13.8 MiB   540.0 KiB
=============================================
  5.5 MiB +  57.0 KiB =   5.5 MiB   324.0 KiB   /sbin/rsyslogd -i /var/run/syslogd.pid -c 5
  8.2 MiB +  68.5 KiB =   8.3 MiB   216.0 KiB   /usr/bin/docker -d
---------------------------------------------
                         13.8 MiB   540.0 KiB
=============================================
  5.5 MiB +  57.0 KiB =   5.5 MiB   324.0 KiB   /sbin/rsyslogd -i /var/run/syslogd.pid -c 5
  8.2 MiB +  68.5 KiB =   8.3 MiB   216.0 KiB   /usr/bin/docker -d
---------------------------------------------
                         13.8 MiB   540.0 KiB
=============================================


显示总和：
# python ps_mem.py -t
7234186240
