FROM azure

WORKDIR /var/app
COPY run-server.sh manage.py requirements.txt ./

COPY django_tutorial ./django_tutorial/
COPY polls           ./polls/

RUN pip install -U pip -r requirements.txt \
 && pip install gunicorn \
 && pip install whitenoise

RUN python manage.py collectstatic

EXPOSE 8000

CMD ["./run-server.sh"]
