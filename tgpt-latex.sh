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

    if ! command -v pandoc &> /dev/null; then
        notify-send -u "critical" -t 1000 "pandoc is not installed"
        exit 1
    fi
}
check_dependencies

old_questions=$(cat /tmp/markdown-questions.txt)

question=$(echo -e "$old_questions" | dmenu -l 3 -p "Ask in Markdown:")

if [[ -z $question ]]; then
    exit 1
fi

if ! echo "$old_questions" | grep -q "$question"; then
  answer=$(tgpt -w "Please write your answer in Markdown format. Include headers, and any other Markdown elements as needed, Write nothing but the Markdown content. 

Question:
$question?")

  echo "$answer" > /tmp/"$question".md
  sed -i '1{/^```.[^ ]*/d};$ {/^```/d}' /tmp/"$question".md
  answer=$(cat /tmp/"$question".md)

    pandoc /tmp/"$question".md -o /tmp/"$question".pdf \
    --pdf-engine=xelatex \
    -V geometry:margin=0.5in \
    -V fontsize=12pt 
  
fi

echo -e "$question\n$old_questions" | uniq > /tmp/markdown-questions.txt

xdg-open /tmp/"$question".pdf


