#!/bin/sh
nohup bin/aestun -s aeskey ::1:12346 ::1:12347 > /dev/null 2>&1 &
nohup bin/aestun -c aeskey ::1:12345 ::1:12346 > /dev/null 2>&1 &
nc -l ::1 12347
