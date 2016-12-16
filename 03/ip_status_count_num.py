# coding:utf-8


## 打开文件,默认为r
f2 = open("www_access_20140823.log")

## 建立空字典用于存放以IP and status为key:其对应的访问次数为values的dict
d2 = {}


## 直接循环打开的文件类似于f2.readlines(),一行行读
#for s in f2:
#    ## 如果s为true,则以IP and status为key:其对应的访问次数为values,组成键值对存放在dict d2
#    if s:
#        d2[s.split()[0],s.split()[8]] = d2.get((s.split()[0],s.split()[8]),0) + 1

## close open file
#f2.close()


## 与上面写法差别,打开文件并保证最后f2.close(),而不需要手动close()
with open("www_access_20140823.log",'r') as f2:
    for s in f2:
        ## 如果s为true,则以IP and status为key:其对应的访问次数为values,组成键值对存放在dict d2
        ## 同时可以忽略s首尾的空格,但解决不了空行的问题: IndexError: list index out of range

        ## 解决不了空行问题
        #if not len(s): continue

        ## 如果是空行,跳过此次循环,进入下一轮循环
        #if s == '\n': continue

        ## s.strip()去除首尾字符,默认是空格;语法: str.strip([chars]) chars:移除字符串头尾指定的字符
        ## 测试发现该函数的作用是去除字符串两端多余的whitespace,whitespace应该是空格,Tab和换行的统称,而不仅仅是空格
        ## 如果是空行,则为Fasle不成立
        if s.strip():
            d2[s.split()[0],s.split()[8]] = d2.get((s.split()[0],s.split()[8]),0) + 1


## html
html_head = "<table border='1'>"

html_title = '''
                <tr>
	            <td>Num</td>
	            <td>IP</td>
	            <td>Status</td>
	            <td>Count</td>
	        </tr>
            '''

html_body = '''
               <tr>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
                   <td>%s</td>
               </tr>
           '''

html_end = '</table>'

#html = html_head + html_title
html = html_head + html_body % ('Num', 'IP', 'Status', 'Count')

## 把dict convert list,通过sorted and lambda函数对d2的values进行排序,反转,取前10
## cmp(...)
##    cmp(x, y) -> integer
##    Return negative if x<y, zero if x==y, positive if x>y.
## sorted(...)
##    sorted(iterable, cmp=None, key=None, reverse=False) --> new sorted list
#d2_conv_list = sorted(d2.items(), lambda x, y: cmp(x[1], y[1]), reverse=True)[0:10]

## 将字典转成list
#l2 = d2.items()
d2_conv_list = d2.items()

### 比较耗时间
#for j in range(len(l2) - 1):
#    for i in range(len(l2) - 1):
#        if l2[i][1] > l2[i + 1][1]:
#            l2[i], l2[i + 1] = l2[i + 1], l2[i]
#print l2

### 比上一种写法耗时少些
#for j in range(len(l2) - 1, 0, -1):
#    for i in range(j):
#        if l2[i][1] > l2[i + 1][1]:
#            #tmp = l2[i]
#            #l2[i] = l2[i + 1]
#            #l2[i + 1] = tmp
#
#            ## 上面3行可简写成1行,改写后减少耗时
#            l2[i], l2[i + 1] = l2[i + 1], l2[i]
#print l2

### 比上一种写法耗时少些
#In [13]: l2 = [1,3,2,6,8,1,20,3,40]
#
#In [14]: len(l2)
#Out[14]: 9
#
#In [15]: range(len(l2) - 1, 0, -1)
#Out[15]: [8, 7, 6, 5, 4, 3, 2, 1]

#for j in range(len(l2) - 1):
## 外层循环减少一次循环,如果是6个数比较大小排序,只要比较5次即可
## range(len(l2) - 1, 0, -1) 这里使用序列分片功能,生成的序列下标是从1开始而不是0,这样就达到减少一次外层循环目的
## 同时将下标倒序排列,这样做是想在内层循环上减少一次比较,同时减去最大的下标,内层循环就变成从开头开始比较,这样最终结果是从小到大

#for j in range(len(l2) - 1):
#    for i in range(len(l2) - 1 - j):
#        if l2[i][1] > l2[i + 1][1]:
#            l2[i], l2[i + 1] = l2[i + 1], l2[i]
#print l2

#for j in range(len(l2) - 1, 0, -1):  ## 比上一个for写法耗时少些
#    for i in range(j):
#        if l2[i][1] > l2[i + 1][1]:
#            l2[i], l2[i + 1] = l2[i + 1], l2[i]
#print l2

## 比上面几个排序都快耗时间最少
count = len(d2_conv_list)
for i in range(0, count):
    for j in range(i + 1, count):
        if d2_conv_list[i][1] > d2_conv_list[j][1]:
            d2_conv_list[i], d2_conv_list[j] = d2_conv_list[j], d2_conv_list[i]

## 倒序排列
d2_conv_list = d2_conv_list[-10:][::-1]

## 正序排列
#d2_conv_list = d2_conv_list[-10:]

## 循环打印list,并进行html拼接
c = 1
for i in d2_conv_list:
     html = html + html_body % (c,i[0][0],i[0][1],i[1])
     c = c + 1

html = html + html_end
print html


### write html to MJ.html
#f3 = open('MJ.html','w')
#f3.write(html)
#f3.close()
