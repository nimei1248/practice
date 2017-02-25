# coding:utf8

class Animal:
    def __init__(self,name,blood,dps):
        self.name = name
        self.blood = blood
        self.max_blood = blood
        self.dps = dps
        #print '%s is create' % (self.name)

    def attack(self,target):
        target.blood -= self.dps  ## 目标人物的血总量减去自身的初始化血量(200 - 15 = 185, 100 - 10 = 90)
        target.tell() ## 调用tell()函数

    def tell(self):
        if self.blood < 0:
           print '%s is die' % (self.name)
        else:
           print '%s has blood %s' % (self.name, self.blood)

sf = Animal('sunfan',100,15)
js = Animal('jiaoshou',200,10)

while True:
    sf.attack(js)
    js.attack(sf)

    if sf.blood < 0 or js.blood < 0:
        break
