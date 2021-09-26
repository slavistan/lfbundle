
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
sudo cp lfbundle-previewer lfbundle-cleaner lfbundle-opener lfbundle-extract /usr/local/lib/
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
├─  lfbundle-extract
└─  lfbundle-cleaner

 $XDG_CONFIG_HOME
└─  lfbundle
   ├─  lfbundle.zshrc
   └─  lfbundle.lfrc
```

To **uninstall** simply remove the above files and delete the line added to your zshrc.

