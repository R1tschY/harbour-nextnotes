import QtQuick 2.0
import Qommons.Lang 0.1

import "../db"
import "../api"

Container {
    // public

    property bool busy: false

    function sync() {
        request.requestFirstChangedChunk()
    }

    signal synced()

    // private

    NotesRepository {
        id: repository
    }

    NextCloudNotesRequest {
        id: request
        chunkSize: 10

        onSuccess: {
            var chunk = responseData
            db.transaction(function(tx) {
                for (var i = 0; i < chunk.length; i++) {
                    mergeNote(tx, chunk[i])
                }
            })

            if (request.pending === 0) {
                console.log("Sync done")
                synced()
            } else {
                console.log("Still " + request.pending + " items open for sync")
                request.requestNextChunk()
            }
        }
    }

    function mergeNote(tx, item) {
        if (typeof item.modified === "undefined") {
            // Ignore strange items which only have the id field
            return
        }

        var note = repository.getById(tx, item.id)
        if (note) {
            // update

            if (typeof item.etag !== "undefined") {
                if (note.etag === item.etag) {
                    if (note.dirty) {
                        // new local changes
                        console.log("TODO: New local changes for " + item.id)
                    } else {
                        // no changes
                        console.debug("No remote changes for " + item.id)
                        return
                    }
                } else {
                    // conflict
                    console.log("TODO: Conflict for " + item.id)
                }
            } else {
                // ETags are missing :(
                console.log("TODO: ETag is missing for " + item.id + ": " + JSON.stringify(note))
            }

        } else {
            // add
            console.log("Creating new local note for " + item.id)
            repository.create(tx, item)
        }
    }
}
