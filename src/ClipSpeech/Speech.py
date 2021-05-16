# coding：utf-8
"""
Super speech
"""
import sys
import os
import json
import srt
import requests
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
        self._subscription = ""
        self._region = ""

    @Slot(str, str)
    def set_auth(self, subscription: str, region: str):
        self._subscription = subscription
        self._region = region

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

    @Slot(str, str)
    def start_simple_tts(self, content: str, ui_config: str):
        if content == '':
            self.failed.emit()
            return
        out_file = os.path.join(QStandardPaths.writableLocation(QStandardPaths.DownloadLocation), 'tts.wav')
        self._do_tts(True, self._get_ssml_config_template(ui_config).format(content), out_file)
        self.allReady.emit()

    @Slot(str, str)
    def start_tts_by_srt_file(self, file_name: str, config_str: str):
        subs = []
        with open(file_name, mode='r', encoding='utf-8') as file:
            subs = list(srt.parse(file.read()))
        # print(subs[0].start, subs[0])
        ssml_template_str = self._get_ssml_config_template(config_str)
        (base_name, ext) = os.path.splitext(file_name)
        out_dir = os.path.join(QStandardPaths.writableLocation(QStandardPaths.DownloadLocation), base_name)
        print("Subtitles to tts results store in: ", out_dir)
        if not os.path.isdir(out_dir):
            os.mkdir(out_dir)
        for srt_obj in subs:
            text = srt_obj.content.replace('\u200e', '')
            out_file = os.path.join(out_dir, '{}.wav'.format(text))
            self._do_tts(True, ssml_template_str.format(text), out_file)

    def _do_tts(self, use_speaker: bool, ssml_config: str, output_file: str):
        print("Start: ", output_file)
        speech_config = SpeechConfig(subscription=self._subscription, region=self._region)
        audio_config = AudioOutputConfig(use_default_speaker=use_speaker)
        synthesizer = SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)

        result = synthesizer.speak_ssml_async(ssml_config).get()

        stream = AudioDataStream(result)
        stream.save_to_wav_file(output_file)
        print("Finished", output_file)

    def _get_ssml_config_template(self, ui_config: str):
        # <speak xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="http://www.w3.org/2001/mstts" xmlns:emo="http://www.w3.org/2009/10/emotionml" version="1.0" xml:lang="en-US">
        #     <voice name="{voice}">
        #         <mstts:express-as style="{style}" styledegree="{style_degree}">
        #             <prosody rate="{rate}" pitch="{pitch}" volume="{volume}">
        #                 {context}
        #             </prosody>
        #         </mstts:express-as>
        #     </voice>
        # </speak>
        obj = json.loads(ui_config)
        ssml_template_str = '<speak xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="http://www.w3.org/2001/mstts" xmlns:emo="http://www.w3.org/2009/10/emotionml" version="1.0" xml:lang="en-US"><voice name="{voice}"><mstts:express-as style="{style}" styledegree="{style_degree}"><prosody rate="{rate}" pitch="{pitch}" volume="{volume}">{context_holder}</prosody></mstts:express-as></voice></speak>'.format(voice=obj['voice'], style=obj['voiceStyle'], style_degree=obj['styledegree'], rate=obj['rate'], pitch=obj['pitch'], volume=obj['volume'], context_holder='{}')
        return ssml_template_str


