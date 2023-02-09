import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {
    function create(tx, note) {
        console.log("Repo.create", tx, note)
        tx.executeSql(
            'INSERT INTO notes (id, etag, readonly, content, title, category, favorite, modified) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [note.id, note.etag, note.readonly, note.context, note.title, note.category, note.favorite, note.modified])
    }

    function update(tx, note) {

    }

    function getAll(tx) {
        var res = []
        var results = tx.executeSql('SELECT id, etag, readonly, content, title, category, favorite, modified FROM notes')
        var length = results.rows.length
        for (var i = 0; i < length; i++) {
            res.push(results.rows.item(0))
        }
        return res
    }

    function getById(tx, id) {
        var results = tx.executeSql('SELECT id, etag, readonly, content, title, category, favorite, modified FROM notes WHERE id = ?', [id])
        if (results.rows.length === 1) {
            return results.rows.item(0)
        }
    }

    function remove(tx, id) {
        tx.executeSql('DELETE FROM notes WHERE id = ?', [id])
    }
}
