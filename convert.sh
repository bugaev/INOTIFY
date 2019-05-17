#!/usr/bin/env bash

WORKDIR=~/RIP
EXE=/nix/store/aivkar15gvwmb943ijnnzfmd2isjd4j5-handbrake-1.0.7/bin/HandBrakeCLI 

ts_p() {
    # Function "ts predicate". Test if the only argument's extention is ".ts"
    
    arg="$1"

    # Hungry deletion from the front of the string up to the last dot "."
    # yields the extention:
    ext="${arg##*.}"

    if [ "$ext" == ts ];
    then
	return 0
    else
	return 1
    fi
    
}

convert() {
	src_nodir="$1"
        src_fullpath="$WORKDIR/$src_nodir"
        src_base=$(basename "$src_nodir" .ts)
	dst_fullpath="$WORKDIR/$src_base.m4v"
	dstlog_fullpath="$dst_fullpath.log"
	# $EXE -i $src_fullpath -o $dst_fullpath -e x264 -q 20 --audio-lang-list eng --subtitle-lang-list eng --all-subtitles   --subtitle-burned=none 2>&1 | tee $dstlog_fullpath
	echo "Converting $1 ..."
}

inotifywait -m -e close_write -e moved_to --format %f ~/RIP |
	while read line
	do
	    if ts_p "$line";
	    then
		time convert "$line"
	    else
		echo "Got $line, doing nothing."
	    fi
	done

