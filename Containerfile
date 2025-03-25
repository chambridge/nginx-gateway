FROM registry.access.redhat.com/ubi9/nginx-124:latest

USER root

RUN dnf install -y nginx-mod-http-perl \
    && dnf clean all

# Create directories and set permissions
RUN mkdir -p /usr/share/nginx/html/static/release \
    && mkdir -p /sockets \
    && mkdir -p /etc/nginx/certs \
    && mkdir -p /var/log/nginx \
    && mkdir -p /etc/nginx/perl \
    && chown -R nginx:nginx /usr/share/nginx/html /sockets /etc/nginx/certs /var/log/nginx /etc/nginx/perl \
    && chmod 770 /sockets \
    && chmod 770 /var/log/nginx

COPY insights-core.egg /usr/share/nginx/html/static/release/insights-core.egg
COPY insights-core.egg.asc /usr/share/nginx/html/static/release/insights-core.egg.asc

COPY certs/nginx.crt /etc/nginx/certs/nginx.crt
COPY certs/nginx.key /etc/nginx/certs/nginx.key
COPY certs/ca.crt /etc/nginx/certs/ca.crt

RUN mkdir -p /etc/nginx/njs && chown nginx:nginx /etc/nginx/njs
COPY cert_identity.json /etc/nginx/perl/cert_identity.json
COPY jwt_identity.json /etc/nginx/perl/jwt_identity.json
COPY identity.pl /etc/nginx/perl/identity.pl

COPY nginx.conf /etc/nginx/nginx.conf

ENV ORG_ID="1001"

USER nginx

CMD ["nginx", "-g", "daemon off;"]
