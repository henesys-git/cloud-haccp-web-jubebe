/**
 * 
 */
 
ChecklistData = function () {}

ChecklistData.prototype.getAll = function () {
 	var checklistDataList = $.ajax({
        type: "GET",
        url: heneServerPath + "/checklist?checklistId=checklist01&seqNo=all",
        success: function (result) {
        	return result;
        }
	});
    
	return checklistDataList;
}