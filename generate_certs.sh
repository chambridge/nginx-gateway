#!/bin/bash

CERT_DIR="certs"

mkdir -p "$CERT_DIR"

openssl genpkey -algorithm RSA -out "$CERT_DIR/ca.key"
openssl req -new -x509 -key "$CERT_DIR/ca.key" -out "$CERT_DIR/ca.crt"

openssl genpkey -algorithm RSA -out "$CERT_DIR/nginx.key"
openssl req -new -key "$CERT_DIR/nginx.key" -out "$CERT_DIR/nginx.csr"
openssl x509 -req -in "$CERT_DIR/nginx.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/nginx.crt"

openssl genpkey -algorithm RSA -out "$CERT_DIR/client.key"
openssl req -new -key "$CERT_DIR/client.key" -out "$CERT_DIR/client.csr"
openssl x509 -req -in "$CERT_DIR/client.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/client.crt"

rm -f "$CERT_DIR/nginx.csr" "$CERT_DIR/client.csr"

chmod 600 "$CERT_DIR/ca.key" "$CERT_DIR/nginx.key" "$CERT_DIR/client.key"
chmod 644 "$CERT_DIR/ca.crt" "$CERT_DIR/nginx.crt" "$CERT_DIR/client.crt"
