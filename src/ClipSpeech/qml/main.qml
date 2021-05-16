import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Window 2.15
import "widgets"

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("SimpleSpeech")

    SwipeView {
        id: contentView
        currentIndex: slidingTabBar.currentIndex
        anchors.fill: parent

        SimpleSynthesizePage {}

        Rectangle {}

        Rectangle {}

        SettingsPage {}
    }
    //    background: Rectangle {
    //        color: "#090c12"
    //    }
    header: ToolBar {
        contentHeight: 40

        Rectangle {
            anchors.fill: parent
            color: "#2e343a"

            SlidingTabBar {
                id: slidingTabBar
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                height: 20
                width: parent.width
                currentIndex: contentView.currentIndex

                SlidingTabButton {
                    id: addBtn
                    title: qsTr("简单合成")
                    padding: 30
                    iconTitleSpacing: 5
                    backgroundColor: "red"
                    frontgroundColor: "#ffffff"
                    selected: slidingTabBar.currentIndex == 0
                    onClicked: {
                        slidingTabBar.currentIndex = 0
                    }
                }

                SlidingTabButton {
                    id: finishedBtn
                    title: qsTr("字幕合成")
                    padding: 20
                    iconTitleSpacing: 5
                    backgroundColor: "#99f5cf8e"
                    frontgroundColor: "#ffffff"
                    selected: slidingTabBar.currentIndex == 1
                    onClicked: {
                        slidingTabBar.currentIndex = 1
                    }
                }

                SlidingTabButton {
                    id: settingsBtn
                    title: qsTr("高级合成")
                    padding: 20
                    iconTitleSpacing: 5
                    backgroundColor: "#99d75656"
                    frontgroundColor: "#ffffff"
                    selected: slidingTabBar.currentIndex == 2
                    onClicked: {
                        slidingTabBar.currentIndex = 2
                    }
                }
                SlidingTabButton {
                    title: qsTr("设置")
                    padding: 20
                    iconTitleSpacing: 5
                    backgroundColor: "#99d75656"
                    frontgroundColor: "#ffffff"
                    selected: slidingTabBar.currentIndex == 2
                    onClicked: {
                        slidingTabBar.currentIndex = 3
                    }
                }
            }
        }
    }
}
