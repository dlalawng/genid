#!/bin/bash

# Source the genid.sh script to make the genid function available
source genid.sh

# Remove any existing genid_counter file
rm -f /tmp/genid_counter

# Set the number of concurrent processes and IDs per process
num_processes=50
ids_per_process=100

# Run the genid function concurrently from multiple processes
# and collect the generated IDs in the generated_ids.txt file
for ((i=1; i<=num_processes; i++)); do
    (
        for ((j=1; j<=ids_per_process; j++)); do
            genid >> generated_ids.txt
        done
    ) &
done

# Wait for all the concurrent processes to finish
wait

# Check the generated_ids.txt file for duplicates and missing IDs
sorted_ids=$(sort -n generated_ids.txt)
duplicate_count=$(echo "$sorted_ids" | uniq -d | wc -l)
total_count=$(echo "$sorted_ids" | wc -l)
expected_count=$((num_processes * ids_per_process))

# If there are no duplicates and no missing IDs, print success messages
if [ $duplicate_count -eq 0 ] && [ $total_count -eq $expected_count ]; then
    echo "No duplicate IDs found."
    echo "No missing IDs found."
else
    echo "Duplicate IDs found!"
    echo "Missing IDs found!"
fi