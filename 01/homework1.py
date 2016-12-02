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
### 使用列表的属性index,获取列表中元素的索引值,再根据索引值获取到列表中元素,然后再根据上面多个变量赋值方法,即可实现交互
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
list5 = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,5,777,65555,45,33,45]
i = 0

for j in list5:
    print j
    max_num_1 = list5[i]
    max_num_2 = list5[i + 1]

    if max_num_2 < max_num_1:
        max_num_1[i], max_num_2[i + 1] = max_num_2[i + 1], max_num_1[i]
    #i = i + 1

print "max number1 is : %s" % max_num_1
print "max number2 is : %s" % max_num_2



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
