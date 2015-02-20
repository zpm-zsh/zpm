# ------------------------------------------------------------------------------
#          FILE:  zshmarks.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Jocelyn Mallon
#       VERSION:  1.0
# ------------------------------------------------------------------------------

bookmarks_file="$HOME/.bookmarks"

# Create bookmarks_file it if it doesn't exist
if [[ ! -f $bookmarks_file ]]; then
	touch $bookmarks_file
fi

function mark() {
	bookmark_name=$1
	if [[ -z $bookmark_name ]]; then
		echo 'Invalid name, please provide a name for your bookmark. For example:'
		echo '  bookmark foo'
		return 1
	else
		bookmark="$(pwd)|$bookmark_name" # Store the bookmark as folder|name
		if [[ -z $(grep "$bookmark" $bookmarks_file) ]]; then
			echo $bookmark >> $bookmarks_file
			echo "Bookmark '$bookmark_name' saved"
		else
			echo "Bookmark already existed"
			return 1
		fi
	fi
}

source_setenv() {
	bookmark_name=$1
	# is there a setenv file to source
	if [[ -f "setenv-source-me.sh" ]]; then

		# if we have not already sourced it in the current zsh session ..
		setenv_var=`echo "setenv_${bookmark_name}" | sed "s/[^a-zA-Z0-9]/_/g"`
		if [[ -z ${(P)setenv_var} ]]; then
			echo "sourceing 'setenv-source-me.sh'"
			source setenv-source-me.sh
			# remember that we have sourced it
			eval "$setenv_var=sourced"
		fi
	fi
}

function c() {
	bookmark_name=$1
	bookmark="$(grep "|$bookmark_name$" "$bookmarks_file")"
	if [[ -z $bookmark ]]; then
		echo "Invalid name, please provide a valid bookmark name. For example:"
		echo "  jump foo"
		echo
		echo "To bookmark a folder, go to the folder then do this (naming the bookmark 'foo'):"
		echo "  bookmark foo"
		return 1
	else
		dir="${bookmark%%|*}"
		cd "${dir}"
		source_setenv $bookmark_name
		unset dir
	fi
}

# Show a list of the bookmarks
function marks() {
	cat ~/.bookmarks | awk '{ printf "%-20s%-40s%s\n",$2,$1,$3}' FS=\|
}

# Delete a bookmark
function delmark()  {
	bookmark_name=$1
	if [[ -z $bookmark_name ]]; then
		echo 'Invalid name, please provide a name for your bookmark to delete. For example:'
		echo '  deletemark foo'
		return 1
	else
		t=$(mktemp -t bookmarks.XXXXXX) || exit 1
		trap "rm -f -- '$t'" EXIT

		sed "/$bookmark_name/d" "$bookmarks_file" > "$t"
		mv "$t" "$bookmarks_file"

		rm -f -- "$t"
		trap - EXIT
	fi
}

