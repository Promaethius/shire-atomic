FROM alpine:latest

EXPOSE 8000

COPY ./repo/* /srv/

RUN apk --no-cache --update add python

WORKDIR /srv

CMD python -m SimpleHTTPServer
