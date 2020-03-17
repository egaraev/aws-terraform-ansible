FROM centos:latest
RUN yum install -y gcc python3-devel 
COPY . /app
WORKDIR /app
RUN pip3 install -r requirements.txt
ENTRYPOINT ["python3"]
CMD ["app.py"]
