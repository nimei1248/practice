# coding:utf8

## 1
#class Person:
#    def __init__(self):
#        self.name = 'nimei'
#        self.job = 'devops'
#
#person1 = Person()
#print person1.name
#print person1.job


## 2
#class Person:
#    def __init__(self):
#        self.name = 'nimei'
#        self.job = 'devops'
# 
#    def hello(self):
#        print 'I am %s, my job is %s' % (self.name, self.job)
#
#person1 = Person()
#person1.hello()


## 3
## 固定变量+传入变量
class Person:
    def __init__(self,name):  ## 传入变量
        self.name = name
        self.job = 'devops'
 
    def hello(self):
        print 'I am %s, my job is %s' % (self.name, self.job)

person1 = Person('xxxxxx')
person1.hello()

person2 = Person('===python')
print person2.name
print person2.job



