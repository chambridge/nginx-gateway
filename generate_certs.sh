#!/bin/bash


CERT_DIR="certs"
CA_SUBJECT="/CN=My CA"
NGINX_SUBJECT="/CN=nginx.example.com"
CLIENT_SUBJECT="/CN=client.example.com"


# Create directory if it doesn't exist
mkdir -p "$CERT_DIR"


# Generate CA key and certificate with specified subject
echo "Generating CA..."
openssl genpkey -algorithm RSA -out "$CERT_DIR/ca.key"
openssl req -new -x509 -key "$CERT_DIR/ca.key" -subj "$CA_SUBJECT" -out "$CERT_DIR/ca.crt"


# Generate nginx server key and certificate with specified subject
echo "Generating nginx server..."
openssl genpkey -algorithm RSA -out "$CERT_DIR/nginx.key"
openssl req -new -key "$CERT_DIR/nginx.key" -subj "$NGINX_SUBJECT" -out "$CERT_DIR/nginx.csr"
openssl x509 -req -in "$CERT_DIR/nginx.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/nginx.crt"


# Generate client key and certificate with specified subject
echo "Generating client..."
openssl genpkey -algorithm RSA -out "$CERT_DIR/client.key"
openssl req -new -key "$CERT_DIR/client.key" -subj "$CLIENT_SUBJECT" -out "$CERT_DIR/client.csr"
openssl x509 -req -in "$CERT_DIR/client.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" -CAcreateserial -out "$CERT_DIR/client.crt"


# Remove intermediate files (nginx and client CSRs)
rm -f "$CERT_DIR/nginx.csr" "$CERT_DIR/client.csr"


# Set appropriate file permissions
echo "Setting file permissions..."
chmod 600 "$CERT_DIR/ca.key" "$CERT_DIR/nginx.key" "$CERT_DIR/client.key"
chmod 644 "$CERT_DIR/ca.crt" "$CERT_DIR/nginx.crt" "$CERT_DIR/client.crt"