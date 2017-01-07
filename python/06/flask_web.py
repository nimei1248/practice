# coding:utf8


from flask import Flask,request,render_template,redirect,session
import fileutil
fileutil.read_file()


app = Flask(__name__)

app.secret_key = 'nimei A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'


import MySQLdb as mysql
conn = mysql.connect(user='root',passwd='123456',host='localhost',db='reboot12',unix_socket='/mysqldata/inst1/sock/mysql.sock')
#设置自动提交
conn.autocommit(True)
cur = conn.cursor()
cur.execute('select * from woniu_user')
print cur.fetchall()


## 一个route,实现get + post,如果是post,前端的页面form需要添加方法method='post'
#@app.route('/login', method=['GET','POST'])
#def login2():
#    print request.method
#    if request.method == 'GET':
#        return render_template('login.html')
#    elif request.method == 'POST':
#        user = request.form.get('user')


@app.route('/')
def index():
    if 'username' in session:
        return redirect('/list')
    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('username')
    return redirect('/')


@app.route('/loginaction')
def login():
    user = request.args.get('user')
    pwd = request.args.get('pwd')

    error_msg = ''
    if user and pwd:
        if user == 'admin' and pwd == 'admin':
            session['username'] = 'admin'
            return redirect('/list')
        else:
            error_msg = 'wrong user or password.'
    else:
        error_msg = 'need input user and password'

    return render_template('login.html', error_msg = error_msg)



## 删除路由操作
@app.route('/del')
def del_user():
    user = request.args.get('user')
    fileutil.file_dict.pop(user)
    fileutil.write_file()
    return redirect('/list')


@app.route('/update')
def update():
    user = request.args.get('user')
    pwd = fileutil.file_dict.get(user)
    return render_template('update.html',pwd=pwd,user=user)


## 更新操作路由
@app.route('/updateaction')
def updateaction():
    new_pwd = request.args.get('new_pwd')
    user = request.args.get('user')
    fileutil.file_dict[user] = new_pwd
    fileutil.write_file()
    return redirect('/list')


## 添加用户路由
@app.route('/adduser')
def adduser():
    user = request.args.get('user')
    pwd = request.args.get('pwd')

    #sql = 'select user from woniu_user where user="%s"' % user
    #cur.execute(sql)
    #if user in cur.fetchall():
    if user in fileutil.file_dict:
        return redirect('/list')
    else:
        #fileutil.file_dict[user] = pwd
        #fileutil.write_file()

        sql = 'insert into woniu_user values ("%s","%s")' % (user,pwd)
        cur.execute(sql)
        return redirect('/list')


## 用户列表信息
@app.route('/list')
def userlist():
    res = cur.execute('select * from woniu_user')
    print res  ## 返回sql操作影响的行数
    #print cur.fetchall()
    if 'username' in session:
        #return render_template('list.html', userlist=fileutil.file_dict.items())
        return render_template('list.html', userlist=cur.fetchall())
    else:
        return redirect('/')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9092, debug=True)
