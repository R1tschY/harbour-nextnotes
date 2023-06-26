import QtQuick 2.0
import Sailfish.Silica 1.0
import "../api"
import "../dateUtil.js" as DateUtil

Page {
    property int noteId
    property var note

    id: page

    allowedOrientations: Orientation.All

    function loadNote() {
        var res
        db.transaction(function(tx) {
            res = repository.getById(tx, noteId)
        })
        return res
    }

    SilicaFlickable {
        id: pageFlickable
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
            }
        }

        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: note.title
                width: parent.width
            }

            TextArea {
                id: editor

                width: parent.width

                focus: true
                readOnly: !!note.readonly

                text: note.content || ""
            }

            DetailItem {
                label: qsTr("Modified")
                value: new Date(note.modified * 1000).toLocaleString(Qt.locale(), Locale.ShortFormat)
            }
        }

        VerticalScrollDecorator { flickable: pageFlickable }
    }
}
