#!/bin/bash

source genid.sh

rm -f /tmp/genid_counter

num_processes=50
ids_per_process=100

for ((i=1; i<=num_processes; i++)); do
  (
    for ((j=1; j<=ids_per_process; j++)); do
      genid
    done
  ) &
  wait $!
done | sort -n > generated_ids.txt

if [ $(uniq -d generated_ids.txt | wc -l) -eq 0 ]; then
  echo "No duplicate IDs found."
else
  echo "Duplicate IDs found!"
fi

if [ $(wc -l < generated_ids.txt) -eq $((num_processes * ids_per_process)) ]; then
  echo "No missing IDs found."
else
  echo "Missing IDs found!"
fi