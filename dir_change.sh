#!/bin/bash

# Directory to monitor
DIR="/var/log"

# Location to store the hash file
HASH_FILE="/tmp/monitored_dir_hash"

# Function to create a hash of the directory
create_hash() {
	find "$1" -type f -exec sha256sum {} + | sha256sum | awk '{print $1}'
}

# A hash exists, compare with the current state
OLD_HASH=$(cat "$HASH_FILE" 2>/dev/null)
NEW_HASH=$(create_hash "$DIR")

if [ "$OLD_HASH" != "$NEW_HASH" ]; then
	echo "changes detected in $DIR"
	echo "Old Hash: $OLD_HASH"
	echo "New Hash: $NEW_HASH"
else
	echo "No changes detected in $DIR"
fi

# Hash file does not exist, create one
echo "$NEW_HASH" > "$HASH_FILE"


