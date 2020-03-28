FROM egaraev/basecentos:latest
RUN yum install -y python-pip
COPY buy.py sell.py config.py start.sh start_buy.sh start_sell.sh requirements.txt /usr/local/bin/
WORKDIR /usr/local/bin
RUN pip install -r requirements.txt
RUN chmod +x start.sh start_buy.sh start_sell.sh
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
ENTRYPOINT ["/usr/local/bin/start.sh"]
