#coding: utf-8

#python对文件的处理:
#
#1.打开文件，读取内容
#    open文件，read或者直接遍历处理文件
#    f ＝ open(‘log.log’)
#    f.read()  ## 读取所有内容        字符串
#    f.readlines() ## 读取所有行      列表
#    它们差别是字符串和列表的差别：
#In [3]: !echo '123' > 1.txt
#
#In [5]: f = open('1.txt')
#
#In [6]: f.read()
#Out[6]: '123\n'
#
#In [7]: type(f.read())
#Out[7]: str
#
#In [8]: type(f.readlines())
#Out[8]: list
#
#f.close()
#
#
#   直接遍历:
#for line in f:
#     print line
#     break
#
#
#2.统计ip和访问状态的数据
#   利用字典，如果key存在dict中，其对应的values ＋ 1，否则values ＝ 1
#   将每一行的ip和访问状态取出来
#   一个维度：
#   ｛
#           ip:123
#           ip:334
#      ｝
#
#    二个维度:
#     ## 按照ip统计状态
#    ｛
#           ## 每个ip 不同状态及状态出现的次数
#           ip1:{
#                    404:1
#                    500:2
#                    200:10
#               }
#           ip2:{
#                    404:1
#                    500:3
#                    200:20
#               }
#       ｝
#   
#  ## 根据不同状态统计ip及ip出现的次数
#｛
#       404:｛
#                      ip1:1
#                      ip2:3
#                      ip3:4
#                ｝
#      200:｛
#                      ip1:11
#                      ip2:3
#                      ip3:4
#                ｝
#｝
#
#
### 利用python的元祖特性，同时判断每行日志中的ip和status字段，相同的有多少行
#｛
#        (ip,200):2
#        (ip,404):2
#        (ip,500):1
#   ｝
#
#
#
### 测试空行在python中的表示方式
#In [22]: f = open('1.txt')              
#
#In [23]: for i in f:                    
#    print [i]  ## 加上[]可以看出空行是用什么字符表示的
#   ....:     
#['123\n']
#['\n']
#['\n']
#
#
#空行 ＝＝ ‘\n’
#
#for line in f:
#    if line == ‘\n’:
#       continue   ## 如果此行等于空行则跳过
#    temp = line.split()  ## 切割行用split(),默认是按照空格分开，切割后的数据是用列表存储




f = open('www_access_20140823.log')
res_dict = {}


for line in f:
    if line == '\n':
       continue
    temp = line.split()
    #ip = temp[0]
    #status = temp[8]
    tup = (temp[0],temp[8])  ## 以元组为key,2个条件同时成立前提下,统计其出现的次数
    res_dict[tup] = res_dict.get(tup,0) + 1
##print res_dict
#print res_dict.items()
#for (ip,status),count in res_dict.items():  ## 直接循环列表，列表中的每个元素为元组，(('113.7.255.88', '200'), 1)
#                                            ## 直接使用for循环列表中每个元素的3个值
#    print 'ip is %s, status is %s, count is %s' % (ip,status,count)


#for line in f:
#    if line == '\n':
#       continue
#    temp = line.split()
#    ip = temp[0]
#    status = temp[8]
#
#    #res_dict.setdefault(ip,{status:0})
#
#    ## 根据ip为key，统计每个ip的所有访问状态
#    #'125.75.246.129': {'200': 50}
#    #'125.41.142.20': {'200': 55, '404': 2}
##In [29]: f2 = {'125.41.142.20': {'200': 55, '404': 2}}
##
##In [30]: f2['125.41.142.20']
##Out[30]: {'200': 55, '404': 2}
##
##In [32]: '200' in f2['125.41.142.20']
##Out[32]: True
##
##In [33]: '404' in f2['125.41.142.20']  
##Out[33]: True
#
#    if ip in res_dict:
#        if status in res_dict[ip]:
#            res_dict[ip][status] += 1
#        else:
#            res_dict[ip][status] = 1
#    else:
#        res_dict[ip] = {status:1}
#
##print res_dict
#
##for ip in res_dict:
##    for status in res_dict[ip]:
##        print 'ip is %s, status is %s, count is %s' % (ip,status,res_dict[ip][status])


f.close()


#3.打印前十
   #思路1:
      #1.dict ---> list
      #list冒泡10次,把出现次数最多的10个排出来

res_list = res_dict.items()
#[(ip,status),count]
for j in range(10):
    #for i in range(len(res_list) - 1):  ## 方法1
    for i in range(len(res_list) - 1 - j):  ## 方法2
        if res_list[i][1] > res_list[i + 1][1]:
            res_list[i],res_list[i + 1] = res_list[i + 1],res_list[i]

