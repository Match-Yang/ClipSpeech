# coding：utf-8
"""
Super speech
"""
import sys
import os
import json
from PySide2.QtCore import QObject, Slot, Signal
from PySide2.QtCore import QStandardPaths
from azure.cognitiveservices.speech import AudioDataStream, SpeechConfig, SpeechSynthesizer, SpeechSynthesisOutputFormat
from azure.cognitiveservices.speech.audio import AudioOutputConfig


class Speech(QObject):
    allReady = Signal()
    stoped = Signal()
    failed = Signal()

    def __init__(self):
        super(Speech, self).__init__(parent=None)

    @Slot(str)
    def log_from_qml(self, log: str):
        print(log)

    @Slot(result=str)
    def voices_json_config(self):
        try:
            with open('resources/config/voices_config.json', mode='r', encoding='utf-8') as file:
                return file.read()
        except:
            return ""

    @Slot(str)
    def start_simple_tts(self, content: str):
        obj = json.loads(content)
        print(obj)
        if obj['context'] == '':
            self.failed.emit()
            return
        speech_config = SpeechConfig(subscription="", region="")
        audio_config = AudioOutputConfig(use_default_speaker=True)
        synthesizer = SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)
        ssml_str = '''
            <speak xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="http://www.w3.org/2001/mstts" xmlns:emo="http://www.w3.org/2009/10/emotionml" version="1.0" xml:lang="en-US">
                <voice name="{voice}">
                    <mstts:express-as style="{style}" styledegree="{style_degree}">
                        <prosody rate="{rate}" pitch="{pitch}" volume="{volume}">
                            {context}
                        </prosody>
                    </mstts:express-as>
                </voice>
            </speak>
        '''.format(voice=obj['voice'], style=obj['voiceStyle'], style_degree=obj['styledegree'], rate=obj['rate'], pitch=obj['pitch'], volume=obj['volume'], context=obj['context'])
        result = synthesizer.speak_ssml_async(ssml_str).get()

        stream = AudioDataStream(result)
        out_file = os.path.join(QStandardPaths.writableLocation(QStandardPaths.DownloadLocation), 'tts.wav')
        stream.save_to_wav_file(out_file)
        print("Finished", out_file)
        self.allReady.emit()
