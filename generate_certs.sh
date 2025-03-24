#!/bin/bash

CERT_DIR="certs"

mkdir -p "$CERT_DIR"

openssl genrsa -out "$CERT_DIR/ca.key" 2048
openssl req -new -x509 -days 365 -key "$CERT_DIR/ca.key" -out "$CERT_DIR/ca.crt" -subj "/O=MyOrg/CN=MyCA" -nodes

openssl genrsa -out "$CERT_DIR/nginx.key" 2048
openssl req -new -key "$CERT_DIR/nginx.key" -out "$CERT_DIR/nginx.crt" -subj "/O=MyOrg/CN=nginx"

openssl genrsa -out "$CERT_DIR/client.key" 2048
openssl req -new -key "$CERT_DIR/client.key" -out "$CERT_DIR/client.csr" -subj "/O=MyOrg/CN=client"

openssl x509 -req -days 365 -in "$CERT_DIR/client.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/client.crt"

rm -f "$CERT_DIR/nginx.csr" "$CERT_DIR/client.csr"

chmod 600 "$CERT_DIR/ca.key" "$CERT_DIR/nginx.key" "$CERT_DIR/client.key"
chmod 644 "$CERT_DIR/ca.crt" "$CERT_DIR/nginx.crt" "$CERT_DIR/client.crt"
