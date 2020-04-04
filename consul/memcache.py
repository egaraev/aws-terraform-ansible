from pymemcache.client import base
import pymysql

username = 'eldar'

client = base.Client(('localhost', 11211))
result = client.get(username)

def query_db(username):
    db_connection = pymysql.connect("172.18.0.14","cryptouser","123456","cryptodb" )
    c = db_connection.cursor()
    try:
        c.execute('SELECT * FROM users where username = "{k}"'.format(k=username))
        data = c.fetchone()[0]
        db_connection.close()
    except:
        data = 'invalid'
    return data

if result is None:
    print("got a miss, need to get the data from db")
    result = query_db(username)
    if result == 'invalid':
        print("requested data does not exist in db")
    else:
        print("returning data to client from db")
        print("=> Username: {p}, ID: {d}".format(p=username, d=result))
        print("setting the data to memcache")
        client.set(username, result)

else:
    print("got the data directly from memcache")
    print("=> Username: {p}, ID: {d}".format(p=username, d=result))