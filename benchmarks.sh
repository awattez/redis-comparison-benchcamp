#!/bin/bash

# Down all container
docker compose down -v

# Reset memtier_benchmark's log
echo "Resetting benchmark logs"
rm -rf benchmarklogs && mkdir benchmarklogs

# Exit on error
set -e

echo "==== Kernel Information ===="
uname -r | tee kernel.log
echo "==== CPU Information ===="
lscpu | tee cpu.log
echo "==== Memory Information ===="
free -m | tee memory.log


# Start the base services (redis-cli and memtier)
docker compose up -d redis-cli memtier

check_ping() {
  local service_name=$1
  local tls=$2

  echo "Checking PING response for $service_name"

  if [ "$tls" == "true" ]; then
    until [ "$(docker compose exec redis-cli redis-cli -h "$service_name" -p 6379 --tls --cert "/tls/client.crt" --key "/tls/client.key" --cacert "/tls/ca.crt" PING)" == "PONG" ]; do
        echo "Waiting for $service_name to respond to PING..."
        sleep 1
    done
  else
    until [ "$(docker compose exec redis-cli redis-cli -h "$service_name" -p 6379 PING)" == "PONG" ]; do
      echo "Waiting for $service_name to respond to PING..."
      sleep 1
    done
  fi
  echo "$service_name PING response: PONG"
}

run_benchmark() {
  local service_name=$1
  local tls=$2

  echo "Running memtier_benchmark for $service_name"

  if [ "$tls" == "true" ]; then
        docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --tls --cert "/tls/client.crt" --key "/tls/client.key" --cacert "/tls/ca.crt" --protocol=redis -t 1 --random-data --data-size-range=4-1024 --data-size-pattern=S --key-minimum=200 --key-maximum=800 --key-pattern=G:G  --distinct-client-seed --hide-histogram --requests=8000 --clients=400 --pipeline=1 | tee "./benchmarklogs/${service_name}_benchmarks_1_threads.txt"
        docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --tls --cert "/tls/client.crt" --key "/tls/client.key" --cacert "/tls/ca.crt" --protocol=redis -t 2 --random-data --data-size-range=4-1024 --data-size-pattern=S --key-minimum=200 --key-maximum=800 --key-pattern=G:G  --distinct-client-seed --hide-histogram --requests=8000 --clients=400 --pipeline=1 | tee "./benchmarklogs/${service_name}_benchmarks_2_threads.txt"
        docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --tls --cert "/tls/client.crt" --key "/tls/client.key" --cacert "/tls/ca.crt" --protocol=redis -t 8 --random-data --data-size-range=4-1024 --data-size-pattern=S --key-minimum=200 --key-maximum=800 --key-pattern=G:G  --distinct-client-seed --hide-histogram --requests=8000 --clients=400 --pipeline=1 | tee "./benchmarklogs/${service_name}_benchmarks_8_threads.txt"
    else
        docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --protocol=redis -t 1 --random-data --data-size-range=4-1024 --data-size-pattern=S --key-minimum=200 --key-maximum=800 --key-pattern=G:G  --distinct-client-seed --hide-histogram --requests=8000 --clients=400 --pipeline=1 | tee "./benchmarklogs/${service_name}_benchmarks_1_threads.txt"
        docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --protocol=redis -t 2 --random-data --data-size-range=4-1024 --data-size-pattern=S --key-minimum=200 --key-maximum=800 --key-pattern=G:G  --distinct-client-seed --hide-histogram --requests=8000 --clients=400 --pipeline=1 | tee "./benchmarklogs/${service_name}_benchmarks_2_threads.txt"
        docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --protocol=redis -t 8 --random-data --data-size-range=4-1024 --data-size-pattern=S --key-minimum=200 --key-maximum=800 --key-pattern=G:G  --distinct-client-seed --hide-histogram --requests=8000 --clients=400 --pipeline=1 | tee "./benchmarklogs/${service_name}_benchmarks_8_threads.txt"
    fi


#  if [ "$tls" == "true" ]; then
#      docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --tls --cert "/tls/client.crt" --key "/tls/client.key" --cacert "/tls/ca.crt" --protocol=redis -t 1 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 | tee "./benchmarklogs/${service_name}_benchmarks_1_threads.txt"
#      docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --tls --cert "/tls/client.crt" --key "/tls/client.key" --cacert "/tls/ca.crt" --protocol=redis -t 2 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 | tee "./benchmarklogs/${service_name}_benchmarks_2_threads.txt"
#      docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --tls --cert "/tls/client.crt" --key "/tls/client.key" --cacert "/tls/ca.crt" --protocol=redis -t 8 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 | tee "./benchmarklogs/${service_name}_benchmarks_8_threads.txt"
#  else
#      docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --protocol=redis -t 1 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 | tee "./benchmarklogs/${service_name}_benchmarks_1_threads.txt"
#      docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --protocol=redis -t 2 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 | tee "./benchmarklogs/${service_name}_benchmarks_2_threads.txt"
#      docker compose exec memtier memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --protocol=redis -t 8 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 | tee "./benchmarklogs/${service_name}_benchmarks_8_threads.txt"
#  fi
}

test_service() {
  local service_name=$1
  local tls=$2

  echo "Starting $service_name service"
  docker compose up -d $service_name

  check_ping "$service_name" "$tls"

  run_benchmark "$service_name" "$tls"

  docker compose down $service_name
}

# Test each service individually
test_service "redis"
test_service "keydb"
test_service "dragonfly"
test_service "valkey"

test_service "redis-tls" true
test_service "keydb-tls" true
test_service "dragonfly-tls" true
test_service "valkey-tls" true

# Cleanup Docker containers
docker compose down -v

echo "Benchmarking process completed."