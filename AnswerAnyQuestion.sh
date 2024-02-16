#!/bin/sh

# tgpt -u

# Read the previous question from /tmp/answer-any-question-tmp.txt
previous_questions=$(cat /tmp/answer-any-question-tmp.txt)

# Use dmenu to edit the previous question or enter a new one
edited_question=$(echo -e "$previous_questions" | dmenu -p  "Edit or enter something:" -l 3)


if [[ -n $edited_question ]]; then
  echo $edited_question | xclip -selection clip
  # If the user entered a new question or edited the previous one, use it
  st -e sh -c "tgpt -q \"$edited_question\"; read -p \"Press enter to exit\""

  if ! echo "$previous_questions" | grep -q "$edited_question"; then
    # Update the /tmp/answer-any-question-tmp.txt file with the edited question
    echo -e "$edited_question" >> /tmp/answer-any-question-tmp.txt
  fi
fi

