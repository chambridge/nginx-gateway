FROM registry.access.redhat.com/ubi9/nginx-124:latest

USER root

RUN mkdir -p /usr/share/nginx/html/static/release && chown -R nginx:nginx /usr/share/nginx/html

COPY insights-core.egg /usr/share/nginx/html/static/release/insights-core.egg
COPY insights-core.egg.asc /usr/share/nginx/html/static/release/insights-core.egg.asc

RUN mkdir -p /sockets && chown nginx:nginx /sockets

RUN mkdir -p /etc/nginx/certs && chown nginx:nginx /etc/nginx/certs
COPY certs/nginx.crt /etc/nginx/certs/nginx.crt
COPY certs/nginx.key /etc/nginx/certs/nginx.key
COPY certs/ca.crt /etc/nginx/certs/ca.crt

RUN mkdir -p /etc/nginx/njs && chown nginx:nginx /etc/nginx/njs
COPY cert_identity.json /etc/nginx/njs/cert_identity.json
COPY jwt_identity.json /etc/nginx/njs/jwt_identity.json
COPY identity.js /etc/nginx/njs/identity.js

COPY nginx.conf /etc/nginx/nginx.conf

ENV ORG_ID="1001"

USER nginx
