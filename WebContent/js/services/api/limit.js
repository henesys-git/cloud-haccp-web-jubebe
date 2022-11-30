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

HENESYS_API.Limit.prototype.getLimitType1 = function (type) {
 	var limit = $.ajax({
        type: "GET",
        url: heneServerPath + "/limit?id=limitType1" + "&type=" + type,
        success: function (result) {
        	return result;
        }
	});
    
	return limit;
}

HENESYS_API.Limit.prototype.getLimitType2 = function (type) {
 	var limit = $.ajax({
        type: "GET",
        url: heneServerPath + "/limit?id=limitType2" + "&type=" + type,
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