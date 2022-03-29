/**
 * 
 */

if(!HENESYS_API) {
	var HENESYS_API = {}
}

HENESYS_API.commonCode = function () {}

HENESYS_API.commonCode.prototype.getCommonCodes = function () {
 	var commonCodes = $.ajax({
        type: "GET",
        url: heneServerPath + "/commonCode?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return commonCodes;
}