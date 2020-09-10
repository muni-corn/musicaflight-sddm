import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Column {
            id: clock
            anchors.leftMargin: 256
            anchors.left: parent.left

            property date dateTime: new Date()

            Timer {
                interval: 100; running: true; repeat: true;
                onTriggered: clock.dateTime = new Date()
            }

            Text {
                id: time
                anchors.topMargin: 128
                anchors.top: parent.top
                anchors.left: parent.left

                color: "white"

                text : Qt.formatTime(clock.dateTime, "hh:mm")

                font.pixelSize: 128
                font.weight: Font.Thin
            }

            Text {
                id: date
                anchors.topMargin: 168
                anchors.top: time.top
                anchors.left: parent.left

                color: "white"

                text : Qt.formatDate(clock.dateTime, Qt.DefaultLocaleLongDate)

                font.pixelSize: 24
            }
        }

        Column {
            id: mainColumn
            spacing: 16

            anchors.left: clock.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 128

            Text {
                color: "white"
                verticalAlignment: Text.AlignVCenter
                height: text.implicitHeight
                text: qsTr("Hello")
                wrapMode: Text.WordWrap
                font.pixelSize: 24
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            Column {
                width: parent.width
                spacing: 4
                Text {
                    id: lblName
                    width: parent.width
                    text: textConstants.userName
                    font.pointSize: 11
                    color: "white"
                }

                TextBox {
                    id: name

                    radius: 8
                    color: "#00000000"
                    textColor: "white"
                    borderColor: "#40ffffff"
                    hoverColor: "white"
                    focusColor: "white"
                    width: parent.width; height: 32
                    text: userModel.lastUser
                    font.pointSize: 11

                    KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 4
                Text {
                    id: lblPassword
                    width: parent.width
                    text: textConstants.password
                    font.pointSize: 11
                    color: "white"
                }

                PasswordBox {
                    id: password

                    radius: 8
                    color: "#00000000"
                    textColor: "white"
                    borderColor: "#40ffffff"
                    hoverColor: "white"
                    focusColor: "white"
                    width: parent.width; height: 32
                    font.pointSize: 11

                    KeyNavigation.backtab: name; KeyNavigation.tab: session

                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }
            }

            Row {
                spacing: 4
                width: parent.width / 2
                z: 100

                Column {
                    z: 100
                    width: parent.width * 1.3
                    spacing : 4
                    anchors.bottom: parent.bottom

                    Text {
                        id: lblSession
                        width: parent.width
                        text: textConstants.session
                        wrapMode: TextEdit.WordWrap
                        font.pointSize: 11
                        color: "white"
                    }

                    ComboBox {
                        id: session

                        color: "#00000000"
                        textColor: "white"
                        borderColor: "#40ffffff"
                        hoverColor: "white"
                        focusColor: "white"
                        width: parent.width; height: 32
                        font.pointSize: 11

                        arrowIcon: "angle-down.png"

                        model: sessionModel
                        index: sessionModel.lastIndex

                        KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                    }
                }

                Column {
                    z: 101
                    width: parent.width * 0.7
                    spacing : 4
                    anchors.bottom: parent.bottom

                    Text {
                        id: lblLayout
                        width: parent.width
                        text: textConstants.layout
                        wrapMode: TextEdit.WordWrap
                        font.pointSize: 11
                        color: "white"
                    }

                    LayoutBox {
                        id: layoutBox

                        color: "#00000000"
                        textColor: "white"
                        borderColor: "#40ffffff"
                        hoverColor: "white"
                        focusColor: "white"
                        width: parent.width; height: 32
                        font.pointSize: 11

                        arrowIcon: "angle-down.png"

                        KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                    }
                }
            }

            Row {
                spacing: 4
                anchors.horizontalCenter: parent.horizontalCenter
                property int btnWidth: Math.max(loginButton.implicitWidth,
                shutdownButton.implicitWidth,
                rebootButton.implicitWidth, 80) + 8
                Button {
                    id: loginButton
                    text: textConstants.login
                    width: parent.btnWidth

                    borderColor: "white"
                    textColor: "white"
                    color: "#00ffffff"
                    activeColor: "#40ffffff"
                    pressedColor: "#80ffffff"

                    onClicked: sddm.login(name.text, password.text, sessionIndex)

                    KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                }

                Button {
                    id: shutdownButton
                    text: textConstants.shutdown
                    width: parent.btnWidth

                    borderColor: "white"
                    textColor: "white"
                    color: "#00ffffff"
                    activeColor: "#40ffffff"
                    pressedColor: "#80ffffff"

                    onClicked: sddm.powerOff()

                    KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                }

                Button {
                    id: rebootButton
                    text: textConstants.reboot
                    width: parent.btnWidth

                    borderColor: "white"
                    textColor: "white"
                    color: "#00ffffff"
                    activeColor: "#40ffffff"
                    pressedColor: "#80ffffff"

                    onClicked: sddm.reboot()

                    KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
        name.focus = true
        else
        password.focus = true
    }
}
