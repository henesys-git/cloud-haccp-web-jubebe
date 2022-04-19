/**
 * 작성자 : 최현수
 * 최초 작성일 : 2020년 11월 3일
 * 목적 : bootstrap modal창 관련 함수 모음
 */

// 1차 모달창 생성자
function HenesysModal(url, size, title, footer) {
	this.size = size;
	this.title = title;
	this.footer = footer;
	this.url = url;
	
	this.get_content = function() {
		$.ajax({
	    	type: "POST",
	    	url: url,
	   	  	success: function (html) {
				$('#ReportNote').html(html);
			}
		});
	};
	
	this.set_modal = function() {
		this.get_content();
    	document.getElementById('modalReport_Title').innerHTML = this.title;
    	document.getElementById('modal-footerq').innerHTML = this.footer;
		//document.getElementById('ReportNote').innerHTML = this.content;
		
		//modalReport 부분은 안바꿔도 될듯하니 나중에 보고 지우기 (2021 01 25 최현수)
    	if(size == 'xlarge') {
	        $('#modalReport').attr('class', 'modal fade bs-example-modal-xl')
	            .attr('aria-labelledby','myXlargeModalLabel');
	        $('#modalDialogId').attr('class','modal-dialog modal-dialog-scrollable modal-xl');
	    }
    	if(size == 'large') {
	        $('#modalReport').attr('class', 'modal fade bs-example-modal-lg')
	            .attr('aria-labelledby','myLargeModalLabel');
	        $('#modalDialogId').attr('class','modal-dialog modal-dialog-scrollable modal-lg');
	    }
	    if(size == 'standard') {
	        $('#modalReport').attr('class', 'modal fade')
	            .attr('aria-labelledby','myModalLabel');
	        $('#modalDialogId').attr('class','modal-dialog modal-dialog-scrollable');
	    }
	    if(size == 'small') {
	        $('#modalReport').attr('class', 'modal fade bs-example-modal-sm')
	            .attr('aria-labelledby','mySmallModalLabel');
	        $('#modalDialogId').attr('class','modal-dialog modal-dialog-scrollable modal-sm');
	    }
		if(size == 'auto') {
	        $('#modalDialogId').attr('class','modal-dialog modal-dialog-scrollable modal-auto');
		}
		
		$('#modalReport').attr("data-backdrop", "static");
	};
	
	this.open_modal = function() {
		this.set_modal();
		$('#modalReport').modal('show');
	};
}

// 2차 모달창 생성자
function HenesysModal2(url, size, title, footer) {
	this.size = size;
	this.title = title;
	this.footer = footer;
	this.url = url;
	
	this.get_content = function() {
		$.ajax({
	    	type: "POST",
	    	url: url,
	   	  	success: function (html) {
				$('#ReportNote2').html(html);
			}
		});
	};
	
	this.set_modal = function() {
		this.get_content();
    	document.getElementById('modalReport_Title2').innerHTML = this.title;
    	document.getElementById('modal-footerq2').innerHTML = this.footer;
		//document.getElementById('ReportNote').innerHTML = this.content;
		
    	if(size == 'xlarge') {
	        $('#modalReport2').attr('class', 'modal fade bs-example-modal-xl')
	            .attr('aria-labelledby','myXlargeModalLabel');
	        $('#modalDialogId2').attr('class','modal-dialog modal-dialog-scrollable modal-xl');
	    }
    	if(size == 'large') {
	        $('#modalReport2').attr('class', 'modal fade bs-example-modal-lg')
	            .attr('aria-labelledby','myLargeModalLabel');
	        $('#modalDialogId2').attr('class','modal-dialog modal-dialog-scrollable modal-lg');
	    }
	    if(size == 'standard') {
	        $('#modalReport2').attr('class', 'modal fade')
	            .attr('aria-labelledby','myModalLabel');
	        $('#modalDialogId2').attr('class','modal-dialog modal-dialog-scrollable');
	    }
	    if(size == 'small') {
	        $('#modalReport2').attr('class', 'modal fade bs-example-modal-sm')
	            .attr('aria-labelledby','mySmallModalLabel');
	        $('#modalDialogId2').attr('class','modal-dialog modal-dialog-scrollable modal-sm');
	    } 

		$('#modalReport2').attr("data-backdrop", "static");
	};
	
	this.open_modal = function() {
		this.set_modal();
		$('#modalReport2').modal('show');
	};
}

