# coding:utf8


#user:pwd
file_dict = {}

# file ---> dict 文件到dict的同步
## 将文件中的每行按照分号切割,存储到dict中
def read_file():
    with open('user.txt') as f:
        #print f.read().split('\n')
        for line in f.read().split('\n'):
            if line:
               temp = line.split(':')
               file_dict[temp[0]] = temp[1]

#read_file()
#print file_dict
#file_dict['df'] = 123

# dict ---> file  将dict中的内容再写回文件中
def write_file():
    file_arr = []
    for user,pwd in file_dict.items():
        file_arr.append('%s:%s' % (user,pwd))
      
    with open('user.txt','w') as f:
        f.write('\n'.join(file_arr))

#write_file()
