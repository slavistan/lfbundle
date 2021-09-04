# This file shall be sourced by zsh and provides the enviroment and setup
# required to extend lf's functionality.

# Cleanup
lfbundle_cleanup() {
	kill "$LFBUNDLE_UEBERZUGID"
	pkill -f "tail -f $LFBUNDLE_TEMPDIR/ueberzug_fifo" # kill tail zombie
	rm -rf "$LFBUNDLE_TEMPDIR" 2>&1
	unset LFBUNDLE_TEMPDIR
	unset LF_COLORS
	unset LF_ICONS
	unset LFBUNDLE_UEBERZUGID
}

lfbundle() {

	LF_ICONS="\
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

	LF_COLORS="\
ex=38;5;253:\
fi=38;5;253:\
di=1;38;5;253:\
ln=38;5;253:\
so=38;5;253:\
"

	# environment
	basedir="$XDG_RUNTIME_DIR/lfbundle"
	mkdir -p "$basedir"
	export LFBUNDLE_TEMPDIR="$(mktemp -d -p "$basedir" lf-XXXXXX)"
	export LF_ICONS
	export LF_COLORS

	# Ensure cleanup is executed without modifying the shell
	setopt localoptions
	setopt localtraps
	# ???: Why is the EXIT signal elicited when I kill the terminal?
	# ???: Any why is the EXIT signal handler apparently cut off after a few 100ms?
	# ???: Which is the proper signal to trap such that it cached a killed terminal?
	trap 'lfbundle_cleanup &!' EXIT

	# State
	touch "$LFBUNDLE_TEMPDIR/togglecol"

	# ueberzug
	mkfifo "$LFBUNDLE_TEMPDIR/ueberzug_fifo"
	tail -f "$LFBUNDLE_TEMPDIR/ueberzug_fifo" | ueberzug layer --silent &!
	export LFBUNDLE_UEBERZUGID=$!

	# Pagination
	echo 1 >"$LFBUNDLE_TEMPDIR/page"

	# execute lf
	\lf -last-dir-path "$LFBUNDLE_TEMPDIR/lastdir" -config "$XDG_CONFIG_HOME/lfbundle/lfbundle.lfrc" "$@"
	/usr/local/lib/lfbundle-cleaner

	# postprocess
	[ -e "$LFBUNDLE_TEMPDIR/changecwd" ] && cd "$(cat "$LFBUNDLE_TEMPDIR/lastdir")" 2>/dev/null
}
alias lf=lfbundle