// 3차 모달창 생성자
function HenesysModal3(url, size, title, footer) {
	this.size = size;
	this.title = title;
	this.footer = footer;
	this.url = url;
	
	this.get_content = function() {
		$.ajax({
	    	type: "POST",
	    	url: url,
	   	  	success: function (html) {
				$('#ReportNote3').html(html);
			}
		});
	};
	
	this.set_modal = function() {
		this.get_content();
    	document.getElementById('modalReport_Title3').innerHTML = this.title;
    	document.getElementById('modal-footerq3').innerHTML = this.footer;
		
    	if(size == 'xlarge') {
	        $('#modalReport3').attr('class', 'modal fade bs-example-modal-xl')
	            .attr('aria-labelledby','myXlargeModalLabel');
	        $('#modalDialogId3').attr('class','modal-dialog modal-dialog-scrollable modal-xl');
	    }
    	if(size == 'large') {
	        $('#modalReport3').attr('class', 'modal fade bs-example-modal-lg')
	            .attr('aria-labelledby','myLargeModalLabel');
	        $('#modalDialogId3').attr('class','modal-dialog modal-dialog-scrollable modal-lg');
	    }
	    if(size == 'standard') {
	        $('#modalReport3').attr('class', 'modal fade')
	            .attr('aria-labelledby','myModalLabel');
	        $('#modalDialogId3').attr('class','modal-dialog modal-dialog-scrollable');
	    }
	    if(size == 'small') {
	        $('#modalReport3').attr('class', 'modal fade bs-example-modal-sm')
	            .attr('aria-labelledby','mySmallModalLabel');
	        $('#modalDialogId3').attr('class','modal-dialog modal-dialog-scrollable modal-sm');
	    } 

		$('#modalReport3').attr("data-backdrop", "static");
	};
	
	this.open_modal = function() {
		this.set_modal();
		$('#modalReport3').modal('show');
	};
}

/*function open_modal() {
    var size = document.getElementById('mysize').value;
    var content = '<form role="form"><div class="form-group"><label for="exampleInputEmail1">Email address</label><input type="email" class="form-control" id="exampleInputEmail1" placeholder="Enter email"></div><div class="form-group"><label for="exampleInputPassword1">Password</label><input type="password" class="form-control" id="exampleInputPassword1" placeholder="Password"></div><div class="form-group"><label for="exampleInputFile">File input</label><input type="file" id="exampleInputFile"><p class="help-block">Example block-level help text here.</p></div><div class="checkbox"><label><input type="checkbox"> Check me out</label></div><button type="submit" class="btn btn-default">Submit</button></form>';
    var title = 'My dynamic modal dialog form with bootstrap';
    var footer = '<button type="button" class="btn btn-default" data-dismiss="modal">Close</button><button type="button" class="btn btn-primary">Save changes</button>';
    
    setModalBox(title,content,footer,size);
    $('#myModal').modal('show');
}

function setModalBox(title, content, footer, size) {
    document.getElementById('modal-bodyku').innerHTML=content;
    document.getElementById('myModalLabel').innerHTML=title;
    document.getElementById('modal-footerq').innerHTML=footer;
    
    if(size == 'large') {
        $('#myModal').attr('class', 'modal fade bs-example-modal-lg')
            .attr('aria-labelledby','myLargeModalLabel');
        $('.modal-dialog').attr('class','modal-dialog modal-lg');
    }
    if(size == 'standart') {
        $('#myModal').attr('class', 'modal fade')
            .attr('aria-labelledby','myModalLabel');
        $('.modal-dialog').attr('class','modal-dialog');
    }
    if(size == 'small') {
        $('#myModal').attr('class', 'modal fade bs-example-modal-sm')
            .attr('aria-labelledby','mySmallModalLabel');
        $('.modal-dialog').attr('class','modal-dialog modal-sm');
    }
}*/

