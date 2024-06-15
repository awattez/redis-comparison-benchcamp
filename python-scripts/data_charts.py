import re
import sys
import os

labels = ['1 Thread Sets', '1 Thread Gets', '1 Thread Totals',
          '2 Threads Sets', '2 Threads Gets', '2 Threads Totals',
          '8 Threads Sets', '8 Threads Gets', '8 Threads Totals']

def extract_latency_from_md(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    avg_latency_values = []
    p50_latency_values = []
    p99_latency_values = []

    for threads in [1, 2, 8]:
        for operation in ['Sets', 'Gets', 'Totals']:
            pattern = rf"{threads} Thread\(s\) \| {operation} \| \d+\.\d+ \| [\d.\-]+ \| [\d.\-]+ \| ([\d\.]+) \| ([\d\.]+) \| ([\d\.]+) \| [\d\.]+"
            match = re.search(pattern, content)
            if match:
                avg_latency = float(match.group(1))
                p50_latency = float(match.group(2))
                p99_latency = float(match.group(3))
                avg_latency_values.append(avg_latency)
                p50_latency_values.append(p50_latency)
                p99_latency_values.append(p99_latency)
            else:
                print(f"No match found for {threads} Threads {operation}")

    return avg_latency_values, p50_latency_values, p99_latency_values


def extract_opssec_from_md(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    opssec_values = []
    for threads in [1, 2, 8]:
        for operation in ['Sets', 'Gets', 'Totals']:
            pattern = rf"{threads} Thread\(s\) \| {operation} \| (\d+\.\d+) .*? \| ([\d.]+) \| ([\d.]+)"
            match = re.search(pattern, content)
            if match:
                opssec = float(match.group(1))
                opssec_values.append(opssec)

    return opssec_values

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: prepare_data.py <combined_results.md> [<combined_results.md> ...]")
        sys.exit(1)

    file_paths = sys.argv[1:]
    for file_path in file_paths:
        service_name = os.path.basename(file_path).replace('combined_', '').replace('_results.md', '')
        print(f"{labels}")
        opssec = extract_opssec_from_md(file_path)
        print(f"opssec {service_name.capitalize()} matching values: {opssec}")
        latency = extract_latency_from_md(file_path)
        print(f"latency {service_name.capitalize()} matching values: {latency}")
