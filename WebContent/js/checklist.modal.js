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
			
			console.log(checklistData);
			var check = confirm('등록하시겠습니까?');
			
			if(check) {

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
		var default_value = cell.childNodes[2].firstChild.textContent;
		var min = cell.childNodes[3].firstChild.textContent;
		var max = cell.childNodes[4].firstChild.textContent;
		var startX = cell.childNodes[5].firstChild.textContent;
		var startY = cell.childNodes[6].firstChild.textContent;
		var width = cell.childNodes[7].firstChild.textContent;
		var height = cell.childNodes[8].firstChild.textContent;
		var readonly = "";
		console.log(id);
		var tagId = "#" + id;
		this.tagIds = tagId;
		this.tagTypes = type;
		let tag;
		
		var nowDate = new Date();
		var weekAgoDate = new Date(new Date().setDate(new Date().getDate() - 7));
		var monthAgoDate = new Date(new Date().setDate(new Date().getDate() - 30));

		var year = nowDate.getFullYear();
		var month = nowDate.getMonth() + 1;
		var day = nowDate.getDate();

		var year2 = weekAgoDate.getFullYear();
		var month2 = weekAgoDate.getMonth() + 1;
		var day2 = weekAgoDate.getDate();

		var year3 = monthAgoDate.getFullYear();
		var month3 = monthAgoDate.getMonth() + 1;
		var day3 = monthAgoDate.getDate();

		
		if(month < 10) {
			month = "0" + month;
		}
		if(day < 10) {
			day = "0" + day;
		}

		if(month2 < 10) {
			month2 = "0" + month2;
		}
		if(day2 < 10) {
			day2 = "0" + day2;
		}

		if(month3 < 10) {
			month3 = "0" + month3;
		}
		if(day3 < 10) {
			day3 = "0" + day3;
		}
		
		var today = year + "-" + month + "-" + day;
		var weekDay = year2 + "-" + month2 + "-" + day2;
		var monthDay = year3 + "-" + month2 + "-" + day3;

		var maxLengthText = parseInt(width) / 16.6; //한글 한 글자당 차지하는 px넓이 : 16.6px

		var widthNum = parseInt(width.replace("px", ""));
		var heightNum = parseInt(height.replace("px", ""));
		var startXNum = parseInt(startX.replace("px", ""));
		var startYNum = parseInt(startY.replace("px", ""));

		var textSizeVal = "";

		if(heightNum >= 20) {
			textSizeVal = "16px"; //text input default font-size = 16px;
		}

		else {
			textSizeVal = parseInt(height.replace("px", "") * 0.8) + "px"; //input 태그 높이에 따라 font-size 조절위함

		}
		
		var opt1 = document.createElement("option");
		var opt2 = document.createElement("option");
		var opt3 = document.createElement("option");
		var opt4 = document.createElement("option");
		var opt5 = document.createElement("option");

		opt1.value = "O";
		opt1.text = "O";

		opt2.value = "△";
		opt2.text = "△";

		opt3.value = "X";
		opt3.text = "X";
		
		opt4.value = "적합";
		opt4.text = "적합"; 

		opt5.value = "부적합";
		opt5.text = "부적합"; 

		var fileTag = "";

		switch(type) {
			case "signature-writer":
				tag = document.createElement('input');
				tag.classList.add('signature-writer');
				tag.setAttribute("readonly", true);
				break;
			case "signature-approver":
				tag = document.createElement('input');
				tag.classList.add('signature-approver');
				tag.setAttribute("readonly", true);
				break;
			case "signature-checker":
				tag = document.createElement('input');
				tag.classList.add('signature-checker');
				tag.setAttribute("readonly", true);
				break;
			case "date":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.setAttribute("type", "date");
				
				if(format == 'yyyy-mm-dd') {
				   tag.setAttribute("date-format", 'yyyy-mm-dd');
                   if(default_value == null) {
                      tag.value = today;
				   }
				   else if(default_value == 'today') {
					  tag.value = today;
				   }
				   else if(default_value == '일주일전') {
					  tag.value = weekDay;
				   }
				   else if(default_value == '한달전') {
					  tag.value = monthDay;
				   }
				}
				else if (format == 'mm-dd') {
				   tag.setAttribute("date-format", 'mm-dd');
				   if (default_value == null) {
                      tag.value = today;
				   }
				   else if(default_value == 'today') {
					  tag.value = today;
				   }
				   else if(default_value == '일주일전') {
					  tag.value = weekDay;
				   }
				   else if(default_value == '한달전') {
					  tag.value = monthDay;
				   }
				}
				break;
			case "time":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.setAttribute("type", "time");
				
				if(format == 'hh:mm:ss') {
				 
				}
				else if (format == 'hh') {
				  
				}
				else if (format == 'hh:mm') {
				  
				}
				break;	
			case "text":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.maxlength = maxLengthText;
				break;
			case "number":
				tag = document.createElement('input');
				tag.type = 'number';
				tag.min = min;
				tag.max = max;
				tag.classList.add("checklist-data");
				if(tag.format != null) {
					tag.value = 0;
				}
				break;
			case "checkbox":
				tag = document.createElement('input');
				tag.type = 'checkbox';
				tag.classList.add("checklist-data");
				
				if(default_value == 'checked') {
					tag.checked = true;
				}
				else if(default_value == 'unchecked') {
					tag.checked = false;
				}
				break;
			case "radio button":
				tag = document.createElement('input');
				tag.type = 'radio';
				tag.classList.add("checklist-data");
				
				if(default_value == 'checked') {
					tag.checked = true;
				}
				else if(default_value == 'unchecked') {
					tag.checked = false;
				}
				break;
			case "file":
				if(format == 'image') {
					formTag = document.createElement('form');
					formTag.id = id + "_form";
					formTag.method = "post";
					formTag.enctype = "multipart/form-data";
					formTag.style.position = 'absolute';
					formTag.style.left = startX;
					formTag.style.top = (startYNum + heightNum - 30) + "px";
					formTag.style.width = width;
					formTag.style.height = "30px";

					fileTag = document.createElement('input');
					fileTag.id = id + "_file";
					fileTag.name = "filename";
					fileTag.setAttribute("type", "file");
					fileTag.setAttribute("onchange", "changeIMG(this);");

					formTag.append(fileTag);
					document.getElementById("checklist-insert-wrapper").appendChild(formTag);
				
					tag = document.createElement('canvas');
					tag.classList.add("checklist-data");
					}
				else {
					tag = document.createElement('input');
					tag.setAttribute("type", "file");
					tag.classList.add("checklist-data");
				}
				break;	
			case "textarea":
				tag = document.createElement('textarea');
				tag.classList.add("checklist-data");
				break;
			case "select":
				tag = document.createElement('select');
				tag.classList.add("checklist-data");

				if(format == 'OX') {
					tag.add(opt1, null);
					tag.add(opt3, null);
					
					if(default_value == null) {

					}
					else if(default_value == 'O') {
						tag.value = 'O';
					}
					else if(default_value == 'X') {
						tag.value = 'X';
					}
				}
				else if(format == 'O△X') {
					tag.add(opt1, null);
					tag.add(opt2, null);
					tag.add(opt3, null);

					if(default_value == null) {
						
					}
					else if(default_value == 'O') {
						tag.value = 'O';
					}
					else if(default_value == '△') {
						tag.value = '△';
					}
					else if(default_value == 'X') {
						tag.value = 'X';

					}
				}
				else if(format == 'good/bad') {
					tag.add(opt4, null);
					tag.add(opt5, null);

					if(default_value == null) {
						
					}
					else if(default_value == 'good') {
						tag.value = '적합';
					}
					else if(default_value == 'bad') {
						tag.value = '부적합';

					}
				}
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
		
		//이미지일 경우 파일 첨부 영역이 하단에 30px만큼 높이 고정되어 표시되도록 하기 귀함.
		if(format == "image") {
			tag.style.height = (heightNum - 30) + "px";
		}
		else {
			tag.style.height = height;
		}
		
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
			console.log(checklistData);
            var check = confirm('수정하시겠습니까?');
			
			if(check) {

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
		var default_value = cell.childNodes[2].firstChild.textContent;
		var min = cell.childNodes[3].firstChild.textContent;
		var max = cell.childNodes[4].firstChild.textContent;
		var startX = cell.childNodes[5].firstChild.textContent;
		var startY = cell.childNodes[6].firstChild.textContent;
		var width = cell.childNodes[7].firstChild.textContent;
		var height = cell.childNodes[8].firstChild.textContent;
		var readonly = "";
		
		var tagId = "#" + id;
		this.tagIds = tagId;
		this.tagTypes = type;
		let tag;

		var nowDate = new Date();
		var weekAgoDate = new Date(new Date().setDate(new Date().getDate() - 7));
		var monthAgoDate = new Date(new Date().setDate(new Date().getDate() - 30));

		var year = nowDate.getFullYear();
		var month = nowDate.getMonth() + 1;
		var day = nowDate.getDate();

		var year2 = weekAgoDate.getFullYear();
		var month2 = weekAgoDate.getMonth() + 1;
		var day2 = weekAgoDate.getDate();

		var year3 = monthAgoDate.getFullYear();
		var month3 = monthAgoDate.getMonth() + 1;
		var day3 = monthAgoDate.getDate();

		if(month < 10) {
			month = "0" + month;
		}
		if(day < 10) {
			day = "0" + day;
		}

		if(month2 < 10) {
			month2 = "0" + month2;
		}
		if(day2 < 10) {
			day2 = "0" + day2;
		}

		if(month3 < 10) {
			month3 = "0" + month3;
		}
		if(day3 < 10) {
			day3 = "0" + day3;
		}

		var today = year + "-" + month + "-" + day;
		var weekDay = year2 + "-" + month2 + "-" + day2;
		var monthDay = year3 + "-" + month2 + "-" + day3;

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
		
		
		
		var maxLengthText = parseInt(width) / 16.6; //한글 한 글자당 차지하는 px넓이 : 16.6px
		var heightNum = parseInt(height.replace("px", ""));
		var widthNum = parseInt(width.replace("px", ""));
		var startXNum = parseInt(startX.replace("px", ""));
		var startYNum = parseInt(startY.replace("px", ""));
		var textSizeVal = "";

		if(heightNum >= 20) {
			textSizeVal = "16px"; //text input default font-size = 16px;
		}

		else {
			textSizeVal = parseInt(height.replace("px", "") * 0.8) + "px"; //input 태그 높이에 따라 font-size 조절위함

		}

		var opt1 = document.createElement("option");
		var opt2 = document.createElement("option");
		var opt3 = document.createElement("option");
		var opt4 = document.createElement("option");
		var opt5 = document.createElement("option");

		opt1.value = "O";
		opt1.text = "O";

		opt2.value = "△";
		opt2.text = "△";

		opt3.value = "X";
		opt3.text = "X";
		
		opt4.value = "적합";
		opt4.text = "적합"; 

		opt5.value = "부적합";
		opt5.text = "부적합"; 

		var fileTag = "";
		
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

				if(format == 'yyyy-mm-dd') {
				   tag.setAttribute("date-format", 'yyyy-mm-dd');
                   if(default_value == null) {
                      if(data == null || data == '') {
						tag.value = "";
					  }
					  else {
						tag.value = data;
					  }
				   }
				   else if(default_value == 'today') {
					  if(data == null || data == '') {
						tag.value = today;
					  }
					  else {
						tag.value = data;
					  }
				   }
				   else if(default_value == '일주일전') {
					  if(data == null || data == '') {
						tag.value = weekDay;
					  }
					  else {
						tag.value = data;
					  }
				   }
				   else if(default_value == '한달전') {
					  if(data == null || data == '') {
						tag.value = monthDay;
					  }
					  else {
						tag.value = data;
					  }
				   }
				}
				else if (format == 'mm-dd') {
				   tag.setAttribute("date-format", 'mm-dd');
				   if (default_value == null) {
                      if(data == null || data == '') {
						tag.value = "";
					  }
					  else {
						tag.value = data;
					  }
				   }
				   else if(default_value == 'today') {
					  if(data == null || data == '') {
						tag.value = today;
					  }
					  else {
						tag.value = data;
					  }
				   }
				   else if(default_value == '일주일전') {
					  if(data == null || data == '') {
						tag.value = weekDay;
					  }
					  else {
						tag.value = data;
					  }
				   }
				   else if(default_value == '한달전') {
					  if(data == null || data == '') {
						tag.value = monthDay;
					  }
					  else {
						tag.value = data;
					  }
				   }
				}
				break;
			case "time":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.setAttribute("type", "time");
				
				if(format == 'hh:mm:ss') {
					tag.value = data;
				}
				else if (format == 'hh') {
					tag.value = data;
				}
				else if (format == 'hh:mm') {
					tag.value = data;
				}
				break;
			case "text":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.value = data;
				tag.maxlength = maxLengthText;
				break;
			case "number":
				tag = document.createElement('input');
				tag.type = 'number';
				tag.min = min;
				tag.max = max;
				tag.classList.add("checklist-data");
				if(data == null || data == '') {
					if(tag.format != null) {
						tag.value = 0;
					}
				}
				else {
					tag.value = data;
				}
				break;
			case "checkbox":
				tag = document.createElement('input');
				tag.type = 'checkbox';
				tag.classList.add("checklist-data");
				
				if(data == 'on') {
					tag.checked = true;
				}
				else {
					if(default_value == 'checked') {
						tag.checked = true;
					}
					else if(default_value == 'unchecked') {
						tag.checked = false;
					}
				}
				break;
			case "radio button":
				tag = document.createElement('input');
				tag.type = 'radio';
				tag.classList.add("checklist-data");
				
				if(data == 'on') {
					tag.checked = true;
				}

				else {
					if(default_value == 'checked') {
						tag.checked = true;
					}
					else if(default_value == 'unchecked') {
						tag.checked = false;
					}
				}
				break;
			case "file":
				if(format == 'image') {
					formTag = document.createElement('form');
					formTag.id = id + "_form";
					formTag.method = "post";
					formTag.enctype = "multipart/form-data";
					formTag.style.position = 'absolute';
					formTag.style.left = startX;
					formTag.style.top = (startYNum + heightNum - 30) + "px";
					formTag.style.width = width;
					formTag.style.height = "30px";

					fileTag = document.createElement('input');
					fileTag.id = id + "_file";
					fileTag.name = "filename";
					fileTag.setAttribute("type", "file");
					fileTag.setAttribute("onchange", "changeIMG(this);");
					formTag.append(fileTag);
					document.getElementById("checklist-update-wrapper").appendChild(formTag);

					tag = document.createElement('canvas');
					tag.classList.add("checklist-data");
					tag.id = id;
					tag.style.position = 'absolute';
					tag.style.left = startX;
					tag.style.top = startY;
					tag.style.width = width;
					tag.style.height = (heightNum - 30) + "px";
					tag.value = data;
					document.getElementById("checklist-update-wrapper").appendChild(tag);
					fn_Set_Image_File_View(data, id, width, tag.style.height);
				}
				else {
					tag = document.createElement('input');
					tag.setAttribute("type", "file");
					tag.classList.add("checklist-data");
				}
				break;	
			case "textarea":
				tag = document.createElement('textarea');
				tag.classList.add("checklist-data");
				tag.value = data;
				break;
			case "select":
				tag = document.createElement('select');
				tag.classList.add("checklist-data");

				if(format == 'OX') {
					tag.add(opt1, null);
					tag.add(opt3, null);

					if(data == '' || data == null) {
						if(default_value == null) {

						}
						else if(default_value == 'O') {
							tag.value = 'O';
						}
						else if(default_value == 'X') {
							tag.value = 'X';

						}
					}
					else {
						tag.value = data;
					}
				}
				else if(format == 'O△X') {
					tag.add(opt1, null);
					tag.add(opt2, null);
					tag.add(opt3, null);

					if(data == '' || data == null) {
						if(default_value == null) {
						
						}
						else if(default_value == 'O') {
						tag.value = 'O';
						}
						else if(default_value == '△') {
						tag.value = '△';
						}
						else if(default_value == 'X') {
						tag.value = 'X';
						}
					}
					else {
						tag.value = data;
					}
				}
				else if(format == 'good/bad') {
					tag.add(opt4, null);
					tag.add(opt5, null);

					if(data == '' || data == null) {

						if(default_value == null) {
						
						}
						else if(default_value == 'good') {
							tag.value = '적합';
						}
						else if(default_value == 'bad') {
							tag.value = '부적합';
						}
					}
					else {
						tag.value = data;
					}
				}
				break;
			default:
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
				tag.value = data;
				break;
		}
		
		//image는 상단 case문에서 tag 추가되기 때문에 제외 
		if(format != "image") {
			tag.id = id;
			tag.style.position = 'absolute';
			tag.style.left = startX;
			tag.style.top = startY;
			tag.style.width = width;
			tag.style.height = height;
			tag.style.fontSize = textSizeVal;
			document.getElementById("checklist-update-wrapper").appendChild(tag);
		}
		
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
		var startX = cell.childNodes[5].textContent.replace('px', '');
		var startY = cell.childNodes[6].textContent.replace('px', '');
		var width = cell.childNodes[7].textContent.replace('px', '');
		var height = cell.childNodes[8].textContent.replace('px', '');
		
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
			case "radio button":
				if(data === 'on') {
					this.ctx.fillText("✔", middleX, middleY);
				}
				break;
			case "checkbox":
				if(data === 'on') {
					this.ctx.fillText("✔", middleX, middleY);
				}
				break;
			case "textarea":
				 this.ctx.textAlign = "left";
				 this.ctx.fillText(data, middleX, middleY);
				 //this.ctx.wrapText_XY(ctx, cl.bodies.body0, "row34", "col14", data,	
 	 							//'balck', "9px serif", "left", "top", 20, 2, 1, 1);
				break;
			case "file":
				if(format == 'image') {
					fn_Set_Image_File_View2(data, 'checklist-select-canvas', startX, startY, width, height);
				}
				else {
					 this.ctx.fillText(data, middleX, middleY);
				}	
			default : 
				this.ctx.fillText(data, middleX, middleY);
				break;
		}
	};
}


