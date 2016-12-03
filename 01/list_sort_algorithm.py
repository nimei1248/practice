http://blog.csdn.net/orangleliu/article/details/8813110


## 八大排序算法
## 用Python实现了插入排序、希尔排序、冒泡排序、快速排序、直接选择排序、堆排序、归并排序、基数排序
http://python.jobbole.com/82270/


## python数据结构与算法 32
[Problem Solving with Algorithms and Data Structures using Python]

## 本书中文版翻译
http://blog.csdn.net/python2014?viewmode=contents

## 32 插入排序
http://blog.csdn.net/python2014/article/details/24347473

## 33 希尔排序
http://blog.csdn.net/python2014/article/details/24692887

http://interactivepython.org/courselib/static/pythonds/Introduction/toctree.html
http://interactivepython.org/courselib/static/pythonds/AlgorithmAnalysis/toctree.html
http://interactivepython.org/courselib/static/pythonds/BasicDS/toctree.html
http://interactivepython.org/courselib/static/pythonds/Recursion/toctree.html
http://interactivepython.org/courselib/static/pythonds/SortSearch/toctree.html
http://interactivepython.org/courselib/static/pythonds/Trees/toctree.html
http://interactivepython.org/courselib/static/pythonds/Graphs/toctree.html


## toctree
http://interactivepython.org/courselib/static/pythonds/SortSearch/toctree.html

## sorting
http://interactivepython.org/courselib/static/pythonds/SortSearch/sorting.html

## 冒泡排序
http://interactivepython.org/courselib/static/pythonds/SortSearch/TheBubbleSort.html

## 选择排序
http://interactivepython.org/courselib/static/pythonds/SortSearch/TheSelectionSort.html

## 插入排序
http://interactivepython.org/courselib/static/pythonds/SortSearch/TheInsertionSort.html

## shell排序
http://interactivepython.org/courselib/static/pythonds/SortSearch/TheShellSort.html

## merge排序
http://interactivepython.org/courselib/static/pythonds/SortSearch/TheShellSort.html

## 快速排序
http://interactivepython.org/courselib/static/pythonds/SortSearch/TheQuickSort.html

## 汇总
http://interactivepython.org/courselib/static/pythonds/SortSearch/Summary.html

#coding:utf8
## python插入排序  
def insertSort(a):  
    for i in range(len(a)-1):  
        #print a,i    
        for j in range(i+1,len(a)):  
            if a[i]>a[j]:  
                temp = a[i]  
                a[i] = a[j]  
                a[j] = temp  
    return a  
  
  
## Python的冒泡排序     
def bubbleSort(alist):  
    for passnum in range(len(alist)-1,0,-1):  
        #print alist,passnum  
        for i in range(passnum):  
            if alist[i]>alist[i+1]:  
                temp = alist[i]  
                alist[i] = alist[i+1]  
                alist[i+1] = temp  
    return alist  
  
  
## Python的选择排序   
def selectionSort(alist):  
    for i in range(len(alist)-1,0,-1):  
        maxone = 0  
        for j in range(1,i+1):  
            if alist[j]>alist[maxone]:  
                maxone = j  
        temp = alist[i]   
        alist[i] = alist[maxone]  
        alist[maxone] = temp   
    return alist  
  
  
alist = [54,26,93,17,77,31,44,55,20]  
#print bubbleSort(alist)  
alist = [54,26,93,17,77,31,44,55,20]  
print selectionSort(alist)  
