import flask, os, socket, subprocess, requests, json, consul
from flask import Flask
import time

SELF_HOSTNAME = str(socket.gethostname())
SELF_IP = socket.gethostbyname(SELF_HOSTNAME)


time.sleep(5) # seconds

# fetch consul's ip, so that we can talk to it.
CONSUL_ALIAS = 'consul'
CONSUL_PORT = '8500'
CONSUL_IP = subprocess.check_output(['getent', 'hosts', CONSUL_ALIAS]).decode().split()[0]

consul_registry = {
    "id":SELF_HOSTNAME,
    "service": "flaskapp",
    "address":SELF_IP,
    "port": 5000
}

# create consul instance (not agent, just python instance)
c = consul.Consul(host=CONSUL_IP, port=CONSUL_PORT)

# get rabbitmq IP
keyindex, mongodb_ip_bytes = c.kv.get('mongodb')


mongodb_ip = mongodb_ip_bytes['Value'].decode()


# add webservice to catalog
c.catalog.register('flaskapp-node', SELF_IP, service=consul_registry, dc='dc1')

app = Flask(__name__)

@app.route('/')
def hello_world():
    text = """Welcome to webservice. <br>
              Host ID: %s <br>
              MongoDB IP: %s <br>
			  
           """ % (SELF_HOSTNAME, mongodb_ip)
    return text, 200

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
