#!/usr/bin/env bash
# Used for modifying web ui files (can only be uploaded in operator/superadmin)

set -euo pipefail

PASSWORD="{{ PWD }}"
ZIPNAME="tz_www_s12_pro_philippines.zip"
SRCDIR="tz_www"

usage() {
	cat <<EOF
Copyright Allen Cruiz 2025

Usage: $0 -C
  -C    Compress '${SRCDIR}' into '${ZIPNAME}' (password-protected)
  -h    Show this help
EOF
	exit 1
}

require_command() {
	command -v "$1" >/dev/null 2>&1 || { echo "Error: '$1' is required but not installed." >&2; exit 2; }
}

do_compress() {
	if [ ! -d "$SRCDIR" ]; then
		echo "Error: source directory '$SRCDIR' not found." >&2
		exit 3
	fi

	require_command zip

	echo "Compressing contents of '$SRCDIR' -> '$ZIPNAME' (password protected)"
	target_zip="$(pwd)/$ZIPNAME"
	[ -f "$target_zip" ] && rm -f "$target_zip"

	if (cd "$SRCDIR" && zip -r -P "$PASSWORD" "$target_zip" .); then
		echo "Compression succeeded: $ZIPNAME"
        sum=$(md5sum "$target_zip" | awk '{print $1}')
        echo "MD5 checksum: $sum"
		return 0
	else
		echo "Compression failed" >&2
		return 4
	fi
}

if [ "$#" -eq 0 ]; then
	usage
fi

while getopts ":Ch" opt; do
	case "$opt" in
		C)
			do_compress
			exit $?;
			;;
		h|\?)
			usage
			;;
	esac
done