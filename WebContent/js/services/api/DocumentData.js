/**
 * 
 */
 
DocumentData = function () {}

DocumentData.prototype.getAll = function (documentNum) {
 	var documentDataList = $.ajax({
        type: "GET",
		url: heneServerPath + "/document",
		data : "documentId=document" + documentNum + "&seqNo=all",
        success: function (result) {
        	return result;
        }
	});
    
	return documentDataList;
}