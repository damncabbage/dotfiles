#!/bin/bash
#
# Symlinks the contents of the dotfiles path into 
#

function info() {
	echo -e "\033[0;32m **\033[m $*"
}

function error() {
	echo -e "\033[1;31m !!\033[m $*"
}

function action() {
	CODE=$1
	shift
	if [ $CODE -gt 0 ]; then
		error $* " (Failed with code $CODE)"
	else
		info $*
	fi
}


# Make sure we're in the same directory as the script
pushd `dirname $0` > /dev/null

	# Can anyone say HACK?
	FILES=".[A-Za-z0-9_]* bin/* lib/*"
	TARGETDIR=$HOME

	for FILE in $FILES
	do
		# HACK: Ignore our repo .git if this is not a bare repo.
		if [ $FILE == ".git" ] || [ $FILE == ".gitignore" ]; then
			continue
		fi

		if [ -f ~/"$FILE" ] || [ -d ~/"$FILE" ]; then
			if [ -L ~/"$FILE" ]; then
				info "Already symlinked: $FILE"
			else
				error "Already present and is a regular file: $FILE"
			fi

		else 
			DIR=`dirname "$FILE"`
			if [ ! -d "$TARGETDIR/$DIR" ]; then
				mkdir -p "$TARGETDIR/$DIR"
				action $? "Created directory: $DIR"
			fi

			ln -s "`pwd`/$FILE" "$TARGETDIR/$DIR/"
			action $? "Linked: $FILE"
		fi
	done

popd > /dev/null
