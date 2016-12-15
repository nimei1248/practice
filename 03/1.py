#coding:utf-8

## 1.打开文件www_access_20140823.log,按行读取
## 2.获取每行的IP and http_code字段并统计IP访问次数
## 3.通过.html页面展现

## 打开nginx日志文件,默认是r模式
f2 = open("www_access_20140823.log")

## 定义空字典用于存放IP:IP_COUNT and http_code
d2 = {}

## 循环打开的nginx日志文件,直接循环文件,是按照行读取相当于f2.readlines()
for s in f2:
    if s:
        ## 根据字符串的split()方法获取每行的IP字段,判断其是否在字典d2中;以IP为key,IP访问次数IP_COUNT为values;
        ## 如果IP存在于d2中,则其对应值加1,否则直接给d2增加值
        #if s.split()[0] in d2:
        #    d2[s.split()[0]] += 1
        #else:
        #    d2[s.split()[0]] = 1

        ## 采用字典的get()方法,如果key存在,其对应的值+1,否则直接给字典增加值,默认值为0;是上面流程控制的简写
        #d2[s.split()[0]] = d2.get(s.split()[0],0) + 1

        ## 以IP and http_code为d2的key,这样可以确定每行IP and http_code,统计每行相同IP and http_code
        d2[s.split()[0],s.split()[8]] = d2.get((s.split()[0],s.split()[8]),0) + 1

#print d2

f2.close()

## 将字典转换成list,d2.items(),格式为[((x, y), count)],然后按照字典的values进行排序,取前10
d2_conv_list = sorted(d2.items(), lambda x, y: cmp(x[1], y[1]), reverse=True)[0:10]

print "<table border='1'>",
print '''
             <tr>
	         <td>IP</td>
	         <td>Status</td>
	         <td>Count</td>
	     </tr>
       '''

for i in d2_conv_list:
    #print "IP:%s, Status:%s, Count:%s" % (i[0][0],i[0][1],i[1])
    #print "<tr><td>%s</td><td>%s</td><td>%s</td></tr>" % (i[0][0],i[0][1],i[1])
    print '''
              <tr>
                  <td>%s</td>
                  <td>%s</td>
                  <td>%s</td>
              </tr>
           ''' % (i[0][0],i[0][1],i[1])
print '</table>'
