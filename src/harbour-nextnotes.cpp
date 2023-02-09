#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif
#include <QGuiApplication>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>

#include <sailfishapp.h>

#include "authmanager.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    qmlRegisterType<AuthManager>("R1tschY.NextNotes", 0, 1, "AuthManager");

    view->engine()->addImportPath("/usr/share/harbour-nextnotes/qml/qommons");
    view->setSource(SailfishApp::pathToMainQml());
    view->showFullScreen();

    return app->exec();
}
