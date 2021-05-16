import QtQuick 2.0
import QtQuick.Controls 2.14

Item {
    id: root
    readonly property string kGroupName: "AZureAuth"
    readonly property string kSubscriptionKey: "AZureAuthSubscription"
    readonly property string kRegionKey: "AZureAuthRegion"
    Column {
        height: 200
        anchors.top: parent.top
        width: parent.width

        TextField {
            id: subscriptionField
            placeholderText: "密钥"
            height: 50
            width: parent.width
        }

        TextField {
            id: regionField
            placeholderText: "区域，比如：southeastasia"
            height: 50
            width: parent.width
        }
        Button {
            width: 100
            height: 50
            text: "应用"
            onClicked: {
                settings.set_value(root.kGroupName, root.kSubscriptionKey,
                                   subscriptionField.text)
                settings.set_value(root.kGroupName, root.kRegionKey,
                                   regionField.text)
                speech.set_auth(subscriptionField.text, regionField.text)
            }
        }

        Component.onCompleted: {
            var subscription = settings.get_value(root.kGroupName,
                                                  root.kSubscriptionKey)
            var region = settings.get_value(root.kGroupName, root.kRegionKey)
            speech.set_auth(subscription, region)
            subscriptionField.text = subscription
            regionField.text = region
        }
    }
}
