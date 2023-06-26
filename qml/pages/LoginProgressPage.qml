import QtQuick 2.0
import Sailfish.Silica 1.0
import "../api"

Page {
    id: page

    property string userName
    property string password
    property string server

    onStatusChanged: {
        if (status === PageStatus.Active) {
            if (server) {
                authManager.setAuth(server, userName, password)
            }
            notesClient.login()
            syncService.sync()
        }
    }

    Connections {
        target: notesClient

        onLoginErrorOccured: {
            pageStack.replace(Qt.resolvedUrl("ErrorPage.qml"), {
                "header": qsTr("Login Error"),
                "text": message
            }, PageStackAction.Immediate)
        }

        onLoggedIn: {
            pageStack.replaceAbove(null, Qt.resolvedUrl("NoteListPage.qml"))
        }
    }

    PageBusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        running: true
    }

    Label {
        width: page.width
        text: qsTr("Logging in…")
        anchors.top: busyIndicator.bottom
        anchors.topMargin: Theme.paddingLarge
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeLarge
    }
}
