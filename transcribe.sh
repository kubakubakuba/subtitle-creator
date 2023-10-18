#!/usr/bin/bash
FILE=""
MODE=0
MODEL="medium" # default model
OUTPUT="output.aac"

while getopts "it:p:m:e:o:b:" opt; do
    case $opt in
    i)	MODE=1
        ;;
    t)	FILE=$OPTARG
    	MODE=2
		if [ ! -f "$FILE" ]; then
			echo "The input file '$FILE' does not exist."
			exit 3
		fi
        ;;
	p)	FILE=$OPTARG
		MODE=3
		if [ ! -f "$FILE" ]; then
			echo "The input file '$FILE' does not exist."
			exit 3
		fi
		;;
	o)	OUTPUT=$OPTARG
		;;
	e) 	FILE=$OPTARG
		MODE=4
		if [ ! -f "$FILE" ]; then
			echo "The input file '$FILE' does not exist."
			exit 3
		fi
		;;
	b) 	FILE=$OPTARG
		MODE=5
		if [ ! -f "$FILE" ]; then
			echo "The input file '$FILE' does not exist."
			exit 3
		fi
		;;
	m)  MODEL=$OPTARG
		;;
    ?)	echo "Incorrect argument entered."
		echo "Use -i for installing the dependencies."
		echo "Use -t for transcribing the audio files."
		echo "Use -p for processing the srt files."
		echo "Use -m for selecting the model type."
		echo "Use -e to extract the audio from the video."
		echo "Use -o to select the output file name."
		exit 1
        ;;
    esac
done

if [ $MODE -eq 0 ]; then
	echo "No mode selected."
	echo "Use -i for installing the dependencies."
	echo "Use -t for transcribing the audio files."
	echo "Use -p for processing the srt files."
	echo "Use -e to extract the audio from the video."
	echo "Use -o to select the output file name."
	exit 1
fi

if [ $MODE -eq 1 ]; then
	echo "Installing dependencies..."
	apt install ffmpeg
	pip3 install --upgrade tensorflow
	pip3 install --upgrade whisper
	pip3 install --upgrade pydub
	pip3 install --upgrade pysrt
	pip3 instal --upgrade torch
	pip3 install stable-ts
	#pip3 install git+https://github.com/jianfch/stable-ts.git

	exit 0
fi

if [ $MODE -eq 2 ]; then
	echo "Transcribing audio files..."
	valid=("tiny" "base" "small" "medium" "large")

	if [[ " ${valid[*]} " == *" $MODEL "* ]]; then
    	whisper "$FILE" --model "$MODEL"
	else
		echo "The input model '$MODEL' is not a valid model type."
		exit 2
	fi

	exit 0
fi

if [ $MODE -eq 3 ]; then
	echo "Processing srt files..."
	tr '\n' ' ' < "$FILE" > "$FILE.tmp"
	python3 split.py "$FILE.tmp"
	mv "$FILE.tmp" "${FILE%.srt}_processed.srt"
	exit 0
fi

if [ $MODE -eq 4 ]; then
	echo "Extracting audio from video..."
	ffmpeg -i "$FILE" -vn -acodec copy "$OUTPUT"
	exit $?
fi

if [ $MODE -eq 5 ]; then
	echo "Transcribing audio files to clearer subtitles..."
	valid=("tiny" "base" "small" "medium" "large")

	if [[ " ${valid[*]} " == *" $MODEL "* ]]; then
    	stable-ts "$FILE" -o "${FILE%.mp3}.srt" -m "$MODEL"
	else
		echo "The input model '$MODEL' is not a valid model type."
		exit 2
	fi

	exit 0
fi