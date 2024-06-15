#!/usr/bin/env python3
# pip install matplotlib numpy
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime

# Data
labels = ['1 Thread Sets', '1 Thread Gets', '1 Thread Totals', '2 Threads Sets', '2 Threads Gets', '2 Threads Totals', '8 Threads Sets', '8 Threads Gets', '8 Threads Totals']

ops_sec_data = [
    [3365.54, 50483.12, 53848.66, 4896.31, 73444.7, 78341.01, 10092.64, 151389.63, 161482.27], # Redis
    [3464.71, 51970.63, 55435.34, 6394.98, 95924.73, 102319.71, 12067.77, 181016.48, 193084.25], # KeyDB
    [2382.72, 35740.78, 38123.5, 4486.14, 67292.15, 71778.3, 15871.04, 238065.56, 253936.6], # Dragonfly
    [3156.78, 47351.68, 50508.46, 5023.13, 75346.91, 80370.03, 9969.68, 149545.22, 159514.91] # Valkey
]

# Update chart title

fig, ax = plt.subplots(figsize=(14, 10))

# Plot data
width = 0.2
x = np.arange(len(labels))
rects1 = ax.bar(x - 1.5*width, ops_sec_data[0], width, label='Redis 7.2.5', color='blue')
rects2 = ax.bar(x - 0.5*width, ops_sec_data[1], width, label='KeyDB 6.3.4', color='green')
rects3 = ax.bar(x + 0.5*width, ops_sec_data[2], width, label='Dragonfly 1.19.0', color='red')
rects4 = ax.bar(x + 1.5*width, ops_sec_data[3], width, label='Valkey 7.2.5', color='orange')


# Add some text for labels, title, and custom x-axis tick labels, etc.
ax.set_xlabel('Type of Operation and Threads')
ax.set_ylabel('Ops/Sec')
ax.set_title('Redis vs KeyDB vs Dragonfly vs Valkey Memtier Benchmarks on AWS r6gd.4xlarge\nby AWA inspired by George Liu')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()

# Attach data labels
def attach_data_labels(rects):
    """Attach a text label above each bar in *rects*, displaying its height, rounded to 0 decimal places."""
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(int(round(height))),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')

attach_data_labels(rects1)
attach_data_labels(rects2)
attach_data_labels(rects3)
attach_data_labels(rects4)

plt.tight_layout()
current_date = datetime.now().strftime('%Y%m%d')
plt.savefig(f'redis-keydb-dragonfly-valkey-opssec-gaussian-{current_date}.png')
plt.close()