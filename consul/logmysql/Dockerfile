FROM egaraev/basecentos:latest
COPY . /logmysql
WORKDIR /logmysql
RUN pip install -r requirements.txt
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
ENTRYPOINT ["python"]
CMD ["app.py"]
