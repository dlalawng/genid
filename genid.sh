genid() {
  local lock_file="/tmp/genid.lock"
  local counter_file="/tmp/genid_counter"
  local max_count=10000

  (
    flock -x 200
    current_count=$(cat "$counter_file" 2>/dev/null || echo 0)
    if [ $current_count -ge $max_count ]; then
      current_count=0
    fi
    next_count=$((current_count + 1))
    printf "%05d\n" "$next_count" >&1
    echo "$next_count" > "$counter_file"
  ) 200>"$lock_file"
}