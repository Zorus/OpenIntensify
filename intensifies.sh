#!/bin/bash

rand() {
	local min=$1
	local max=$2
	local range=$(($max - $min))
	echo $(( ($RANDOM % ($range+1)) + $min ))
}

f=$1

if [ ! -r "$f" ]; then
	echo "Usage: $0 image_file" >&2
	exit 1
fi

o=`basename ${f%.*}`ing-intensifies.gif

width=`identify -format '%w' $f`
height=`identify -format '%h' $f`
dimensions="${width}x${height}"

if [ "$dimensions" = "x" ]; then
	echo "Unable to get dimensions of $f" >&2
	exit 1
fi

frames=()
nframes=5
for ((i=0; i<$nframes; i++)); do
	x=$(( $(rand 0 $(($width/20))) - ($width/40) ))
	y=$(( $(rand 0 $(($height/20))) - ($height/40) ))
	[ $x -gt 0 ] && x="+${x}"
	[ $y -gt 0 ] && y="+${y}"
	framef="$o-frame${i}.gif"
	echo -en "\rGenerating frame $((i+1))/$nframes @ ($x, $y)"
	convert $f -page "${x}${y}" -background transparent -flatten $framef
	frames+=($framef)
done

echo -e "\rWriting output to: $o"
convert -loop 0 -delay 2 -set dispose background ${frames[@]} $o

rm -f ${frames[@]}
