#coding: utf8


### 变量赋值
### a,b = b,a: 把右边的b赋给左边的a,把右边的a赋给左边的b,如下实例:
#In [165]: a,b = 4,2
#
#In [166]: a
#Out[166]: 4
#
#In [167]: b
#Out[167]: 2
#
#In [168]: b,a = 4,2
#
#In [169]: b
#Out[169]: 4
#
#In [170]: a
#Out[170]: 2


### 将列表中任意2个元素位置交换,因为目前列表没有现成的函数解决此问题,可以使用下面方式:
### 使用列表的属性index,获取列表中元素的索引值,再根据索引值获取到列表中元素,然后再根据上面多个变量赋值方法,即可实现交互,达到排序目的
#In [153]: l2 = ['a','b','c','d']
#
#In [155]: num1 = l2.index('a')
#
#In [156]: num2 = l2.index('b') 
#
#In [157]: l2[num1], l2[num2] = l2[num2], l2[num1]
#
#In [158]: l2
#Out[158]: ['b', 'a', 'c', 'd']


## 求最大的两个值并打印出来
### 方法一: 多变量赋值 + 位置交换(通过索引获取元素值进行比较)
#list5 = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,6,777,65555,45,33,45]
##list5 = [33,11,12]
#
#for j in range(len(list5) - 1):  ## 比较一组数中最大的数,需要比较的次数=长度-1
#                                 ## 如,[33,12,11],比较2次即可;33可以分别与其它2个数比,也可以与一个中间数比
#    for i in range(len(list5) - 1):  ## 数的总数-1,通过range函数,即可获取索引,索引从0开始,总的个数不变
#                                     ## list通过索引获取元素
#        if list5[i] > list5[i + 1]:  ## 通过索引获取元素进行比较,如果i > i + 1,那么进行变量赋值、位置交换,
#                                     ## 以此达到排序目的,具体实例可以参考上面2个
#        #if list5[i] < list5[i + 1]:  ## 获取2个最小值
#            list5[i],list5[i + 1] = list5[i + 1],list5[i]
#        #print list5  ## 查看内层循环的过程
#    #print list5      ## 查看外层循环的过程
#
#print list5[i]
#print list5[i + 1]



### 方法二: 使用模块heapq
### 获取一个列表/集合中最大/最小的N个元素列表
#In [179]: import heapq
#
#In [180]: list5 = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,5,777,65555,45,33,45]
#
#In [183]: print(heapq.nlargest(2, list5)) 
#[65555, 4111]
#
#In [184]: print(heapq.nsmallest(2, list5))       
#[1, 1]


## 方法三: 使用sorted函数对列表进行倒序排列,然后再取前2个值
## 写法一:
#In [28]: sorted(list5)[::-1]
#Out[28]: 
#[65555,
# 4111,
# 3333,
# 777,
# 444,
# 111,
# 45,
# 45,
# 33,
# 22,
# 21,
# 12,
# 5,
# 4,
# 3,
# 3,
# 3,
# 3,
# 2,
# 2,
# 2,
# 2,
# 1,
# 1]
#
#In [29]: sorted(list5)[::-1][0:2]
#Out[29]: [65555, 4111]


### 写法二:
#In [25]: sorted(list5, reverse=True)
#Out[25]: 
#[65555,
# 4111,
# 3333,
# 777,
# 444,
# 111,
# 45,
# 45,
# 33,
# 22,
# 21,
# 12,
# 5,
# 4,
# 3,
# 3,
# 3,
# 3,
# 2,
# 2,
# 2,
# 2,
# 1,
# 1]
#
#In [26]: sorted(list5, reverse=True)[0:2]
#Out[26]: [65555, 4111]


## 方法四:
## woniu 冒泡排序 == bubble sort later
#list5 = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,6,777,65555,45,33,45]
#count = len(list5)
#
#for i in range(0, count):
#    for j in range(i + 1, count):
#        if list5[i] < list5[j]:
#            list5[i], list5[j] = list5[j], list5[i]
#        #print list5
#
#print 'bubble sort later: %s' % list5
#print 'max two values is: %s %s' % (list5[0], list5[1])



## 方法五: python插入排序 insertSort
### 列表位置互换演示
#In [6]: list5 = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,6,777,65555,45,33,45]
#
#In [7]: list5[1]
#Out[7]: 2
#
#In [8]: list5[6]
#Out[8]: 1
#
#In [9]: tmp = list5[1]
#
#In [10]: print tmp
#2
#
#In [11]: list5[1] = list5[6]
#
#In [12]: list5[1]
#Out[12]: 1
#
#In [13]: list5[6]
#Out[13]: 1
#
#In [14]: list5[6] = tmp
#
#In [15]: list5[6]
#Out[15]: 2


#list5 = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,6,777,65555,45,33,45]
#
#for i in range(len(list5) - 1):
#    print list5, i, list5[i]
#    for j in range(i + 1, len(list5)):
#        print "before: "
#        print list5[i], i, list5[j]
#        if list5[i] > list5[j]:
#            tmp = list5[i]
#            list5[i] = list5[j]
#            list5[j] = tmp
#        print "after: "
#        print list5[i], i, list5[j]
#    print
#
#print i, j
#print list5
#print list5[i]
#print list5[i + 1]



## 方法六:
## python冒泡排序  bubbleSort
#list5 = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,6,777,65555,45,33,45]
#
#for j in range(len(list5) - 1, 0, -1):  ## first [23-1]
#    for i in range(j):  ## first [0-23]
#        if list5[i] > list5[i + 1]:
#            tmp = list5[i]
#            list5[i] = list5[i + 1]
#            list5[i + 1] = tmp
#
#print list5
#print list5[-1]
#print list5[-2]



## 方法七:
## python选择排序  selectionSort
list5 = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,6,777,65555,45,33,45]

for i in range(len(list5) - 1, 0, -1):  ## first [23-1]
    maxone = 0
    for j in range(1, i + 1):
        if list5[j] > list5[maxone]:
            maxone = j
    tmp = list5[i]
    list5[i] = list5[maxone]
    list5[maxone] = tmp

print list5
print list5[-1]
print list5[-2]
