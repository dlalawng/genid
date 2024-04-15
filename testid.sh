#!/bin/bash

# Include the 'genid' function from the 'genid.sh' file
source genid.sh

# Remove the existing 'genid_counter' file to start fresh
rm -f /tmp/genid_counter

# Set the number of parallel processes to run
num_processes=50

# Set the number of IDs to generate per process
ids_per_process=100

# Run the ID generation in parallel for each process
for ((i=1; i<=num_processes; i++)); do
    (
        # Generate the IDs for the current process
        for ((j=1; j<=ids_per_process; j++)); do
            genid
        done
    ) &
done

# Wait for all the parallel processes to finish
wait $!

# Collect all the generated IDs into a file
sort -n > generated_ids.txt

# Check for duplicate IDs
if [ $(uniq -d generated_ids.txt | wc -l) -eq 0 ]; then
    echo "No duplicate IDs found."
else
    echo "Duplicate IDs found!"
fi

# Check if all the expected IDs were generated
if [ $(wc -l < generated_ids.txt) -eq $((num_processes * ids_per_process)) ]; then
    echo "No missing IDs found."
else
    echo "Missing IDs found!"
fi