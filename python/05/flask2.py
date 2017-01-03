# coding:utf8

## request 获取参数
## render_template 渲染模版文件,默认的模版文件在templates文件夹下面
## redirect 跳转
from flask import Flask,request,render_template,redirect 
import mem2
import register

## 新建app
app = Flask(__name__)

## 监听一个url,路径是根目录
## The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.
## 这种报错说明没有访问监听的url
## 启动了 当我这么写的时候：
#@app.route('/')
#    def index():
#      return render_template('form.html')
#
#访问/form.html 而不是/ 就会报错如上404


#@app.route('/')
#@app.route('/meminfo.html')
#@app.route('/form.html')
@app.route('/login.html')
def index():
    #return "hello world"

    ## 使用模版替代open展示
    #return render_template('meminfo.html')
    #return render_template('form.html')
    #return render_template('login.html')
    
    user_list = [['user','pwd'], ['fuck','nimei'], ['abc','123']]
    return render_template('login.html', error_msg='xxx', ulist=user_list)

## 监听一个url,路径是/huoying
@app.route('/huoying')

## 当这个路由被访问的时候,触发下面这个函数执行
def huoying():
    ## 函数的返回值会显示在浏览器中
    #return 'huoying xxx123'

    ## request
    ## http://192.168.200.8:9092/huoying
    ## http://192.168.200.8:9092/huoying?username=fuck&password=123
    print request.args

    ## get方法获取url参数
    user = request.args.get('username')
    pwd = request.args.get('password')
    return 'huoying %s:%s' % (user, pwd)

## 练习浏览器中显示内存信息,导入模块mem2
@app.route('/mem')
def memxx():
    return mem2.getMem()

## 定义统一的错误页面
@app.route('/error')
def error():
    return '<img width="100%" src="http://www.laoshiz.com/uploads/allimg/140218/2136352614-2.jpg">'

## 练习浏览器输入用户名和密码,点击提交
## 后端的user.txt文件中判断是不是有权限登录
## template/login.html 页面中定义的action对应的函数
@app.route('/login')
def login():
    user = request.args.get('user')
    pwd = request.args.get('pwd')
    if register.register(user,pwd) == 'error': 
        return redirect('/error')
    return register.register(user,pwd)


## 启动应用
if __name__ == '__main__':
    ## host允许所有ip port监听的端口 debug调试
    app.run(host='0.0.0.0',port=9092,debug=True)
