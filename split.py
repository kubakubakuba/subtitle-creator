import pysrt
from pydub import AudioSegment
import sys

subs = pysrt.open(sys.argv[1].replace('.mp3', '.srt'))
audio = AudioSegment.from_mp3(sys.argv[1])

transcript_segments = []
for sub in subs:
    start_time = (sub.start.minutes * 60 + sub.start.seconds) * 1000 + sub.start.milliseconds
    end_time = (sub.end.minutes * 60 + sub.end.seconds) * 1000 + sub.end.milliseconds
    transcript_segments.append((start_time, end_time, sub.text))

from pydub.silence import split_on_silence

refined_subs = []
for start, end, text in transcript_segments:
    segment_audio = audio[start:end]
    chunks = split_on_silence(segment_audio, silence_thresh=-40, min_silence_len=300)
    
    new_start = start
    for chunk in chunks:
        new_end = new_start + len(chunk)
        refined_subs.append((new_start, new_end, text))
        new_start = new_end

new_subs = pysrt.SubRipFile()
for i, (start, end, text) in enumerate(refined_subs):
    item = pysrt.SubRipItem()
    item.index = i
    item.start.seconds = start // 1000
    item.end.seconds = end // 1000
    item.text = text
    new_subs.append(item)
    
new_subs.save('new_file.srt')
