import QtQuick 2.0

NextCloudRequest {
    id: root

    property int chunkSize: 50
    // readonly
    property int pending: -1
    property string etag: ""

    property string _cursor: ""

    onFinished: {
        if (response.status === 200) {
            etag = response.getHeader("ETag") || ""
            _cursor = response.getHeader("X-Notes-Chunk-Cursor") || ""
            pending = Number(response.getHeader("X-Notes-Chunk-Pending") || "0")
        } else {
            etag = ""
            _cursor = ""
            pending = 0
        }
    }

    function requestFirstChunk() {
        etag = ""
        _cursor = ""
        pending = -1
        executeApi("GET", notesClient.basePath + "/notes",
                   { chunkSize: chunkSize })
    }

    function requestNextChunk() {
        executeApi("GET", notesClient.basePath + "/notes",
                   { chunkSize: chunkSize, chunkCursor: _cursor })
    }

    function requestFirstChangedChunk() {
        _cursor = ""
        pending = -1
        if (etag) {
            executeApi("GET", notesClient.basePath + "/notes",
                       { chunkSize: chunkSize }, null, "json", { "If-None-Match": _etag })
        } else {
            requestFirstChunk()
        }
    }
}
