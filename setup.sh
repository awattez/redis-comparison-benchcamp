#!/bin/bash

# Get the number of CPU threads
CPUS=$(nproc)
echo "Tests will be executed with ${CPUS} threads using memtier_benchmark."

# Populate the .env file with the number of threads
export CPUS
envsubst < .env.template > .env

# Generate TLS certificates
./generate-certs.sh


# Start services using Docker Compose
docker compose up -d

# Message to verify services are running
echo "Please verify that all services are running using 'docker compose ps'."