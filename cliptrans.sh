#!/bin/bash
cd "$(dirname "$(realpath "$0")")" || exit 1
set -x

selector() {

	if [[ "$isInteractive" == "true" ]]; then
		selector_fzf "$@"
	else
		selector_rofi "$@"
	fi
}

selector_fzf() {
	fzf --prompt "Transforming: '$(xclip -o -selection clipboard)'" "$@" |
		cut -d' ' -f 1
}

selector_rofi() {
	rofi -dmenu -mesg "Transforming: '$(xclip -o -selection clipboard)'" "$@" |
		cut -d' ' -f 1
}

export isInteractive

if [ -t 0 ]; then
	isInteractive="true"
else
	isInteractive="false"

fi

transformer="$(find transformers -mindepth 2 -maxdepth 2 -type f -name "transform" -executable |
	cut -d/ -f2 |
	sort |
	{
		while IFS= read -r transformer; do
			echo "$transformer => '$(xclip -o -selection clipboard | timeout 2 "transformers/$transformer/transform" | head -n1)'" | sponge &
		done
		wait
	} | selector "$@")"

echo "$transformer"
exit
test -x "transformers/$transformer/transform" || exit 1
xclip -o -selection clipboard |
	"transformers/$transformer/transform" 2>/tmp/cliptransErr |
	xclip -i -selection clipboard
if [ -s /tmp/cliptransErr ]; then
	notify-send -u critical "cliptrans" "Transformer $transformer failed, see /tmp/cliptransErr"
fi
notify-send -u low -t 2500 "cliptrans" "Done: $(xclip -o -selection clipboard)"
