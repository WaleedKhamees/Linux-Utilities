#!/bin/bash

check_dependencies() {
    if ! command -v dmenu &> /dev/null; then
        notify-send -u "critical" -t 1000 "dmenu is not installed"
        exit 1
    fi

    if ! command -v tgpt &> /dev/null; then
        notify-send -u "critical" -t 1000 "tgpt is not installed"
        exit 1
    fi

    if ! command -v pdflatex &> /dev/null; then
        notify-send -u "critical" -t 1000 "pdflatex is not installed"
        exit 1
    fi

    if ! command -v zathura &> /dev/null; then
        notify-send -u "critical" -t 1000 "zathura is not installed"
        exit 1
    fi
}
check_dependencies


old_questions=$(cat /tmp/latex-questions.txt)

question=$(echo -e "$old_questions" | dmenu -l 3 -p "Ask in LaTeX:")


if [[ -z $question ]]; then
    exit 1
fi

if ! echo "$old_questions" | grep -q "$question"; then
  answer=$(tgpt -w "write your answer as a latex document, make the margin smaller, increase default font size, write the question at the beginning, write nothing but the document, and write it raw without code block, and write all what you know about this topic in detail include equations and dive deep in answering the question:  $question?")

  echo $answer > /tmp/answer.tex

  echo "$answer" | pdflatex -jobname="$question" -output-directory=/tmp/ > /dev/null


fi 

echo "$question" > /tmp/latex-questions.txt
echo "$old_questions" >> /tmp/latex-questions.txt


zathura /tmp/"$question".pdf
