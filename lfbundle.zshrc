# This file shall be sourced by zsh and provides the enviroment and setup
# required to extend lf's functionality.

lfbundle() {
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
	LFBUNDLE_TEMPDIR="$LFBUNDLE_TEMPDIR" \lf \
		-last-dir-path "$LFBUNDLE_TEMPDIR/lastdir" \
		-config "$XDG_CONFIG_HOME/lfbundle/lfbundle.lfrc" \
		"$@"

	# Change working directory after closing lf.
	[[ -f "$LFBUNDLE_TEMPDIR/changecwd" ]] && cd "$(cat "$LFBUNDLE_TEMPDIR/lastdir")" 2>/dev/null

	lfbundle_cleanup
}
alias lf=lfbundle

# FIXME: Cleanup is not performed when the terminal is killed.
#        To reproduce open lf in a terminal, observe the new tempdir in $XDG_RUNTIME_DIR,
#        and kill the terminal window (mod4+q). The tempdir, tail and ueberzug won't be cleaned up.
