#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <Secrets/secretmanager.h>
#include <Secrets/secret.h>
#include <Secrets/request.h>
#include <QObject>
#include <QScopedPointer>

class AuthManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(State state READ state NOTIFY stateChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY stateChanged)
    Q_PROPERTY(int errorCode READ errorCode NOTIFY stateChanged)

    Q_PROPERTY(QString secretName READ secretName WRITE setSecretName NOTIFY secretNameChanged)

    Q_PROPERTY(QString userName READ userName NOTIFY authChanged)
    Q_PROPERTY(QString url READ url NOTIFY authChanged)
    Q_PROPERTY(QString token READ token NOTIFY authChanged)
public:
    enum State {
        Empty,
        Loaded,
        Busy,
        Error
    };
    Q_ENUM(State);

    explicit AuthManager(QObject *parent = nullptr);
    ~AuthManager();

    State state() const { return m_state; }
    QString errorString() const { return m_errorString; }
    int errorCode() const { return m_errorCode; }
    QString secretName() const { return m_secretName; }
    void setSecretName(const QString& value);
    QString url() const { return m_url; }
    QString userName() const { return m_userName; }
    QString token() const { return m_token; }

    Q_SCRIPTABLE void setAuth(const QString &url, const QString& username, const QString& token);
    Q_SCRIPTABLE void loadFromSystem();

signals:
    void authChanged();
    void stateChanged();
    void secretNameChanged();

    void loaded();
    void stored();
    void errorOccured(const QString& message);

private:
    State m_state = State::Error;
    QString m_errorString;
    int m_errorCode;
    QString m_url;
    QString m_userName;
    QString m_token;
    QString m_secretName;

    Sailfish::Secrets::SecretManager m_secretManager;
    QScopedPointer<Sailfish::Secrets::Request> m_request;

    void setBusy();
    void setError(int code, const QString& message);
    Sailfish::Secrets::Secret::Identifier getSecretId() const;
};

#endif // AUTHMANAGER_H
