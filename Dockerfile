FROM python:3

WORKDIR /var/app

COPY requirements.txt ./
RUN pip install -U pip -r requirements.txt && pip install gunicorn

COPY manage.py runserver.sh ./
COPY django_tutorial ./django_tutorial/
COPY polls ./polls/

EXPOSE 8000

CMD ["./runserver.sh"]
