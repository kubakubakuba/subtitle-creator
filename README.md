# Subtitle creator
## Installation
For the installation of all dependencies, run the following commands in the terminal:
```bash
git clone git@github.com:kubakubakuba/subtitle-creator.git
cd subtitle-creator
chmod +x transcribe.sh
./transcribe.sh -i
```

## Usage
Firstly, extract an audio from the video file. To do this, run the following command in the terminal:
```bash
./transcribe.sh -e <path/to/file> -o <path/to/output>
```
The output file name is optional. If not specified, the output file will be named by a default name.

### Base whisper

To transcribe the audio file, run the following command in the terminal:
```bash
./transcribe.sh -t <path/to/file> -m "medium"
```
The model type is optional. If not specified, the default model will be set to `medium`. The model types are: `"tiny" "base" "small" "medium" "large"`.

### Better transcription using stable-ts
Run the following command:
```bash
./transcribe.sh -b <path/to/file> -m "large"
```
The process will take a while, the output subtitles file will have the same name as the input audio file.
The resulting subtitles look like this:

![subtitles_gif](https://github.com/kubakubakuba/subtitle-creator/assets/13603688/c4342124-2c38-44ed-8020-38fa4c7061d7)

To split the subtitle file into single words, run the following command in the terminal:
```bash
python3 split.py <path/to/srt/file>
```

Run the script with no arguments to see the help message.

Created for [Technologická gramotnost](https://www.technologicka-gramotnost.cz/).
