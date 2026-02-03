#!/bin/bash

functions="merge SRT with MP4\nreplace character in filename with another character\nremove node_modules\nconvert webm to mp3\ndelete files without extension"

merge () { 
  current_dir=$(pwd)
  
  shopt -s nullglob
  files=( *.srt *.vtt )

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "No subtitle files found."
    return
  fi

  selection=$(printf "%s\n" "${files[@]}" "all" | fzf --reverse --height 40%)


  case $selection in 
    "all")

        for file in "${files[@]}"; do
          extension="${file##*.}"
          filename="${file%.*}"

          echo "file: \"$file\""

          if [ "$extension" == "vtt" ]; then
            ffmpeg -i "$file" "${filename}.srt"
          fi

          srt="$current_dir/${filename}.srt"
          mp4="$current_dir/${filename}.mp4"

          if [ ! -f "$mp4" ]; then
            echo "Error: Corresponding MP4 file ($mp4) not found."
            return 1
          fi

          ffmpeg -i "$mp4" -i "$srt" -c copy -c:s srt "${filename}.mkv"
        done
      
        read -p "Do you want to delete the original files? [y/n]: " -r reply

        if [ "$reply" == "y" ]; then
          for file in "${files[@]}"; do
            extension="${file##*.}"
            filename="${file%.*}"

            srt="$current_dir/${filename}.srt"
            mp4="$current_dir/${filename}.mp4"
            vtt="$current_dir/${filename}.vtt"

            rm "$mp4" "$srt"
            [ "$extension" == "vtt" ] && rm "$vtt"  # Remove original VTT if converted
          done
        fi

      ;;

    *)
      extension="${selection##*.}"
      filename="${selection%.*}"

      echo "Selected file: $filename.$extension"

      if [ "$extension" == "vtt" ]; then
        ffmpeg -i "$selection" "${filename}.srt"
      fi

      srt="$current_dir/${filename}.srt"
      mp4="$current_dir/${filename}.mp4"

      if [ ! -f "$mp4" ]; then
        echo "Error: Corresponding MP4 file ($mp4) not found."
        exit 1
      fi

      ffmpeg -i "$mp4" -i "$srt" -c copy -c:s srt "${filename}.mkv"

      read -p "Do you want to delete the original files? [y/n]: " -r reply

      if [ "$reply" == "y" ]; then
        rm "$mp4" "$srt"
        [ "$extension" == "vtt" ] && rm "$selection"  # Remove original VTT if converted
      fi

    ;;

  esac

}

replaceCharInFilenameWithAnotherChar() {
  shopt -s nullglob  # Prevent errors if no files match

  read -p "Enter the character you want to replace: " -r char1
  IFS= read -r -p "Enter the character you want to replace with: " char2  # Preserve spaces

  if [[ "$char1" == "." ]]; then
    char1='\.'  # Ensure dot is treated as a literal character
  fi

  for file in *; do
    [[ -d "$file" ]] && continue  # Skip directories

    base="${file%.*}"  
    ext="${file##*.}" 
    regexcommand="s/${char1}/${char2}/g"
    new_base="$(echo "$base" | sed "$regexcommand")"
    new_name="${new_base}.${ext}"


    if [[ "$file" != "$new_name" ]]; then
      mv "$file" "$new_name"
      echo "Renamed: $file → $new_name"
    else
      echo "No change needed for $file"
    fi

  done

}

removeNodeModules() {
  find . -name "node_modules" -type d -prune -exec rm -rfv '{}' +
}

convertWebmToMp3() {
    webm_files=$(find . -name "*.webm")
    file=$(echo "$webm_files" | fzf --reverse --height 40%)
    [[ -z "$file" ]] && return
    ffmpeg -i "$file" -vn -acodec libmp3lame -ab 192k "${file%.*}.mp3"
}

deleteFilesWithoutExtension() {
  for f in *; do
    if [[ -f "$f" && "$f" != *.* ]]; then
        echo "Deleting: $f"
        rm -- "$f"
    fi
  done
}

function_selected=$(echo -e "$functions" | fzf --reverse --height 40%)

case $function_selected in 
  "merge SRT with MP4")
    merge 
    ;;
  "replace character in filename with another character")
    replaceCharInFilenameWithAnotherChar
    ;;
  "remove node_modules")
    removeNodeModules
    ;;
  "convert webm to mp3")
      convertWebmToMp3
    ;;
  "delete files without extension")
      deleteFilesWithoutExtension
    ;;
esac

