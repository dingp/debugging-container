#!/usr/bin/env python3

import argparse
import os
import time
import datetime

_MB = 1024*1024

def stream_write(block_size, count, output_path):
    """
    Perform streaming write to a file.

    Args:
        block_size (int): Size of each block in bytes.
        count (int): count of blocks to write.
        output_path (str): Path to write to.
    """
    with open(output_path, 'wb') as f:
        ct = 0
        bytes_written = 0
        while ct < count:
            block = os.urandom(block_size)
            f.write(block[:block_size])
            bytes_written += block_size
            ct += 1

def main():
    parser = argparse.ArgumentParser(description='Perform streaming I/O')
    parser.add_argument('-b', '--block-size', type=int, default=_MB, help='Block size in bytes')
    parser.add_argument('-c', '--count', type=int, default=256, help='Count of blocks to write')
    parser.add_argument('-s', '--sleep', type=int, default=60*5, help='Time to sleep')
    parser.add_argument('-p', '--path', default="/test/testfile", help='Path to write to')
    parser.add_argument('-l', '--log', default="/test/log", help='Path to write to')
    parser.add_argument('-a', '--appendlog', default="/test/data.csv", help='Path to append rates in TSV')
    args = parser.parse_args()
    total_mb = (args.block_size * args.count)/_MB
    if not os.path.exists(args.appendlog):
        with open(args.appendlog, "wt") as f:
            f.write(f'timestamp\tvalue\n')

    while True:
        start_time = time.time()
        stream_write(args.block_size, args.count, args.path)
        end_time = time.time()
        duration = end_time-start_time
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        rate = total_mb/duration
        print(f"{now}: {duration:.2f}s to write {total_mb}MB rate: {rate:.1f} MB/s")
        with open(args.log, 'at') as f:
            f.write(f"{now}: {duration:.2f}s to write {total_mb}MB rate: {rate:.1f} MB/s\n")
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        with open(args.appendlog, 'at') as f:
            f.write(f"{now}\t{rate}\n")
        start_time = time.time()
        os.unlink(args.path)
        end_time = time.time()
        duration = end_time-start_time
        now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
#        print(f"{now}: {duration:.2f}s to unlink")
#        with open(args.log, 'at') as f:
#            f.write(f"{now}: {duration:.2f}s to unlink\n")
        time.sleep(args.sleep)

if __name__ == '__main__':
    main()