function ChecklistInsertModal(checklistId, seqNo) {
	this.checklistId = checklistId;
	this.seqNo = seqNo;
	
	this.metaDataPath;
	this.imagePath;
	
	this.modalWidth;
	this.modalHeight;
	this.xmlDoc;
	this.tagIds;
	this.tagTypes;
	this.ctx;
	
	this.setMetadataAndImagePath = async function() {
		// checklistXX_Y.txt, checklistXX_Y.jpg에서 
		// XX는 점검표 아이디, Y는 점검표 수정이력번호
		this.metaDataPath = heneServerPath + '/checklist/' + heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '.txt';
		this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '.jpg';
	}
	
	this.setModal = async function() {
		// read meta-data
		let response = await fetch(this.metaDataPath);
	    let metaData = await response.text();
	    
	 	// parse meta-data
		let parser = new DOMParser();
		this.xmlDoc = parser.parseFromString(metaData, "text/xml");
		
		// set modal size
		this.modalWidth = this.xmlDoc.getElementsByTagName("width")[0].innerHTML;
		this.modalHeight = this.xmlDoc.getElementsByTagName("height")[0].innerHTML;
		console.log(this.modalWidth);
		
		document.getElementById('checklist-insert-wrapper').style.width = this.modalWidth;
		document.getElementById('checklist-insert-wrapper').style.height = this.modalHeight;
	};
	
	this.openModal = async function() {
		let that = this;
		
		await this.setMetadataAndImagePath();
		await this.setModal();
		
		$("#checklist-insert-modal").modal("show");
		
		// read checklist image
		var canvas = document.getElementById('checklist-insert-canvas');
		
		let modalWidthWithoutPxKeyword = this.modalWidth.replace('px', '');
		let modalHeightWithoutPxKeyword = this.modalHeight.replace('px', '');
		
		canvas.width = modalWidthWithoutPxKeyword;
		canvas.height = modalHeightWithoutPxKeyword;
		
		this.ctx = canvas.getContext('2d');
		
		var bgImg = new Image();
		bgImg.src = this.imagePath;
		bgImg.onload = function() {
			that.drawImage(bgImg);
		};
		
		// generate tags
		var cellList = this.xmlDoc.getElementsByTagName("cells")[0].childNodes;
		
		for(var i=0; i<cellList.length; i++) {
			var cell = cellList[i];
			this.makeTag(cell);
		};
		
		// save data to db
		$('#checklist-insert-btn').click(function() {
			
			//var check = confirm('등록하시겠습니까?');
			
			//if(check) {
			
			var head = {};
			var checklistData = {};
	
			let elements = document.getElementsByClassName('checklist-data');
	
			for(var i=0; i<elements.length; i++) {
				let element = elements[i];
				console.log(element.type);
				if(element.type == 'checkbox') {
					if(element.checked == true) {
						checklistData[element.id] = element.value;
					}
					else {
						checklistData[element.id] = '';
					}
				}
				else {
					checklistData[element.id] = element.value;
				}
			}
			
			head.checklistId = checklistId;
			head.revisionNo = seqNo;
			head.checklistData = checklistData;
			
			$.ajax({
				type: "POST",
		        url: heneServerPath + "/checklist",
		        data: "data=" + JSON.stringify(head) +
					  "&type=insert",
		        success: function (result) {
		        	console.log(result);
					$('#checklist-insert-modal').modal('hide');
					 parent.refreshMainTable();
		        }
			});
			
			//}
		});
	};
	
	this.drawImage = async function(imageObject) {
		this.ctx.drawImage(imageObject, 0, 0);
	}
	
	this.makeTag = async function(cell) {
		var id = cell.nodeName;
		var type = cell.childNodes[0].textContent;
		var format = cell.childNodes[1].textContent;
		var startX = cell.childNodes[2].textContent;
		var startY = cell.childNodes[3].textContent;
		var width = cell.childNodes[4].textContent;
		var height = cell.childNodes[5].textContent;
		var readonly = "";
		
		var tagId = "#" + id;
		this.tagIds = tagId;
		this.tagTypes = type;
		let tag;
		
		var nowDate = new Date();
		
		var year = nowDate.getFullYear();
		var month = nowDate.getMonth() + 1;
		var day = nowDate.getDate();
		
		if(month < 10) {
			month = "0" + month;
		}
		
		if(day < 10) {
			day = "0" + day;
		}
		
		var today = year + "-" + month + "-" + day;
				
		switch(type) {
			case "signature-writer":
				tag = document.createElement('input');
				tag.classList.add('signature-writer');
				tag.setAttribute("readonly", true);
				//tag.innerHTML = "서명";
				break;
			case "signature-approver":
				tag = document.createElement('input');
				tag.classList.add('signature-approver');
				tag.setAttribute("readonly", true);
				//tag.innerHTML = "서명";
				break;
			case "signature-checker":
				tag = document.createElement('input');
				tag.classList.add('signature-checker');
				tag.setAttribute("readonly", true);
				//tag.innerHTML = "서명";
				break;
			case "date":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.setAttribute("type", "date");
				tag.value = today;
				break;
			case "text":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				break;
			case "truefalse":
				tag = document.createElement('input');
				if(format === 'checkbox') {
					tag.type = 'checkbox';
				}
				tag.classList.add("checklist-data");
				break;
			case "image":
				tag = document.createElement('input');
				tag.setAttribute("type", "file");
				tag.classList.add("checklist-data");
				break;
			case "textarea":
				tag = document.createElement('textarea');
				tag.classList.add("checklist-data");
				break;
		}
		
		tag.id = id;
		tag.style.position = 'absolute';
		tag.style.left = startX;
		tag.style.top = startY;
		tag.style.width = width;
		tag.style.height = height;
		
		document.getElementById("checklist-insert-wrapper").appendChild(tag);
		
	};
}

