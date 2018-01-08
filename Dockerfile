FROM polls-base

WORKDIR /var/app
RUN touch .in_docker
COPY run-server.sh manage.py requirements.txt ./

COPY django_tutorial ./django_tutorial/
COPY polls           ./polls/
COPY templates       ./templates/

RUN pip install -r requirements.txt
RUN python3 manage.py collectstatic

CMD ["./run-server.sh"]
