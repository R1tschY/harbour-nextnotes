.pragma library

function toShortDate(timestamp) {
    return new Date(timestamp * 1000).toLocaleString(Qt.locale(), Locale.ShortFormat)
}
