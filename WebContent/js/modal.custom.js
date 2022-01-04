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