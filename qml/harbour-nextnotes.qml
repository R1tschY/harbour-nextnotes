import QtQuick 2.0
import Sailfish.Silica 1.0
//import Sailfish.Secrets 1.0
import R1tschY.NextNotes 0.1
import "pages"
import "api"
import "services"
import "db"

ApplicationWindow {
    AuthManager {
        id: authManager

        secretName: "NextCloud Login"
    }

    DbConnection {
        id: db

        dataBaseId: "notes"
    }

    NextCloudNotesClient {
        id: notesClient
    }

    NotesRepository {
        id: repository
    }

    SyncService {
        id: syncService
    }

    initialPage: Component { StartupPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
