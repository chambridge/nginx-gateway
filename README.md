# nginx-gateway
Provide example setup for an nginx gateway setup using ubi9/nginx-124

## Setup Instructions

### Generate certificates
Run the provided script to create mTLS certificates in the certs directory.

```
./generate_certs.sh
```

This generates:
- `certs/ca.crt`, `certs/ca.key`: CA certificate and key
- `certs/nginx.crt`, `certs/nginx.key`: NGINX server certificate and key
- `certs/client.crt`, `certs/client.key`: Client certificate and key for testing

### Build the Container Image
Ensure all required files are in the current directory, then build the image:

```
podman build -t nginx-gateway:latest .
```

The image includes:
- NGINX configuraton with mTLS and custom headers.
- JSON templates.
- Mounts the static files (`insights-core.egg`, `insights-core.egg.asc`).
- Mounts the certificate files.

### Run the Container
Create a podman network and run the container with a mounted socket directory:

```
podman compose up
```
This currently creates the upstream dependencies for the reverse proxy routing.

_Still working through the unix socket interaction with mTLS._


### Example Usage

#### Basic Request

```
curl http://localhost:8080/api/inventory/v1/hosts
```

- Response: Proxied to inventory-api pod
- Headers generated request id, empty identity header

#### Request with passed x-alt-req-id

```
curl -H"x-alt-req-id: 1111-2222-3333-4444" http://localhost:8080/api/inventory/v1/hosts
```

- Headers pass on the request id and create empty identity header

#### cert-auth Type

```
curl -H"x-auth-type: cert-auth" -H"x-cn: cn-id-example" -H"x-org-id: 1234567" http://localhost:8080/api/inventory/v1/hosts
```

- Headers generates request is and formats populates a cert identity header json

#### jwt-auth Type

```
USER=`echo "{\"username\":\"jdoe\", \"email\": \"jdoe@examle.com\", \"first_name\": \"John\", \"last_name\": \"Doe\"}" | base64`
curl -H"x-auth-type: jwt-auth" \
    -H"x-user: $USER" \
    -H"x-org-id: 1234567" \
    http://localhost:8080/api/inventory/v1/hosts
```

- Headers generates request is and formats populates a jwt identity header json
