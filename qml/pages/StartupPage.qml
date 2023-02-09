import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    PageBusyIndicator {
        running: true
    }

    Connections {
        target: authManager

        onLoaded: {
            if (authManager.token) {
              pageStack.replace(Qt.resolvedUrl("LoginProgressPage.qml"), {},
                                PageStackAction.Immediate)
            } else {
              pageStack.replace(Qt.resolvedUrl("LoginPage.qml"), {},
                                PageStackAction.Immediate)
            }
        }

        onErrorOccured: {
            pageStack.replace(Qt.resolvedUrl("ErrorPage.qml"), {},
                              PageStackAction.Immediate)
        }
    }

    Component.onCompleted: authManager.loadFromSystem()
}
