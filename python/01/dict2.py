#coding: utf8

## dict就是key value值,索引的引用和list的区别
## 不同场景使用不同数据结构
## key是不可变的,value可以是任何类型
## python数据结构类似于数据库增删改查


## 字典中K,V单双引号没有区别
## 通过key获取字典的value
## 字典的取值方式是[],如果是索引查找,一律使用[],无论是list or dict


### 定义字典
#In [62]: d = {"name":"fuck", 'age':22}
#
### 查看字典所有内容
#In [63]: d
#Out[63]: {'age': 22, 'name': 'fuck'}
#
### 给字典增加K,V
#In [64]: d['type'] = 'linux'
#
#In [65]: d
#Out[65]: {'age': 22, 'name': 'fuck', 'type': 'linux'}
#
### 查看/获取字典中某个key的值
#In [66]: d['type']
#Out[66]: 'linux'
#
#In [67]: d['age'] 
#Out[67]: 22
#
### 修改字典中key的值
#In [68]: d['type'] = 'Mac OS' 
#
#In [69]: d['type']
#Out[69]: 'Mac OS'
#
### 判断key是否在字典中
#In [73]: 'name' in d
#Out[73]: True
#
#In [74]: 'xxx' in d
#Out[74]: False
#
### 获取字典中所有key的名字,以列表的形式返回
#In [75]: d.keys()
#Out[75]: ['age', 'type', 'name']
#
### 获取字典中所有value的名字,以列表的形式返回
#In [76]: d.values()
#Out[76]: [22, 'Mac OS', 'fuck']
#
### 获取字典中所有内容,以列表的形式返回,列表的元素是元组
#In [77]: d.items()
#Out[77]: [('age', 22), ('type', 'Mac OS'), ('name', 'fuck')]


## 求出这个list中,每个字符出现的次数
list4 = ['C','js','python','js','css','js','html','node','js','python','js','css','js','html','node','js','python','js','css','js','html','node','css','js','html','node','js','python','js','css','js','html','node','js','python','js','css','js','html','node']

## 定义空字典
d2 = {}

for i in list4:
    if i in d2:  ## 以字符为key,字符出现的次数为value,字符每出现一次,其对应value + 1,第一次出现其值为1
                 ## 首先判断key是否在字典中,如果在字典中,其对应值 + 1,即,修改字典中某key的value;
                 ## 否则,以字符为key,其对应值为1,即,给字典增加K,V对
        d2[i] = d2[i] + 1
    else:
        d2[i] = 1
    #print d2    ## 查看循环每次执行过程

print '打印字典中k,v:'
for k,v in d2.items(): print k,v  ## 使用字典的属性items(),返回的是由元组组成的列表
print

print '对字典按照key值做排序:'
for k,v in (sorted(d2.items(), key=lambda d2: d2[0])): print k,v  ## 使用lambda函数
print

print '对字典按照value值做排序:'
for k,v in (sorted(d2.items(), key=lambda d2: d2[1])): print k,v
