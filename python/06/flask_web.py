# coding:utf8


from flask import Flask,request,render_template,redirect
import fileutil
fileutil.read_file()

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('login.html')


@app.route('/loginaction')
def login():
    user = request.args.get('user')
    pwd = request.args.get('pwd')

    error_msg = ''
    if user and pwd:
        if user == 'admin' and pwd == 'admin':
            return redirect('/list')
        else:
            error_msg = 'wrong user or password.'
    else:
        error_msg = 'need input user and password'

    return render_template('login.html', error_msg = error_msg)


@app.route('/list')
def userlist():                                  ## 字典中的字典转成list
    return render_template('list.html', userlist=fileutil.file_dict.items())


@app.route('/del')
def del_user():
    user = request.args.get('user')
    fileutil.file_dict.pop(user)
    fileutil.write_file()
    return redirect('/list')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9092, debug=True)
