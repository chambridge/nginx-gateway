FROM registry.access.redhat.com/ubi9/nginx-124:latest

USER root

RUN dnf install -y nginx-mod-http-perl perl-JSON-PP \
    && dnf clean all

# Create directories and set permissions
RUN mkdir -p /usr/share/nginx/html/static/release \
    && mkdir -p /sockets \
    && mkdir -p /run \
    && mkdir -p /etc/nginx/certs \
    && mkdir -p /var/log/nginx \
    && mkdir -p /etc/nginx/perl \
    && mkdir -p /var/lib/nginx/tmp/client_body \
    && chmod 770 /var/log/nginx \
    && chmod -R 750 /var/lib/nginx

COPY cert_identity.json /etc/nginx/perl/cert_identity.json
COPY jwt_identity.json /etc/nginx/perl/jwt_identity.json
COPY identity.pl /etc/nginx/perl/identity.pl

# COPY nginx.conf /etc/nginx/nginx.conf

RUN chown -R nginx:nginx /usr/share/nginx/html /sockets /etc/nginx/certs /var/log/nginx /etc/nginx /var/lib/nginx /run

ENV ORG_ID="1001"

USER nginx

CMD ["nginx", "-g", "daemon off;"]
