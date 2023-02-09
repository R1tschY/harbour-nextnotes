#include <Secrets/storesecretrequest.h>
#include <Secrets/storedsecretrequest.h>
#include <QLoggingCategory>

#include "authmanager.h"

using namespace Sailfish::Secrets;

static Q_LOGGING_CATEGORY(logger, "NextNotes.AuthManager");

AuthManager::AuthManager(QObject *parent) : QObject(parent)
{
qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
}

AuthManager::~AuthManager()
{
    qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
}

void AuthManager::setSecretName(const QString &value)
{
    qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    if (value != m_secretName) {
        m_secretName = value;
        qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
        Q_EMIT secretNameChanged();
        qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    }
}

void AuthManager::setAuth(const QString &url, const QString &userName, const QString &token)
{qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    if (m_secretName.isEmpty())
        return;

    setBusy();

    m_url = url;
    m_userName = userName;
    m_token = token;

    Secret secret(getSecretId());
    secret.setFilterData(QStringLiteral("url"), url);
    secret.setFilterData(QStringLiteral("username"), userName);
    secret.setData(token.toUtf8());
    secret.setType(Secret::TypeBlob);

    StoreSecretRequest* ssr = new StoreSecretRequest();
    m_request.reset(ssr);
    ssr->setManager(&m_secretManager);
    ssr->setSecretStorageType(StoreSecretRequest::StandaloneDeviceLockSecret);
    ssr->setDeviceLockUnlockSemantic(SecretManager::DeviceLockKeepUnlocked);
    ssr->setAccessControlMode(SecretManager::OwnerOnlyMode);
    ssr->setEncryptionPluginName(SecretManager::DefaultEncryptionPluginName);
    ssr->setUserInteractionMode(SecretManager::SystemInteraction);
    ssr->setSecret(secret);
    ssr->startRequest();

    connect(ssr, &Request::resultChanged,
            this, [this, ssr]() {
        auto result = ssr->result();
        if (result.code() == Result::Failed) {
            setError(result.errorCode(), result.errorMessage());
        } else {
            m_state = AuthManager::Loaded;
            m_errorString = QString();
            Q_EMIT stateChanged();
            Q_EMIT stored();
        }
    });
}

void AuthManager::loadFromSystem()
{qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    if (m_secretName.isEmpty())
        return; // TODO: error

    qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;

    setBusy();
    qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;


    StoredSecretRequest* ssr = new StoredSecretRequest();qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    m_request.reset(ssr);qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    ssr->setManager(&m_secretManager);qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    ssr->setIdentifier(getSecretId());qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    ssr->setUserInteractionMode(SecretManager::SystemInteraction);qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    ssr->startRequest();qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;

    connect(ssr, &Request::resultChanged,
            this, [this, ssr]() {
        auto result = ssr->result();qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
        if (result.code() == Result::Failed) {qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
            if (result.errorCode() == Result::InvalidSecretError) {qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
                m_state = AuthManager::Loaded;
                m_token = QString();
                m_url = QString();
                m_userName = QString();qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
                Q_EMIT stateChanged();qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
                Q_EMIT loaded();qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
            } else {qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
                setError(result.errorCode(), result.errorMessage());
            }
        } else {
            m_state = AuthManager::Loaded;
            auto secret = ssr->secret();
            m_token = QString::fromUtf8(secret.data());
            m_url = secret.filterData(QStringLiteral("url"));
            m_userName = secret.filterData(QStringLiteral("username"));
            Q_EMIT stateChanged();
            Q_EMIT loaded();
        }
        qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    });
}

void AuthManager::setBusy()
{qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    m_state = AuthManager::Busy;
    m_errorCode = 0;
    m_errorString = QString();
    Q_EMIT stateChanged();
}

void AuthManager::setError(int code, const QString &message)
{qCDebug(logger) << __PRETTY_FUNCTION__ << __LINE__;
    m_state = AuthManager::Error;
    m_errorCode = code;
    m_errorString = message;
    Q_EMIT errorOccured(m_errorString);
    Q_EMIT stateChanged();
}

Secret::Identifier AuthManager::getSecretId() const
{
    return Secret::Identifier(
                m_secretName, QString(), SecretManager::DefaultStoragePluginName);
}
