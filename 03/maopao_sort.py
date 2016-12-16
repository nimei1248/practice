# coding:utf-8

## 冒泡排序几种写法

l2 = [1,3,2,6,8,40,1,20,3]


## 1
for j in range(len(l2) - 1):
    for i in range(len(l2) - 1 - j):
        if l2[i] > l2[i + 1]:
            l2[i], l2[i + 1] = l2[i + 1], l2[i]
print l2


## 2
for j in range(len(l2) - 1, 0, -1):
    for i in range(len(l2) - 1):
        if l2[i] > l2[i + 1]:
            l2[i], l2[i + 1] = l2[i + 1], l2[i]
print l2


## 3
for j in range(len(l2) - 1, 0, -1):
    for i in range(j):
        if l2[i] > l2[i + 1]:
            l2[i], l2[i + 1] = l2[i + 1], l2[i]
print l2


## 4
count = len(l2)
for i in range(0, count):
    #print 'i---->%s---->%s' % (i, l2[i])
    for j in range(i + 1, count):
        if l2[i] > l2[j]:
            l2[i], l2[j] = l2[j], l2[i]
    #print 'j---->%s---->%s' % (j, l2[j])
print l2


## 5
count = len(l2)
for i in range(5):
    for j in range(count - 1):
        if l2[j] > l2[j + 1]:
            l2[i], l2[j + 1] = l2[j + 1], l2[i]
print l2
