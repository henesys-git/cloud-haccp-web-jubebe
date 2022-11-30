/**
 * 
 */

if(!HENESYS_API) {
	var HENESYS_API = {}
}

HENESYS_API.Limit = function () {}

HENESYS_API.Limit.prototype.getLimit = function () {
 	var limit = $.ajax({
        type: "GET",
        url: heneServerPath + "/limit?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return limit;
}

HENESYS_API.Limit.prototype.getLimit2 = function (sensorId) {
	return $.ajax({
        type: "GET",
        url: heneServerPath + "/limit?id=" + sensorId,
        success: function (result) {
        	return result;
        }
	});
}