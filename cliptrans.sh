#!/bin/bash

cd "$(dirname "$(realpath "$0")")"
transformer="$(find transformers -type f -name "transform" -executable | cut -d/ -f2 | sort | rofi -dmenu "$@")"
test -x "transformers/$transformer/transform" || exit 1
xclip -o  -selection clipboard | "transformers/$transformer/transform" 2>/tmp/cliptransErr | xclip -i -selection clipboard
if [ -s /tmp/cliptransErr ] ; then
  notify-send "cliptrans" "Transformer $transformer failed, see /tmp/cliptransErr"
fi

