
# Installation

Install the following dependencies:

- lf
- zsh
- ueberzug
- mpv
- bat
- sxiv
- inkscape
- libreoffice
- GraphicsMagick
- Ghostscript
- ffmpeg

Afterwards, checkout this repository and as a regular user execute these instructions:

```
# Install files
sudo mkdir -p /usr/local/lib/
sudo cp lfbundle-previewer lfbundle-cleaner lfbundle-opener /usr/local/lib/
mkdir -p "$XDG_CONFIG_HOME/lfbundle/"
cp lfbundle.zshrc lfbundle.lfrc "$XDG_CONFIG_HOME/lfbundle/"

# Source zsh configuration
echo "source ${XDG_CONFIG_HOME}/lfbundle/lfbundle.zshrc" >>${ZDOTDIR:-$HOME}/.zshrc
```

This will create the following files:

```
 /usr/local/lib
├─  lfbundle-previewer
├─  lfbundle-opener
└─  lfbundle-cleaner

 $XDG_CONFIG_HOME
└─  lfbundle
   ├─  lfbundle.zshrc
   └─  lfbundle.lfrc
```

To **uninstall** simply remove the above files and delete the line added to your zshrc.

<!--
TODO: Preview and open .drawio files
TODO: Open selected directory in new terminal (o)
TODO: Open current working directory in new terminal (Shift + o)
TODO: Open GUI application and swallow window (^x + o)
TODO: Preview for font files (otf, ttf, woff, woff2)
TODO: Markdown.md
FIXME: Color of /tmp dir is blue
-->
