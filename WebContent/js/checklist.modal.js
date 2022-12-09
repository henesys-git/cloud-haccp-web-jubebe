function ChecklistInsertModal(checklistId, seqNo, page) {
	this.checklistId = checklistId;
	this.seqNo = seqNo;
	
	this.modalUtil = new ChecklistModalUtil();
	
	this.metaDataPath;
	this.imagePath;
	
	this.metaDataPath2;
	this.imagePath2;
	this.metaDataPath3;
	this.imagePath3;
	this.metaDataPath4;
	this.imagePath4;
	this.metaDataPath5;
	this.imagePath5;
	
	this.modalWidth;
	this.modalHeight;
	this.modalWidthWithoutPxKeyword;
	this.modalHeightWithoutPxKeyword;
	
	this.modalWidth2;
	this.modalHeight2;
	this.modalWidthWithoutPxKeyword2;
	this.modalHeightWithoutPxKeyword2;
	
	this.modalWidth3;
	this.modalHeight3;
	this.modalWidthWithoutPxKeyword3;
	this.modalHeightWithoutPxKeyword3;
	
	this.modalWidth4;
	this.modalHeight4;
	this.modalWidthWithoutPxKeyword4;
	this.modalHeightWithoutPxKeyword4;
	
	this.modalWidth5;
	this.modalHeight5;
	this.modalWidthWithoutPxKeyword5;
	this.modalHeightWithoutPxKeyword5;
	
	this.xmlDoc;
	this.tagIds;
	this.tagTypes;
	this.ctx;
	this.page = page;
	var pageNum = page;
	
	var canvas2;
	var response2;
	var metaData2;
	var parser2;
	this.xmlDoc2;
	this.ctx2;
	
	var canvas3;
	var response3;
	var metaData3;
	var parser3;
	this.xmlDoc3;
	this.ctx3;
	
	var canvas4;
	var response4;
	var metaData4;
	var parser4;
	this.xmlDoc4;
	this.ctx4;
	
	var canvas5;
	var response5;
	var metaData5;
	var parser5;
	this.xmlDoc5;
	this.ctx5;
	
	this.setMetadataAndImagePath = async function() {
		// checklistXX_Y.xml, checklistXX_Y.png에서 
		// XX는 점검표 아이디, Y는 점검표 수정이력번호
		// checklistXX_Y_Z.xml, checklistXX_Y_Z.png에서 
		// XX는 점검표 아이디, Y는 점검표 수정이력번호 + Z는 page number
		
		if(this.page == 1) {
			this.metaDataPath = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '.xml';
			this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '.png';
			}
		
		else if(this.page >= 2) {
			this.metaDataPath = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '_' + 1 +'.xml';
			this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '_' + 1 + '.png';
			this.metaDataPath2 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '_' + 2 +'.xml';
			this.imagePath2 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '_' + 2 + '.png';
			this.metaDataPath3 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '_' + 3 +'.xml';
			this.imagePath3 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '_' + 3 + '.png';
			this.metaDataPath4 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '_' + 4 +'.xml';
			this.imagePath4 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '_' + 4 + '.png';
			this.metaDataPath5 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '_' + 5 +'.xml';
			this.imagePath5 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '_' + 5 + '.png';
		}
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
		
		let size = this.modalUtil.adjustModalSize(this, 1);
		this.modalWidthWithoutPxKeyword = size.width;
		this.modalHeightWithoutPxKeyword = size.height;
		
		var modalContent = document.querySelector('#checklist-insert-modal .modal-content');
		modalContent.style.width = Number(this.modalWidthWithoutPxKeyword) + Number(30) + 'px';
		
		//if page length is more than 1page add additional modal setting
		if(this.page >= 2) {
			response2 = await fetch(this.metaDataPath2);
	    	metaData2 = await response2.text();
		    parser2 = new DOMParser();
			this.xmlDoc2 = parser.parseFromString(metaData2, "text/xml");
			
			this.modalWidth2 = this.xmlDoc2.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight2 = this.xmlDoc2.getElementsByTagName("height")[0].innerHTML;
		
			let size2 = this.modalUtil.adjustModalSize(this, 2);
			this.modalWidthWithoutPxKeyword2 = size2.width;
			this.modalHeightWithoutPxKeyword2 = size2.height;
			
			$('#checklist-insert-footer').prepend('<button type="button" id="checklist-next-btn" class="btn btn-success" onclick="checklist_next(2);">다음페이지</button>');
			$('#checklist-insert-footer').prepend('<button type="button" id="checklist-prev-btn" class="btn btn-success" style="display:none;" onclick="checklist_prev(2);">이전페이지</button>');
		}
		
		if(this.page >= 3) {
			
			response3 = await fetch(this.metaDataPath3);
	    	metaData3 = await response3.text();
		    parser3 = new DOMParser();
			this.xmlDoc3 = parser.parseFromString(metaData3, "text/xml");
			
			this.modalWidth3 = this.xmlDoc3.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight3 = this.xmlDoc3.getElementsByTagName("height")[0].innerHTML;
			
			let size3 = this.modalUtil.adjustModalSize(this, 3);
			this.modalWidthWithoutPxKeyword3 = size3.width;
			this.modalHeightWithoutPxKeyword3 = size3.height;
		}
		
		if(this.page >= 4) {
			response4 = await fetch(this.metaDataPath4);
	    	metaData4 = await response4.text();
		    parser4 = new DOMParser();
			this.xmlDoc4 = parser.parseFromString(metaData4, "text/xml");
			
			this.modalWidth4 = this.xmlDoc4.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight4 = this.xmlDoc4.getElementsByTagName("height")[0].innerHTML;
			
			let size4 = this.modalUtil.adjustModalSize(this, 4);
			this.modalWidthWithoutPxKeyword4 = size4.width;
			this.modalHeightWithoutPxKeyword4 = size4.height;
		}
		
		if(this.page >= 5) {
			response5 = await fetch(this.metaDataPath5);
	    	metaData5 = await response5.text();
		    parser5 = new DOMParser();
			this.xmlDoc5 = parser.parseFromString(metaData5, "text/xml");
			
			this.modalWidth5 = this.xmlDoc5.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight5 = this.xmlDoc5.getElementsByTagName("height")[0].innerHTML;
			
			let size5 = this.modalUtil.adjustModalSize(this, 5);
			this.modalWidthWithoutPxKeyword5 = size5.width;
			this.modalHeightWithoutPxKeyword5 = size5.height;
		}
	};
	
	this.openModal = async function() {
		let that = this;
		let that2 = this;
		
		await this.setMetadataAndImagePath();
		await this.setModal();
		
		$("#checklist-insert-modal").modal("show");
		
		// read checklist image
		var canvas = document.getElementById('checklist-insert-canvas');
		
		canvas.width = this.modalWidthWithoutPxKeyword;
		canvas.height = this.modalHeightWithoutPxKeyword;
		
		this.ctx = canvas.getContext('2d');
		
		//console.log(this.modalWidthWithoutPxKeyword);
		//console.log(this.modalHeightWithoutPxKeyword);
		
		var bgImg = new Image();
		bgImg.src = this.imagePath;
		bgImg.onload = function() {
			that.drawImage(bgImg, 0, 0, this.modalWidthWithoutPxKeyword, this.modalHeightWithoutPxKeyword);
		};
		
		// generate tags
		var cellList = this.xmlDoc.getElementsByTagName("cells")[0].childNodes;
		
		for(var i=0; i<cellList.length; i++) {
			var cell = cellList[i];
			this.makeTag(cell, 1);
		};
		
		if(this.page >= 2) {
			var canvas2 = document.getElementById('checklist-insert-canvas2');
		
			canvas2.width = this.modalWidthWithoutPxKeyword2;
			canvas2.height = this.modalHeightWithoutPxKeyword2;
		
			this.ctx2 = canvas2.getContext('2d');
		
			var bgImg2 = new Image();
			bgImg2.src = this.imagePath2;
			bgImg2.onload = function() {
				that.drawImage2(bgImg2, 0, 0, this.modalWidthWithoutPxKeyword2, this.modalHeightWithoutPxKeyword2);
			};
		
			// generate tags
			var cellList2 = this.xmlDoc2.getElementsByTagName("cells")[0].childNodes;
		
			for(var i=0; i<cellList2.length; i++) {
				var cell2 = cellList2[i];
				this.makeTag(cell2, 2);
			};
			
		}
			
		if(this.page >= 3) {
			var canvas3 = document.getElementById('checklist-insert-canvas3');
		
			canvas3.width = this.modalWidthWithoutPxKeyword3;
			canvas3.height = this.modalHeightWithoutPxKeyword3;
		
			this.ctx3 = canvas3.getContext('2d');
		
			var bgImg3 = new Image();
			bgImg3.src = this.imagePath3;
			bgImg3.onload = function() {
				that.drawImage3(bgImg3, 0, 0, this.modalWidthWithoutPxKeyword3, this.modalHeightWithoutPxKeyword3);
			};
		
			// generate tags
			var cellList3 = this.xmlDoc3.getElementsByTagName("cells")[0].childNodes;
		
			for(var i=0; i<cellList3.length; i++) {
				var cell3 = cellList3[i];
				this.makeTag(cell3, 3);
			};
		}
		
		if(this.page >= 4) {
			
			var canvas4 = document.getElementById('checklist-insert-canvas4');
		
			canvas4.width = this.modalWidthWithoutPxKeyword4;
			canvas4.height = this.modalHeightWithoutPxKeyword4;
		
			this.ctx4 = canvas4.getContext('2d');
		
			var bgImg4 = new Image();
			bgImg4.src = this.imagePath4;
			bgImg4.onload = function() {
				that.drawImage4(bgImg4, 0, 0, this.modalWidthWithoutPxKeyword4, this.modalHeightWithoutPxKeyword4);
			};
		
			// generate tags
			var cellList4 = this.xmlDoc4.getElementsByTagName("cells")[0].childNodes;
		
			for(var i=0; i<cellList4.length; i++) {
				var cell4 = cellList4[i];
				this.makeTag(cell4, 4);
			};
		}
			
		if(this.page >= 5) {
			
			var canvas5 = document.getElementById('checklist-insert-canvas5');
		
			canvas5.width = this.modalWidthWithoutPxKeyword5;
			canvas5.height = this.modalHeightWithoutPxKeyword5;
		
			this.ctx5 = canvas5.getContext('2d');
		
		
			var bgImg5 = new Image();
			bgImg5.src = this.imagePath5;
			bgImg5.onload = function() {
				that.drawImage5(bgImg5, 0, 0, this.modalWidthWithoutPxKeyword5, this.modalHeightWithoutPxKeyword5);
			};
		
			// generate tags
			var cellList5 = this.xmlDoc5.getElementsByTagName("cells")[0].childNodes;
		
			for(var i=0; i<cellList5.length; i++) {
				var cell5 = cellList5[i];
				this.makeTag(cell5, 5);
			};
		}
		
		// save data to db
		$('#checklist-insert-btn').off().click(function() {
			
			var dataArray = new Array();
			var head = {};
			var checklistData = {};
			var checklistData2 = {};
			var checklistData3 = {};
			var checklistData4 = {};
			var checklistData5 = {};
	
			//let elements = document.getElementsByClassName('checklist-data');
			let elements = document.getElementById('checklist-insert-wrapper1').getElementsByClassName('checklist-data');
			let elements2 = document.getElementById('checklist-insert-wrapper2').getElementsByClassName('checklist-data');
			let elements3 = document.getElementById('checklist-insert-wrapper3').getElementsByClassName('checklist-data');
			let elements4 = document.getElementById('checklist-insert-wrapper4').getElementsByClassName('checklist-data');
			let elements5 = document.getElementById('checklist-insert-wrapper5').getElementsByClassName('checklist-data');
	
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
			dataArray.push(checklistData);
			
			if(pageNum >= 2) {
				for(var j=0; j<elements2.length; j++) {
					let element2 = elements2[j];
					if(element2.type == 'checkbox') {
						if(element2.checked == true) {
							checklistData2[element2.id] = element2.value;
						}
						else {
							checklistData2[element2.id] = '';
						}
					}
					else {
						checklistData2[element2.id] = element2.value;
					}
				}
				dataArray.push(checklistData2);	
			}
			
			if(pageNum >= 3) {
				for(var k=0; k<elements3.length; k++) {
					let element3 = elements3[k];
					if(element3.type == 'checkbox') {
						if(element3.checked == true) {
							checklistData3[element3.id] = element3.value;
						}
						else {
							checklistData3[element3.id] = '';
						}
					}
					else {
						checklistData3[element3.id] = element3.value;
					}
				}
				dataArray.push(checklistData3);	
			}
			
			if(pageNum >= 4) {
				for(var l=0; l<elements4.length; l++) {
					let element4 = elements4[l];
					if(element4.type == 'checkbox') {
						if(element4.checked == true) {
							checklistData4[element4.id] = element4.value;
						}
						else {
							checklistData4[element4.id] = '';
						}
					}
					else {
						checklistData4[element4.id] = element4.value;
					}
				}
				dataArray.push(checklistData4);	
			}
			
			if(pageNum >= 5) {
				for(var m=0; m<elements5.length; m++) {
					let element5 = elements5[m];
					if(element5.type == 'checkbox') {
						if(element5.checked == true) {
							checklistData5[element5.id] = element5.value;
						}
						else {
							checklistData5[element5.id] = '';
						}
					}
					else {
						checklistData5[element5.id] = element5.value;
					}
				}
				dataArray.push(checklistData5);	
			}
			
			head.checklistId = checklistId;
			head.revisionNo = seqNo;
			//head.checklistData = checklistData;
			
			if(pageNum >= 2) {
				head.checklistData = dataArray;
			}
			else {
				head.checklistData = checklistData;
			}
			
			//console.log(checklistData);
			//console.log(dataArray);
			//console.log(head);
			//console.log(JSON.stringify(head));
			
			if(confirm('등록하시겠습니까?')) {

			$.ajax({
				type: "POST",
		        url: heneServerPath + "/checklist",
		        data: "data=" + JSON.stringify(head) +
					  "&type=insert",
		        success: function (result) {
					//console.log(result);
					
					var children = $('#checklist-insert-wrapper1').children();
					var children2 = $('#checklist-insert-wrapper2').children();
					var children3 = $('#checklist-insert-wrapper3').children();
					var children4 = $('#checklist-insert-wrapper4').children();
					var children5 = $('#checklist-insert-wrapper5').children();
    		
    				for(let i=1; i<children.length; i++) {
    					children[i].remove();
    				}

					for(let j=1; j<children2.length; j++) {
    					children2[j].remove();
    				}

					for(let k=1; k<children3.length; k++) {
    					children3[k].remove();
    				}

					for(let l=1; l<children4.length; l++) {
    					children4[l].remove();
    				}
					
					for(let m=1; m<children5.length; m++) {
    					children5[m].remove();
    				}


					$('#checklist-insert-modal').modal('hide');
					 parent.refreshMainTable();
		        }
			});
			
			}
		});
	};
	
	this.drawImage = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword, this.modalHeightWithoutPxKeyword);
	}
	this.drawImage2 = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx2.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword2, this.modalHeightWithoutPxKeyword2);
	}
	this.drawImage3 = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx3.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword3, this.modalHeightWithoutPxKeyword3);
	}
	this.drawImage4 = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx4.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword4, this.modalHeightWithoutPxKeyword4);
	}
	this.drawImage5 = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx5.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword5, this.modalHeightWithoutPxKeyword5);
	}
	
	this.makeTag = async function(cell, pages) {
		
		var size = this.modalUtil.setTagSize(this, cell);
		var startX = size.startX;
		var startY = size.startY;
		var width = size.width;
		var height = size.height;
		
		var id = cell.tagName;
		var type = cell.childNodes[0].firstChild.textContent;
		var format = cell.childNodes[1].firstChild.textContent;
		var default_value = cell.childNodes[2].firstChild.textContent;
		var min = cell.childNodes[3].firstChild.textContent;
		var max = cell.childNodes[4].firstChild.textContent;
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
		var reductDay;
		
		if(month != 10) {
			reductDay = month.toString().replace("0", "") + "/" + day;
		}
		else {
			reductDay = month + "/" + day;
		}
		
		var maxLengthText = parseInt(parseInt(width) / 16.6); //한글 한 글자당 차지하는 px넓이 : 16.6px

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
		var opt6 = document.createElement("option");

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
		
		opt6.value = "";
		opt6.text = ""; 

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
				tag.style.fontSize = "10px";
				
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
	 			   else if(default_value == 'todayReduct') {
					  tag.value = reductDay;
				   }
				}
				else if (format == 'yyyy') {
					tag.setAttribute("date-format", 'yyyy');
					if (default_value == null) {
					
				   	}
				   	else if(default_value == 'thisyear') {
					  	tag.value = year;
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
				//tag.maxlength = maxLengthText;
				//tag.setAttribute("maxlength", maxLengthText);
				break;
			case "number":
				tag = document.createElement('input');
				tag.type = 'number';
				tag.min = min;
				tag.max = max;
				tag.classList.add("checklist-data");
				if(tag.format != null) {
					//TODO: 필요한 코드인가?
					tag.value = 0;
				}
				else if(tag.format == null) {
					if(default_value == null) {
						tag.value = '';
					}
					else {
						tag.value = default_value;
					} 
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
					if(pages == 1) {
						document.getElementById("checklist-insert-wrapper1").appendChild(formTag);
					}
					else if(pages == 2) {
						document.getElementById("checklist-insert-wrapper2").appendChild(formTag);

					}
					else if(pages == 3) {
						document.getElementById("checklist-insert-wrapper3").appendChild(formTag);

					}
					else if(pages == 4) {
						document.getElementById("checklist-insert-wrapper4").appendChild(formTag);

					}
					else if(pages == 5) {
						document.getElementById("checklist-insert-wrapper5").appendChild(formTag);

					}
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
					tag.add(opt6, null);
					
					if(default_value == null) {
						
					}
					else if(default_value == 'O') {
						tag.value = 'O';
					}
					else if(default_value == 'X') {
						tag.value = 'X';
					}
					else if(default_value == '') {
						tag.value = '';
					}
				}
				else if(format == 'O△X') {
					tag.add(opt1, null);
					tag.add(opt2, null);
					tag.add(opt3, null);
					tag.add(opt6, null);

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
					else if(default_value == '') {
						tag.value = '';
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
				//tag.setAttribute("maxlength", maxLengthText);
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
		if(pages == 1) {
			document.getElementById("checklist-insert-wrapper1").appendChild(tag);
		}
		else if(pages == 2) {
			document.getElementById("checklist-insert-wrapper2").appendChild(tag);
		}
		else if(pages == 3) {
			document.getElementById("checklist-insert-wrapper3").appendChild(tag);
		}
		else if(pages == 4) {
			document.getElementById("checklist-insert-wrapper4").appendChild(tag);
		}
		else if(pages == 5) {
			document.getElementById("checklist-insert-wrapper5").appendChild(tag);
		}
	};
	
}

function ChecklistUpdateModal(checklistId, revisionNo, seqNo, page) {
	this.checklistId = checklistId;
	this.revisionNo = revisionNo;
	this.seqNo = seqNo;

	this.modalUtil = new ChecklistModalUtil();

	this.metaDataPath;
	this.imagePath;
	
	this.metaDataPath2;
	this.imagePath2;
	this.metaDataPath3;
	this.imagePath3;
	this.metaDataPath4;
	this.imagePath4;
	this.metaDataPath5;
	this.imagePath5;
	
	this.modalWidth;
	this.modalHeight;
	this.modalWidthWithoutPxKeyword;
	this.modalHeightWithoutPxKeyword;
	
	this.modalWidth2;
	this.modalHeight2;
	this.modalWidthWithoutPxKeyword2;
	this.modalHeightWithoutPxKeyword2;
	
	this.modalWidth3;
	this.modalHeight3;
	this.modalWidthWithoutPxKeyword3;
	this.modalHeightWithoutPxKeyword3;
	
	this.modalWidth4;
	this.modalHeight4;
	this.modalWidthWithoutPxKeyword4;
	this.modalHeightWithoutPxKeyword4;
	
	this.modalWidth5;
	this.modalHeight5;
	this.modalWidthWithoutPxKeyword5;
	this.modalHeightWithoutPxKeyword5;
	
	this.xmlDoc;
	this.tagIds;
	this.tagTypes;
	this.ctx;
	this.page = page;
	var pageNum = page;
	
	var canvas2;
	var response2;
	var metaData2;
	var parser2;
	this.xmlDoc2;
	this.ctx2;
	
	var canvas3;
	var response3;
	var metaData3;
	var parser3;
	this.xmlDoc3;
	this.ctx3;
	
	var canvas4;
	var response4;
	var metaData4;
	var parser4;
	this.xmlDoc4;
	this.ctx4;
	
	var canvas5;
	var response5;
	var metaData5;
	var parser5;
	this.xmlDoc5;
	this.ctx5;
	
	this.setMetadataAndImagePath = async function() {
		// checklistXX_Y.xml, checklistXX_Y.png에서 
		// XX는 점검표 아이디, Y는 점검표 수정이력번호
		
		if(this.page == 1) {
			this.metaDataPath = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '.xml';
			this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '.png';
		}
		
		else if(this.page >= 2) {
			this.metaDataPath = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 1 +'.xml';
			this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 1 + '.png';
			this.metaDataPath2 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 2 +'.xml';
			this.imagePath2 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 2 + '.png';
			this.metaDataPath3 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 3 +'.xml';
			this.imagePath3 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 3 + '.png';
			this.metaDataPath4 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 4 +'.xml';
			this.imagePath4 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 4 + '.png';
			this.metaDataPath5 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 5 +'.xml';
			this.imagePath5 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 5 + '.png';
		}
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
		
		let size = this.modalUtil.adjustModalSize(this, 1);
		this.modalWidthWithoutPxKeyword = size.width;
		this.modalHeightWithoutPxKeyword = size.height;
		
		var modalContent = document.querySelector('#checklist-update-modal .modal-content');
		modalContent.style.width = Number(this.modalWidthWithoutPxKeyword) + Number(30) + 'px';
		
		//if page length is more than 1page add additional modal setting
		if(this.page >= 2) {
			response2 = await fetch(this.metaDataPath2);
	    	metaData2 = await response2.text();
		    parser2 = new DOMParser();
			this.xmlDoc2 = parser.parseFromString(metaData2, "text/xml");
			
			this.modalWidth2 = this.xmlDoc2.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight2 = this.xmlDoc2.getElementsByTagName("height")[0].innerHTML;
		
			let size2 = this.modalUtil.adjustModalSize(this, 2);
			this.modalWidthWithoutPxKeyword2 = size2.width;
			this.modalHeightWithoutPxKeyword2 = size2.height;
			
			$('#checklist-update-footer').prepend('<button type="button" id="checklist-next-btn" class="btn btn-success" onclick="checklist_next(2);">다음페이지</button>');
			$('#checklist-update-footer').prepend('<button type="button" id="checklist-prev-btn" class="btn btn-success" style="display:none;" onclick="checklist_prev(2);">이전페이지</button>');
		}
		
		if(this.page >= 3) {
			
			response3 = await fetch(this.metaDataPath3);
	    	metaData3 = await response3.text();
		    parser3 = new DOMParser();
			this.xmlDoc3 = parser.parseFromString(metaData3, "text/xml");
			
			this.modalWidth3 = this.xmlDoc3.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight3 = this.xmlDoc3.getElementsByTagName("height")[0].innerHTML;
			
			let size3 = this.modalUtil.adjustModalSize(this, 3);
			this.modalWidthWithoutPxKeyword3 = size3.width;
			this.modalHeightWithoutPxKeyword3 = size3.height;
		}
		
		if(this.page >= 4) {
			
			response4 = await fetch(this.metaDataPath4);
	    	metaData4 = await response4.text();
		    parser4 = new DOMParser();
			this.xmlDoc4 = parser.parseFromString(metaData4, "text/xml");
			
			this.modalWidth4 = this.xmlDoc4.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight4 = this.xmlDoc4.getElementsByTagName("height")[0].innerHTML;
			
			let size4 = this.modalUtil.adjustModalSize(this, 4);
			s.modalWidthWithoutPxKeyword4 = size4.width;
			this.modalHeightWithoutPxKeyword4 = size4.height;
		}
		
		if(this.page >= 5) {
			
			response5 = await fetch(this.metaDataPath5);
	    	metaData5 = await response5.text();
		    parser5 = new DOMParser();
			this.xmlDoc5 = parser.parseFromString(metaData5, "text/xml");
			
			this.modalWidth5 = this.xmlDoc5.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight5 = this.xmlDoc5.getElementsByTagName("height")[0].innerHTML;
			
			let size5 = this.modalUtil.adjustModalSize(this, 5);
			this.modalWidthWithoutPxKeyword5 = size5.width;
			this.modalHeightWithoutPxKeyword5 = size5.height;
		}
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
			that.drawImage(bgImg, 0, 0, this.modalWidthWithoutPxKeyword, this.modalHeightWithoutPxKeyword);
		};
		
		// generate tags
		var cellList = this.xmlDoc.getElementsByTagName("cells")[0].childNodes;
		
		for(var i=0; i<cellList.length; i++) {
			var cell = cellList[i];
			this.makeTag(cell, 1);
		};
		
		if(this.page >= 2) {
			
			var canvas2 = document.getElementById('checklist-update-canvas2');
		
			canvas2.width = this.modalWidthWithoutPxKeyword2;
			canvas2.height = this.modalHeightWithoutPxKeyword2;
		
			this.ctx2 = canvas2.getContext('2d');
		
			var bgImg2 = new Image();
			bgImg2.src = this.imagePath2;
			bgImg2.onload = function() {
				that.drawImage2(bgImg2, 0, 0, this.modalWidthWithoutPxKeyword2, this.modalHeightWithoutPxKeyword2);
			};
		
			// generate tags
			var cellList2 = this.xmlDoc2.getElementsByTagName("cells")[0].childNodes;
		
			for(var i=0; i<cellList2.length; i++) {
				var cell2 = cellList2[i];
				this.makeTag(cell2, 2);
			};
			
		}
		
		if(this.page >= 3) {
			
			var canvas3 = document.getElementById('checklist-update-canvas3');
		
			canvas3.width = this.modalWidthWithoutPxKeyword3;
			canvas3.height = this.modalHeightWithoutPxKeyword3;
		
			this.ctx3 = canvas3.getContext('2d');
		
			var bgImg3 = new Image();
			bgImg3.src = this.imagePath3;
			bgImg3.onload = function() {
				that.drawImage3(bgImg3, 0, 0, this.modalWidthWithoutPxKeyword3, this.modalHeightWithoutPxKeyword3);
			};
		
			// generate tags
			var cellList3 = this.xmlDoc3.getElementsByTagName("cells")[0].childNodes;
		
			for(var i=0; i<cellList3.length; i++) {
				var cell3 = cellList3[i];
				this.makeTag(cell3, 3);
			};
		}
		
		if(this.page >= 4) {
			
			var canvas4 = document.getElementById('checklist-update-canvas4');
		
			canvas4.width = this.modalWidthWithoutPxKeyword4;
			canvas4.height = this.modalHeightWithoutPxKeyword4;
		
			this.ctx4 = canvas4.getContext('2d');
		
			var bgImg4 = new Image();
			bgImg4.src = this.imagePath4;
			bgImg4.onload = function() {
				that.drawImage4(bgImg4, 0, 0, this.modalWidthWithoutPxKeyword4, this.modalHeightWithoutPxKeyword4);
			};
		
			// generate tags
			var cellList4 = this.xmlDoc4.getElementsByTagName("cells")[0].childNodes;
		
			for(var i=0; i<cellList4.length; i++) {
				var cell4 = cellList4[i];
				this.makeTag(cell4, 4);
			};
			
		}
		
		if(this.page >= 5) {
			
			var canvas5 = document.getElementById('checklist-update-canvas5');
		
			canvas5.width = this.modalWidthWithoutPxKeyword5;
			canvas5.height = this.modalHeightWithoutPxKeyword5;
		
			this.ctx5 = canvas5.getContext('2d');
		
			var bgImg5 = new Image();
			bgImg5.src = this.imagePath5;
			bgImg5.onload = function() {
				that.drawImage5(bgImg5, 0, 0, this.modalWidthWithoutPxKeyword5, this.modalHeightWithoutPxKeyword5);
			};
		
			// generate tags
			var cellList5 = this.xmlDoc5.getElementsByTagName("cells")[0].childNodes;
		
			for(var i=0; i<cellList5.length; i++) {
				var cell5 = cellList5[i];
				this.makeTag(cell5, 5);
			};
		}
		
		// save data to db
		$('#checklist-update-btn').off().click(function() {
			
			var dataArray = new Array();
			var head = {};
			var checklistData = {};
			var checklistData2 = {};
			var checklistData3 = {};
			var checklistData4 = {};
			var checklistData5 = {};
			
			let elements = document.getElementById('checklist-update-wrapper1').getElementsByClassName('checklist-data');
			let elements2 = document.getElementById('checklist-update-wrapper2').getElementsByClassName('checklist-data');
			let elements3 = document.getElementById('checklist-update-wrapper3').getElementsByClassName('checklist-data');
			let elements4 = document.getElementById('checklist-update-wrapper4').getElementsByClassName('checklist-data');
			let elements5 = document.getElementById('checklist-update-wrapper5').getElementsByClassName('checklist-data');
	
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
					checklistData[element.id] = element.value.replace(/(\n|\r\n)/g, '<br>');
				}
			}
			dataArray.push(checklistData);
			
			if(pageNum >= 2) {
				for(var j=0; j<elements2.length; j++) {
					let element2 = elements2[j];
						if(element2.type == 'checkbox') {
							if(element2.checked == true) {
								checklistData2[element2.id] = element2.value;
							}
							else {
								checklistData2[element2.id] = '';
							}
						}
						else {
							checklistData2[element2.id] = element2.value;
						}
				}
				dataArray.push(checklistData2);	
			}
			
			if(pageNum >= 3) {
				for(var k=0; k<elements3.length; k++) {
					let element3 = elements3[k];
						if(element3.type == 'checkbox') {
							if(element3.checked == true) {
								checklistData3[element3.id] = element3.value;
							}
						else {
							checklistData3[element3.id] = '';
							}
						}
						else {
							checklistData3[element3.id] = element3.value;
							}
				}
			dataArray.push(checklistData3);	
			}
			
			if(pageNum >= 4) {
				for(var l=0; l<elements4.length; l++) {
					let element4 = elements4[l];
						if(element4.type == 'checkbox') {
							if(element4.checked == true) {
								checklistData4[element4.id] = element4.value;
							}
						else {
							checklistData4[element4.id] = '';
							}
						}
						else {
							checklistData4[element4.id] = element4.value;
							}
				}
			dataArray.push(checklistData4);	
			}
			
			if(pageNum >= 5) {
				for(var m=0; m<elements5.length; m++) {
					let element5 = elements5[m];
						if(element5.type == 'checkbox') {
							if(element5.checked == true) {
								checklistData5[element5.id] = element5.value;
							}
						else {
							checklistData5[element5.id] = '';
							}
						}
						else {
							checklistData5[element5.id] = element5.value;
							}
				}
				dataArray.push(checklistData5);	
			}
			
			head.checklistId = checklistId;
			head.revisionNo = revisionNo;
			head.seqNo = seqNo;
			//head.checklistData = checklistData;
			
			if(pageNum >= 2) {
				head.checklistData = dataArray;
			}
			else {
				head.checklistData = checklistData;
			}
			
			//console.log(checklistData);
            var check = confirm('수정하시겠습니까?');
			
			if(check) {

			$.ajax({
				type: "POST",
		        url: heneServerPath + "/checklist",
		        data: "data=" + JSON.stringify(head) +
					  "&type=update",
		        success: function (result) {
					
				var children = $('#checklist-update-wrapper1').children();
    			var children2 = $('#checklist-update-wrapper2').children();
				var children3 = $('#checklist-update-wrapper3').children();
				var children4 = $('#checklist-update-wrapper4').children();
				var children5 = $('#checklist-update-wrapper5').children();
					
    			for(let i=1; i<children.length; i++) {
    				children[i].remove();
    			}
    			
				for(let j=1; j<children2.length; j++) {
    				children2[j].remove();
    			}

				for(let k=1; k<children3.length; k++) {
    				children3[k].remove();
    			}

				for(let l=1; l<children4.length; l++) {
    				children4[l].remove();
    			}
					
				for(let m=1; m<children5.length; m++) {
    				children5[m].remove();
    			}

					$('#checklist-update-modal').modal('hide');
					 parent.refreshMainTable();
		        }
			});
			
			}
		});
	};
	
	this.drawImage = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx.drawImage(imageObject, 0, 0 , this.modalWidthWithoutPxKeyword, this.modalHeightWithoutPxKeyword);
	}
	this.drawImage2 = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx2.drawImage(imageObject, 0, 0 , this.modalWidthWithoutPxKeyword2, this.modalHeightWithoutPxKeyword2);
	}
	this.drawImage3 = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx3.drawImage(imageObject, 0, 0 , this.modalWidthWithoutPxKeyword3, this.modalHeightWithoutPxKeyword3);
	}
	this.drawImage4 = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx4.drawImage(imageObject, 0, 0 , this.modalWidthWithoutPxKeyword4, this.modalHeightWithoutPxKeyword4);
	}
	this.drawImage5 = async function(imageObject, startX, startY, imgWidth, imgHeight) {
		this.ctx5.drawImage(imageObject, 0, 0 , this.modalWidthWithoutPxKeyword5, this.modalHeightWithoutPxKeyword5);
	}
	
	this.makeTag = async function(cell, pages) {
		
		var size = this.modalUtil.setTagSize(this, cell);
		var startX = size.startX;
		var startY = size.startY;
		var width = size.width;
		var height = size.height;
		
		var id = cell.tagName;
		var type = cell.childNodes[0].firstChild.textContent;
		var format = cell.childNodes[1].firstChild.textContent;
		var default_value = cell.childNodes[2].firstChild.textContent;
		var min = cell.childNodes[3].firstChild.textContent;
		var max = cell.childNodes[4].firstChild.textContent;
		//var startX = cell.childNodes[5].firstChild.textContent;
		//var startY = cell.childNodes[6].firstChild.textContent;
		//var width = cell.childNodes[7].firstChild.textContent;
		//var height = cell.childNodes[8].firstChild.textContent;
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
		
		var data;
		//var data = this.checkData[id];
		
		if(pageNum == 1) {
		 	data = this.checkData[id];
		}
		else {
			data = this.checkData[pages - 1][id];	
		}
		if (data == null || data == '') {
				data = "";
		}
		/*
		else {
				data = this.checkData[id];
		}
		*/
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
		var opt6 = document.createElement("option");

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
		
		opt6.value = "";
		opt6.text = ""; 

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
				//console.log(data);
				//console.log(default_value);
				//console.log(default_value == null);
				//console.log(default_value == 'null');
				//console.log(format);
				if(format == 'yyyy-mm-dd') {
				   tag.setAttribute("date-format", 'yyyy-mm-dd');
                   if(default_value == 'null') {
					  
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
				   if (default_value == 'null') {
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
					
					if(pages == 1) {
						document.getElementById("checklist-update-wrapper1").appendChild(formTag);
					}
					else if(pages == 2) {
						document.getElementById("checklist-update-wrapper2").appendChild(formTag);
					}
					else if(pages == 3) {
						document.getElementById("checklist-update-wrapper3").appendChild(formTag);
					}
					else if(pages == 4) {
						document.getElementById("checklist-update-wrapper4").appendChild(formTag);
					}
					else if(pages == 5) {
						document.getElementById("checklist-update-wrapper5").appendChild(formTag);
					}
					
					tag = document.createElement('canvas');
					tag.classList.add("checklist-data");
					tag.id = id;
					tag.style.position = 'absolute';
					tag.style.left = startX;
					tag.style.top = startY;
					tag.style.width = width;
					tag.style.height = (heightNum - 30) + "px";
					tag.value = data;
					
					if(pages == 1) {
						document.getElementById("checklist-update-wrapper1").appendChild(tag);
					}
					else if(pages == 2) {
						document.getElementById("checklist-update-wrapper2").appendChild(tag);
					}
					else if(pages == 3) {
						document.getElementById("checklist-update-wrapper3").appendChild(tag);
					}
					else if(pages == 4) {
						document.getElementById("checklist-update-wrapper4").appendChild(tag);
					}
					else if(pages == 5) {
						document.getElementById("checklist-update-wrapper5").appendChild(tag);
					}
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
				tag.value = data.split('<br>').join('\r\n');
				break;
			case "select":
				tag = document.createElement('select');
				tag.classList.add("checklist-data");

				if(format == 'OX') {
					tag.add(opt1, null);
					tag.add(opt3, null);
					tag.add(opt6, null);

					if(data == '' || data == null) {
						if(default_value == 'null') {

						}
						else if(default_value == 'O') {
							tag.value = 'O';
						}
						else if(default_value == 'X') {
							tag.value = 'X';

						}
						else if(default_value == '') {
							tag.value = '';
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
					tag.add(opt6, null);

					if(data == '' || data == null) {
						if(default_value == 'null') {
						
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
						else if(default_value == '') {
						tag.value = '';
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

						if(default_value == 'null') {
						
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
			
			if(pages == 1) {
				document.getElementById("checklist-update-wrapper1").appendChild(tag);
			}
			else if(pages == 2) {
				document.getElementById("checklist-update-wrapper2").appendChild(tag);
			}
			else if(pages == 3) {
				document.getElementById("checklist-update-wrapper3").appendChild(tag);
			}
			else if(pages == 4) {
				document.getElementById("checklist-update-wrapper4").appendChild(tag);
			}
			else if(pages == 5) {
				document.getElementById("checklist-update-wrapper5").appendChild(tag);
			}
		}
		
	};
}


function ChecklistSelectModal(checklistId, seqNo, revisionNo, page) {
	this.checklistId = checklistId;
	this.seqNo = seqNo;
	this.revisionNo = revisionNo;
	
	this.checklistData;
	this.checkData;
	
	this.modalUtil = new ChecklistModalUtil();
		
	this.metaDataPath;
	this.imagePath;
	
	this.metaDataPath2;
	this.imagePath2;
	
	this.metaDataPath3;
	this.imagePath3;
	
	this.metaDataPath4;
	this.imagePath4;
	
	this.metaDataPath5;
	this.imagePath5;
	
	this.modalWidth;
	this.modalHeight;
	this.modalWidthWithoutPxKeyword;
	this.modalHeightWithoutPxKeyword;
	
	this.modalWidth2;
	this.modalHeight2;
	this.modalWidthWithoutPxKeyword2;
	this.modalHeightWithoutPxKeyword2;
	
	this.modalWidth3;
	this.modalHeight3;
	this.modalWidthWithoutPxKeyword3;
	this.modalHeightWithoutPxKeyword3;
	
	this.modalWidth4;
	this.modalHeight4;
	this.modalWidthWithoutPxKeyword4;
	this.modalHeightWithoutPxKeyword4;
	
	this.modalWidth5;
	this.modalHeight5;
	this.modalWidthWithoutPxKeyword5;
	this.modalHeightWithoutPxKeyword5;
	
	this.xmlDoc;
	this.ctx;
	this.xmlDoc2;
	this.ctx2;
	this.xmlDoc3;
	this.ctx3;
	this.xmlDoc4;
	this.ctx4;
	this.xmlDoc5;
	this.ctx5;
	
	var pageNum = page;
	var canvas2;
	var response2;
	var metaData2;
	var parser2;
	
	var canvas3;
	var response3;
	var metaData3;
	var parser3;
	
	var canvas4;
	var response4;
	var metaData4;
	var parser4;
	
	var canvas5;
	var response5;
	var metaData5;
	var parser5;
	
	this.page = page;
	var pageNum = page;
	
	this.setMetadataAndImagePath = async function() {
		// 점검표 데이터 테이블에서 cheklistId와 seqNo로 점검표정보수정이력번호를 구한 다음
		// 점검표정보 테이블에서 checklistId와 점검표정보수정이력번호로 조회해서
		// 이미지경로와 메타데이터파일경로를 구한다
		//this.metaDataPath = heneServerPath + '/checklist/'+ heneBizNo + 'metadata/' + checklistId + '_' + revisionNo + '.xml';
		//this.imagePath = '/checklist/' + heneBizNo + 'images/' + checklistId + '_' + revisionNo + '.png';
		
		if(this.page == 1) {
			this.metaDataPath = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '.xml';
			this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '.png';
			}
			
		else if(this.page >= 2) {
			this.metaDataPath = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 1 +'.xml';
			this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 1 + '.png';
			this.metaDataPath2 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 2 +'.xml';
			this.imagePath2 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 2 + '.png';
			this.metaDataPath3 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 3 +'.xml';
			this.imagePath3 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 3 + '.png';
			this.metaDataPath4 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 4 +'.xml';
			this.imagePath4 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 4 + '.png';
			this.metaDataPath5 = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + checklistId + '_' + revisionNo + '_' + 5 +'.xml';
			this.imagePath5 = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + revisionNo + '_' + 5 + '.png';
			}
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
		
		let size = this.modalUtil.adjustModalSize(this, 1);
		this.modalWidthWithoutPxKeyword = size.width;
		this.modalHeightWithoutPxKeyword = size.height;
		
		var modalContent = document.querySelector('#checklist-select-modal .modal-content');
		modalContent.style.width = Number(this.modalWidthWithoutPxKeyword) + Number(30) + 'px';
		
		//if page length is more than 2page add additional modal setting
		if(this.page >= 2) {
			response2 = await fetch(this.metaDataPath2);
	    	metaData2 = await response2.text();
		    parser2 = new DOMParser();
			this.xmlDoc2 = parser.parseFromString(metaData2, "text/xml");
			
			this.modalWidth2 = this.xmlDoc2.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight2 = this.xmlDoc2.getElementsByTagName("height")[0].innerHTML;
		
			let size2 = this.modalUtil.adjustModalSize(this, 2);
			this.modalWidthWithoutPxKeyword2 = size2.width;
			this.modalHeightWithoutPxKeyword2 = size2.height;
			
			$('#checklist-select-footer').prepend('<button type="button" id="checklist-next-btn" class="btn btn-success" onclick="checklist_next(2);">다음페이지</button>');
			$('#checklist-select-footer').prepend('<button type="button" id="checklist-prev-btn" class="btn btn-success" style="display:none;" onclick="checklist_prev(2);">이전페이지</button>');
		}
		
		if(this.page >= 3) {
			response3 = await fetch(this.metaDataPath3);
	    	metaData3 = await response3.text();
		    parser3 = new DOMParser();
			this.xmlDoc3 = parser.parseFromString(metaData3, "text/xml");
			
			this.modalWidth3 = this.xmlDoc3.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight3 = this.xmlDoc3.getElementsByTagName("height")[0].innerHTML;
		
			let size3 = this.modalUtil.adjustModalSize(this, 3);
			this.modalWidthWithoutPxKeyword3 = size3.width;
			this.modalHeightWithoutPxKeyword3 = size3.height;
		}
		
		if(this.page >= 4) {
			response4 = await fetch(this.metaDataPath4);
	    	metaData4 = await response4.text();
		    parser4 = new DOMParser();
			this.xmlDoc4 = parser.parseFromString(metaData4, "text/xml");
			
			this.modalWidth4 = this.xmlDoc4.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight4 = this.xmlDoc4.getElementsByTagName("height")[0].innerHTML;
		
			let size4 = this.modalUtil.adjustModalSize(this, 4);
			this.modalWidthWithoutPxKeyword4 = size4.width;
			this.modalHeightWithoutPxKeyword4 = size4.height;
		}
		
		if(this.page >= 5) {
			response5 = await fetch(this.metaDataPath5);
	    	metaData5 = await response5.text();
		    parser5 = new DOMParser();
			this.xmlDoc5 = parser.parseFromString(metaData5, "text/xml");
			
			this.modalWidth5 = this.xmlDoc5.getElementsByTagName("width")[0].innerHTML;
			this.modalHeight5 = this.xmlDoc5.getElementsByTagName("height")[0].innerHTML;
		
			let size5 = this.modalUtil.adjustModalSize(this, 5);
			this.modalWidthWithoutPxKeyword5 = size5.width;
			this.modalHeightWithoutPxKeyword5 = size5.height;
		}
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
			that.drawImage(bgImg, 0, 0, this.modalWidthWithoutPxKeyword, this.modalHeightWithoutPxKeyword);
			
			// display data
			var cellList = that.xmlDoc.getElementsByTagName("cells")[0].childNodes;
			
			for(var i=0; i<cellList.length; i++) {
				var cell = cellList[i];
				that.displayData(cell, 1);
			};
		};
		
		if(this.page >= 2) {
			
			var canvas2 = document.getElementById('checklist-select-canvas2');
		
			canvas2.width = this.modalWidthWithoutPxKeyword2;
			canvas2.height = this.modalHeightWithoutPxKeyword2;
		
			this.ctx2 = canvas2.getContext('2d');
		
			var bgImg2 = new Image();
			bgImg2.src = this.imagePath2;
			bgImg2.onload = function() {
				that.drawImage2(bgImg2, 0, 0, this.modalWidthWithoutPxKeyword2, this.modalHeightWithoutPxKeyword2);
				
				// display data page2 
				var cellList2 = that.xmlDoc2.getElementsByTagName("cells")[0].childNodes;
		
				for(var i=0; i<cellList2.length; i++) {
					var cell2 = cellList2[i];
					that.displayData(cell2, 2);
				};
			};
		}
		
		if(this.page >= 3) {
			
			var canvas3 = document.getElementById('checklist-select-canvas3');
		
			canvas3.width = this.modalWidthWithoutPxKeyword3;
			canvas3.height = this.modalHeightWithoutPxKeyword3;
		
			this.ctx3 = canvas3.getContext('2d');
		
			var bgImg3 = new Image();
			bgImg3.src = this.imagePath3;
			bgImg3.onload = function() {
				that.drawImage3(bgImg3, 0, 0, this.modalWidthWithoutPxKeyword3, this.modalHeightWithoutPxKeyword3);
				
				// display data page3 
				var cellList3 = that.xmlDoc3.getElementsByTagName("cells")[0].childNodes;
		
				for(var i=0; i<cellList3.length; i++) {
					var cell3 = cellList3[i];
					that.displayData(cell3, 3);
				};
			};
		}
		
		if(this.page >= 4) {
			
			var canvas4 = document.getElementById('checklist-select-canvas4');
		
			canvas4.width = this.modalWidthWithoutPxKeyword4;
			canvas4.height = this.modalHeightWithoutPxKeyword4;
		
			this.ctx4 = canvas4.getContext('2d');
		
			var bgImg4 = new Image();
			bgImg4.src = this.imagePath4;
			bgImg4.onload = function() {
				that.drawImage4(bgImg4, 0, 0, this.modalWidthWithoutPxKeyword4, this.modalHeightWithoutPxKeyword4);
				
				// display data page4
				var cellList4 = that.xmlDoc4.getElementsByTagName("cells")[0].childNodes;
		
				for(var i=0; i<cellList4.length; i++) {
					var cell4 = cellList4[i];
					that.displayData(cell4, 4);
				};
			};
		}
			
		if(this.page >= 5) {
			
			var canvas5 = document.getElementById('checklist-select-canvas5');
		
			canvas5.width = this.modalWidthWithoutPxKeyword5;
			canvas5.height = this.modalHeightWithoutPxKeyword5;
		
			this.ctx5 = canvas5.getContext('2d');
		
			var bgImg5 = new Image();
			bgImg5.src = this.imagePath5;
			bgImg5.onload = function() {
				that.drawImage5(bgImg5, 0, 0, this.modalWidthWithoutPxKeyword5, this.modalHeightWithoutPxKeyword5);
				
				// display data page5
				var cellList5 = that.xmlDoc5.getElementsByTagName("cells")[0].childNodes;
		
				for(var i=0; i<cellList5.length; i++) {
					var cell5 = cellList5[i];
					that.displayData(cell5, 5);
				};
			};
		}
		
		// 점검표 출력
		$('#checklist-print-btn').click(function() {
			var dataUrl = document.getElementById("checklist-select-canvas").toDataURL();
    		var windowContent = '<!DOCTYPE html>';
   	 		windowContent += '<html>';
    		windowContent += '<head><title>점검표 출력</title></head>';
    		windowContent += '<body style="zoom:93%">';
   		 	windowContent += '<img src="' + dataUrl + '">';
			
			if(pageNum >= 2) {
				var dataUrl2 = document.getElementById("checklist-select-canvas2").toDataURL();
				windowContent += '<img src="' + dataUrl2 + '">';
			}
			if(pageNum >= 3) {
				var dataUrl3 = document.getElementById("checklist-select-canvas3").toDataURL();
				windowContent += '<img src="' + dataUrl3 + '">';
			}
			if(pageNum >= 4) {
				var dataUrl4 = document.getElementById("checklist-select-canvas4").toDataURL();
				windowContent += '<img src="' + dataUrl4 + '">';
			}
			if(pageNum >= 5) {
				var dataUrl5 = document.getElementById("checklist-select-canvas5").toDataURL();
				windowContent += '<img src="' + dataUrl5 + '">';
			}
			
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
		this.ctx.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword, this.modalHeightWithoutPxKeyword);
	}
	
	this.drawImage2 = function(imageObject) {
		this.ctx2.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword2, this.modalHeightWithoutPxKeyword2);
	}
	
	this.drawImage3 = function(imageObject) {
		this.ctx3.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword3, this.modalHeightWithoutPxKeyword3);
	}
	
	this.drawImage4 = function(imageObject) {
		this.ctx4.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword4, this.modalHeightWithoutPxKeyword4);
	}
	
	this.drawImage5 = function(imageObject) {
		this.ctx5.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword5, this.modalHeightWithoutPxKeyword5);
	}
	
	this.displayData = function(cell, pages) {
		var size = this.modalUtil.setTagSize(this, cell);
		var startX = size.startX;
		var startY = size.startY;
		var width = size.width;
		var height = size.height;
		
		var id = cell.nodeName;
		var type = cell.childNodes[0].textContent;
		var format = cell.childNodes[1].textContent;
		
		var data;
		
		if(this.page == 1) {
		 	data = this.checkData[id];
		}
		else {
			data = this.checkData[pages - 1][id];	
		}
			
		if (data == null || data == '') {
			data = "";
		}
		/*
		else {
				data = this.checkData[id];
		}
		*/
		var signWriter = this.checklistSignData.signWriter;
		var signChecker = this.checklistSignData.signChecker;
		var signApprover = this.checklistSignData.signApprover;
		
		var startXWrite = parseInt(startX) + 10;
		var startYWrite = parseInt(startY) + 16;

		var middleX = Number(startX.replace("px", "")) + (Number(width.replace("px", "")) / 2);
		var middleY = Number(startY.replace("px", "")) + (Number(height.replace("px", "")) / 2);
		
		this.ctx.textAlign = "center";
		this.ctx.font = '15px sans-serif';
		
		if(pages >= 2) {
			this.ctx2.textAlign = "center";
			this.ctx2.font = '15px sans-serif';
		}
		if(pages >= 3) {
			this.ctx3.textAlign = "center";
			this.ctx3.font = '15px sans-serif';
		}
		if(pages >= 4) {
			this.ctx4.textAlign = "center";
			this.ctx4.font = '15px sans-serif';
		}
		if(pages >= 5) {
			this.ctx5.textAlign = "center";
			this.ctx5.font = '15px sans-serif';
		}
		
		switch(type) {
			case "signature-writer":
				if(signWriter != null) {
					if(pages == 1) {
					this.ctx.fillText(signWriter, middleX, middleY);
					}
					else if(pages == 2){
					this.ctx2.fillText(signWriter, middleX, middleY);	
					}
					else if(pages == 3){
					this.ctx3.fillText(signWriter, middleX, middleY);	
					}
					else if(pages == 4){
					this.ctx4.fillText(signWriter, middleX, middleY);	
					}
					else if(pages == 5){
					this.ctx5.fillText(signWriter, middleX, middleY);	
					}
				}
				break;
			case "signature-approver":
				if(signApprover != null) {
					if(pages == 1) {
					this.ctx.fillText(signApprover, middleX, middleY);
					}
					else if(pages == 2){
					this.ctx2.fillText(signApprover, middleX, middleY);	
					}
					else if(pages == 3){
					this.ctx3.fillText(signApprover, middleX, middleY);	
					}
					else if(pages == 4){
					this.ctx4.fillText(signApprover, middleX, middleY);	
					}
					else if(pages == 5){
					this.ctx5.fillText(signApprover, middleX, middleY);	
					}
				}
				break;
			case "signature-checker":
				if(signChecker != null) {
					if(pages == 1) {
					this.ctx.fillText(signChecker, middleX, middleY);
					}
					else if(pages == 2){
					this.ctx2.fillText(signChecker, middleX, middleY);	
					}
					else if(pages == 3){
					this.ctx3.fillText(signChecker, middleX, middleY);	
					}
					else if(pages == 4){
					this.ctx4.fillText(signChecker, middleX, middleY);	
					}
					else if(pages == 5){
					this.ctx5.fillText(signChecker, middleX, middleY);	
					}
				}
				break;
			case "radio button":
				if(data === 'on') {
					if(pages == 1) {
					this.ctx.fillText("✔", middleX, middleY);
					this.ctx.font = '20px sans-serif';
					}
					else if(pages == 2){
					this.ctx2.fillText("✔", middleX, middleY);
					this.ctx2.font = '20px sans-serif';	
					}
					else if(pages == 3){
					this.ctx3.fillText("✔", middleX, middleY);
					this.ctx3.font = '20px sans-serif';	
					}
					else if(pages == 4){
					this.ctx4.fillText("✔", middleX, middleY);
					this.ctx4.font = '20px sans-serif';	
					}
					else if(pages == 5){
					this.ctx5.fillText("✔", middleX, middleY);
					this.ctx5.font = '20px sans-serif';	
					}
				}
				break;
			case "checkbox":
				if(data === 'on') {
					if(pages == 1) {
					this.ctx.fillText("✔", middleX, middleY);
					this.ctx.font = '20px sans-serif';
					}
					else if(pages == 2){
					this.ctx2.fillText("✔", middleX, middleY);
					this.ctx2.font = '20px sans-serif';
					}
					else if(pages == 3){
					this.ctx3.fillText("✔", middleX, middleY);
					this.ctx3.font = '20px sans-serif';
					}
					else if(pages == 4){
					this.ctx4.fillText("✔", middleX, middleY);
					this.ctx4.font = '20px sans-serif';
					}
					else if(pages == 5){
					this.ctx5.fillText("✔", middleX, middleY);
					this.ctx5.font = '20px sans-serif';
					}
					
				}
				break;
			case "textarea":
				if(pages == 1) {
				 this.ctx.textAlign = "left";
				 wrapText(this.ctx, data.split('<br>').join('\r\n'), startXWrite, startYWrite, width, 20);
				}
				else if(pages == 2){
				 this.ctx2.textAlign = "left";
				 wrapText(this.ctx2, data.split('<br>').join('\r\n'), startXWrite, startYWrite, width, 20);
				}
				else if(pages == 3){
				 this.ctx3.textAlign = "left";
				 wrapText(this.ctx3, data.split('<br>').join('\r\n'), startXWrite, startYWrite, width, 20);
				}
				else if(pages == 4){
				 this.ctx4.textAlign = "left";
				 wrapText(this.ctx4, data.split('<br>').join('\r\n'), startXWrite, startYWrite, width, 20);
				}
				else if(pages == 5){
				 this.ctx5.textAlign = "left";
				 wrapText(this.ctx5, data.split('<br>').join('\r\n'), startXWrite, startYWrite, width, 20);
				}
				 //this.ctx.fillText(data, startXWrite, startYWrite);
				break;
			case "file":
				if(format == 'image') {
					if(pages == 1) {
						//console.log("image act");
					fn_Set_Image_File_View2(data, 'checklist-select-canvas', startX, startY, width, height);
					}
					else if(pages == 2) {
						fn_Set_Image_File_View2(data, 'checklist-select-canvas2', startX, startY, width, height);	
					}
					else if(pages == 3) {
						fn_Set_Image_File_View2(data, 'checklist-select-canvas3', startX, startY, width, height);	
					}
					else if(pages == 4) {
						fn_Set_Image_File_View2(data, 'checklist-select-canvas4', startX, startY, width, height);	
					}
					else if(pages == 5) {
						fn_Set_Image_File_View2(data, 'checklist-select-canvas5', startX, startY, width, height);	
					}
				}
				else {
					 //this.ctx.fillText(data, startX, startY);
				}
				break;
			case "date":
				if(pages == 1) {
					this.ctx.fillText(data, middleX, middleY);
				}
				else if(pages == 2) {
					this.ctx2.fillText(data, middleX, middleY);	
				}
				else if(pages == 3) {
					this.ctx3.fillText(data, middleX, middleY);	
				}
				else if(pages == 4) {
					this.ctx4.fillText(data, middleX, middleY);	
				}
				else if(pages == 5) {
					this.ctx5.fillText(data, middleX, middleY);	
				}
				break;	
			default : 
				//this.ctx.fillText(data, startXWrite, startYWrite);
				//console.log(middleX);
				//console.log(middleY);
				if(pages == 1) {
					this.ctx.fillText(data, middleX, middleY);
				}
				else if(pages == 2) {
					this.ctx2.fillText(data, middleX, middleY);	
				}
				else if(pages == 3) {
					this.ctx3.fillText(data, middleX, middleY);	
				}
				else if(pages == 4) {
					this.ctx4.fillText(data, middleX, middleY);	
				}
				else if(pages == 5) {
					this.ctx5.fillText(data, middleX, middleY);	
				}
				break;
		}
	};
}


function ChecklistSelectModalCCP(createDate, 
								 formClassificationCriteria, 
								 sensorId, 
								 productId) {
	this.createDate = createDate;
	this.formClassificationCriteria = formClassificationCriteria;
	this.sensorId = sensorId;
	this.productId = productId;
	
	this.checklistId;
	this.seqNo = 0;
	this.revisionNo = '0';
	
	this.checklistData;
	this.checkData;
	
	this.modalUtil = new ChecklistModalUtil();
	
	this.metaDataPath;
	this.imagePath;
	
	this.modalWidth;
	this.modalHeight;
	this.modalWidthWithoutPxKeyword;
	this.modalHeightWithoutPxKeyword;
	
	this.xmlDoc;
	
	this.ctx;
	this.jsonParameterNm;
	this.jsonFileData;
	
	var jsonData;
	var processCd = "";
	var infoList;
	
	this.setChecklistId = async function() {
		console.debug('setChecklistId():')
		console.debug('product id:' + this.productId);
		console.debug('sensor id:' + this.sensorId);
		var clInfo = new ChecklistInfo();
    	infoList = await clInfo.getChecklistId(this.formClassificationCriteria, this.productId, this.sensorId);
		this.checklistId = infoList.checklistId;
	}
	
	this.setMetadataAndImagePath = async function() {
		// 점검표 데이터 테이블에서 cheklistId와 seqNo로 점검표정보수정이력번호를 구한 다음
		// 점검표정보 테이블에서 checklistId와 점검표정보수정이력번호로 조회해서
		// 이미지경로와 메타데이터파일경로를 구한다
		this.metaDataPath = heneServerPath + '/checklist/'+ heneBizNo + '/metadata/' + this.checklistId + '_' + this.revisionNo + '.xml';
		this.imagePath = '/checklist/' + heneBizNo + '/images/' + this.checklistId + '_' + this.revisionNo + '.png';
	}
	
	this.getChecklistData = async function() {
		
		if(this.sensorId.includes('CD')) {
			processCd = "PC10";
		}
		//heating machine
		else if(this.sensorId.includes('HM')) {
			processCd = "PC30";
		}
		//cream machine
		else if(this.sensorId.includes('CR')) {
			processCd = "PC80";
		}
		
		console.debug('getChecklistData()');
		console.debug(this.sensorId);
		console.debug(processCd);
		
		let fetchedData = $.ajax({
			type: "GET",
	        url: heneServerPath + "/ccptestvm"
	            	+ "?method=" + 'detail'
	            	+ "&date=" + this.createDate
	            	+ "&processCode=" + processCd
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
		
		if(
		   (Number(this.modalWidth.replace('px', '')) < 1000 && Number(this.modalWidth.replace('px', '')) >= 800 )|| 
		   (Number(this.modalHeight.replace('px', '')) < 1000 && Number(this.modalWidth.replace('px', '')) >= 800 )
		  )
		{
			this.modalWidthWithoutPxKeyword = Number(this.modalWidth.replace('px', '')) * 1.3;
			this.modalHeightWithoutPxKeyword = Number(this.modalHeight.replace('px', '')) * 1.3;
		} 
		else if(Number(this.modalWidth.replace('px', '')) < 800 || Number(this.modalHeight.replace('px', '')) < 800) {
			this.modalWidthWithoutPxKeyword = Number(this.modalWidth.replace('px', '')) * 1.8;
			this.modalHeightWithoutPxKeyword = Number(this.modalHeight.replace('px', '')) * 1.8;
		}
		else {
			this.modalWidthWithoutPxKeyword = this.modalWidth.replace('px', '');
			this.modalHeightWithoutPxKeyword = this.modalHeight.replace('px', '');
		}
		
		this.modalWidthWithoutPxKeyword = this.modalWidth.replace('px', '');
		this.modalHeightWithoutPxKeyword = this.modalHeight.replace('px', '');
		
		var modalContent = document.querySelector('#checklist-select-modal .modal-content');
		modalContent.style.width = Number(this.modalWidthWithoutPxKeyword) + Number(30) + 'px';
	};
	
	this.openModal = async function() {
		let that = this;
	
		await this.setChecklistId();
		await this.setMetadataAndImagePath();
		await this.setModal();
		this.checklistData = await this.getChecklistData();
		this.checklistSignData = await this.getChecklistSignData();
		
		this.getJsonData = function() {
			/*
			//metal detector
			if(this.sensorId.includes('CD')) {
				this.jsonParameterNm = "metaldetector";
			}
			//heating machine
			else if(this.sensorId.includes('HM')) {
				this.jsonParameterNm = "heating";
			}
			//cream machine
			else if(this.sensorId.includes('CR')) {
				this.jsonParameterNm = "cream";
			}
			else {
				console.error('no info for this sensor id in ccpChecklistDataConfig file');
			}
			*/
			this.jsonParameterNm = this.checklistId;
			
			readJsonFile(heneServerPath + "/checklist/"+ heneBizNo + "/metadata/ccpChecklistDataConfig.json" , function(text){
	    		this.jsonFileData = JSON.parse(text);
				jsonData = this.jsonFileData;
				
				return jsonData;
			});
		}
		
		this.getJsonData();
		console.log(this.jsonParameterNm);
		console.log(jsonData);
		let info = {
			"rowStartCell" : jsonData[this.jsonParameterNm].rowStartCell,
			"writerSignCell" : jsonData[this.jsonParameterNm].writerSignCell,
			"approverSignCell" : jsonData[this.jsonParameterNm].approverSignCell,
			"dateCell" : jsonData[this.jsonParameterNm].dateCell,
			"normalSumValueWhenAddAllTestResult" : jsonData[this.jsonParameterNm].normalSumValueWhenAddAllTestResult, 
			"rowOrder" : jsonData[this.jsonParameterNm].rowOrder
		}
		
		let outer = new Array();
		let row = new Object();
		let sensorKey;
		
		for(let i=0; i<this.checklistData.length; i++) {
			if(sensorKey == this.checklistData[i].sensorKey) {
				if(!row.detail) {
					row.detail = new Object();
				}
				row.detail[this.checklistData[i].eventCode] = this.checklistData[i].sensorValue;
				row.detail[this.checklistData[i].eventCode + "_" + "minValue"] = this.checklistData[i].minValue;
				row.detail[this.checklistData[i].eventCode + "_" + "maxValue"] = this.checklistData[i].maxValue;
			} else {
				row = new Object();
				row.prod = this.checklistData[i].productName;
				row.time = this.checklistData[i].createTime;
				row.detail = new Object();
				row.detail[this.checklistData[i].eventCode] = this.checklistData[i].sensorValue;
				row.detail[this.checklistData[i].eventCode + "_" + "minValue"] = this.checklistData[i].minValue;
				row.detail[this.checklistData[i].eventCode + "_" + "maxValue"] = this.checklistData[i].maxValue;
				outer.push(row);
				sensorKey = this.checklistData[i].sensorKey;
				
			}
		}
		
		console.debug('this.checklistData');
		console.debug(this.checklistData);
		
		$("#checklist-select-modal").modal("show");
		
		// read checklist image
		var canvas = document.getElementById('checklist-select-canvas');
		
		canvas.width = this.modalWidthWithoutPxKeyword;
		canvas.height = this.modalHeightWithoutPxKeyword;
		
		this.ctx = canvas.getContext('2d');
		
		var bgImg = new Image();
		bgImg.src = this.imagePath;
		bgImg.onload = async function() {
			that.drawImage(bgImg, 0, 0, this.modalWidthWithoutPxKeyword, this.modalHeightWithoutPxKeyword);
			
			// display data
			var cellList = that.xmlDoc.getElementsByTagName("cells")[0].childNodes;
			
			// draw date
			that.displayData(cellList[info.dateCell], that.createDate);
			
			// draw signature
			var ccpSign = new CCPSign();
			var signInfo = await ccpSign.get(that.createDate, processCd);
			
			//CCP 데이터 관리에서 서명된 정보로 표시되도록 일괄 적용
			that.displayData(cellList[info.writerSignCell], signInfo.checkerName);
			that.displayData(cellList[info.approverSignCell], signInfo.checkerName);
			
			var currentRow = 0;
			var startFlag = false;
			var cellPos = 0;
			var rightCount = 0;
			for(let i=0; i<cellList.length; i++) {
				if(cellList[i].nodeName == info.rowStartCell) {
					startFlag = true;
					cellPos = i;
				}
				
				if(!startFlag) {
					continue;
				} else {
					var row = outer[currentRow];
					if(!row) {
						continue;
					}
					
					for(let j=0; j<info.rowOrder.length; j++) {
						var item = info.rowOrder[j];
						console.debug("item: " + item);
						console.debug("cell pos: ");
						console.debug(cellList[cellPos]);
						
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
							case "MC41":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC41"]);
								break;
							case "MC42":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC42"]);
								break;
							case "MC50":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC50"]);
								break;
							case "MC51":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC51"]);
								break;
							case "MC52":
								var cell = cellList[cellPos];
								that.displayData(cell, row.detail["MC52"]);
								break;
							//start temperature
							case "HT10":
								var cell = cellList[cellPos];
								var temp; 
								
								if(row.detail["HT10"] != null) {
									temp = row.detail["HT10"] + "°C";
								}
								else {
									temp = "";
								}
								if(Number(row.detail["HT10"]) >= Number(row.detail["HT10_minValue"]) && Number(row.detail["HT10"]) <= Number(row.detail["HT10_maxValue"])) {
									rightCount += 1;
								}
								that.displayData(cell, temp);
								break;
							case "HT15":
								var cell = cellList[cellPos];
								var temp; 
								
								if(row.detail["HT15"] != null) {
									temp = row.detail["HT15"] + "°C";
								}
								else {
									temp = "";
								}
								if(Number(row.detail["HT15"]) >= Number(row.detail["HT15_minValue"]) && Number(row.detail["HT15"]) <= Number(row.detail["HT15_maxValue"])) {
									rightCount += 1;
								}
								that.displayData(cell, temp);
								break;
							case "HT20":
								var cell = cellList[cellPos];
								if(row.detail["HT20"] >= row.detail["HT20_minValue"] && row.detail["HT20"] <= row.detail["HT20_maxValue"]) {
									rightCount += 1;
								}
								that.displayData(cell, row.detail["HT20"]);
								break;
							//start time
							case "HT30":
								var cell = cellList[cellPos];
								var time;
								if(row.detail["HT30"] != null) {
									time = row.detail["HT30"].toString().substring(0, 5);
								}
								else {
									time = "";
								}
								
								if(row.detail["HT30"] >= row.detail["HT30_minValue"] && row.detail["HT30"] <= row.detail["HT30_maxValue"]) {
									rightCount += 1;
								}
								
								that.displayData(cell, time);
								break;
							//end time
							case "HT40":
								var cell = cellList[cellPos];
								var time;
								
								if(row.detail["HT40"] != null) {
									time = row.detail["HT40"].toString().substring(0, 5);
								}
								else {
									time = "";
								}
								
								if(row.detail["HT40"] >= row.detail["HT40_minValue"] && row.detail["HT40"] <= row.detail["HT40_maxValue"]) {
									rightCount += 1;
								}
								
								that.displayData(cell, time);
								break;
							case "HT50":
								var cell = cellList[cellPos];
								var temp;
								
								if(row.detail["HT50"] != null) {
									temp = row.detail["HT50"] + "°C";
								}
								else {
									temp = "";
								}
								if(Number(row.detail["HT50"]) >= Number(row.detail["HT50_minValue"]) && Number(row.detail["HT50"]) <= Number(row.detail["HT50_maxValue"])) {
									rightCount += 1;
								}
								that.displayData(cell, temp);
								break;
							case "HT55":
								var cell = cellList[cellPos];
								var temp;
								
								if(row.detail["HT55"] != null) {
									temp = row.detail["HT55"] + "°C";
								}
								else {
									temp = "";
								}
								if(Number(row.detail["HT55"]) >= Number(row.detail["HT55_minValue"]) && Number(row.detail["HT55"]) <= Number(row.detail["HT55_maxValue"])) {
									rightCount += 1;
								}
								that.displayData(cell, temp);
								break;
							//end temperature
							//during time
							case "HT60":
								var cell = cellList[cellPos];
								var time;
								if(row.detail["HT60"] != null) {
									
									if(row.detail["HT60"].length == 7) {
										time = row.detail["HT60"].toString().substring(0, 1) + "시 " + row.detail["HT60"].toString().substring(2, 4) + "분 " + row.detail["HT60"].toString().substring(5, 7) +"초";
									}
									else {
										time = row.detail["HT60"].toString().substring(0, 2) + "시 " + row.detail["HT60"].toString().substring(3, 5) + "분 " + row.detail["HT60"].toString().substring(6, 8) +"초";
									}
									
								}
								else {
									time = "";
								}
								if(row.detail["HT60"] >= row.detail["HT60_minValue"] && row.detail["HT60"] <= row.detail["HT60_maxValue"]) {
									rightCount += 1;
								}
								that.displayData(cell, time);
								break;
							//product temperture
							case "HT70":
								var cell = cellList[cellPos];
								var temp;
								
								if(row.detail["HT70"] != null) {
									temp = row.detail["HT70"] + "°C";
								}
								else {
									temp = "";
								}
								if(Number(row.detail["HT70"]) >= Number(row.detail["HT70_minValue"]) && Number(row.detail["HT70"]) <= Number(row.detail["HT70_maxValue"])) {
									rightCount += 1;
								}
								that.displayData(cell, temp);
								break;
							case "CR10":
								var cell = cellList[cellPos];
								var temp = "";
								
								if(row.detail["CR10"] != null) {
									temp = row.detail["CR10"] + "°C";
								}

								that.displayData(cell, temp);
								break;
							case "CR20":
								var cell = cellList[cellPos];
								var temp = "";
								
								if(row.detail["CR20"] != null) {
									temp = row.detail["CR20"] + "°C";
								}

								that.displayData(cell, temp);
								break;
							case "CR30":
								var cell = cellList[cellPos];
								var time = "";
								
								if(row.detail["CR30"] != null) {
									time = row.detail["CR30"].toString().substring(0, 5);
								}

								that.displayData(cell, time);
								break;
							case "CR40":
								var cell = cellList[cellPos];
								var time = "";
								
								if(row.detail["CR40"] != null) {
									time = row.detail["CR40"].toString().substring(0, 5);
								}

								that.displayData(cell, time);
								break;
							case "CR50":
								var cell = cellList[cellPos];
								var temp = "";
								
								if(row.detail["CR50"] != null) {
									temp = row.detail["CR50"] + "°C";
								}

								that.displayData(cell, temp);
								break;
							case "sign":
								var cell = cellList[cellPos];
								that.displayData(cell, signInfo.checkerName);
								break;
							case "judge":
								var cell = cellList[cellPos];
								
								if(processCd.toString().includes("PC30")) {
									if(rightCount == info.normalSumValueWhenAddAllTestResult) {
										that.displayData(cell, "적합");
									}
									else {
										that.displayData(cell, "부적합");
									}
								}
								else {
									if(that.judgeResult(row.detail, info)) {
										that.displayData(cell, "적합");
									} else {
										that.displayData(cell, "부적합");
									}
								}
								
						}
						
						cellPos += 1;
					}
					
					currentRow += 1;
					i += info.rowOrder.length;
					rightCount = 0;
				}
			}
		};
		
		// 점검표 출력
		$('#checklist-print-btn').off().click(function() {
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
		this.ctx.drawImage(imageObject, 0, 0, this.modalWidthWithoutPxKeyword, this.modalHeightWithoutPxKeyword);
	}
	
	this.judgeResult = function(testResults, info) {
		let outerObj = this.getInfoPerEventCode(testResults);
		
		let keys = Object.keys(outerObj);
		for(let i=0; i<keys.length; i++) {
			let event = outerObj[keys[i]];
			if(event.val > event.max || event.val < event.min) {
				return false;
			}
		}
		
		return true;
	}
	
	this.getInfoPerEventCode = function(testResults) {
		console.debug('test result:');
		console.debug(testResults);
		
		let outerObj = {};
		
		let keys = Object.keys(testResults);
		for(let i=0; i<keys.length; i++) {
			let splitedKey = keys[i].split('_');
			let testType = splitedKey[0];
			let newKey;
			let newValue;
			
			if(splitedKey.length === 2) {
				let info = splitedKey[1];
				
				if(info == 'minValue') {
					newKey = 'min';
					newValue = testResults[keys[i]];
				} else if(info == 'maxValue') {
					newKey = 'max';
					newValue = testResults[keys[i]];
				}
			}
			else {
				newKey = 'val';
				newValue = testResults[keys[i]];
			}
			
			if(outerObj[testType]) {
				outerObj[testType][newKey] = newValue;
			} else {
				outerObj[testType] = {};
				outerObj[testType][newKey] = newValue;
			}
		}
		
		console.debug('Get info per event code:');
		console.debug(outerObj);
		
		return outerObj;
	}
	
	this.displayData = function(cell, data) {
		console.debug('displayData data:' + data);
		
		var size = this.modalUtil.setTagSize(this, cell);
		var startX = size.startX;
		var startY = size.startY;
		var width = size.width;
		var height = size.height;
		
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
		this.ctx.font = '10px sans-serif';
		
		if(data == 1 || parseFloat(data) == 1.1) {
			data = 'O';
		}
		else if(data === 0 || data === '0') {
			data = 'X';
		}
		else if(!data) {
			data = '';
		}
		
		this.ctx.fillText(data, middleX, middleY);
	};
}

function readJsonFile(file, callback) {
	var rawFile = new XMLHttpRequest();
	rawFile.overrideMimeType("application/json");
	rawFile.open("GET", file, false);
	rawFile.onreadystatechange = function() {
		if (rawFile.readyState === 4 && rawFile.status == "200") {
    		callback(rawFile.responseText);
		}
	}
	rawFile.send(null);
}