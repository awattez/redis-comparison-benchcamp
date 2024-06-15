#!/usr/bin/env python3
# pip install matplotlib numpy
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime

# Data for x-axis labels and bar width
labels = ['1 Thread Sets', '1 Thread Gets', '1 Thread Totals', '2 Threads Sets', '2 Threads Gets', '2 Threads Totals', '8 Threads Sets', '8 Threads Gets', '8 Threads Totals']
width = 0.2
x = np.arange(len(labels))  # Defining x variable

# Updated Data for latencies
avg_latency_data = [
    [5.21842, 2.71392, 2.87046, 11.28312, 6.32827, 6.63782, 27.00248, 26.58489, 26.61082], # Redis
    [4.48665, 2.91563, 3.01382, 9.38607, 5.34626, 5.59875, 29.00708, 27.85778, 27.92919], # KeyDB
    [6.16445, 4.29512, 4.41196, 10.60894, 7.18811, 7.40191, 36.72427, 35.43788, 35.51784],  # Dragonfly
    [5.52166, 2.9505, 3.11119, 10.85543, 6.41036, 6.68802, 27.93882, 27.86128, 27.86609] # Valkey
]

p50_latency_data = [
    [2.623, 2.607, 2.607, 6.303, 6.207, 6.207, 27.007, 26.879, 26.879], # Redis
    [2.911, 2.895, 2.895, 5.055, 5.023, 5.023, 28.671, 28.543, 28.543], # KeyDB
    [4.095, 4.095, 4.095, 7.199, 7.263, 7.263, 28.159, 28.159, 28.159],  # Dragonfly
    [2.863, 2.831, 2.831, 6.271, 6.239, 6.239, 27.903, 27.903, 27.903] # Valkey
]

p99_latency_data = [
    [4.767, 3.967, 4.031, 12.991, 11.711, 11.711, 50.431, 50.175, 50.175], # Redis
    [6.943, 6.079, 6.111, 12.351, 10.559, 10.559, 54.015, 52.735, 52.991], # KeyDB
    [11.519, 10.687, 10.751, 14.847, 12.927, 12.991, 144.383, 138.239, 138.239], # Dragonfly
    [5.343, 4.159, 4.351, 11.455, 10.495, 10.559, 50.175, 50.687, 50.687] # Valkey
]

def plot_latency_chart(data, title, filename_suffix):
    fig, ax = plt.subplots(figsize=(14, 10))

    # Plot data
    rects1 = ax.bar(x - 1.5*width, data[0], width, label='Redis', color='blue')
    rects2 = ax.bar(x - 0.5*width, data[1], width, label='KeyDB', color='green')
    rects3 = ax.bar(x + 0.5*width, data[2], width, label='Dragonfly', color='red')
    rects4 = ax.bar(x + 1.5*width, data[3], width, label='Valkey', color='orange')

    # Labels, title and ticks
    ax.set_xlabel('Type of Operation and Threads')
    ax.set_ylabel('Latency (ms)')
    ax.set_title(f'Redis vs KeyDB vs Dragonfly vs Valkey {title}\nby AWA inspired by George Liu')
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.legend()

    # Attach data labels
    def attach_vertical_data_labels(rects):
        """Attach a text label above each bar in *rects*, displaying its height, rounded to 2 decimal places."""
        for rect in rects:
            height = rect.get_height()
            ax.annotate('{}'.format(round(height, 2)),
                        xy=(rect.get_x() + rect.get_width() / 2, height),
                        xytext=(0, 3),  # 3 points vertical offset
                        textcoords="offset points",
                        ha='center', va='bottom')

    attach_vertical_data_labels(rects1)
    attach_vertical_data_labels(rects2)
    attach_vertical_data_labels(rects3)
    attach_vertical_data_labels(rects4)

    plt.tight_layout()

    # Get current date in YYYYMMDD format
    current_date = datetime.now().strftime('%Y%m%d')

    # Save the figure with the date in the filename
    plt.savefig(f'redis-keydb-dragonfly-valkey-{filename_suffix}-{current_date}.png')
    plt.close()

# Plotting the 3 charts
plot_latency_chart(avg_latency_data, 'Average Latency (ms)', 'avg-latency')
plot_latency_chart(p50_latency_data, 'p50 Latency (ms)', 'p50-latency')
plot_latency_chart(p99_latency_data, 'p99 Latency (ms)', 'p99-latency')