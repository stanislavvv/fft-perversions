#!/bin/sh

if [ "$1" = "" ]; then
    echo "Usage: $0 file.wav"
    echo "  file.raw 48000/16bit/mono will be created"
    exit 0
fi

if [ -r "$1" ]; then
    sox "$1" -r 48k -e signed -b16 -c 1 "`echo $1 | sed -e 's/wav$/raw/'`"
else
    echo "Can't read $1"
    exit 1
fi