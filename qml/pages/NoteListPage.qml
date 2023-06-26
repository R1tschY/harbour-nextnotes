import QtQuick 2.0
import Sailfish.Silica 1.0
import "../api"


Page {
    id: page

    NextCloudNotesRequest {
        id: request
    }

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    function loadNotes() {
        var res
        db.transaction(function(tx) {
            res = repository.getAll(tx)
        })
        return res
    }

    SilicaListView {
        id: listView
        model: loadNotes()
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Nextcloud Notes")
        }

        delegate: BackgroundItem {
            id: delegate

            Label {
                x: Theme.horizontalPageMargin
                text: modelData.title
                anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: pageStack.push(Qt.resolvedUrl("NotePage.qml"), {
                                             "noteId": modelData.id,
                                             "note": modelData
                                         })
        }

        VerticalScrollDecorator { flickable: listView }
    }
}
