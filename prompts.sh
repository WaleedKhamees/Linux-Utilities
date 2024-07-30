#/bin/env bash



prompt=$(cat "$HOME/dotfiles/Linux-Utilities/prompts.txt" | dmenu -l 10 -p "Select a prompt: ")
[ -z "$prompt" ] && exit 1
input=$(xclip -o)
[ -z "$input" ] && exit 1

tgpt_input="prompt: $prompt\ninput: $input"
echo $tgpt_input

output=$(tgpt -w "$tgpt_input")
echo -e "$output" | xclip -selection clipboard
notify-send "Answer copied to clipboard!"
