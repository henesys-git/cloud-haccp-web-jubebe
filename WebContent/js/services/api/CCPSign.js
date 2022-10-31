/**
 * 
 */
 
CCPSign = function () {}

CCPSign.prototype.get = function (date, processCode) {
	var ccpSignInfo = $.ajax({
        type: "GET",
        url: heneServerPath + "/ccpsign",
        data: "date=" + date +
        	  "&processCode=" + processCode,
        success: function (result) {
        	return result;
        }
    });
    
    return ccpSignInfo;
}

// return: 서명자 이름
CCPSign.prototype.sign = function (date, processCode) {
 	var signUser = $.ajax({
        type: "POST",
        url: heneServerPath + "/ccpsign",
        data: "date=" + date +
        	  "&processCode=" + processCode,
        success: function (result) {
        	return result;
        }
	});
    
	return signUser;
}

// return: true or false in string
CCPSign.prototype.delete = function (date, processCode) {
 	var deleteResult = $.ajax({
        type: "PUT",
        url: heneServerPath + "/ccpsign",
        data: "date=" + date +
        	  "&processCode=" + processCode,
        success: function (result) {
        	return result;
        }
	});
    
	return deleteResult;
}

// return: 서명자 이름
CCPSign.prototype.show = async function (selectedDate, processCode) {
	let oSign = await this.get(selectedDate, processCode);
	
	if(oSign.checkerName) {
		$("#ccp-sign-btn").hide();
		$("#ccp-sign-text").text("서명 완료: " + oSign.checkerName);
		return oSign.checkerName;
	} else {
		$("#ccp-sign-btn").show();
		$("#ccp-sign-text").text("");
	}
}