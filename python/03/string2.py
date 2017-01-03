#!/usr/bin/env python
# -*- coding=utf-8 -*-
# File Name: string.py
# Created Time: 2016年12月10日 星期六 10时06分43秒


## 字符串也是类似数组的数据格式,不可修改,只能返回结果
name = 'hello'
## 字符串通过下标/索引取值/分片
print name[0]
print name[-1]
print name[1:4]
print '-' * 50

## 循环打印字符串
for n in name:
    print n
