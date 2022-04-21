/**
 * 
 */
 
ChecklistData = function () {}

ChecklistData.prototype.getAll = function (checklistNum) {
	console.log(checklistNum);
 	var checklistDataList = $.ajax({
        type: "GET",
		//url: heneServerPath + "/checklist?checklistId=checklist01&seqNo=all",
		url: heneServerPath + "/checklist",
		data : "checklistId=checklist" + checklistNum + "&seqNo=all",
        success: function (result) {
        	return result;
        }
	});
    
	return checklistDataList;
}