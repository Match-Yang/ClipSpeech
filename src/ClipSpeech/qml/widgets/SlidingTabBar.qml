import QtQuick 2.12
import QtQuick.Controls 2.14

Container {
    id: container

    contentItem: ListView {
        model: container.contentModel
        snapMode: ListView.SnapOneItem
        orientation: ListView.Horizontal
    }
}
