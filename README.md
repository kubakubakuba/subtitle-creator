# Subtitle creator
## Installation
For the installation of all dependencies, run the following commands in the terminal:
```bash
git clone
chmod +x transcribe.sh
./transcribe.sh -i
```

## Usage
Firstly, extract an audio from the video file. To do this, run the following command in the terminal:
```bash
./transcribe.sh -e <path/to/file> -o <path/to/output>
```
The output file name is optional. If not specified, the output file will be named by a default name.

To transcribe the audio file, run the following command in the terminal:
```bash
./transcribe.sh -t <path/to/file> -m "medium"
```
The model type is optional. If not specified, the default model will be set to `medium`. The model types are: `"tiny" "base" "small" "medium" "large"`.

To split the subtitle format file into multiple files, run the following command in the terminal:
```bash
./transcribe.sh -s <path/to/file>
```

Run the script with no arguments to see the help message.