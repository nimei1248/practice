import MySQLdb as mysql
conn = mysql.connect(user='woniu', passwd='123456', host='59.110.12.72', db='woniu')
conn.autocommit(True)
cur = conn.cursor()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/idclist')
    cur.execute('select * from idc')
    res = cur.fetchall()
    return json.dumps(res)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9092, debug=True)
