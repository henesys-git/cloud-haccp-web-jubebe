function ChecklistInsertModal(checklistId, seqNo) {
	this.checklistId = checklistId;
	this.seqNo = seqNo;
	
	this.metaDataPath;
	this.imagePath;
	
	this.modalWidth;
	this.modalHeight;
	this.modalWidthWithoutPxKeyword;
	this.modalHeightWithoutPxKeyword;
	this.xmlDoc;
	this.tagIds;
	this.tagTypes;
	this.ctx;
	
	this.setMetadataAndImagePath = async function() {
		// checklistXX_Y.xml, checklistXX_Y.png에서 
		// XX는 점검표 아이디, Y는 점검표 수정이력번호
		this.metaDataPath = heneServerPath + '/checklist/' + heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '.xml';
		this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '.png';
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
		this.modalWidthWithoutPxKeyword = this.modalWidth.replace('px', '');
		this.modalHeightWithoutPxKeyword = this.modalHeight.replace('px', '');
		
		var modalContent = document.querySelector('#checklist-insert-modal .modal-content');
		modalContent.style.width = Number(this.modalWidthWithoutPxKeyword) + Number(30) + 'px';
	};
	
	this.openModal = async function() {
		let that = this;
		
		await this.setMetadataAndImagePath();
		await this.setModal();
		
		$("#checklist-insert-modal").modal("show");
		
		// read checklist image
		var canvas = document.getElementById('checklist-insert-canvas');
		
		canvas.width = this.modalWidthWithoutPxKeyword;
		canvas.height = this.modalHeightWithoutPxKeyword;
		
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
		$('#checklist-insert-btn').off().click(function() {
			
			var check = confirm('등록하시겠습니까?');
			
			if(check) {
			
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
					
					var children = $('#checklist-insert-wrapper').children();
    		
    				for(let i=1; i<children.length; i++) {
    					children[i].remove();
    				}

					$('#checklist-insert-modal').modal('hide');
					 parent.refreshMainTable();
		        }
			});
			
			}
		});
	};
	
	this.drawImage = async function(imageObject) {
		this.ctx.drawImage(imageObject, 0, 0);
	}
	
	this.makeTag = async function(cell) {
		var id = cell.tagName;
		var type = cell.childNodes[0].firstChild.textContent;
		var format = cell.childNodes[1].firstChild.textContent;
		var startX = cell.childNodes[2].firstChild.textContent;
		var startY = cell.childNodes[3].firstChild.textContent;
		var width = cell.childNodes[4].firstChild.textContent;
		var height = cell.childNodes[5].firstChild.textContent;
		var readonly = "";
		console.log(id);
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
		var maxLengthText = parseInt(width) / 16.6; //한글 한 글자당 차지하는 px넓이 : 16.6px 
		var heightNum = parseInt(height.replace("px", ""));
		var textSizeVal = "";

		if(heightNum >= 20) {
			textSizeVal = "16px"; //text input default font-size = 16px;
		}

		else {
			textSizeVal = parseInt(height.replace("px", "") * 0.8) + "px"; //input 태그 높이에 따라 font-size 조절위함

		}
		console.log(heightNum);
		console.log(textSizeVal);
		
		var opt1 = document.createElement("option");
		var opt2 = document.createElement("option");

		opt1.value = "O";
		opt1.text = "O";

		opt2.value = "X";
		opt2.text = "X"; 

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
				tag.maxlength = maxLengthText;
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
			case "select":
				tag = document.createElement('select');
				tag.add(opt1, null);
				tag.add(opt2, null);
				tag.classList.add("checklist-data");
				break;
			default:
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				break;
		}
		
		tag.id = id;
		tag.style.position = 'absolute';
		tag.style.left = startX;
		tag.style.top = startY;
		tag.style.width = width;
		tag.style.height = height;
		tag.style.fontSize = textSizeVal;
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
	this.modalWidthWithoutPxKeyword;
	this.modalHeightWithoutPxKeyword;
	this.xmlDoc;
	this.tagIds;
	this.tagTypes;
	this.ctx;
	
	this.setMetadataAndImagePath = async function() {
		// checklistXX_Y.xml, checklistXX_Y.png에서 
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
		this.modalWidthWithoutPxKeyword = this.modalWidth.replace('px', '');
		this.modalHeightWithoutPxKeyword = this.modalHeight.replace('px', '');
		
		var modalContent = document.querySelector('#checklist-update-modal .modal-content');
		modalContent.style.width = Number(this.modalWidthWithoutPxKeyword) + Number(30) + 'px';
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
		
		canvas.width = this.modalWidthWithoutPxKeyword;
		canvas.height = this.modalHeightWithoutPxKeyword;
		
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
		$('#checklist-update-btn').off().click(function() {
			
			var check = confirm('수정하시겠습니까?');
			
			if(check) {
			
			var head = {};
			var checklistData = {};
	
			let elements = document.getElementsByClassName('checklist-data');
	
			for(var i=0; i<elements.length; i++) {
				let element = elements[i];
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
					
				var children = $('#checklist-update-wrapper').children();
    		
    			for(let i=1; i<children.length; i++) {
    				children[i].remove();
    			}
    		

					$('#checklist-update-modal').modal('hide');
					 parent.refreshMainTable();
		        }
			});
			
			}
		});
	};
	
	this.drawImage = async function(imageObject) {
		this.ctx.drawImage(imageObject, 0, 0);
	}
	
	this.makeTag = async function(cell) {
		var id = cell.tagName;
		var type = cell.childNodes[0].firstChild.textContent;
		var format = cell.childNodes[1].firstChild.textContent;
		var startX = cell.childNodes[2].firstChild.textContent;
		var startY = cell.childNodes[3].firstChild.textContent;
		var width = cell.childNodes[4].firstChild.textContent;
		var height = cell.childNodes[5].firstChild.textContent;
		
		var tagId = "#" + id;
		this.tagIds = tagId;
		this.tagTypes = type;
		let tag;

		var nowDate = new Date();
		
		var year = nowDate.getFullYear();
		var month = nowDate.getMonth() + 1;
		var day = nowDate.getDate();
		var data = this.checkData[id];
			
		if (data == null || data == '') {
				data = "";
		}
		else {
				data = this.checkData[id];
		}
		
		var signWriter = this.checklistSignData.signWriter;
		var signChecker = this.checklistSignData.signChecker;
		var signApprover = this.checklistSignData.signApprover;
		
		
		if(month < 10) {
			month = "0" + month;
		}
		
		if(day < 10) {
			day = "0" + day;
		}
		var maxLengthText = parseInt(width) / 16.6; //한글 한 글자당 차지하는 px넓이 : 16.6px
		var heightNum = parseInt(height.replace("px", ""));
		var textSizeVal = "";

		if(heightNum >= 20) {
			textSizeVal = "16px"; //text input default font-size = 16px;
		}

		else {
			textSizeVal = parseInt(height.replace("px", "") * 0.8) + "px"; //input 태그 높이에 따라 font-size 조절위함

		}

		var opt1 = document.createElement("option");
		var opt2 = document.createElement("option");

		opt1.value = "O";
		opt1.text = "O";

		opt2.value = "X";
		opt2.text = "X"; 

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
				tag.maxlength = maxLengthText;
				break;
			case "truefalse":
				tag = document.createElement('input');
				if(format === 'checkbox') {
					tag.type = 'checkbox';
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
			case "select":
				tag = document.createElement('select');
				tag.add(opt1, null);
				tag.add(opt2, null);
				tag.value = data;
				tag.classList.add("checklist-data");
				break;
			default:
				tag = document.createElement('input');
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
		tag.style.fontSize = textSizeVal;

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
	this.modalWidthWithoutPxKeyword;
	this.modalHeightWithoutPxKeyword;
	
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
		this.modalWidthWithoutPxKeyword = this.modalWidth.replace('px', '');
		this.modalHeightWithoutPxKeyword = this.modalHeight.replace('px', '');
		
		var modalContent = document.querySelector('#checklist-select-modal .modal-content');
		modalContent.style.width = Number(this.modalWidthWithoutPxKeyword) + Number(30) + 'px';
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
		
		canvas.width = this.modalWidthWithoutPxKeyword;
		canvas.height = this.modalHeightWithoutPxKeyword;
		
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
			
		if (data == null || data == '') {
				data = "";
		}
		else {
				data = this.checkData[id];
		}

		var signWriter = this.checklistSignData.signWriter;
		var signChecker = this.checklistSignData.signChecker;
		var signApprover = this.checklistSignData.signApprover;
		
		var middleX = Number(startX) + (width / 2);
		var middleY = Number(startY) + (height / 2);
		
		this.ctx.textAlign = "center";
		this.ctx.font = '10px serif';
		
		console.log(type);
		console.log(format);
		
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
			case "textarea":
				 this.ctx.textAlign = "left";
				 this.ctx.fillText(data, middleX, middleY);
				 //this.ctx.wrapText_XY(ctx, cl.bodies.body0, "row34", "col14", data,	
 	 							//'balck', "9px serif", "left", "top", 20, 2, 1, 1);
				break;
			default : 
				this.ctx.fillText(data, middleX, middleY);
				break;
		}
	};
}

