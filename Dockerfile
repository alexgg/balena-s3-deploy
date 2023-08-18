FROM python:alpine3.18

LABEL "com.github.actions.name"="Balena's S3 deploy"
LABEL "com.github.actions.description"="Deploy to balena S3 OS image storage"
LABEL "com.github.actions.icon"="box"
LABEL "com.github.actions.color"="green"

LABEL version="0.1.0"
LABEL repository="https://github.com/alexgg/balena-s3-action"
LABEL maintainer="Alex Gonzalez <alexg@balena.io>"

COPY requirements.txt /data/requirements.txt

RUN pip install --quiet --no-cache-dir -r /data/requirements.txt

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
