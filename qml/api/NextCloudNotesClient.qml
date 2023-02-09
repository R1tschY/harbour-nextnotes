import QtQuick 2.0
import Qommons.Lang 0.1

Container {
    id: root

    property int apiVersionMajor: -1
    property int apiVersionMinor: -1
    readonly property string basePath: "/index.php/apps/notes/api/v1"

    function login() {
        loginRequest.getCapabilities()
    }

    signal loginErrorOccured(string message);
    signal loggedIn();

    // private

    NextCloudRequest {
        id: loginRequest

        onSuccess: {
            var data = responseData.ocs.data
            var nextcloudVersion = data.version.string
            var capabilities = data.capabilities
            var notes = capabilities.notes

            console.log("NextCloud: " + nextcloudVersion)
            if (notes) {
                console.log("Notes Version: " + (notes.version || "<3.6.0"))
                var apiVersions = notes.api_version || ["0.2"]
                var apiVersion = _findApiVersion(apiVersions)
                if (apiVersion) {
                    console.log("Using API Version: " + apiVersion.major + "." + apiVersion.minor)
                    root.apiVersionMajor = apiVersion.major
                    root.apiVersionMinor = apiVersion.major
                    root.loggedIn()
                } else {
                    root.loginErrorOccured("No matching API version: " + apiVersions.join())
                }
            } else {
                root.loginErrorOccured("Notes app not installed on NextCloud instance")
            }
        }
    }

    function _findApiVersion(apiVersions) {
        for (var i = 0; i < apiVersions.length; i++) {
            var match = /(\d+).(\d+)/.exec(apiVersions[i])
            if (match) {
                var major = Number(match[1])
                var minor = Number(match[2])
                if (major === 1 && minor >= 0) {
                    return { major: major, minor: minor }
                }
            }
        }
    }
}
