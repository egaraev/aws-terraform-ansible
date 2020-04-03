import flask, os, socket, subprocess, requests, json, consul, sys
from flask import Flask
import time
import json
import MySQLdb
import pika
import time
import datetime

SELF_HOSTNAME = str(socket.gethostname())
SELF_IP = socket.gethostbyname(SELF_HOSTNAME)



time.sleep(5) # seconds

# fetch consul's ip, so that we can talk to it.
CONSUL_ALIAS = 'consul'
CONSUL_PORT = '8500'
CONSUL_IP = subprocess.check_output(['getent', 'hosts', CONSUL_ALIAS]).decode().split()[0]



# create consul instance (not agent, just python instance)
c = consul.Consul(host=CONSUL_IP, port=CONSUL_PORT)

# get mongodb IP
keyindex, mysqldb_ip_bytes = c.kv.get('mysqldb')
mysqldb_ip = mysqldb_ip_bytes['Value'].decode()

keyindex, rabbitmq_ip_bytes = c.kv.get('rabbitmq')
rabbitmq_ip = rabbitmq_ip_bytes['Value'].decode()
rabbitmq_ip_only = rabbitmq_ip.split(":", 1)
rabbitmq_ip_only=rabbitmq_ip_only[0]




# add this webservice to catalog

consul_registry = {
    "id":SELF_HOSTNAME,
    "service": "logmysql",
    "address":SELF_IP,
    "port": 5000
}
#c.catalog.register('flaskapp-node', SELF_IP, service=consul_registry, dc='dc1')


# Register healthcheck
#payload = { 
#    "id": SELF_HOSTNAME,
#    "service": "flaskapp",	
#    "name": "flaskapp", 
#   "port": 5000, 
#    "check": { "name": "Check FlaskApp health", "http": "http://flaskapp:5000/health", "method": "GET", "interval": "10s", "timeout": "1s" } 
#}

url = "http://{}:8500/v1/agent/service/register".format(CONSUL_IP)
headers = {}
res = requests.put(url, data=open('register.json', 'rb'), headers=headers)

# OR we can add to kv
# add to kv
LOGMYSQL_IP = SELF_IP
LOGMYSQL_PORT = '5000'
REGISTRY = ':'.join([LOGMYSQL_IP, LOGMYSQL_PORT])
c.kv.put('logmysql', REGISTRY)




app = Flask(__name__)


credentials = pika.PlainCredentials('user1', 'pass1')
connection = pika.BlockingConnection(pika.ConnectionParameters(rabbitmq_ip_only,5672,'/',credentials))
channel = connection.channel()
channel.queue_declare(queue='logging')

def callback(ch, method, properties, body):
    now = datetime.datetime.now()
    currenttime = now.strftime("%Y-%m-%d %H:%M")
    print(" [x] Received %r" % body)
    try:
        db = MySQLdb.connect("mysqldb", "cryptouser", "123456", "cryptodb")
        cursor = db.cursor()
        cursor.execute('insert into logs(date, log_entry) values("%s", "%s")' % (currenttime, body))
        db.commit()
    except MySQLdb.Error, e:
        print "Error %d: %s" % (e.args[0], e.args[1])
        sys.exit(1)
    finally:
        db.close()

channel.basic_consume('logging', callback, auto_ack=True)

print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()





@app.route('/')
def hello_world():
    text = """Welcome to webservice. <br>
              Host IP: %s <br>
              MongoDB IP: %s <br>
			  RabitMQ IP: %s <br>
			  Redis IP: %s <br>
           """ % (SELF_IP, mongodb_ip, rabbitmq_ip, redis_ip)
    return text, 200

	
@app.route('/health')
def health():
    data = {
        'status': 'healthy'
    }
    return json.dumps(data)	
	
	
	
if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
