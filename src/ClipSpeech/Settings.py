# coding：utf-8
"""
Super speech
"""
import sys
import os
import json
from PySide2.QtCore import QObject,QSettings, Slot, Signal
from PySide2.QtCore import QStandardPaths


class Settings(QObject):


    def __init__(self):
        super(Settings, self).__init__(parent=None)
        self._settings = QSettings(parent=None)

    @Slot(str, str, str)
    def set_value(self, group: str, key: str, value: str):
        self._settings.beginGroup(group)
        self._settings.setValue(key, value)
        self._settings.endGroup()

    @Slot(str, str, result=str)
    def get_value(self, group: str, key: str) -> str:
        self._settings.beginGroup(group)
        value = self._settings.value(key, "")
        self._settings.endGroup()
        print(value)
        return value
