import stable_whisper

model = stable_whisper.load_model('medium')



result = model.transcribe('output.aac', regroup=False)
(
    result
    .clamp_max()
    .split_by_punctuation([('.', ' '), '。', '?', '？', (',', ' '), '，'])
    .split_by_gap(.5)
    .merge_by_gap(.3, max_words=3)
	.split_by_length(15)
    .split_by_punctuation([('.', ' '), '。', '?', '？'])
)

model.refine('output.aac', result)

result.to_srt_vtt('audio.srt')