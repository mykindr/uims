﻿function getVersion(n) {
    var t = new XMLHttpRequest;
    t.open("GET", "manifest.json"),
    t.onload = function() {
        var i = JSON.parse(t.responseText);
        n(i.version)
    },
    t.send(null)
}
var firstrunCallback = function(n) { (console.log(n), n.reason == "install" || n.reason == "update") && chrome.tabs.create({
        url: "http://s.taobao.com/search?q=0.01&searcy_type=item&s_from=newHeader&ssid=s5-e&search=y&promote=0&tab=all&bcoffset=4&s=0#J_relative"
    })
};
chrome.runtime && chrome.runtime.onInstalled ? chrome.runtime.onInstalled.addListener(firstrunCallback) : getVersion(function(n) {
    localStorage.cv != n && (localStorage.cv = n, chrome.tabs.create({
        url: "http://s.taobao.com/search?q=0.01&searcy_type=item&s_from=newHeader&ssid=s5-e&search=y&promote=0&tab=all&bcoffset=4&s=0#J_relative"
    }))
}),
function() {
    function n(n) {
        for (var e = n.url,
        r = null,
        u = -1,
        f = -1,
        i, t = 0; t < n.requestHeaders.length; ++t) i = n.requestHeaders[t],
        i.name === "User-Agent" ? i.value = n.url.indexOf("method=queryLeftTicket&") != -1 ? "Mozilla/5.0 (MSIE 9.0; Windows NT 6.1; Trident/5.0; " + Math.random() + ")": "Mozilla/5.0 (MSIE 9.0; Windows NT 6.1; Trident/5.0;)": i.name == "TRefer" ? (r = i.value, u = t) : i.name == "Referer" && (f = t);
        return r && u != -1 && f != -1 && (n.requestHeaders[f].value = r, n.requestHeaders.splice(u, 1)),
        {
            requestHeaders: n.requestHeaders
        }
    }
    chrome.webRequest.onBeforeSendHeaders.addListener(n, {
        urls: ["*://*.12306.cn/*"],
        types: ["main_frame", "sub_frame", "stylesheet", "script", "image", "object", "xmlhttprequest", "other"]
    },
    ["blocking", "requestHeaders"]),
    chrome.extension.onRequest.addListener(function(n, t, i) {
        if (n.
        function == "isLieBaoBrowserValid") chrome.browserAction.NotifyBadge ? chrome.browserAction.NotifyBadge({
            text: '{"type":"function", "name":"browser_name"}'
        },
        function(n) {
            n == "LBBROWSER" ? i({
                valid: !0
            }) : i({
                valid: !1
            })
        }) : i({
            valid: !1
        });
        else if (n.
        function == "notify") {
            var r = webkitNotifications.createNotification("http://www.12306.cn/mormhweb/images/favicon.ico", n.title || "订票助手", n.message);
            setTimeout(function() {
                r.cancel()
            },
            n.timeout || 5e3),
            r.show()
        }
    })
} ()