function ChecklistSelectModalMetalDetector(createDate, sensorId) {
	this.createDate = createDate;
	this.sensorId = sensorId;	
	
	this.checklistId = 'checklist05';
	this.seqNo = 0;
	this.revisionNo = '0';
	
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
		this.metaDataPath = heneServerPath + '/checklist/' + heneBizNo + '/metadata/' + this.checklistId + '_' + this.revisionNo + '.xml';
		this.imagePath = '/checklist/' + heneBizNo + '/images/' + this.checklistId + '_' + this.revisionNo + '.png';
	}
	
	this.getChecklistData = async function() {
		let fetchedData = $.ajax({
			type: "GET",
	        url: heneServerPath + "/ccptestvm"
	            	+ "?method=" + 'detail'
	            	+ "&date=" + this.createDate
	            	+ "&processCode=" + 'PC10'
	            	+ "&sensorId=" + this.sensorId,
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
		this.checklistSignData = await this.getChecklistSignData();
		console.log(this.checklistData);
		
		let info = {
			"rowStartCell":"cell3",
			"writerSignCell":0,
			"approverSignCell":1,
			"dateCell":2,
			"normalSumValueWhenAddAllTestResult":"4", 
			"roworder": ["prod", "time", "MC10", "MC20", "MC30", "MC40", "MC50", "judge", "empty"]
		}
		
		let outer = new Array();
		let row = new Object();
		let sensorKey = this.checklistData[0].sensorKey;
		
		for(let i=0; i<this.checklistData.length; i++) {
			if(sensorKey == this.checklistData[i].sensorKey) {
				if(!row.detail) {
					row.detail = new Object();
				}
				row.detail[this.checklistData[i].eventCode] = this.checklistData[i].sensorValue;
			} else {
				row = new Object();
				row.prod = this.checklistData[i].productName;
				row.time = this.checklistData[i].createTime;
				row.detail = new Object();
				row.detail[this.checklistData[i].eventCode] = this.checklistData[i].sensorValue;
				
				outer.push(row);
				sensorKey = this.checklistData[i].sensorKey
			}
		}
		
		$("#checklist-select-modal").modal("show");
		
		// read checklist image
		var canvas = document.getElementById('checklist-select-canvas');
		
		canvas.width = this.modalWidthWithoutPxKeyword;
		canvas.height = this.modalHeightWithoutPxKeyword;
		
		this.ctx = canvas.getContext('2d');
		
		var bgImg = new Image();
		bgImg.src = this.imagePath;
		bgImg.onload = async function() {
			that.drawImage(bgImg);
			
			// display data
			var cellList = that.xmlDoc.getElementsByTagName("cells")[0].childNodes;
			
			// draw date
			that.displayData(cellList[info.dateCell], that.createDate);
			
			// draw signature
			var ccpSign = new CCPSign();
			var signInfo = await ccpSign.get(that.createDate, 'PC10');
			console.log(signInfo);
			
			that.displayData(cellList[info.writerSignCell], '김치훈');
			that.displayData(cellList[info.approverSignCell], '노찬울');
			
/*			if(signInfo.checkerName != null) {
				that.displayData(cellList[info.approverSignCell], '노찬울');
			}*/
			
			var currentRow = 0;
			var startFlag = false;
			var cellPos = 0;
			for(let i=0; i<cellList.length; i++) {
				if(cellList[i].nodeName == info.rowStartCell) {
					console.log('start flag to true');
					startFlag = true;
					cellPos = i;
				}
				
				if(!startFlag) {
					continue;
				} else {
					var row = outer[currentRow];
					
					for(let j=0; j<info.roworder.length; j++) {
						var item = info.roworder[j];
						
						switch(item) {
							case "prod":
								var cell = cellList[cellPos];
								that.displayData(cell, row.prod);
								break;
							case "time":
								var cell = cellList[cellPos];
								var time = row.time.substring(11, 16);
								that.displayData(cell, time);
								break;
							case "MC10":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC10"]);
								break;
							case "MC20":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC20"]);
								break;
							case "MC30":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC30"]);
								break;
							case "MC40":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC40"]);
								break;
							case "MC50":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC50"]);
								break;
							case "judge":
								var cell = cellList[cellPos];

								if(that.judgeResult(row.detail, info)) {
									that.displayData(cell, "적합");
								} else {
									that.displayData(cell, "부적합");
								}
						}
						
						cellPos += 1;
					}
					
					currentRow += 1;
					i += info.roworder.length;
				}
			}
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
	
	this.judgeResult = function(testResults, info) {
		let sum = 0;

		for (const key in testResults) {
			sum += Number(testResults[key]);
		}
		
		if(sum == info.normalSumValueWhenAddAllTestResult) {
			return true;
		}
		
		return false;
	}
	
	this.displayData = function(cell, data) {
		var id = cell.nodeName;
		var type = cell.childNodes[0].textContent;
		var format = cell.childNodes[1].textContent;
		var startX = cell.childNodes[5].textContent.replace('px', '');
		var startY = cell.childNodes[6].textContent.replace('px', '');
		var width = cell.childNodes[7].textContent.replace('px', '');
		var height = cell.childNodes[8].textContent.replace('px', '');
		
		var signWriter = this.checklistSignData.signWriter;
		var signChecker = this.checklistSignData.signChecker;
		var signApprover = this.checklistSignData.signApprover;
		
		var middleX = Number(startX) + (width / 2);
		var middleY = Number(startY) + (height / 2);
		
		this.ctx.textAlign = "center";
		this.ctx.font = '10px serif';
		
		if(!data) {
			data = '';
		}
		
		if(data == 1) {
			data = 'O';
		}
		if(data == 0) {
			data = 'X';
		}
		this.ctx.fillText(data, middleX, middleY);
	};
}
