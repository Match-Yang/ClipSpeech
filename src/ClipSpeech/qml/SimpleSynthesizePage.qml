import QtQuick 2.0
import QtQuick.Controls 2.14

Item {
    TextEdit {
        id: editor

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: ctrlItem.top
        anchors.bottomMargin: 3

        selectByMouse: true
    }
    Item {
        id: ctrlItem
        height: 90
        width: parent.width
        anchors.bottom: parent.bottom
        Component.onCompleted: {
            speechTypeBox.model = JSON.parse(speech.voices_json_config())
        }

        Column {
            width: parent.width
            height: childrenRect.height

            // 第一行，语言与风格
            Row {
                width: parent.width
                height: 30
                spacing: 5

                Label {
                    text: "语音"
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

                ComboBox {
                    id: speechTypeBox
                    width: 100
                    height: parent.height
                    textRole: "type"
                    onCurrentIndexChanged: {
                        voiceBox.model = model[currentIndex].voices
                    }
                }
                ComboBox {
                    id: voiceBox
                    width: 150
                    height: parent.height
                    textRole: "语音名称"
                    valueRole: "语音名称"
                    delegate: ItemDelegate {
                        width: voiceBox.width
                        contentItem: Text {
                            text: modelData["语音名称"]
                            font: voiceBox.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter

                            ToolTip.visible: hovered
                            ToolTip.delay: 0
                            ToolTip.text: modelData["语言"] + " | " + modelData["性别"]
                        }
                        highlighted: voiceBox.highlightedIndex === index
                    }
                    onCurrentIndexChanged: {
                        voiceStypeBox.model = model[currentIndex]["风格列表"]
                    }
                }
                ComboBox {
                    id: voiceStypeBox
                    width: 150
                    height: parent.height
                    textRole: "style"
                    valueRole: "style"
                    delegate: ItemDelegate {
                        width: voiceBox.width
                        contentItem: Text {
                            text: modelData["style"]
                            font: voiceBox.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter

                            ToolTip.visible: hovered
                            ToolTip.delay: 0
                            ToolTip.text: modelData.desc
                        }
                        highlighted: voiceBox.highlightedIndex === index
                    }
                }
                Slider {
                    id: styledegreeSlider
                    width: 180
                    from: 0.01
                    value: 1
                    to: 2
                    handle: Rectangle {
                        x: styledegreeSlider.leftPadding + styledegreeSlider.visualPosition
                           * (styledegreeSlider.availableWidth - width)
                        y: styledegreeSlider.topPadding
                           + styledegreeSlider.availableHeight / 2 - height / 2
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        color: styledegreeSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                    ToolTip {
                        parent: styledegreeSlider.handle
                        visible: styledegreeSlider.pressed
                        text: styledegreeSlider.value.toFixed(1)
                    }
                }
            }

            // 第二行，韵律调节
            Row {
                width: parent.width
                height: 30

                Label {
                    text: "韵律"
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

                Slider {
                    id: pitchSlider
                    width: 200
                    from: -10
                    value: 1
                    to: 10
                    stepSize: 1
                    handle: Rectangle {
                        x: pitchSlider.leftPadding + pitchSlider.visualPosition
                           * (pitchSlider.availableWidth - width)
                        y: pitchSlider.topPadding + pitchSlider.availableHeight / 2 - height / 2
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        color: pitchSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                    ToolTip {
                        parent: pitchSlider.handle
                        visible: pitchSlider.pressed
                        text: "音调：" + pitchSlider.value.toFixed(1) + "st"
                    }
                }
                Slider {
                    id: rateSlider
                    width: 200
                    from: -200
                    value: 0
                    to: 200
                    stepSize: 10
                    handle: Rectangle {
                        x: rateSlider.leftPadding + rateSlider.visualPosition
                           * (rateSlider.availableWidth - width)
                        y: rateSlider.topPadding + rateSlider.availableHeight / 2 - height / 2
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        color: pitchSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                    ToolTip {
                        parent: rateSlider.handle
                        visible: rateSlider.pressed
                        text: "速度：" + rateSlider.value.toFixed(1) + "%"
                    }
                }
                Slider {
                    id: volumeSlider
                    width: 200
                    from: 0
                    value: 100
                    to: 100
                    stepSize: 1
                    handle: Rectangle {
                        x: volumeSlider.leftPadding + volumeSlider.visualPosition
                           * (volumeSlider.availableWidth - width)
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        color: pitchSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                    ToolTip {
                        parent: volumeSlider.handle
                        visible: volumeSlider.pressed
                        text: "音量：" + volumeSlider.value.toFixed(1) + "%"
                    }
                }
            }

            Button {
                id: startBtn
                width: 100
                height: 30
                text: enabled ? "Start" : "Processing..."
                onClicked: {
                    var info = {
                        "id": "simple_synthesize_page",
                        "context": editor.text,
                        "voice": voiceBox.currentValue,
                        "voiceStyle": voiceStypeBox.currentText,
                        "styledegree": styledegreeSlider.value,
                        "pitch": pitchSlider.value
                                 >= 0 ? ("+" + pitchSlider.value.toString(
                                             ) + "st") : (pitchSlider.value.toString(
                                                              ) + "st"),
                        "rate": rateSlider.value
                                >= 0 ? ("+" + rateSlider.value.toString(
                                            ) + "%") : (rateSlider.value.toString(
                                                            ) + "%"),
                        "volume": volumeSlider.value
                                  >= 0 ? ("+" + volumeSlider.value.toString(
                                              ) + "%") : (volumeSlider.value.toString(
                                                              ) + "%")
                    }
                    speech.start_simple_tts(JSON.stringify(info))
                    //enabled = false
                }
                Connections {
                    target: speech
                    function onAllReady() {
                        startBtn.enabled = true
                    }
                    function onStoped() {
                        startBtn.enabled = true
                    }
                    function onFailed() {
                        speech.log_from_qml("failedddd->>")
                        startBtn.enabled = true
                    }
                }
            }
        }
    }
}
