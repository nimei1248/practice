# coding:utf8


## import module
from sqlalchemy import Column, String, create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

## 创建对象的基类
Base = declarative_base()

## 定义User对象
class User(Base):
    ## 表的名字
    __tablename__ = 'user'

    ## 表的结构
    id = Column(String(20), primary_key=True)
    name = Column(String(20))

## 初始化数据库连接,create_engine()用来初始化数据库连接
engine = create_engine('mysql+mysqlconnector://root:123456@localhost:4311/test?charset=utf8', connect_args = dict(unix_socket="/mysqldata/inst1/sock/mysql.sock"))

## 创建DBSession类型
DBSession = sessionmaker(bind=engine)


## 以上代码完成SQLAlchemy的初始化和具体每个表的class定义.如果有多个表,就继续定义其它class,例如School:
#class School(Base):
#    __tablename__ = 'school'
#    id = ...
#    name = ...


## SQLAlchemy用一个字符串表示连接信息:
## '数据库类型+数据库驱动名称://用户名:口令@机器地址:端口号/数据库名'
## 只需要根据需要替换掉用户名、口令等信息即可
## 
## 看看如何向数据库表中添加一行记录:
## 由于有了ORM，我们向数据库表中添加一行记录，可以视为添加一个User对象:


### 创建session对象
#session = DBSession()
#
### 创建新User对象
#new_user = User(id='8', name='nimei')
#
### 添加到session
#session.add(new_user)
#
### 提交即保存到数据库
#session.commit()
#
### 关闭session
#session.close()


## 从上可见,关键是获取session,然后把对象添加到session,最后提交并关闭
## Session对象可视为当前数据库连接
## 如何从数据库表中查询数据呢? 有了ORM,查询出来的可以不再是tuple,而是User对象
## SQLAlchemy提供的查询接口如下:

## 创建session
session = DBSession()

## 创建query查询,filter是where条件,最后调用one()返回唯一行,如果调用all()则返回所有行
#user2 = session.query(User).filter(User.id=='6').all()
user2 = session.query(User).filter(User.id=='8').one()

## 打印类型和对象的name属性
print 'type:', type(user2)
print 'name:', user2.name

## 关闭session
session.close()


## 运行结果如下:
#type: <class '__main__.User'>
#name: Bob



class User(Base):
    __tablename__ = 'user'

    id = Column(String(20), primary_key=True)
    name = Column(String(20))

    ## 一对多
    books = relationship('Book')


class Book(Base):
    __tablename__ = 'book'

    id = Column(String(20), primary_key=True)
    name = Column(String(20))

    ## 多的一方的book表是通过外键关联到user表的
    user_id = Column(String(20), ForeignKey('user.id'))