function ChecklistUpdateModal(checklistId, revisionNo, seqNo) {
	this.checklistId = checklistId;
	this.revisionNo = revisionNo;
	this.seqNo = seqNo;
	this.metaDataPath;
	this.imagePath;
	
	this.modalWidth;
	this.modalHeight;
	this.xmlDoc;
	this.tagIds;
	this.tagTypes;
	this.ctx;
	
	this.setMetadataAndImagePath = async function() {
		// checklistXX_Y.txt, checklistXX_Y.jpg에서 
		// XX는 점검표 아이디, Y는 점검표 수정이력번호
		this.metaDataPath = heneServerPath + '/checklist/' + heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '.xml';
		this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '.png';
	}
	
	this.getChecklistData = async function() {
		let fetchedData = $.ajax({
							type: "GET",
					        url: heneServerPath + "/checklist"
					        	+ "?checklistId=" + this.checklistId
					        	+ "&seqNo=" + this.seqNo,
					        success: function (data) {
					        	return data;
					        }
						});
		
		return fetchedData;
	}
	
	this.getChecklistSignData = async function() {
		let fetchedData = $.ajax({
							type: "GET",
					        url: heneServerPath + "/checklist"
					        	+ "?checklistId=" + this.checklistId
					        	+ "&seqNo=signData" + "&seqNo2=" + this.seqNo,
					        success: function (data) {
					        	return data;
					        }
						});
		
		return fetchedData;
	}
	
	this.setModal = async function() {
		// read meta-data
		let response = await fetch(this.metaDataPath);
	    let metaData = await response.text();
	    
	 	// parse meta-data
		let parser = new DOMParser();
		this.xmlDoc = parser.parseFromString(metaData, "text/xml");
		
		// set modal size
		this.modalWidth = this.xmlDoc.getElementsByTagName("width")[0].innerHTML;
		this.modalHeight = this.xmlDoc.getElementsByTagName("height")[0].innerHTML;
		console.log(this.modalWidth);
		
		document.getElementById('checklist-update-wrapper').style.width = this.modalWidth;
		document.getElementById('checklist-update-wrapper').style.height = this.modalHeight;
	};
	
	this.openModal = async function() {
		let that = this;
		
		await this.setMetadataAndImagePath();
		await this.setModal();
		this.checklistData = await this.getChecklistData();
		this.checkData = JSON.parse(this.checklistData.checkData);
		this.checklistSignData = await this.getChecklistSignData();
		
		$("#checklist-update-modal").modal("show");
		
		// read checklist image
		let canvas = document.getElementById('checklist-update-canvas');
		
		let modalWidthWithoutPxKeyword = this.modalWidth.replace('px', '');
		let modalHeightWithoutPxKeyword = this.modalHeight.replace('px', '');
		
		canvas.width = modalWidthWithoutPxKeyword;
		canvas.height = modalHeightWithoutPxKeyword;
		
		this.ctx = canvas.getContext('2d');
		
		var bgImg = new Image();
		bgImg.src = this.imagePath;
		bgImg.onload = function() {
			that.drawImage(bgImg);
			
		};
		
		// generate tags
		var cellList = this.xmlDoc.getElementsByTagName("cells")[0].childNodes;
		
		for(var i=0; i<cellList.length; i++) {
			var cell = cellList[i];
			this.makeTag(cell);
		};
		
		// save data to db
		$('#checklist-update-btn').click(function() {
			
			//var check = confirm('수정하시겠습니까?');
			
			//if(check) {
			
			var head = {};
			var checklistData = {};
	
			let elements = document.getElementsByClassName('checklist-data');
	
			for(var i=0; i<elements.length; i++) {
				let element = elements[i];
				console.log(element.type);
				if(element.type == 'checkbox') {
					if(element.checked == true) {
						checklistData[element.id] = element.value;
					}
					else {
						checklistData[element.id] = '';
					}
				}
				else {
					checklistData[element.id] = element.value;
				}
			}
			
			head.checklistId = checklistId;
			head.revisionNo = revisionNo;
			head.seqNo = seqNo;
			head.checklistData = checklistData;
			
			$.ajax({
				type: "POST",
		        url: heneServerPath + "/checklist",
		        data: "data=" + JSON.stringify(head) +
					  "&type=update",
		        success: function (result) {
		        	console.log(result);
					$('#checklist-update-modal').modal('hide');
					 parent.refreshMainTable();
		        }
			});
			
			//}
		});
	};
	
	this.drawImage = async function(imageObject) {
		this.ctx.drawImage(imageObject, 0, 0);
	}
	
	this.makeTag = async function(cell) {
		var id = cell.nodeName;
		var type = cell.childNodes[0].textContent;
		var format = cell.childNodes[1].textContent;
		var startX = cell.childNodes[2].textContent;
		var startY = cell.childNodes[3].textContent;
		var width = cell.childNodes[4].textContent;
		var height = cell.childNodes[5].textContent;
		
		var tagId = "#" + id;
		this.tagIds = tagId;
		this.tagTypes = type;
		let tag;

		var nowDate = new Date();
		
		var year = nowDate.getFullYear();
		var month = nowDate.getMonth() + 1;
		var day = nowDate.getDate();
		
		var data = this.checkData[id];
		var signWriter = this.checklistSignData.signWriter;
		var signChecker = this.checklistSignData.signChecker;
		var signApprover = this.checklistSignData.signApprover;
		
		
		if(month < 10) {
			month = "0" + month;
		}
		
		if(day < 10) {
			day = "0" + day;
		}
		
		var today = year + "-" + month + "-" + day;
		switch(type) {
			case "signature-writer":
				tag = document.createElement('input');
				tag.classList.add('signature-writer');
				tag.value = signWriter;
				tag.setAttribute("readonly", true);
				break;
			case "signature-approver":
				tag = document.createElement('input');
				tag.classList.add('signature-approver');
				tag.value = signApprover;
				tag.setAttribute("readonly", true);
				break;
			case "signature-checker":
				tag = document.createElement('input');
				tag.classList.add('signature-checker');
				tag.value = signChecker;
				tag.setAttribute("readonly", true);
				break;
			case "date":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.setAttribute("type", "date");
				if(data == null || data == '') {
					tag.value = "";
				}
				else {
					tag.value = data;
				}
				
				break;
			case "text":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.value = data;
				break;
			case "truefalse":
				tag = document.createElement('input');
				if(format === 'checkbox') {
					tag.type = 'checkbox';
					console.log("checkbox");
					console.log(data);
					if(data == 'on') {
						//tag.setAttribute("autocomplete", "off");
						tag.checked = true;
					}
					else {
						tag.setAttribute("autocomplete", "off");
						tag.checked = false;
					}
				}
				tag.classList.add("checklist-data");
				break;
			case "image":
				tag = document.createElement('input');
				tag.setAttribute("type", "file");
				tag.classList.add("checklist-data");
				break;	
			case "textarea":
				tag = document.createElement('textarea');
				tag.classList.add("checklist-data");
				tag.value = data;
				break;
		}
		
		tag.id = id;
		tag.style.position = 'absolute';
		tag.style.left = startX;
		tag.style.top = startY;
		tag.style.width = width;
		tag.style.height = height;
		
		document.getElementById("checklist-update-wrapper").appendChild(tag);
		
	};
}


