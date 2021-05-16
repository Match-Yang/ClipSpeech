import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.14

Button {
    id: controller
    property alias source: icon.source
    property alias radius: bgRect.radius
    property string tooltop
    property color overlayColor: "transparent"

    implicitWidth: 26
    implicitHeight: 26

    Image {
        id: icon
        width: parent.width - 2
        height: parent.height - 2
        anchors.centerIn: parent
        ColorOverlay {
            anchors.fill: icon
            source: icon
            enabled: controller.overlayColor != "transparent"
            color: controller.overlayColor
        }
    }
    background: Rectangle {
        id: bgRect
        implicitWidth: parent.width
        implicitHeight: parent.height
        opacity: {
            if (controller.hovered) {
                return controller.down ? 0.3 : 0.2
            } else {
                return 0
            }
        }

        color: "gray"
        radius: parent.width
    }
}
