FROM polls-base

WORKDIR /var/app
RUN touch .in_docker
COPY manage.py requirements.txt ./

RUN pip install -r requirements.txt

COPY django_tutorial ./django_tutorial/
COPY polls           ./polls/
COPY templates       ./templates/
RUN python3 manage.py collectstatic

COPY run-server.sh ./

CMD ["./run-server.sh"]
