/**
 * 
 */
 
UploadChecklistData = function () {}

UploadChecklistData.prototype.getAll = function (documentNum) {
 	var documentDataList = $.ajax({
        type: "GET",
		url: heneServerPath + "/uploadChecklist",
		data : "documentId=uploadChecklist" + documentNum + "&seqNo=all",
        success: function (result) {
        	return result;
        }
	});
    
	return documentDataList;
}