#!/bin/bash
# generate_large_files.sh

# Directory to store large files
OUTPUT_DIR="/data"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Generate large files until the disk is full
while true; do
  dd if=/dev/zero of=${OUTPUT_DIR}/file_$(date +%s).dat bs=1M count=1024
done
