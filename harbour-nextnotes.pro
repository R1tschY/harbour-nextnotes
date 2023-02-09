# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-nextnotes

CONFIG += sailfishapp
CONFIG += link_pkgconfig

PKGCONFIG += sailfishsecrets sailfishapp

SOURCES += src/harbour-nextnotes.cpp \
    src/authmanager.cpp

HEADERS += \
    src/authmanager.h

DISTFILES += qml/harbour-nextnotes.qml \
    qml/api/NextCloudNotesClient.qml \
    qml/api/NextCloudNotesRequest.qml \
    qml/api/NextCloudRequest.qml \
    qml/cover/CoverPage.qml \
    qml/db/DbConnection.qml \
    qml/db/Note.qml \
    qml/db/NotesRepository.qml \
    qml/pages/FirstPage.qml \
    qml/pages/NoteListPage.qml \
    qml/pages/StartupPage.qml \
    qml/pages/LoginPage.qml \
    qml/pages/ErrorPage.qml \
    qml/pages/LoginProgressPage.qml \
    qml/qommons/Qommons/HttpRequest.qml \
    qml/services/SyncService.qml \
    rpm/harbour-nextnotes.changes.in \
    rpm/harbour-nextnotes.changes.run.in \
    rpm/harbour-nextnotes.spec \
    rpm/harbour-nextnotes.yaml \
    translations/*.ts \
    harbour-nextnotes.desktop

QML_IMPORT_PATH += qml/qommons

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-nextnotes-de.ts
