/**
 * 
 */

/*
 * 점검표 조회
 * 파라미터:
*/
function displayChecklist(element, id, date) {
	let ajaxUrl = heneServerPath + '/Contents/CheckList/getChecklistFormat.jsp';
	
	let jObj = new Object();
	jObj.checklistId = id;
	jObj.checklistDate = date;
	
	let ajaxParam = JSON.stringify(jObj);

	$.ajax({
		url: ajaxUrl,
		data: {"ajaxParam" : ajaxParam},
		success: function(rcvData) {
			let format = rcvData[0][0];	// 이미지 파일
			let page = rcvData[0][1];	// jsp 페이지
	    	let modalUrl = heneServerPath + page +
	    					 '?format=' + format;
			let footer = "<button type='button' class='btn btn-outline-primary'"
							   + "onclick='printChecklist()'>출력</button>";
			let title = element.innerText;
			let heneModal = new HenesysModal(modalUrl, 'large', title, footer);
			heneModal.open_modal();
		}
	});
}

// 점검표 출력
function printChecklist() {
    var dataUrl = document.getElementById("myCanvas").toDataURL();
    var windowContent = '<!DOCTYPE html>';
    windowContent += '<html>'
    windowContent += '<head><title>점검표 출력</title></head>';
    windowContent += '<body style="zoom:165%">'
    windowContent += '<img src="' + dataUrl + '">';
    windowContent += '</body>';
    windowContent += '</html>';
    var printWin = window.open();
    printWin.document.open();
    printWin.document.write(windowContent);
    
    printWin.document.addEventListener('load', function() {
        printWin.focus();
        printWin.print();
        printWin.document.close();
        printWin.close();
    }, true);
}

/** 
 * 점검표 서명
 * @param {Array} checklistInfo - checklist id, checklist date, checklist revision no, etc.
 * @param {string} pid - query id ex) M010S010000E102
 */
function confirmChecklist(checklistInfo, pid, cb) {
	let confirmed = confirm('서명하시겠습니까?');
	
	if(confirmed) {
		let ajaxUrl = heneServerPath + '/Contents/CommonView/insert_update_delete_json.jsp';
	
		let jObj = new Object();
		jObj.checklistId = checklistInfo[0];
		jObj.checklistRevNo = checklistInfo[1];
		jObj.checklistDate = checklistInfo[2];
		jObj.seq_no = checklistInfo[3];
		jObj.recordTime = checklistInfo[checklistInfo.length-1];	// 서명하기 전 시간을 받아 마지막 array에 push한 시간값
		jObj.userId = loggedUserId;
		
		let ajaxParam = JSON.stringify(jObj);

		$.ajax({
			url: ajaxUrl,
			data: {"bomdata" : ajaxParam, "pid" : pid},
			success: function(rcvData) {
				if(rcvData > 0) {
					heneSwal.successTimer("서명 완료되었습니다");
					cb();
				} else {
					heneSwal.errorTimer("서명 실패, 관리자에게 문의해주세요");
				}
			}
		});
	}
}

//시간 기록되는 측정일지 페이지에서 사용, 향후 위 함수와 통합 고려해야 함.
//checklistInfo[0] = date
//checklistInfo[1] = time
function confirmChecklist2(checklistInfo, pid, cb) {
	let confirmed = confirm('서명하시겠습니까?');
	
	if(confirmed) {
		let ajaxUrl = heneServerPath + '/Contents/CommonView/insert_update_delete_json.jsp';
	
		let jObj = new Object();
		jObj.checklistDate = checklistInfo[0];
		jObj.checkTime = checklistInfo[1];
		jObj.userId = loggedUserId;
		
		let ajaxParam = JSON.stringify(jObj);

		$.ajax({
			url: ajaxUrl,
			data: {"bomdata" : ajaxParam, "pid" : pid},
			success: function(rcvData) {
				if(rcvData > 0) {
					heneSwal.successTimer("서명 완료되었습니다");
					cb();
				} else {
					heneSwal.errorTimer("서명 실패, 관리자에게 문의해주세요");
				}
			}
		});
	}
}

/** 
 * ccp 데이터관리 서명
 * @param {Array} ccpInfo - censor_no, censor_rev_no, censor_name, etc.
 * @param {string} pid - query id ex) M010S010000E102
 */
function confirmChecklist3(ccpInfo, pid, cb) {
	let confirmed = confirm('서명하시겠습니까?');
	
	if(confirmed) {
		let ajaxUrl = heneServerPath + '/Contents/CommonView/insert_update_delete_json.jsp';
	
		const code_cd = ccpInfo[ccpInfo.length - 1];
		
		let jObj = new Object();
		
		if(code_cd.slice(0,3) == "CCP"){
			
			jObj.censor_no = ccpInfo[0];	// 센서번호
			jObj.censor_rev_no = ccpInfo[1];	// 센서수정이력번호
			jObj.ccp_date = ccpInfo[5];		// 생성날짜
			jObj.ccp_time = ccpInfo[6];		// 생성시간
			jObj.improve_cd = code_cd;	// 개선조치사항코드
			jObj.userId = loggedUserId;
			
		} else {
			
			jObj.detect_date = ccpInfo[0];	// 테스트일자
			jObj.detect_time = ccpInfo[1];	// 테스트시간
			jObj.seq_no = ccpInfo[2];		// 일련번호
			jObj.improve_cd = code_cd;		// 개선조치사항코드
			jObj.userId = loggedUserId;
		}
	
		let ajaxParam = JSON.stringify(jObj);

		$.ajax({
			url: ajaxUrl,
			data: {"bomdata" : ajaxParam, "pid" : pid},
			success: function(rcvData) {
				if(rcvData > 0) {
					heneSwal.successTimer("서명 완료되었습니다");
					cb();
				} else {
					heneSwal.errorTimer("서명 실패, 관리자에게 문의해주세요");
				}
			}
		});
	}
}