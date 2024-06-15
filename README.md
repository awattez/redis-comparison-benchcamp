# Forked Redis Comparison Benchmarks

[![Benchmark Redis vs KeyDB](https://github.com/centminmod/redis-comparison-benchmarks/actions/workflows/benchmarks.yml/badge.svg)](https://github.com/centminmod/redis-comparison-benchmarks/actions/workflows/benchmarks.yml)


# Redis vs KeyDB vs Dragonfly vs Valkey With IO Threads

I have forked the initial project from [centminmod/redis-comparison-benchmarks](https://github.com/centminmod/redis-comparison-benchmarks) and conducted more intensive tests using the `memtier_benchmark` command. The command used is:

\```bash
memtier_benchmark -s "$service_name" --ratio=1:15 -p 6379 --protocol=redis -t 1 --random-data --data-size-range=4-1024 --data-size-pattern=S --key-minimum=200 --key-maximum=800 --key-pattern=G:G --distinct-client-seed --hide-histogram --requests=8000 --clients=400 --pipeline=1
\```

# Results:

## Dragonfly

| Database              | Type  | Ops/sec  | Hits/sec  | Misses/sec | Avg Latency | p50 Latency | p99 Latency | p99.9 Latency | KB/sec  |
|-----------------------|-------|----------|-----------|------------|-------------|-------------|-------------|---------------|---------|
| dragonfly 1 Thread(s) | Sets  | 2382.72  | ---       | ---        | 10.48085    | 9.72700     | 43.77500    | 67.07100      | 1298.95 |
| dragonfly 1 Thread(s) | Gets  | 35740.78 | 35666.15  | 74.63      | 10.49021    | 9.72700     | 44.79900    | 67.07100      | 19252.21|
| dragonfly 1 Thread(s) | Totals| 38123.50 | 35666.15  | 74.63      | 10.48963    | 9.72700     | 44.54300    | 67.07100      | 20551.16|
| dragonfly 2 Thread(s) | Sets  | 4486.14  | ---       | ---        | 11.29166    | 10.11100    | 49.91900    | 69.63100      | 2442.57 |
| dragonfly 2 Thread(s) | Gets  | 67292.15 | 67292.15  | 0.00       | 11.27635    | 10.11100    | 49.40700    | 69.63100      | 36317.26|
| dragonfly 2 Thread(s) | Totals| 71778.30 | 67292.15  | 0.00       | 11.27731    | 10.11100    | 49.40700    | 69.63100      | 38759.83|
| dragonfly 8 Thread(s) | Sets  | 15871.04 | ---       | ---        | 13.76478    | 11.07100    | 75.26300    | 173.05500     | 8640.72 |
| dragonfly 8 Thread(s) | Gets  | 238065.56| 238065.56 | 0.00       | 13.76347    | 11.00700    | 75.77500    | 175.10300     | 128466.33|
| dragonfly 8 Thread(s) | Totals| 253936.60| 238065.56 | 0.00       | 13.76355    | 11.00700    | 75.77500    | 175.10300     | 137107.05|

## KeyDB

| Database           | Type  | Ops/sec  | Hits/sec  | Misses/sec | Avg Latency | p50 Latency | p99 Latency | p99.9 Latency | KB/sec  |
|--------------------|-------|----------|-----------|------------|-------------|-------------|-------------|---------------|---------|
| keydb 1 Thread(s)  | Sets  | 3464.71  | ---       | ---        | 7.25782     | 6.81500     | 20.09500    | 61.43900      | 1888.81 |
| keydb 1 Thread(s)  | Gets  | 51970.63 | 51862.32  | 108.31     | 7.21128     | 6.68700     | 26.49500    | 61.95100      | 27994.80|
| keydb 1 Thread(s)  | Totals| 55435.34 | 51862.32  | 108.31     | 7.21419     | 6.68700     | 26.11100    | 61.95100      | 29883.61|
| keydb 2 Thread(s)  | Sets  | 6394.98  | ---       | ---        | 7.89124     | 7.32700     | 33.02300    | 63.99900      | 3481.88 |
| keydb 2 Thread(s)  | Gets  | 95924.73 | 95924.73  | 0.00       | 7.81388     | 7.26300     | 31.48700    | 63.74300      | 51770.13|
| keydb 2 Thread(s)  | Totals| 102319.71| 95924.73  | 0.00       | 7.81871     | 7.26300     | 31.61500    | 63.74300      | 55252.01|
| keydb 8 Thread(s)  | Sets  | 12067.77 | ---       | ---        | 16.79999    | 14.07900    | 51.96700    | 71.67900      | 6570.09 |
| keydb 8 Thread(s)  | Gets  | 181016.48| 181016.48 | 0.00       | 16.80303    | 14.07900    | 51.96700    | 71.67900      | 97681.17|
| keydb 8 Thread(s)  | Totals| 193084.25| 181016.48 | 0.00       | 16.80284    | 14.07900    | 51.96700    | 71.67900      | 104251.26|

## Redis

| Database           | Type  | Ops/sec  | Hits/sec  | Misses/sec | Avg Latency | p50 Latency | p99 Latency | p99.9 Latency | KB/sec  |
|--------------------|-------|----------|-----------|------------|-------------|-------------|-------------|---------------|---------|
| redis 1 Thread(s)  | Sets  | 3365.54  | ---       | ---        | 7.43256     | 6.81500     | 28.15900    | 61.43900      | 1834.74 |
| redis 1 Thread(s)  | Gets  | 50483.12 | 50377.51  | 105.61     | 7.42637     | 6.81500     | 28.03100    | 61.43900      | 27193.28|
| redis 1 Thread(s)  | Totals| 53848.66 | 50377.51  | 105.61     | 7.42675     | 6.81500     | 28.03100    | 61.43900      | 29028.03|
| redis 2 Thread(s)  | Sets  | 4896.31  | ---       | ---        | 10.32119    | 9.15100     | 45.82300    | 77.31100      | 2665.90 |
| redis 2 Thread(s)  | Gets  | 73444.70 | 73444.70  | 0.00       | 10.30835    | 9.15100     | 45.82300    | 76.79900      | 39637.76|
| redis 2 Thread(s)  | Totals| 78341.01 | 73444.70  | 0.00       | 10.30915    | 9.15100     | 45.82300    | 76.79900      | 42303.66|
| redis 8 Thread(s)  | Sets  | 10092.64 | ---       | ---        | 19.97025    | 17.91900    | 79.87100    | 106.49500     | 5494.77 |
| redis 8 Thread(s)  | Gets  | 151389.63| 151389.63 | 0.00       | 19.93128    | 17.91900    | 80.38300    | 106.49500     | 81693.75|
| redis 8 Thread(s)  | Totals| 161482.27| 151389.63 | 0.00       | 19.93371    | 17.91900    | 80.38300    | 106.49500     | 87188.52|

## Valkey

| Database           | Type  | Ops/sec  | Hits/sec  | Misses/sec | Avg Latency | p50 Latency | p99 Latency | p99.9 Latency | KB/sec  |
|--------------------|-------|----------|-----------|------------|-------------|-------------|-------------|---------------|---------|
| valkey 1 Thread(s) | Sets  | 3156.78  | ---       | ---        | 7.93371     | 7.58300     | 32.25500    | 62.20700      | 1720.94 |
| valkey 1 Thread(s) | Gets  | 47351.68 | 47252.82  | 98.85      | 7.91658     | 7.58300     | 31.23100    | 61.95100      | 25506.62|
| valkey 1 Thread(s) | Totals| 50508.46 | 47252.82  | 98.85      | 7.91765     | 7.58300     | 31.23100    | 61.95100      | 27227.56|
| valkey 2 Thread(s) | Sets  | 5023.13  | ---       | ---        | 10.07307    | 8.95900     | 43.51900    | 74.75100      | 2734.95 |
| valkey 2 Thread(s) | Gets  | 75346.91 | 75346.91  | 0.00       | 10.08764    | 8.95900     | 44.79900    | 75.26300      | 40664.37|
| valkey 2 Thread(s) | Totals| 80370.03 | 75346.91  | 0.00       | 10.08673    | 8.95900     | 44.79900    | 75.26300      | 43399.32|
| valkey 8 Thread(s) | Sets  | 9969.68  | ---       | ---        | 20.16873    | 18.17500    | 81.40700    | 106.49500     | 5427.83 |
| valkey 8 Thread(s) | Gets  | 149545.22| 149545.22 | 0.00       | 20.17778    | 18.17500    | 81.40700    | 106.49500     | 80698.47|
| valkey 8 Thread(s) | Totals| 159514.91| 149545.22 | 0.00       | 20.17721    | 18.17500    | 81.40700    | 106.49500     | 86126.29|
