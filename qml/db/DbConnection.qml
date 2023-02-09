import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {
    property string dataBaseId

    property var _db

    onDataBaseIdChanged: {
        if (dataBaseId) {
            _db = LocalStorage.openDatabaseSync(dataBaseId, "1", "", 1000000)
            _db.transaction(function (tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS notes (' +
                              'id INTEGER PRIMARY KEY, ' +
                              'etag TEXT, ' +
                              'readonly BOOLEAN, ' +
                              'content TEXT, ' +
                              'title TEXT, ' +
                              'category TEXT, ' +
                              'favorite BOOLEAN, ' +
                              'modified INTEGER, ' +
                              'dirty BOOLEAN, ' +
                              'conflict INTEGER' +
                              ')')
            })
        } else {
            _db = null
        }
    }

    function transaction(fn) {
        if (_db !== null) {
            _db.transaction(fn)
        }
    }
}
