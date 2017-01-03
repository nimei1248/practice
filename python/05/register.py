# coding:utf-8

def register(user, pwd):
    with open('user.txt') as f:
            user_list = f.read().split('\n')
            user_pwd = '%s:%s' % (user,pwd)
            if user_pwd in user_list:
                return 'success'
            else:
                return 'error'            
                #return redirect('/error')
