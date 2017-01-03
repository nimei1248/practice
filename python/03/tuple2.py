#!/usr/bin/env python
# -*- coding=utf-8 -*-
# File Name: tuple2.py
# Created Time: 2016年12月10日 星期六 10时11分50秒


## 元组，不可变的数组
#tup = (1,2,3)
## 除了修改，所有数组的属性都有
## 和数组的区别
#1.不可修改，所以速度快
#2.tup可以当作dict的key，而list不行
#3.[1,2,3] (2015,5,11)


#字典 = (其它语言中，这种数据结构叫做哈希表)
#my_dict = {
#    #[12,1,2]:'list',## TypeError: unhashable type: 'list'
#    (12,1,2):'tuple',
#    0:"test0",
#    1:"test1",
#    "name":'nimei',
#    "age":12,
#    "hobby":['linux','python'],
#    "des":{
#        "job":"ops",
#        "hehe":"xxx"
#    }
#}
## 字典里的数据没有顺序，是key:value的形式，key必须是不可变的数据结构，values任意
## key必须是不可变的数据结构,values可以是任意数据结构

## 增删改查

## 查找
#print my_dict[key]
#print my_dict["name"]
#print my_dict[1]
#print my_dict[(12,1,2)]
#print my_dict["hobby"][0]
#print my_dict['des']['job']


#key 和 values的长度也没有限制？
## 一般来说不要超出python本身的限制


## 修改
#my_dict = {'name':'nimei','age':1}
#my_dict["name"] = "hello"
#print my_dict
#
### 添加
#my_dict["job"] = "ops"
#print my_dict
#
### 删除
#del my_dict['age']
#print my_dict

## 总结: 字典的增删改查都是以key来操作,key是唯一的
## 修改和添加语法一样,如果存在key,则修改对应的values,否则添加K,V
## dict本身是无序的


### in判断字典是否有这个key
#print 'name' in my_dict
#print 'namexxx' in my_dict
#
### len获取dict中的数据数量
#print len(my_dict)
#
### for循环遍历字典的key
#for k in my_dict:
#    print k,my_dict[k]


## 统计这段文字力，所有字符出现的次数（除了空格）
## 字符:次数

string2 = '''
first of all, i want make it clear that i can not claim understanding this holy book  in just a few weeks, and i would not dare comment on this sacred book, in addition, i don't think i can give you a full picture of the holy bible in just few words.i can not preach anything here. what i want to do here is to express my understanding by sharing two events described in this book. the fist story i want to share is abandoned tower of babel.according to the bibel,people use the same language to communicate with each other in ancient times.with the soaring vanity,they decided to build a heaven-reaching tower to show off their achievement, god knows, he change the human language into different kinds and make it difficult for people to communicate with each other,hence the failure of building tower of  babel.this story tells people,never do things in selfishness, but make a life out of enternal glory.the other story,before jesus christ was crucified,he said, father,forgive them, for they know not what they do. with great love, he shouldered all the sins of  people. what can we learn from this story?we live in this world thanks to the love of god, for this reanson, we should make our lives glorious to honor our god.finally,i want to sum up by saying that only if we put our lives in the eternal love of god,can we live a perfect life, and  what you appealed is what god expected!
'''

dict2 = {}

for k in string2:
    ## if key等于空格就跳过
    if k == ' ':  ## 加上这个就会去除统计空格的次数,不加统计所有字符的出现的次数
        continue

    ## 写法1
    elif k in dict2:
        dict2[k] = dict2[k] + 1  ## 另一种写法dict2[k] += 1
    else:
        dict2[k] = 1

    ### 写法2
    #elif k not in dict2:
    #    dict2[k] = 1
    #else:
    #    dict2[k] = dict2[k] + 1  ## 另一种写法dict2[k] += 1


#print dict2


## 打印上面输出结果的前10名
## 方法1: 按照字典的values排序,通过sorted and lambda函数
#dict3 = sorted(dict2.items(), lambda x, y: cmp(x[1], y[1]), reverse=True)[0:10]
#for i in dict3:
#    print i


## 方法2: 把dict 转成 list
## 字典是无序的,list是有序的,元组是不可修改的,所以考虑将dict转list,然后list冒泡10次就可以了,不冒泡所有
#dict_list2 = []
#for k in dict2:
#    dict_list2.append([k, dict2[k]])  ## 列表套列表,取出一对字典的k,V作为一组小列表,放在大列表dict_list2中
#print dict_list2
#
#for i in range(10):
#    for j in range(len(dict_list2) - 1):
#        if dict_list2[j][1] > dict_list2[j + 1][1]:
#            dict_list2[j],dict_list2[j + 1] = dict_list2[j + 1],dict_list2[j]
#print dict_list2
#
#for r in dict_list2[-10:]:
#    print r
#    print 'char %s count is %s' % (r[0], r[1])


## 方法3: 反转dict,让值:字符,然后把值取出,sort排序把前10取出来,然后遍历,去反转后的dict里获取字符
## 值:[字符1, 字符2]

## 反转 次数:[字符1, 字符2]

reverse_dict2 = {}

for k in dict2:
    if dict2[k] in reverse_dict2:
        reverse_dict2[dict2[k]].append(k)
    else:
        reverse_dict2[dict2[k]] = [k]

## 把key排序
key_list = []
for k in reverse_dict2:
    key_list.append(k)
key_list.sort()
print key_list

count = 0
while count < 10:
    val = key_list.pop()

    ## 方法1
    #print 'char %s, count is %s' %(reverse_dict2[val],val)
    #print val,reverse_dict2[val]
    #count += len(reverse_dict2[val])

    ## 方法2
    for k in reverse_dict2[val]:
        print 'char %s,count is %s' %(k,val)
        count += 1
