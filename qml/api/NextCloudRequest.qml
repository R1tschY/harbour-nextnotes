import QtQuick 2.0
import Qommons.Http 0.1
import Qommons.Lang 0.1
import Nemo.Notifications 1.0

Container {
    id: root

    readonly property alias busy: request.busy


    Notification {
        id: notification
    }

    function _sendError(errorType, errorMessage) {
        notification.previewSummary = errorMessage
        notification.publish()
        console.error("API error: " + errorType + ": " + errorMessage)
        root.error(errorType, errorMessage)
    }

    HttpRequest {
        id: request

        onFinished: root.finished(response)

        onSuccess: {
            if (response.status >= 200 && response.status < 300) {
                root.success(response.data)
            } else {
                var error = response.data.error || {}
                _sendError(
                    "http-" + response.status,
                    error.message || (response.status + ": " + JSON.stringify(response.data)))
            }
        }

        onError: _sendError(errorType, errorMessage)
    }

    // signals

    signal finished(var response)
    signal error(string errorType, string errorMessage)
    signal success(var responseData)

    // API functions

    function executeApi(method, path, params, data, responseType, headers) {
        if (!authManager.token) {
            _sendError("Request without access token not possible")
            return
        }
        responseType = responseType || "json"

        var requestData = {
            "method": method,
            "url": authManager.url + path,
            "params": params,
            "headers": {
                "Authorization": "Basic " + Qt.btoa(authManager.userName + ":" + authManager.token),
                "OCS-APIRequest": "true"
            },
            "responseType": responseType,
            "data": data
        }
        // Only `application/json` produces JSON
        if (responseType === 'json') {
            requestData.headers["Accept"] = "application/json"
        }
        for (var header in headers) {
            if (headers.hasOwnProperty(header)) {
                req.setRequestHeader(header, headers[header])
            }
        }
        request.execute(requestData)
    }

    function getCapabilities() {
        executeApi("GET", "/ocs/v1.php/cloud/capabilities")
    }

    // actions

    function abort() {
        request.abort()
    }
}
