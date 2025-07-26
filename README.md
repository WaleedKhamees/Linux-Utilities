# My Linux Utilities

This is a collection of utilities that I use on my Linux system. I have written these utilities to make my life easier. They are designed to simplify and speed up common tasks, and I usually trigger them with a keyboard shortcut. I hope they make your life easier too.

I was inspired to share these utilities by Dr. Yousef Ghatus.

## Setup

I trigger these utilities with `sxhkd`, and I use `dmenu` for the user interface.  

**`sxhkd`** is a simple X hotkey daemon that triggers commands in response to keyboard events. It is an easy way to bind keyboard shortcuts to commands. You might already have this provided by your distribution, or you can install it with your package manager.

**`dmenu`** is a dynamic menu for X, providing a simple way to create a menu that you can use to select options. I don't know of any distributions that come with `dmenu` installed by default, and I'm not sure if it is compatible with all desktop environments. Most, if not all, of these utilities use `dmenu`. You can compile it from source at `https://tools.suckless.org/dmenu/`.

## Utilities

### [`AnswerAnyQuestion.sh`](./AnswerAnyQuestion.sh)
This is one of my favorites. It's a simple wrapper around this great project [tgpt](https://github.com/aandrew-me/tgpt), which is essentially chatgpt built into your operating system. It's a quick way to ask questions and get immediate answers. 

To make this work you need:
- **`dmenu`** for the user interface
- [**`tgpt`**](https://github.com/aandrew-me/tgpt) for the chatgpt

### [`ColorPicker.sh`](./ColorPicker.sh)
Just a simple color picker.

To make this work you need:
- **`grabc`** for the color picker

### [`DownloadFromYoutube.sh`](./DownloadFromYoutube.sh)
This is a wrapper around [`yt-dlp`](https://github.com/yt-dlp/yt-dlp). To download videos, you just copy a link to a video or a playlist and run this utility. It will ask you whether you want to download the video or the playlist and then it will ask you for the quality of the video `high - 720p`, `medium - 360p` or `audio`. It'll then download the video or the playlist to your `~/Videos` or `~/Audio` directory.

To make this work you need:
- **`dmenu`** for the user interface
- **`yt-dlp`** for downloading videos from YouTube

### [`EditDir.sh`](./EditDir.sh)
This is my absolute favorite. It's a simple way to open a directory in either a `tmux/nvim` session, a `ranger - file manager`, or `vscode`. There is a text file that comes with this utility called `dir.txt`. You can edit it to add your own directories inside `~` for special directories. The tool will ask you if you want directories nested inside the dirs in `dir.txt` or all dirs on the system.

To make this work you need:
- **`fzf`** for the user interface
- **`tmux`** terminal multiplexer
- **`nvim`** text editor
- **`ranger`** file manager
- **`code`** text editor
- **`plocate`** for finding directories on the system

### [`EditFile.sh`](./EditFile.sh)

This is the same as `EditDir.sh` but for files. It opens a file in `nvim`. It uses the same `dir.txt` file to open files in these special directories or all files on the system.

To make this work you need:
- **`fzf`** for the user interface
- **`nvim`** text editor
- **`plocate`** for finding files on the system 

### [`Emoji.sh`](./Emoji.sh)

This is a simple emoji picker. It uses `dmenu` to show you a list of emojis and then copies the selected emoji to the clipboard.

To make this work you need:
- **`dmenu`** for the user interface
- **`xclip`** for copying the emoji to the clipboard
- **`dmenu-emoji`** I use this utility, but you can simply store all emojis in a text file and use `dmenu` to select an emoji.

### [`GermanSpecialCharacters.sh`](./GermanSpecialCharacters.sh)

I started learning German and needed a way to type the special characters in the German language. 

To make this work you need:
- **`dmenu`** for the user interface

### [`Language.sh`](./Language.sh)

This is how I switch between Arabic and English keyboard layouts. 

To make this work you need:
- **`xorg-setxkbmap`** for changing the keyboard layout. It comes with Xorg distributions. 

### [`Screenshot.sh`](./Screenshot.sh)

This utility takes a screenshot of the current screen, a window, or a selection of the screen, and asks you whether you want to save it to a file or copy it to the clipboard.

To make this work you need:
- **`dmenu`** for the user interface
- **`maim`** for taking screenshots
- **`xclip`** for copying the screenshot to the clipboard

### [`Ocr.sh`](./Ocr.sh)

This utility uses tesseract to perform OCR on the current screen. It takes a screenshot of the current screen, then uses tesseract to perform OCR on the screenshot. 

To make this work you need:
- **`dmenu`** for the user interface
- **`tesseract`** OCR engine
- **`maim`** for taking screenshots
- **`xclip`** for copying the OCR result to the clipboard

## License
This project is licensed under the GPL License. 