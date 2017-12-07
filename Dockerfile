FROM ubuntu:16.04

WORKDIR /var/app
COPY ./setup-server.sh run-server.sh manage.py requirements.txt ./

RUN ./setup-server.sh

COPY django_tutorial ./django_tutorial/
COPY polls ./polls/

RUN pip install -U pip -r requirements.txt && pip install gunicorn

EXPOSE 8000

CMD ["./run-server.sh"]
