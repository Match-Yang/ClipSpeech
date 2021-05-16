# coding：utf-8
"""
Super speech
"""
import sys
import os
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import Qt
from PySide2.QtQml import QQmlContext

from Speech import Speech
from Settings import Settings


def main():
    sys.argv +=['--style', 'material`']
    QGuiApplication.setAttribute(Qt.AA_EnableHighDpiScaling)
    app = QGuiApplication(sys.argv)
    speech = Speech()
    settings = Settings()
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty('speech', speech)
    engine.rootContext().setContextProperty('settings', settings)
    engine.load(os.path.join(os.path.dirname(__file__), 'qml/main.qml'))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
