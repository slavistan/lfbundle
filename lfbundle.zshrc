# This file shall be sourced by zsh and provides the enviroment and setup
# required to extend lf's functionality.

lfbundle() {

	local LF_ICONS="\
tw=:\
st=:\
ow=:\
dt=:\
di=:\
fi=:\
ln=:\
or=:\
ex=:\
*.c=:\
*.cc=:\
*.clj=:\
*.coffee=:\
*.cpp=:\
*.css=:\
*.d=:\
*.dart=:\
*.erl=:\
*.exs=:\
*.fs=:\
*.go=:\
*.h=:\
*.hh=:\
*.hpp=:\
*.hs=:\
*.html=:\
*.java=:\
*.jl=:\
*.js=:\
*.json=:\
*.lua=:\
*.md=:\
*.php=:\
*.pl=:\
*.pro=:\
*.py=:\
*.rb=:\
*.rs=:\
*.scala=:\
*.ts=:\
*.vim=:\
*.cmd=:\
*.ps1=:\
*.sh=:\
*.bash=:\
*.zsh=:\
*.fish=:\
*.tar=:\
*.tgz=:\
*.arc=:\
*.arj=:\
*.taz=:\
*.lha=:\
*.lz4=:\
*.lzh=:\
*.lzma=:\
*.tlz=:\
*.txz=:\
*.tzo=:\
*.t7z=:\
*.zip=:\
*.z=:\
*.dz=:\
*.gz=:\
*.lrz=:\
*.lz=:\
*.lzo=:\
*.xz=:\
*.zst=:\
*.tzst=:\
*.bz2=:\
*.bz=:\
*.tbz=:\
*.tbz2=:\
*.tz=:\
*.deb=:\
*.rpm=:\
*.jar=:\
*.war=:\
*.ear=:\
*.sar=:\
*.rar=:\
*.alz=:\
*.ace=:\
*.zoo=:\
*.cpio=:\
*.7z=:\
*.rz=:\
*.cab=:\
*.wim=:\
*.swm=:\
*.dwm=:\
*.esd=:\
*.jpg=:\
*.jpeg=:\
*.mjpg=:\
*.mjpeg=:\
*.gif=:\
*.bmp=:\
*.pbm=:\
*.pgm=:\
*.ppm=:\
*.tga=:\
*.xbm=:\
*.xpm=:\
*.tif=:\
*.tiff=:\
*.png=:\
*.svg=:\
*.svgz=:\
*.mng=:\
*.pcx=:\
*.mov=:\
*.mpg=:\
*.mpeg=:\
*.m2v=:\
*.mkv=:\
*.webm=:\
*.ogm=:\
*.mp4=:\
*.m4v=:\
*.mp4v=:\
*.vob=:\
*.qt=:\
*.nuv=:\
*.wmv=:\
*.asf=:\
*.rm=:\
*.rmvb=:\
*.flc=:\
*.avi=:\
*.fli=:\
*.flv=:\
*.gl=:\
*.dl=:\
*.xcf=:\
*.xwd=:\
*.yuv=:\
*.cgm=:\
*.emf=:\
*.ogv=:\
*.ogx=:\
*.aac=:\
*.au=:\
*.flac=:\
*.m4a=:\
*.mid=:\
*.midi=:\
*.mka=:\
*.mp3=:\
*.mpc=:\
*.ogg=:\
*.ra=:\
*.wav=:\
*.oga=:\
*.opus=:\
*.spx=:\
*.xspf=:\
*.pdf=:\
*.nix=:\
"

	local LF_COLORS="\
ex=38;5;253:\
fi=38;5;253:\
di=1;38;5;253:\
ln=38;5;253:\
so=38;5;253:\
"


	# Initialize tempdir.
	local basedir="$XDG_RUNTIME_DIR/lfbundle"
	mkdir -p "$basedir"
	LFBUNDLE_TEMPDIR="$(mktemp -d -p "$basedir" lf-XXXXXX)"

	# Start ueberzug.
	mkfifo "$LFBUNDLE_TEMPDIR/ueberzug_fifo"
	tail -f "$LFBUNDLE_TEMPDIR/ueberzug_fifo" | ueberzug layer --silent &!
	LFBUNDLE_UEBERZUGID=$!

	# Arm cleanup trap.
	lfbundle_cleanup() {
		kill "$LFBUNDLE_UEBERZUGID"
		pkill -f "tail -f $LFBUNDLE_TEMPDIR/ueberzug_fifo" # kill tail zombie
		rm -rf "$LFBUNDLE_TEMPDIR"
		unset LFBUNDLE_UEBERZUGID
		unset LFBUNDLE_TEMPDIR
		unfunction lfbundle_cleanup
	}
	setopt localoptions
	setopt localtraps
	trap 'lfbundle_cleanup' HUP INT TERM QUIT

	# Initialize state of pagination and single/multi columns mode.
	touch "$LFBUNDLE_TEMPDIR/togglecol"
	echo 1 >"$LFBUNDLE_TEMPDIR/page"

	# Run lf.
	LF_ICONS="$LF_ICONS" LF_COLORS="$LF_COLORS" LFBUNDLE_TEMPDIR="$LFBUNDLE_TEMPDIR" \lf \
		-last-dir-path "$LFBUNDLE_TEMPDIR/lastdir" \
		-config "$XDG_CONFIG_HOME/lfbundle/lfbundle.lfrc" \
		"$@"

	# Change working directory after closing lf.
	[[ -f "$LFBUNDLE_TEMPDIR/changecwd" ]] && cd "$(cat "$LFBUNDLE_TEMPDIR/lastdir")" 2>/dev/null

	lfbundle_cleanup
}
alias lf=lfbundle

# FIXME: Cleanup is not performed when the terminal is killed.