function ChecklistSelectModal(checklistId, seqNo, revisionNo) {
	this.checklistId = checklistId;
	this.seqNo = seqNo;
	this.revisionNo = revisionNo;
	
	this.checklistData;
	this.checkData;
		
	this.metaDataPath;
	this.imagePath;
	
	this.modalWidth;
	this.modalHeight;
	this.xmlDoc;
	
	this.ctx;
	
	this.setMetadataAndImagePath = async function() {
		// 점검표 데이터 테이블에서 cheklistId와 seqNo로 점검표정보수정이력번호를 구한 다음
		// 점검표정보 테이블에서 checklistId와 점검표정보수정이력번호로 조회해서
		// 이미지경로와 메타데이터파일경로를 구한다
		this.metaDataPath = heneServerPath + '/checklist/' + heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '.xml';
		this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '.png';
	}
	
	this.getChecklistData = async function() {
		let fetchedData = $.ajax({
							type: "GET",
					        url: heneServerPath + "/checklist"
					        	+ "?checklistId=" + this.checklistId
					        	+ "&seqNo=" + this.seqNo,
					        success: function (data) {
					        	return data;
					        }
						});
		
		return fetchedData;
	}
	
	this.getChecklistSignData = async function() {
		let fetchedData = $.ajax({
							type: "GET",
					        url: heneServerPath + "/checklist"
					        	+ "?checklistId=" + this.checklistId
					        	+ "&seqNo=signData" + "&seqNo2=" + this.seqNo,
					        success: function (data) {
					        	return data;
					        }
						});
		
		return fetchedData;
	}
	
	this.setModal = async function() {
		// read meta-data
		let response = await fetch(this.metaDataPath);
	    let metaData = await response.text();
	    
	 	// parse meta-data
		let parser = new DOMParser();
		this.xmlDoc = parser.parseFromString(metaData, "text/xml");
		
		// set modal size
		this.modalWidth = this.xmlDoc.getElementsByTagName("width")[0].innerHTML;
		this.modalHeight = this.xmlDoc.getElementsByTagName("height")[0].innerHTML;
	
		document.getElementById('checklist-select-wrapper').style.width = this.modalWidth;
		document.getElementById('checklist-select-wrapper').style.height = this.modalHeight;
	};
	
	this.openModal = async function() {
		let that = this;
	
		await this.setMetadataAndImagePath();
		await this.setModal();
		this.checklistData = await this.getChecklistData();
		this.checkData = JSON.parse(this.checklistData.checkData);
		this.checklistSignData = await this.getChecklistSignData();
		
		$("#checklist-select-modal").modal("show");
		
		// read checklist image
		var canvas = document.getElementById('checklist-select-canvas');
		
		let modalWidthWithoutPxKeyword = this.modalWidth.replace('px', '');
		let modalHeightWithoutPxKeyword = this.modalHeight.replace('px', '');
		
		canvas.width = modalWidthWithoutPxKeyword;
		canvas.height = modalHeightWithoutPxKeyword;
		
		this.ctx = canvas.getContext('2d');
		
		var bgImg = new Image();
		bgImg.src = this.imagePath;
		bgImg.onload = function() {
			that.drawImage(bgImg);
			
			// display data
			var cellList = that.xmlDoc.getElementsByTagName("cells")[0].childNodes;
			
			for(var i=0; i<cellList.length; i++) {
				var cell = cellList[i];
				that.displayData(cell);
			};
		};
		
		// 점검표 출력
		$('#checklist-print-btn').click(function() {
			var dataUrl = document.getElementById("checklist-select-canvas").toDataURL();
    		var windowContent = '<!DOCTYPE html>';
   	 		windowContent += '<html>'
    		windowContent += '<head><title>점검표 출력</title></head>';
    		windowContent += '<body style="zoom:120%">'
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
		});
	};
	
	this.drawImage = function(imageObject) {
		this.ctx.drawImage(imageObject, 0, 0);
	}
	
	this.displayData = function(cell) {
		var id = cell.nodeName;
		var type = cell.childNodes[0].textContent;
		var format = cell.childNodes[1].textContent;
		var startX = cell.childNodes[2].textContent.replace('px', '');
		var startY = cell.childNodes[3].textContent.replace('px', '');
		var width = cell.childNodes[4].textContent.replace('px', '');
		var height = cell.childNodes[5].textContent.replace('px', '');
		
		var data = this.checkData[id];
		
		var signWriter = this.checklistSignData.signWriter;
		var signChecker = this.checklistSignData.signChecker;
		var signApprover = this.checklistSignData.signApprover;
		
		var middleX = Number(startX) + (width / 2);
		var middleY = Number(startY) + (height / 2);
		
		this.ctx.textAlign = "center";
		this.ctx.font = '10px serif';
		
		switch(type) {
			case "signature-writer":
				if(signWriter != null) {
					this.ctx.fillText(signWriter, middleX, middleY);
				}
				break;
			case "signature-approver":
				if(signApprover != null) {
					this.ctx.fillText(signApprover, middleX, middleY);
				}
				break;
			case "signature-checker":
				if(signChecker != null) {
					this.ctx.fillText(signChecker, middleX, middleY);
				}
				break;
			case "truefalse":
				if(format === 'checkbox' && data === 'on') {
					this.ctx.fillText("✔", middleX, middleY);
				}
				break;
			default : 
				this.ctx.fillText(data, middleX, middleY);
				break;
		}
	};
}