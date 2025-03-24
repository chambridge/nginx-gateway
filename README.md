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
- Static files (`insights-core.egg`, `insights-core.egg.asc`).
- Certificates and JSON templates.

### Run the Container
Create a podman network and run the container with a mounted socket directory:

```
podman network create my-network

podman run -d --network my-network \
    --name nginx-gateway \ 
    -v /path/to/sockets:/sockets:Z \
    nginx-gateway:latest

### Example Usage
NGINX listens on /sockets/nginx.sock with mTLS. Use curl with the --unix-socket option and client certificates to test.

#### Common curl Options

```
BASE_CMD="curl --unix-socket /path/to/sockets/nginx.sock \
    --cert certs/client.crt \
    --key certs/client.key \
    -v"
```

#### Basic Request

```
$BASE_CMD https://localhost/api/inventory/v1/hosts
```

- Response: Proxied to inventory-api pod
- Headers generated request id, empty identity header

#### Request with passed x-alt-req-id

```
$BASE_CMD -H"x-alt-req-id: 1111-2222-3333-4444" https://localhost/api/inventory/v1/hosts
```

- Headers pass on the request id and create empty identity header

#### cert-auth Type

```
$BASE_CMD \
    -H"x-auth-type: cert-auth" \
    -H"x-cn: cn-id-example" \
    -H"x-org-id: 1234567" \
    https://localhost/api/inventory/v1/hosts
```

- Headers generates request is and formats populates a cert identity header json

#### jwt-auth Type

```
$BASE_CMD \
    -H"x-auth-type: jwt-auth" \
    -H"x-user: {\"username\":\"jdoe\", \"email\": \"jdoe@examle.com\", \"first_name\": \"John\", \"last_name\": \"Doe\"}" \
    -H"x-org-id: 1234567" \
    https://localhost/api/inventory/v1/hosts
```

- Headers generates request is and formats populates a jwt identity header json
