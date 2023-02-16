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
CCPSign.prototype.sign = function (date, processCode, signType) {
 	var signUser = $.ajax({
        type: "POST",
        url: heneServerPath + "/ccpsign",
        data: "date=" + date +
        	  "&processCode=" + processCode +
			  "&signType=" + signType,
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

// return: 에러 여부 (true/false)
CCPSign.prototype.checkError = function (rows) {
	if(rows.length < 1) {
		alert('해당 일자의 서명 처리할 가열공정 데이터가 없습니다.');
		return true;
	}
	
	for(var i=0; i<rows.length; i++) {
		if(rows[i].improvementCompletion !== '완료') {
			alert('개선조치를 먼저 완료해주세요');
			return true;
		}
	}
	
	return false;
}