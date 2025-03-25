#!/bin/bash

CERT_DIR="certs"

mkdir -p "$CERT_DIR"

openssl genrsa -out "$CERT_DIR/ca.key" 2048
openssl req -new -x509 -new -nodes -key "$CERT_DIR/ca.key" -sha256  -days 365 -out "$CERT_DIR/ca.crt" -subj "/O=MyOrg/CN=MyCA"

openssl genrsa -out "$CERT_DIR/nginx.key" 2048
openssl req -new -key "$CERT_DIR/nginx.key" -out "$CERT_DIR/nginx.csr" -subj "/O=MyOrg/CN=nginx"

openssl x509 -req -in "$CERT_DIR/nginx.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/nginx.crt" -days 365 -sha256

openssl genrsa -out "$CERT_DIR/client.key" 2048
openssl req -new -key "$CERT_DIR/client.key" -out "$CERT_DIR/client.csr" -subj "/O=MyOrg/CN=client"

openssl x509 -req -in "$CERT_DIR/client.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/client.crt" -days 365 -sha256

rm -f "$CERT_DIR/nginx.csr" "$CERT_DIR/client.csr"

chmod 600 "$CERT_DIR/ca.key" "$CERT_DIR/nginx.key" "$CERT_DIR/client.key"
chmod 644 "$CERT_DIR/ca.crt" "$CERT_DIR/nginx.crt" "$CERT_DIR/client.crt"
