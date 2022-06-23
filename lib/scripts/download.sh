#!/bin/bash

mkdir -p $1 && cd $1 && yt-dlp -x --audio-format mp3 -o '%(id)s.%(ext)s' "https://www.youtube.com/watch?v=$2"

