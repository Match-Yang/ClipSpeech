import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.14

Item {
    id: controller
    property real padding: 0
    property real iconTitleSpacing: 0
    property alias title: titleLabel.text
    property string normalIcon
    property string hoverIcon
    property string pressIcon
    property string selectedIcon
    property color background
    property color hoverBackground
    property color pressBackground
    property color selectedColor
    property bool selected: false
    property real iconSize: 20
    property color backgroundColor: "#000000"
    property color frontgroundColor: "#ffffff"

    signal clicked

    clip: true

    height: parent.height
    state: selected ? "selected" : "normal"

    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: controller
                width: titleLabel.width + padding * 2
            }
            PropertyChanges {
                target: titleLabel
                opacity: 0.5
            }
            PropertyChanges {
                target: backgroundRect
                opacity: 0.5
            }
        },
        State {
            name: "selected"
            PropertyChanges {
                target: controller
                width: icon.width + titleLabel.width + iconTitleSpacing + padding * 2
            }
            PropertyChanges {
                target: titleLabel
                opacity: 1
            }
            PropertyChanges {
                target: backgroundRect
                opacity: 1
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {
                properties: "width, opacity"
                duration: 200
                easing.type: Easing.InCubic
            }
        }
    ]

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        radius: parent.height / 2
        color: parent.backgroundColor
        opacity: 0.1
    }

    Image {
        id: icon
        source: normalIcon
        width: normalIcon == "" ? 0 : controller.iconSize
        height: normalIcon == "" ? 0 : controller.iconsSize
        smooth: true
        fillMode: Image.PreserveAspectFit
        anchors.left: parent.left
        anchors.leftMargin: padding
        anchors.verticalCenter: parent.verticalCenter
        ColorOverlay {
            anchors.fill: icon
            source: icon
            color: controller.frontgroundColor
        }
    }

    Item {
        id: titleItem
        height: parent.height
        width: childrenRect.width

        anchors.right: parent.right
        anchors.rightMargin: padding
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: titleLabel
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            height: parent.height
            font.pixelSize: 10
            font.bold: true
            color: controller.frontgroundColor
        }
    }

    MouseArea {
        id: controlMouse
        anchors.fill: parent
        onClicked: {
            controller.clicked()
        }
    }
}
