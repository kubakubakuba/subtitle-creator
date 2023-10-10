#!/usr/bin/bash
FILE=""
MODE=0
MODEL="medium" # default model
OUTPUT="output.aac"

while getopts "it:s:m:e:o:" opt; do
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
	s)	FILE=$OPTARG
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
	m)  MODEL=$OPTARG
		;;
    ?)	echo "Incorrect argument entered."
		echo "Use -i for installing the dependencies."
		echo "Use -t for transcribing the audio files."
		echo "Use -s for splitting the srt files."
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
	echo "Use -s for splitting the srt files."
	echo "Use -e to extract the audio from the video."
	echo "Use -o to select the output file name."
	exit 1
fi

if [ $MODE -eq 1 ]; then
	echo "Installing dependencies..."
	apt install ffmpeg
	pip install tensorflow
	pip3 install whisper
	pip3 install pydub
	pip3 install pysrt
	exit 0
fi

if [ $MODE -eq 2 ]; then
	echo "Transcribing audio files..."
	valid=("tiny" "base" "small" "medium" "large")

	if [[ " ${valid[*]} " == *" $MODEL "* ]]; then
    	whisper "$FILE" --model "$MODEL" --language Czech
	else
		echo "The input model '$MODEL' is not a valid model type."
		exit 2
	fi

	exit 0
fi

if [ $MODE -eq 3 ]; then
	echo "Splitting srt files..."
	python3 split.py "$FILE"
	exit 0
fi

if [ $MODE -eq 4 ]; then
	echo "Extracting audio from video..."
	ffmpeg -i "$FILE" -vn -acodec copy "$OUTPUT"
	exit $?
fi