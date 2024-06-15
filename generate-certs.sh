#!/bin/bash


if [ -d "tls" ]; then
  echo "tls directory already exists - skip"
  exit 0
fi

mkdir tls
pushd tls || exit

# Generate CA
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out ca.key
openssl req -new -x509 -days 365 -key ca.key -out ca.crt -subj "/C=FR/ST=Some-State/O=OrganizationName/OU=OrganizationalUnit/CN=CA"

# Generate server's private key and certificate signing request (CSR)
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out server.key
openssl req -new -key server.key -out server.csr -subj "/C=FR/ST=Some-State/O=OrganizationName/OU=OrganizationalUnit/CN=server"

# Sign the server's CSR with the CA's private key to get the server's certificate
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365

# Generate client's private key and CSR
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out client.key
openssl req -new -key client.key -out client.csr -subj "/C=FR/ST=Some-State/O=OrganizationName/OU=OrganizationalUnit/CN=client"

# Sign the client's CSR with the CA's private key to get the client's certificate
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365

# Update certificate permissions
chmod 644 ./*

popd || exit

# list certs
ls -lAhRt