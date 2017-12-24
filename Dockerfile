FROM azure

WORKDIR /var/app
COPY run-server.sh manage.py requirements.txt ./

COPY django_tutorial ./django_tutorial/
COPY polls           ./polls/
COPY templates       ./templates/

RUN pip install -r requirements.txt

RUN python manage.py collectstatic

EXPOSE 80 
EXPOSE 22

CMD ["./run-server.sh"]
