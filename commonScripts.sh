#!/bin/bash

functions="copy directory (rsync)\nmerge audio with video\nmerge SRT with MP4\nreplace character in filename with another character\nremove node_modules\nconvert webm to mp3\ndelete files without extension\nupscale and sharpen slides"

copyDirRsync() {
    # 1. Get directories with max depth 4
    # -not -path '*/.*' hides hidden folders for a cleaner fzf list
    dirs=$(find . -maxdepth 4 -type d -not -path '*/.*')

    if [[ -z "$dirs" ]]; then
        echo "No directories found."
        return
    fi

    # 2. Select Source
    src=$(echo "$dirs" | fzf --reverse --height 40% --header "SELECT SOURCE DIRECTORY")
    [[ -z "$src" ]] && return

    # 3. Select Destination
    dest=$(echo "$dirs" | fzf --reverse --height 40% --header "SELECT DESTINATION DIRECTORY")
    [[ -z "$dest" ]] && return

    # 3.5 rename illegal characters in destination directory
    find "$src" -depth -name '*[\\:*?"<>|]*' -exec bash -c '
        for item; do
            dir=$(dirname "$item")
            base=$(basename "$item")
            # Using your preferred replacement character "-" 
            new_base=$(echo "$base" | sed "s/[\\:*?\"<>|]/-/g")
            
            if [ "$base" != "$new_base" ]; then
                if [ -e "$dir/$new_base" ]; then
                    echo "Collision: $new_base already exists, skipping $base"
                else
                    mv -v "$item" "$dir/$new_base"
                fi
            fi
        done
    ' _ {} +

    # 4. Actual Copying
    echo "Starting transfer: $src -> $dest"
    rsync -rtvhL --progress --modify-window=1 "$src" "$dest"

    # 5. Verification Dry Run (Post-Copy)
    printf "\n====================================================================\n"
    printf "DRY RUN (Verification)"
    printf "\n====================================================================\n"
    
    # Running rsync again with --dry-run. 
    # If everything copied correctly, this should show no further changes needed.
    rsync -rtvh --progress --modify-window=1 --dry-run "$src" "$dest"

    printf "\nVerification complete.\n"
}

upscaleSlides() {
    shopt -s nullglob
    # Supporting common image formats for slides
    files=( *.jpg *.jpeg *.png *.webp )

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No image files found."
        return
    fi

    selection=$(printf "%s\n" "${files[@]}" "all" | fzf --reverse --height 40% --header "Select slide(s) to upscale to 1080p")

    case $selection in
        "all")
            mkdir -p upscaled
            for file in "${files[@]}"; do
                echo "Processing: $file"
                # Mitchell filter + Distort + Adaptive Sharpen for crisp text
                magick "$file" -filter Mitchell -distort Resize 1920x1080 -despeckle -adaptive-sharpen 0x3 "upscaled/${file%.*}.png"
            done
            echo "Finished! Check the 'upscaled' folder."
            ;;
        "")
            return
            ;;
        *)
            filename="${selection%.*}"
            echo "Upscaling $selection..."
            magick "$selection" -filter Mitchell -distort Resize 1920x1080 -despeckle -adaptive-sharpen 0x3 "${filename}_1080p.png"
            echo "Done: ${filename}_1080p.png"
            ;;
    esac
}

mergeAudio() {
    current_dir=$(pwd)
    shopt -s nullglob
    files=( *.m4a *.mp3 *.webm *.wav )
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No audio files found."
        return
    fi

    selection=$(printf "%s\n" "${files[@]}" "all" | fzf --reverse --height 40% --header "Select audio file(s) to merge")

    # $1 is the selected file
    _merge_audio() {
        video_file="${1%.*}.mp4"
        if ! [ -f "$video_file" ]; then
            video_file="${1%.*}.mkv"
        fi
        if ! [ -f "$video_file" ]; then
            echo "Error: Corresponding video file ($video_file) not found."
            return 1
        fi
        echo "Merging $1 into $video_file..."
        ffmpeg -i "$video_file" -i "$1" -c copy -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -strict experimental "${video_file}_merged.mkv"
        echo "Done: $video_file"
    }

    case $selection in
        "all")
            for file in "${files[@]}"; do
                _merge_audio "$file"
            done
            ;;
        "")
            return
            ;;
        *)
            _merge_audio "$selection"
            ;;
    esac
}

mergeSRTwithMP4 () { 
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
            mkv="$current_dir/${filename}.mkv"

            if [ -f "$mkv" ]; then
                rm "$mp4" "$srt"
            fi

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
    "merge audio with video")
        mergeAudio
    ;;
    "merge SRT with MP4")
        mergeSRTwithMP4
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
    "upscale and sharpen slides")
        upscaleSlides
    ;;
    "copy directory (rsync)")
        copyDirRsync
    ;;
esac
