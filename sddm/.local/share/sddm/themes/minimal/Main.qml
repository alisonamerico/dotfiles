import QtQuick 2.0
import QtQuick.Controls 1.4 as Controls
import SddmComponents 2.0

Rectangle {
    width: 640
    height: 480
    color: "#000000"
    
    property int sessionIndex: 0
    
    Text {
        id: time
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ffffff"
        font.pixelSize: 42
        font.weight: 100
        text: Qt.formatTime(new Date(), "HH:mm")
    }
    
    Text {
        id: date
        anchors.top: time.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#888888"
        font.pixelSize: 14
        text: Qt.formatDate(new Date(), "dddd, d MMMM")
    }
    
    Column {
        anchors.centerIn: parent
        spacing: 10
        
        Controls.TextField {
            id: username
            width: 250
            height: 36
            text: ""
            placeholderText: "usuário"
            horizontalAlignment: TextInput.AlignHCenter
            style: TextFieldStyle {
                textColor: "#ffffff"
                placeholderTextColor: "#666666"
                backgroundColor: "#1a1a1a"
            }
        }
        
        Controls.TextField {
            id: password
            width: 250
            height: 36
            placeholderText: "senha"
            echoMode: TextInput.Password
            horizontalAlignment: TextInput.AlignHCenter
            style: TextFieldStyle {
                textColor: "#ffffff"
                placeholderTextColor: "#666666"
                backgroundColor: "#1a1a1a"
            }
        }
        
        Controls.Button {
            width: 250
            height: 36
            text: "ENTRAR"
            style: ButtonStyle {
                background: Rectangle {
                    color: "#333333"
                    radius: 4
                }
                label: Text {
                    color: "#ffffff"
                    font.weight: 500
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            onClicked: sddm.login(username.text, password.text, sessionIndex)
        }
    }
    
    Controls.ComboBox {
        id: session
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: 150
        style: ComboBoxStyle {
            backgroundColor: "#1a1a1a"
            textColor: "#ffffff"
        }
        
        model: sessionModel
        index: sessionIndex
        
        onCurrentIndexChanged: sessionIndex = currentIndex
    }
    
    Timer {
        interval: 1000
        running: true
        onTriggered: time.text = Qt.formatTime(new Date(), "HH:mm")
    }
}
