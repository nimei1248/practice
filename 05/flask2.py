# coding:utf8

from flask import Flask
import mem2

## 新建app
app = Flask(__name__)

## 监听一个url,路径是根目录
@app.route('/')
def index():
    return "hello world"

## 监听一个url,路径是/huoying
@app.route('/huoying')

## 当这个路由被访问的时候,触发下面这个函数执行
def huoying():
    ## 函数的返回值会显示在浏览器中
    return 'huoying xxx123'

@app.route('/mem')
def memxx():
    return mem2.getMem()

## 启动应用
if __name__ == '__main__':
    ## host允许所有ip port监听的端口 debug调试
    app.run(host='0.0.0.0',port=9092,debug=True)
