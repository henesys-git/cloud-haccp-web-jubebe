/**
 * 
 */
 
ChecklistInfo = function () {}

ChecklistInfo.prototype.getById = function (id) {
 	var checklistInfo = $.ajax({
        type: "GET",
        url: heneServerPath + "/checklist-info?id=" + id,
        success: function (result) {
        	return result;
        }
    });
    
	return checklistInfo;
}

ChecklistInfo.prototype.getAll = function () {
 	var checklistInfoList = $.ajax({
        type: "GET",
        url: heneServerPath + "/checklist-info?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return checklistInfoList;
}

ChecklistInfo.prototype.getChecklistId = function (prodId, sensorId) {
 	var checklistInfo = $.ajax({
        type: "GET",
        url: heneServerPath + "/checklist-info?id=getChecklistNo" + "&productId=" + prodId + "&sensorId=" + sensorId,
        success: function (result) {
        	return result;
        }
    });
    
	return checklistInfo;
}