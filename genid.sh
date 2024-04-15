#!/bin/bash

# Function to generate a unique ID
genid() {
    # Lock file to ensure only one process can access the counter at a time
    local lock_file="/tmp/genid.lock"
    # File to store the current counter value
    local counter_file="/tmp/genid_counter"
    # Maximum value for the counter
    local max_count=10000

    # Acquire an exclusive lock on the lock file
    {
        flock -x 200
        # Read the current counter value from the file
        current_count=$(cat "$counter_file" 2>/dev/null || echo 0)
        # Check if the counter has reached the maximum value
        if [ $current_count -ge $max_count ]; then
            # Reset the counter if it has reached the maximum
            current_count=0
        fi
        # Increment the counter
        next_count=$((current_count + 1))
        # Format the counter value with leading zeros
        printf "%05d\n" "$next_count"
        # Write the new counter value to the file
        echo "$next_count" > "$counter_file"
    } 200>"$lock_file"
}