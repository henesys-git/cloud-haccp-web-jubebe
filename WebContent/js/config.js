/**
 * 작성자 : 최현수
 * 작성일 : 2020 12 29
 * 목적 : 실서버 배포 시 로그 메시지 안 뜨기 위함
 */
var logger = function() {
    var oldConsoleLog = null;
    var logObj = {};

    logObj.enableLogger =  function enableLogger() {
        if(oldConsoleLog == null)
            return;

        window['console']['log'] = oldConsoleLog;
    };

    logObj.disableLogger = function disableLogger() {
        oldConsoleLog = console.log;
        window['console']['log'] = function() {};
    };

    return logObj;
}();