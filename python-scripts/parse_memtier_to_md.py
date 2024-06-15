#!/usr/bin/env python3
import sys

def parse_to_md(filename, prefix):
    with open(filename, 'r') as file:
        lines = file.readlines()

    # Find the ALL STATS section
    start_index = None
    for idx, line in enumerate(lines):
        if "ALL STATS" in line:
            start_index = idx
            break

    if start_index is None:
        raise ValueError(f"'ALL STATS' section not found in {filename}")

    # Skip to the header line
    header_index = start_index + 3

    # Extract data lines, skipping empty lines
    stats_lines = []
    for line in lines[header_index + 1:]:
        stripped_line = line.strip()
        if stripped_line:  # Check if the line is not empty
            stats_lines.append(stripped_line)

    # Add prefix to the first column and format lines
    formatted_lines = [f"| {prefix} | " + " | ".join(line.split()) + " |\n" for line in stats_lines]

    # Construct the complete Markdown table
    header = f"| Database | Type | Ops/sec | Hits/sec | Misses/sec | Avg Latency | p50 Latency | p99 Latency | p99.9 Latency | KB/sec |\n"
    separator = "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |\n"
    body = "".join(formatted_lines)
    md_table = header + separator + body

    with open(filename.replace('.txt', '.md'), 'w') as file:
        file.write(md_table)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        raise ValueError("Expected filename and prefix as arguments.")
    parse_to_md(sys.argv[1], sys.argv[2])