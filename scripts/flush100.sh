#!/bin/bash

OUTDIR=$1
# Get the hostname
HOSTNAME=$(hostname)

# Get the current timestamp in YYYYMMDD_HHMMSS format
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Generate the filename for the random characters
FILENAME="${OUTDIR}/${HOSTNAME}_${TIMESTAMP}.txt"

# Start timer for the entire write operation in nanoseconds
START_TIME=$(date +%s%N)

# Create the file and write 200 lines of random strings
{
    for i in $(seq 1 100); do
        # Generate random string of 80 characters
        tr -dc 'A-Za-z0-9' </dev/urandom | head -c 80
        echo # Add a newline
    done
} > "$FILENAME"

# End timer for the whole write operation in nanoseconds
END_TIME=$(date +%s%N)

# Calculate duration in milliseconds
DURATION_MS=$(( (END_TIME - START_TIME) / 1000000 ))

# Generate the filename for the log file, including the duration
LOGFILE="${OUTDIR}/duration_${DURATION_MS}ms_${HOSTNAME}_${TIMESTAMP}.txt"

# Log the duration to the log file
echo "Duration for writing 200 lines to the file: $DURATION_MS milliseconds" > "$LOGFILE"

# Inform the user that the file has been created
#echo "File created: $FILENAME"
echo "Log file created: $LOGFILE"
