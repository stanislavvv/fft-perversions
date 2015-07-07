#!/bin/sh

if [ "$1" = "" ]; then
    echo "Usage: $0 file.wav"
    echo "  file.wav 30sec 48000/16bit/mono will be recored"
    exit 0
fi

arecord -f S16_LE -c1 -r48000 -d30 "$1"
