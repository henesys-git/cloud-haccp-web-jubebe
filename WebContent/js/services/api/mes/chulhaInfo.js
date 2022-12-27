/**
 * 
 */
 
ChulhaInfo = function () {}

ChulhaInfo.prototype.getChulhaInfo = function () {
 	var data = $.ajax({
        type: "GET",
        url: heneServerPath + "/chulha-info?id=all",
        success: function (result) {
        	return result;
        }
    });
    
	return data;
}

ChulhaInfo.prototype.getChulhaInfoDetail = function (chulhaNo) {
 	var data = $.ajax({
        type: "GET",
        url: heneServerPath + "/chulha-info?id=detail"
        					+ "&chulhaNo=" + chulhaNo,
        success: function (result) {
        	return result;
        }
	});
    
	return data;
}