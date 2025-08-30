# This file shall be sourced by zsh and provides the enviroment and setup
# required to extend lf's functionality.

# LF_CONFIG_HOME can be used to override the default config directory
# where lf expects the 'lf' subdirectory.
LF_CONFIG_HOME="${0:A:h}"

lfbundle() {
	local basedir="$XDG_RUNTIME_DIR/lfbundle"
	mkdir -p "$basedir"
	LFBUNDLE_TEMPDIR="$(mktemp -d -p "$basedir" lfbundle-$(date -Ins)-XXXXXX)"

	# Arm cleanup trap.
	lfbundle_cleanup() {
		rm -rf "$LFBUNDLE_TEMPDIR"
		unset LFBUNDLE_TEMPDIR
		unfunction lfbundle_cleanup
	}
	setopt localoptions
	setopt localtraps

	# FIXME: Trap doesn't trigger if st terminal is killed
	trap 'lfbundle_cleanup' INT QUIT HUP

	# Run lf.
	LFBUNDLE_TEMPDIR="$LFBUNDLE_TEMPDIR"                  \
		LF_CONFIG_HOME="$LF_CONFIG_HOME"                  \
		\lf                                               \
		-last-dir-path "$LFBUNDLE_TEMPDIR/lastdir"        \
		"$@"

	# Change working directory after closing lf.
	[[ -f "$LFBUNDLE_TEMPDIR/changecwd" ]] && cd "$(cat "$LFBUNDLE_TEMPDIR/lastdir")" 2>/dev/null

	lfbundle_cleanup
}

alias lf=lfbundle
