# This file shall be sourced by zsh and provides the enviroment and setup
# required to extend lf's functionality.

lfbundle() {
	# Initialize tempdir.
	local basedir="$XDG_RUNTIME_DIR/lfbundle"
	mkdir -p "$basedir"
	LFBUNDLE_TEMPDIR="$(mktemp -d -p "$basedir" lfbundle-XXXXXX)"

	# Arm cleanup trap.
	lfbundle_cleanup() {
		rm -rf "$LFBUNDLE_TEMPDIR"
		unset LFBUNDLE_TEMPDIR
		unfunction lfbundle_cleanup
	}
	setopt localoptions
	setopt localtraps

	# FIXME: Trap doesn't trigger if terminal is killed
	trap 'lfbundle_cleanup' INT QUIT HUP

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