## 从大到小排序
#print res_list[:-11:-1]
## 从小到大排序
#print res_list[-10:]

## (a,b) = (1,2)
## print a

html_str = '<table border "1">'
tr_tmpl = '<tr><td>%s</td><td>%s</td><td>%s</td></tr>'
html_str += tr_tmpl % ('IP','status','count')



## 从大到小排序
#print res_list[:-11:-1]
## 从小到大排序
#for (ip,status),count in res_list[-10:]:  ## 直接循环列表，列表中的每个元素为元组，(('113.7.255.88', '200'), 1)
for (ip,status),count in res_list[:-11:-1]:  ## 直接循环列表，列表中的每个元素为元组，(('113.7.255.88', '200'), 1)
                                            ## 直接使用for循环列表中每个元素的3个值
    #print 'ip is %s, status is %s, count is %s' % (ip,status,count)
    html_str += tr_tmpl % (ip,status,count)
html_str += '</table>'

html_f = open('res.html','w')
html_f.write(html_str)
html_f.close()


## 如果有key,其实可以不用reverse
#arr = [{'name':'xxx','age':12}, {'name':'xxx', 'age':15}, {'name':'xxx', 'age':5}]
#print sorted(arr, key=lambda o:o['age'])
#print sorted(arr, key=lambda o:o['age'], reverse=True)
#print sorted(arr, key=lambda o:-o['age'])



#3.打印前十
   #思路1:
      #1.dict —> list
      #list冒泡10次,把出现次数最多的10个排出来

res_list = res_dict.items()
#print res_list
#print len(res_list)
#[(ip,status),count]
for j in range(10):
    #for i in range(len(res_list) - 1):  ## 方法1
    for i in range(len(res_list) - 1 - j):  ## 方法2
        #print "i is %s." % i
        if res_list[i][1] > res_list[i + 1][1]:
            res_list[i],res_list[i + 1] = res_list[i + 1],res_list[i]
            #tmp = res_list[i]
            #res_list[i] = res_list[i + 1]
            #res_list[i + 1] = tmp
            #print "res_list %s." % res_list



#这段有2点不明白：
#1.冒泡10次就能取结果怎么理解？
#2.方法2 减j怎么理解？
#
#冒泡十次就是排好了十个数，题目让取前十，不就十次搞定了嘛，就不用都排完了
#减j，你可以打印每次循环后的列表，重点看看右边的部分，你会发现其实右边排好的，以后就不用管它了不用再去比较，这个排好的数的个数就是外层循环的次数也就是j
#
#减去j 单纯的优化效率
#比如已经冒泡三次了
#下次冒泡的时候 后三个就不需要比较了
#因为肯定是最大的三个
#
#1:26:37



## with 语句
## 自动关闭文件
## 面向对象中的扩展，不能直接循环 __exit__ __enter__有关系
#with open('log.log') as f:
#    print f.readline()


## 文件 指针
## seek 控制文件指针的位置    写
## seek 2个参考(移动的字符，移动的相对位置[0是文件开始，1是现在的位置，2是文件结尾])
## tell 返回文件当前指针位置  读
#f = open('test.txt')
#print f.read(3) ## 读取3个字符 
#print f.read(3) ## 再读取3个字符 
#print f.tell()
#
#
#In [51]: !vim test.txt
#
#In [52]: f = open('test.txt')
#
#In [53]: print f.read(3)
#123
#
#In [54]: print f.read(3)
#456
#
#In [55]: print f.tell()
#6
#
#
#
#In [64]: f = open('test.txt')
#
#In [65]: print f.read(3)
#123
#
#In [66]: f.seek(0)
#
#In [67]: print f.read(3)
#123
#
#In [68]: print f.seek(1)
#None
#
#In [69]: print f.read(3)
#234


## 基于当前位置，跳过1，再计算
#FILE_START = 0
#FILE_NOW = 1
#FILE_END = 2
#f = open('test.txt')
#print f.read(3)
#f.seek(-2,FILE_END)
#print f.read(3)
#
#
#f.close()



## 函数
# 函数的语法
# 函数的参数
# 函数的返回值

# 函数可以是参数
# 函数可以调用自己

#def hello():
#    print 'hello world'
#    print 'fuck'
#
#hello()
#hello()


def hello():
    print 'xxx'
    print 3 + 2
    #return 'hello world'

print '---hello---'
hello  ## 不会执行函数,也不会报错

print '---hello()---'
hello()  ## 返回除return的语句 执行函数

print '---print hello---'
print hello  ## 打印函数的内存地址,不会执行函数中的语句

print '---print hello()---'
print hello()  ## 执行函数内的所有语句,包括return,执行print 返回hello world

## return 表示执行结果有返回,如果不加return，print hello()返回的是None



## 参数

3:35
