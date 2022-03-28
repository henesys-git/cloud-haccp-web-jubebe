/**
 * 
 */

if(!HENESYS_API) {
	var HENESYS_API = {}
}

HENESYS_API.Sensor = function () {}

HENESYS_API.Sensor.prototype.getSensors = function () {
 	var sensors = $.ajax({
        type: "GET",
        url: heneServerPath + "/sensor?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return sensors;
}