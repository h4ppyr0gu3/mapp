#!/bin/bash

mkdir -p $1 && cd $1 && youtube-dl -x --audio-format mp3 -o '%(id)s.%(ext)s' "https://invidious.snopyta.org/watch?v=$2"

