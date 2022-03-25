/**
 * 
 */

ItemList = function () {}

ItemList.prototype.getSensorList = function (type_cd) {
	var itemLists = $.ajax({
		type : "GET",
		url: heneServerPath + "/itemList?type=sensorList",
		data : "type_cd=" + type_cd,
		success: function (result) {
        	return result;
        }
	});
	return itemLists;
}

ItemList.prototype.getCCPList = function (type_cd) {
	var itemLists = $.ajax({
		type : "GET",
		url: heneServerPath + "/itemList?type=ccpList",
		data : "type_cd=" + type_cd,
		success: function (result) {
        	return result;
        }
	});
	return itemLists;
}

