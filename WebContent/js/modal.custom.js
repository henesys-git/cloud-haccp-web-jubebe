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
			var head = {};
			var checklistData = {};
	
			let elements = document.getElementsByClassName('checklist-data');
	
			for(var i=0; i<elements.length; i++) {
				let element = elements[i];
				checklistData[element.id] = element.value;
			}
			
			head.checklistId = checklistId;
			head.revisionNo = seqNo;
			head.checklistData = checklistData;
			
			$.ajax({
				type: "POST",
		        url: heneServerPath + "/checklist",
		        data: "data=" + JSON.stringify(head),
		        success: function (result) {
		        	console.log(result);
					$('#checklist-insert-modal').modal('hide');
					 refreshMainTable();
		        }
			});
		});
	};
	
	this.drawImage = function(imageObject) {
		this.ctx.drawImage(imageObject, 0, 0);
	}
	
	this.makeTag = function(cell) {
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
		
		switch(type) {
			case "signature-writer":
				tag = document.createElement('button');
				tag.classList.add('signature-writer');
				tag.innerHTML = "서명";
				break;
			case "signature-approver":
				tag = document.createElement('button');
				tag.classList.add('signature-approver');
				tag.innerHTML = "서명";
				break;
			case "signature-checker":
				tag = document.createElement('button');
				tag.classList.add('signature-checker');
				tag.innerHTML = "서명";
				break;
			case "date":
				tag = document.createElement('input');
				tag.classList.add("checklist-data");
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
		
		if(this.tagTypes == 'date') {
			new SetSingleDate2("", this.tagIds, 0);
		}
	};
}

function ChecklistSelectModal(checklistId, seqNo) {
	this.checklistId = checklistId;
	this.seqNo = seqNo;
	
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
		this.metaDataPath = heneServerPath + '/checklist/' + heneBizNo + '/metadata/' + checklistId + '_' + seqNo + '.txt';
		this.imagePath = '/checklist/' + heneBizNo + '/images/' + checklistId + '_' + seqNo + '.jpg';
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
		
		var middleX = Number(startX) + (width / 2);
		var middleY = Number(startY) + (height / 2);
		
		this.ctx.textAlign = "center";
		this.ctx.font = '10px serif';
		this.ctx.fillText(data, middleX, middleY);
	};
}