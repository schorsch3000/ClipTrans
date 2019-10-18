#!/bin/bash
cd "$(dirname "$(realpath "$0")")" || exit 1
transformer="$(find transformers -mindepth 2 -maxdepth 2 -type f -name "transform" -executable | cut -d/ -f2 | sort | {
  while IFS= read -r transformer
  do
    echo "$transformer => '$(xclip -o  -selection clipboard | timeout 2s "transformers/$transformer/transform" | head -n1)'"
  done
  } | rofi -dmenu -mesg "Transforming: '$(xclip -o -selection clipboard)" "$@" | cut -d' ' -f 1)'"
test -x "transformers/$transformer/transform" || exit 1
xclip -o  -selection clipboard | "transformers/$transformer/transform" 2>/tmp/cliptransErr | xclip -i -selection clipboard
if [ -s /tmp/cliptransErr ] ; then
  notify-send -u critical "cliptrans" "Transformer $transformer failed, see /tmp/cliptransErr"
fi
notify-send -u low -t 2500 "cliptrans" "Done: $(xclip -o -selection clipboard)"

