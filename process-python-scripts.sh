#!/bin/bash

# Array of services
services=("redis" "keydb" "dragonfly" "valkey" "redis-tls" "keydb-tls" "dragonfly-tls" "valkey-tls")

# Array of thread counts
threads=(1 2 8)

# Function to process benchmarks for a given service and thread count
process_benchmark() {
  local service=$1
  local thread=$2
  local input_file="./benchmarklogs/${service}_benchmarks_${thread}_threads.txt"
  local output_file="./benchmarklogs/${service}_benchmarks_${thread}_threads.md"
  local title="${service} ${thread} Thread(s)"

  if [ -f "$input_file" ]; then
    echo "Processing $input_file"
    python3 python-scripts/parse_memtier_to_md.py "$input_file" "$title"
    cat "$output_file"
  else
    echo "File $input_file does not exist. Skipping."
  fi
}

# Function to combine markdown results for a given service
combine_results() {
  local service=$1
  local output_file="./benchmarklogs/combined_${service}_results.md"
  local input_files=()

  for thread in "${threads[@]}"; do
    input_files+=("./benchmarklogs/${service}_benchmarks_${thread}_threads.md")
  done

  python3 python-scripts/combine_markdown_results.py "${input_files[*]}" "$service"
  cat "$output_file"
  python3 python-scripts/data_charts.py "$output_file" | tee -a data_charts.log

  # Clean up intermediate markdown files
  echo "Cleaning up intermediate markdown files for $service..."
  for thread in "${threads[@]}"; do
    rm -f "./benchmarklogs/${service}_benchmarks_${thread}_threads.md"
  done
}

# Loop through each service and each thread count to process benchmarks
for service in "${services[@]}"; do
  for thread in "${threads[@]}"; do
    process_benchmark "$service" "$thread"
  done
  # Combine results for the current service
  combine_results "$service"
done

echo "Please update the data tables in latency-charts.py and opssec-charts.py based on the output above to generate the graphs."
echo "After updating the data, run the following commands to generate the charts:"
echo "python3 python-scripts/latency-charts.py"
echo "python3 python-scripts/opssec-charts.py"


echo "Processing completed."
