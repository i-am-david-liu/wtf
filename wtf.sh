#!/bin/bash

# =====================================================================================
# wtf: [w]hat's [t]hat [f]ile?
# 
# CLI tool to take notes on files and folders within a directory.
#
# =====================================================================================

# Check if a file exists in .wtf
# $1 - filename
file_exists () {
	if grep -q "^$1," .wtf; then
		return 0
	fi
	return 1
}

list () {
	#if [[ $# -eq 1 ]]; then
			
	#fi

	# get length of longest file name for padding 
	local file=".wtf"
	local max=0
	while read line; do
		local filename=$(echo "$line" | sed "s/,.*//")
		local length=${#filename}
		if [[ max -lt $length ]]; then
			max=$length
		fi
	done < $file

	# apply padding and display the file and note
	while read line; do
		local filename=$(echo "$line" | sed "s/,.*//")
		local length=${#filename}
		local note=$(echo "$line" | sed "s/.*,//")
		
		((pad_length = $max - $length + 1))
		printf "$filename%-${pad_length}s| $note\n" " "
	done < $file
}

init () {
	if [[ -f ".wtf" ]]; then
		# FINISH <-----------------------------------------------
		echo "A '.wtf' file has already been made. Destroy all notes and re-initialize? (Y/n): "
		exit 0
	fi

	# get dot files besides '.' and '..'
	for entry in ./.*; do
		if [[ $entry != "./." && $entry != "./.." && $entry != "./.wtf" ]]; then
			local new_entry=$(echo $entry | sed "s/^.\///")
			if [[ -d $entry ]]; then
				echo "${new_entry}/," >> .wtf
			else
				echo "${new_entry}," >> .wtf
			fi
		fi
	done

	# get everything else
	for entry in ./*; do
		local new_entry=$(echo $entry | sed "s/^.\///")
		if [[ -d $entry ]]; then
			echo "${new_entry}/," >> .wtf
		else
			echo "${new_entry}," >> .wtf
		fi
	done
}

# $1 - number of arguments passed
# $2 - filename
# $3 - note
note () {
	if [[ $1 -eq 1 ]]; then
		echo "Need to specify a filename and note"
	elif [[ $1 -eq 2 ]]; then
		echo "Need to specify a note for the file"
	else
		if ! [[ -f $2 || -d $2 ]]; then
			echo "'$2' does not exist in current directory"
		else
			# change '/' in folder names to '\/' for proper regex
			local file=$2
			if [[ -d $2 ]]; then
				file=$(echo $2 | sed "s/\///")
				sed -i "s/\(^$file\/,\).*/\1${3}/" .wtf
			else
				sed -i "s/\(^$file,\).*/\1${3}/" .wtf
			fi
		fi
	fi
}

# $1 - number of arguments passed
# $2 - filename
# remove () {
# 	if [[ $1 -eq 1 ]]; then
# 		echo "Need to specify a filename"
# 	elif file_exists $2; then
# 		sed -i "/^$2,/d" .wtf 
# 	else
# 		echo "File doesn't exist"
# 	fi
# }

if [[ $1 == "init" ]]; then
	init
	exit 0
fi

# check if directory contains a '.wtf' file
if ! [[ -f ".wtf" ]]; then
	echo "A '.wtf' file does not exist in this directory. Do 'wtf init' to create one."
	exit 0
fi

if [[ $# -eq 0 ]]; then
	list
elif [[ $1 == "note" ]]; then
	note $# $2 "$3"
# elif [[ $1 == "remove" ]]; then
# 	remove $# $2
elif [[ -f $1 || -d $1 ]]; then
	list $1
else
	echo "Unrecognized command or file: '$1'"
fi


