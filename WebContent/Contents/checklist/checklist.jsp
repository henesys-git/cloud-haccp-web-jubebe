<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String login_name = session.getAttribute("login_name").toString();
	String bizNo = session.getAttribute("bizNo").toString();
	
	String checklistNum = "", menuName = "";
	
	if(request.getParameter("checklistNum") != null) 
		checklistNum = request.getParameter("checklistNum");
	
	if(request.getParameter("MenuTitle") != null) 
		menuName = request.getParameter("MenuTitle");
%>
<style>
	input[type="date"]::-webkit-inner-spin-button,
	input[type="date"]::-webkit-calendar-picker-indicator {
   	color: rgba(0, 0, 0, 0);
}

input::-webkit-outer-spin-button,
	input::-webkit-inner-spin-button {
  	-webkit-appearance: none;
}

table#ccpDataTable.dataTable tbody tr:hover {
	background-color: #be7352;
}
 
table#ccpDataTable.dataTable tbody tr:hover > .sorting_1 {
	background-color: #be7352;
}

</style>
<script type="text/javascript">
    
    var mainTable;
    var checklistPage = 1;
    var modalPageCnt;
    
	$(document).ready(function () {
		//let mainTable;
		 var selected = [];
		 var clInfo;
		 var clList;
		
		async function getData() {
	        var fetchedList = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/checklist"
				            	+ "?checklistId=" + 'checklist' + '<%=checklistNum%>'
				            	+ "&seqNo=all",
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedList;
	    };
	    
	    //checklist_sign 테이블에서 해당 점검표의 사인 정보 조회
	    async function getSignColumnData() {
	        var fetchedList = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/checklist"
				            	+ "?checklistId=" + 'checklist' + '<%=checklistNum%>'
				            	+ "&seqNo=signColumn",
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedList;
	    };
	    
	    async function initTable() {
	    	var list = await getData();
	    	var list2 = await getSignColumnData();
	    	
	    	clInfo = new ChecklistInfo();
	    	clList = await clInfo.getById('checklist' + '<%=checklistNum%>');
	    	console.log(clInfo);
	    	modalPageCnt = clList.pageCnt;
	    	
	    	//서명 칼럼 index 들어갈 배열
	    	var columnDefsKeys = new Array();
	    	
	    	//html 고정th명(점검표아이디, 일련번호, 양식수정이력번호, 작성일자)
	    	var fixedTh = new Array();
	    	fixedTh[0] = "점검표아이디";
			fixedTh[1] = "일련번호";
			fixedTh[2] = "양식수정이력번호";
			fixedTh[3] = "작성일자";
			
			//db로부터 받아온 칼럼명
			var fixedColumn = new Array();
			fixedColumn[0] = "checklistId";
			fixedColumn[1] = "seqNo";
			fixedColumn[2] = "revisionNo";
			fixedColumn[3] = "writeDate";
	    	
			// 하단 datatable 고정영역 columns 변수 array로 만들기  (점검표아이디, 일련번호, 양식수정이력번호, 작성일자) 
			var columnKeys = [ 
   				{data:fixedColumn[0] , defaultContent : ''}, 
   			  	{data:fixedColumn[1] , defaultContent : ''}, 
   			  	{data:fixedColumn[2] , defaultContent : ''},
   			 	{data:fixedColumn[3] , defaultContent : ''}
   			];
			
			// 고정영역 html th 태그 만들기(점검표아이디, 일련번호, 양식수정이력번호, 작성일자)
	    	for(var a = 0; a < 4; a++) {
	    		if(a%2 == 0) {
					$("#ccpDataTable thead tr").append("<th style='display:none; width:0px'>"+fixedTh[a]+"</th>");
	    		}
	    		else {
	    			$("#ccpDataTable thead tr").append("<th>"+fixedTh[a]+"</th>");
	    		}
	    	}
	    	
			//점검표의 사인정보를 조회해온 데이터를 판단하여 동적으로 
			//columnKeys 배열에 push하여 칼럼을 늘리고 html th 태그를 생성한다.
	    	for(var i = 0; i<list2.length; i++) {
	    		var column = new Object();
	    		var columnDef = new Object();
	    		if(list2[i].signatureType == "WRITE") {
	    			column.data = "signWriter";
	    			column.defaultContent = "";
	    			columnKeys.push(column);
	    			$("#ccpDataTable thead tr").append("<th>작성자서명</th>");
	    			columnDefsKeys[i] = (i+4);
	    			
	    		}
	    		else if(list2[i].signatureType == "CHECK") {
	    			column.data = "signChecker";
	    			column.defaultContent = "";
	    			columnKeys.push(column);
	    			$("#ccpDataTable thead tr").append("<th>확인자서명</th>");
	    			columnDefsKeys[i] = (i+4);
	    			
	    		}
	    		else if(list2[i].signatureType == "APPRV") {
	    			column.data = "signApprover";
	    			column.defaultContent = "";
	    			columnKeys.push(column);
	    			$("#ccpDataTable thead tr").append("<th>승인자서명</th>");
	    			columnDefsKeys[i] = (i+4);
	    			
	    		}
	    	}
			
			//columns : 상단에서 정의된 columnKeys 사용
			//columnDefs - targets : 서명버튼 정의될 칼럼 index로 columnDefsKeys 사용
			//서명 칼럼에 데이터가 없으면 서명버튼을 칼럼명에 맞게 생성한다. 
		    var customOpts = {
		    		
				data : list,
				pageLength: 10,
				columns : columnKeys,
				'columnDefs' : [
					{
						'targets' : [0,2],
						'createdCell' : function(td, cellData, rowData, rowinx, col) {
							$(td).attr('style', 'display:none;');
						}
					},
					{
						'targets' : columnDefsKeys,
						'createdCell' : function(td, cellData, rowData, rowinx, col) {
							var colInfo = $('#ccpDataTable').DataTable().settings()[0].aoColumns[col];
						    
						    if(cellData == null && colInfo.sTitle == "작성자서명") {
						    	$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_writer" onclick = "registSignInfo(this);">서명</button>');
						    }
						    else if(cellData == null && colInfo.sTitle == "확인자서명") {
						    	$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_checker" onclick = "registSignInfo(this);">서명</button>');
						    }
						    else if(cellData == null && colInfo.sTitle == "승인자서명") {
						    	$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_approver" onclick = "registSignInfo(this);">서명</button>');
						    }
						}
					}
				],
				"rowCallback": function( row, data ) {
		            if ( $.inArray(data.DT_RowId, selected) !== -1 ) {
		                $(row).addClass('selected');
		                $(row).addClass('hene-bg-color');
		            }
		        }
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
		initTable();
    	
    	$("#insert-btn").off().click(function() {
    		let checklistId = 'checklist' + '<%=checklistNum%>';
    		// 제일 최신 포맷 수정이력번호 가져와야 함
    		let checklistFormatRevisionNo = 0;
    		let page = 2;
    		
    		$('#checklist-insert-wrapper1').css("display","block");
    		$('#checklist-insert-wrapper2').css("display","none");
    		$('#checklist-insert-wrapper3').css("display","none");
    		$('#checklist-insert-wrapper4').css("display","none");
    		$('#checklist-insert-wrapper5').css("display","none");
    		$('#checklist-prev-btn').remove();
    		$('#checklist-next-btn').remove();
    		
    		checklistPage = 1;
    		
    		var modal = new ChecklistInsertModal(checklistId, checklistFormatRevisionNo, clList.pageCnt);
    		modal.openModal();
    	});
    	
    	$("#update-btn").off().click(function() {
    		let selectedRows = mainTable.rows('.selected').data();
			let selectedRow = selectedRows[0];
			
    		if(selectedRows.length > 1) {
    			alert('하나만 선택해주세요.');
    			return false;
    		}

    		if(!selectedRow) {
				alert('정보를 수정할 선행요건을 선택해주세요.');
				return false;
			}
    		
    		let checklistId = selectedRow.checklistId;
    		// 제일 최신 포맷 수정이력번호 가져와야 함
    		//let checklistFormatRevisionNo = 0;
    		let checklistRevisionNo = selectedRow.revisionNo;
    		let checklistSeqNo = selectedRow.seqNo;
    		
    		$('#checklist-update-wrapper1').css("display","block");
    		$('#checklist-update-wrapper2').css("display","none");
    		$('#checklist-update-wrapper3').css("display","none");
    		$('#checklist-update-wrapper4').css("display","none");
    		$('#checklist-update-wrapper5').css("display","none");
    		$('#checklist-prev-btn').remove();
    		$('#checklist-next-btn').remove();
    		
    		checklistPage = 1;
    		
    		var modal = new ChecklistUpdateModal(checklistId, checklistRevisionNo, checklistSeqNo, clList.pageCnt);
    		modal.openModal();
    	});
    	
    	$("#delete-btn").off().click(function() {
    		let selectedRows = mainTable.rows('.selected').data();
			let selectedRow = selectedRows[0];
			
    		if(selectedRows.length > 1) {
    			alert('하나만 선택해주세요.');
    			return false;
    		}

    		if(!selectedRow) {
				alert('정보를 삭제할 선행요건을 선택해주세요.');
				return false;
			}
    		
    		let checklistId = selectedRow.checklistId;
    		let seqNo = selectedRow.seqNo;
    		
    		if(confirm("해당 점검표를 삭제하시겠습니까?")) {
    			
    			$.ajax({
    	            type: "POST",
    	            url: "<%=Config.this_SERVER_path%>/checklist",
    	            data: {
    	            	"type" : "delete",
    	            	"checklistId" : checklistId, 
    	            	"seqNo" : seqNo
    	            },
    	            success: function (insertResult) {
    	            	if(insertResult == '1') {
    	            		alert('삭제되었습니다.');
    	            		$('#myModal').modal('hide');
    	            		refreshMainTable();
    	            	} else {
    	            		alert('삭제 실패했습니다, 관리자에게 문의해주세요.');
    	            	}
    	            }
    	        });
    			
    		}
    		
    	});
    	
    	$("#select-btn").off().click(function() {
    		let selectedRows = mainTable.rows('.selected').data();
			let selectedRow = selectedRows[0];
			
    		if(selectedRows.length > 1) {
    			alert('하나만 선택해주세요.');
    			return false;
    		}

    		if(!selectedRow) {
				alert('정보를 조회할 선행요건을 선택해주세요.');
				return false;
			}
    		
    		let checklistId = selectedRow.checklistId;
    		let seqNo = selectedRow.seqNo;
    		let revisionNo = selectedRow.revisionNo;
    		
    		$('#checklist-select-wrapper1').css("display","block");
    		$('#checklist-select-wrapper2').css("display","none");
    		$('#checklist-select-wrapper3').css("display","none");
    		$('#checklist-select-wrapper4').css("display","none");
    		$('#checklist-select-wrapper5').css("display","none");
    		$('#checklist-prev-btn').remove();
    		$('#checklist-next-btn').remove();
    		
    		checklistPage = 1;
    		
    		var modal = new ChecklistSelectModal(checklistId, seqNo, revisionNo, clList.pageCnt);
    		modal.openModal();
    	});
    	
    	$('#checklist-insert-btn-close').off().click(function() {
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
    	});
    	
    	$('#checklist-update-btn-close').off().click(function() {
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
    	});
    	
    	$('#checklist-select-btn-close').off().click(function() {
    		var children = $('#checklist-select-wrapper1').children();
    		var children2 = $('#checklist-select-wrapper2').children();
    		var children3 = $('#checklist-select-wrapper3').children();
    		var children4 = $('#checklist-select-wrapper4').children();
    		var children5 = $('#checklist-select-wrapper5').children();
    		
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
    		
    		$('#checklist-select-modal').modal('hide');
    	});
    	
    	$("#sign-writer").click(function() {
    		var rowIdx = $(obj).closest("tr").index();
    		var selectedRow = mainTable.rows(rowIdx).data()[0];
    		console.log($(this).attr("id"));
    		
    		var check = confirm('서명하시겠습니까?');
    		
    		if(check) {
    		
    		let checklistId = selectedRow.checklistId;
    		let seqNo = selectedRow.seqNo;
    		let loginId = '<%=loginID%>';
    		let loginName = '<%=login_name%>';
    		$.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/checklist",
	            data: {
	            	"type" : "sign",
	            	"checklistId" : checklistId, 
	            	"seqNo" : seqNo,
	            	"loginId" : loginId,
	            	"loginName" : loginName
	            },
	            success: function (insertResult) {
	            	if(insertResult == 'true') {
	            		alert('등록되었습니다.');
	            		$('#myModal').modal('hide');
	            		refreshMainTable();
	            	} else {
	            		alert('등록 실패했습니다, 관리자에게 문의해주세요.');
	            	}
	            }
	        });
    		
    		}
    	});
    	
    	$('#ccpDataTable tbody').on('click', 'tr', function () {
	        var id = this.id;
	        var index = $.inArray(id, selected);
	        
	        if ( index === -1 ) {
	            selected.push( id );
	        } else {
	            selected.splice( index, 1 );
	        }	
	 
	        $(this).toggleClass('selected');
	        $(this).toggleClass('hene-bg-color');
	    } );
    	
    });
	
	function registSignInfo(obj){
		
		var rowIdx = $(obj).closest("tr").index();
		var selectedRow = mainTable.rows(rowIdx).data()[0];
		var signTarget = $(obj).attr("id");
		
		var check = confirm('서명하시겠습니까?');
		
		if(check) {
		
		let checklistId = selectedRow.checklistId;
		let seqNo = selectedRow.seqNo;
		
		$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/checklist",
            data: {
            	"type" : "sign",
            	"checklistId" : checklistId, 
            	"seqNo" : seqNo,
            	"signTarget" : signTarget
            },
            success: function (insertResult) {
            	if(insertResult == 1) {
            		alert('등록되었습니다.');
            		$('#myModal').modal('hide');
            		refreshMainTable();
            	} else {
            		alert('등록 실패했습니다, 관리자에게 문의해주세요.');
            	}
            }
        });
		
		}
		
	}
	
	function changeIMG(obj) {
		var image_file_name = $(obj).val();
		
		var cellId = $(obj).attr('id');
		var cellId2 = cellId.split('_');
		var formId = cellId2[0]+"_form";
		var canvas = document.getElementById(cellId2[0]);
		console.log(canvas);
		console.log();
		if( image_file_name.indexOf(".") ) { // 파일명 검사(파일이 선택됐는지) 및  확장자 검사(이미지파일-jpg,jpeg,png,gif 맞는지)
			var aExt = image_file_name.split("."); // 파일명에서 확장자명 분리(aExt[1] : 파일 확장자)
			if( aExt[1]!='jpg' && aExt[1]!='JPG' && aExt[1]!='JPEG' && aExt[1]!='jpeg' 
				&& aExt[1]!='png' && aExt[1]!='PNG'  && aExt[1]!='gif' && aExt[1]!='GIF' ){
				swal("선택한 파일은 지원하지 않는 파일형식입니다." + "\n" + "jpg, jpeg, png, gif 형식의 파일을 선택하세요!!!");
				return;
			} else {
				vPicImageFileName1 = "<%=bizNo%>_" + 'checklist' + '<%=checklistNum%>_' + cellId2[0] + "_" + Math.random() + "." + aExt[1] ; 
				// 실제로 저장할 파일명(사업자등록번호_직인)
//					var image_save_name = "ex_pic1_1" + "." + aExt[1] ; // 저장할 파일명(임시)
				fn_image_file_upload(vPicImageFileName1, formId, cellId2[0]) ;
			}
		}else {
			swal("등록할 이미지 파일을 선택하세요.");
			return;
		}
	}
	
	function fn_image_file_upload(image_save_name, formID, canvasID) {
		if(image_save_name == ""){ // 파일명 없을때 실행안함
			return;
		}
		var form = $('#' + formID)[0]; // 파일선택 버튼이 속해있는 form
		console.log(form);
		var data = new FormData(form);
		data.append("fileName", image_save_name); // 보낼 데이터1(저장할 파일명)
		console.log("data in form : =================");
		for (var pair of data.entries()) {
			console.log(pair[0]+ ', ' + pair[1]);
		}

    	// checklistImageFileUpload.jsp 호출 (이미지파일을 서버폴더에 저장)
		$.ajax({
			type: "POST",
			enctype: "multipart/form-data",
			url: "<%=Config.this_SERVER_path%>/Contents/ImageFileUpload/checklistImageFileUpload.jsp",
			data: data,
			processData: false,
			contentType: false,
			//async : false,
			cache: false,
			timeout: 600000,
			success: function (html) {
				// 화면에 저장한 이미지 미리보기로 띄움(canvasID가 있을때만 - 임시파일 저장할때만)
				if(html.length>0 && canvasID != undefined){
					var canvas = document.getElementById(canvasID);
					var context = canvas.getContext('2d');
					var imgSrc = "<%=Config.this_SERVER_path%>/images/checklist_file_img/"
								+ image_save_name
								+ "?v=" + Math.random() ; // 파일경로 + 저장한 파일명 + 랜덤숫자데이터(파일캐시 방지용)
					loadImages(imgSrc, context);
					function loadImages(ImgPage1, context) {
						var images = new Image;
						images.onload = function() {
							context.clearRect(0, 0, canvas.width, canvas.height);
							context.drawImage(this, 0, 0, canvas.width, canvas.height);  //캔버스에 이미지 디스플레이
						};
						images.src = ImgPage1;
					}
					$('#' + canvasID).val(image_save_name);
                }
	        },
			error: function (e) {
				console.log("ERROR : ", e);
			}
		});
	}
	// 점검표 image 영역 불러오는 function (수정 모달)
	function fn_Set_Image_File_View(imageFile, canvasID, width, height){
		var canvas = document.getElementById(canvasID);
		var context = canvas.getContext('2d');
		var imgSrc = "<%=Config.this_SERVER_path%>/images/checklist_file_img/"
					+ imageFile
					+ "?v=" + Math.random() ; // 파일경로 + 저장한 파일명 + 랜덤숫자데이터(파일캐시 방지용)
		loadImages(imgSrc, context);
		function loadImages(ImgPage1, context) {
			var images;
			images = new Image();
			images.onload = function() {
				context.clearRect(0, 0, canvas.width, canvas.height);
				context.drawImage(this, 0, 0, canvas.width, canvas.height);
			};
			images.onerror = function () {
			};
			images.src = ImgPage1;
		}
	}
	
	
	// 점검표 image 영역 불러오는 function (조회 모달)
	function fn_Set_Image_File_View2(imageFile, canvasID, startX, startY, width, height){
		var canvas = document.getElementById(canvasID);
		var context = canvas.getContext('2d');
		var imgSrc = "<%=Config.this_SERVER_path%>/images/checklist_file_img/"
					+ imageFile
					+ "?v=" + Math.random() ; // 파일경로 + 저장한 파일명 + 랜덤숫자데이터(파일캐시 방지용)
		loadImages(imgSrc, context);
		function loadImages(ImgPage1, context) {
			var images;
			images = new Image();
			images.onload = function() {
				context.clearRect(startX, startY, width, height);
				context.drawImage(this, startX, startY, width, height);
			};
			images.onerror = function () {
			};
			images.src = ImgPage1;
		}
	}
	
	
	async function refreshMainTable() {
    	var clData = new ChecklistData();
    	var clList = await clData.getAll('<%=checklistNum%>');
    	console.log(clList);
		mainTable.clear().rows.add(clList).draw();
	}
	
function checklist_prev(page){
		
		if(checklistPage == 2) {
			$('#checklist-insert-wrapper1').css("display","block");
			$('#checklist-insert-wrapper2').css("display","none");
			$('#checklist-update-wrapper1').css("display","block");
			$('#checklist-update-wrapper2').css("display","none");
			$('#checklist-select-wrapper1').css("display","block");
			$('#checklist-select-wrapper2').css("display","none");
			$('#checklist-prev-btn').css("display","none");
		}
		else if(checklistPage == 3) {
			$('#checklist-insert-wrapper2').css("display","block");
			$('#checklist-insert-wrapper3').css("display","none");
			$('#checklist-update-wrapper2').css("display","block");
			$('#checklist-update-wrapper3').css("display","none");
			$('#checklist-select-wrapper2').css("display","block");
			$('#checklist-select-wrapper3').css("display","none");
		}
		else if(checklistPage == 4) {
			$('#checklist-insert-wrapper3').css("display","block");
			$('#checklist-insert-wrapper4').css("display","none");
			$('#checklist-update-wrapper3').css("display","block");
			$('#checklist-update-wrapper4').css("display","none");
			$('#checklist-select-wrapper3').css("display","block");
			$('#checklist-select-wrapper4').css("display","none");
		}
		else if(checklistPage == 5) {
			$('#checklist-insert-wrapper4').css("display","block");
			$('#checklist-insert-wrapper5').css("display","none");
			$('#checklist-update-wrapper4').css("display","block");
			$('#checklist-update-wrapper5').css("display","none");
			$('#checklist-select-wrapper4').css("display","block");
			$('#checklist-select-wrapper5').css("display","none");
			$('#checklist-next-btn').css("display","inline");
		}
		
		checklistPage -= 1;
		
		if(modalPageCnt > checklistPage) {
			$('#checklist-next-btn').css("display","inline");
		}
	}
	
	function checklist_next(page){
		
		if(checklistPage == 1) {
			$('#checklist-insert-wrapper1').css("display","none");
			$('#checklist-insert-wrapper2').css("display","block");
			$('#checklist-update-wrapper1').css("display","none");
			$('#checklist-update-wrapper2').css("display","block");
			$('#checklist-select-wrapper1').css("display","none");
			$('#checklist-select-wrapper2').css("display","block");
			$('#checklist-prev-btn').css("display","inline");
		}
		else if(checklistPage == 2) {
			$('#checklist-insert-wrapper2').css("display","none");
			$('#checklist-insert-wrapper3').css("display","block");
			$('#checklist-update-wrapper2').css("display","none");
			$('#checklist-update-wrapper3').css("display","block");
			$('#checklist-select-wrapper2').css("display","none");
			$('#checklist-select-wrapper3').css("display","block");
		}
		else if(checklistPage == 3) {
			$('#checklist-insert-wrapper3').css("display","none");
			$('#checklist-insert-wrapper4').css("display","block");
			$('#checklist-update-wrapper3').css("display","none");
			$('#checklist-update-wrapper4').css("display","block");
			$('#checklist-select-wrapper3').css("display","none");
			$('#checklist-select-wrapper4').css("display","block");
		}
		else if(checklistPage == 4) {
			$('#checklist-insert-wrapper4').css("display","none");
			$('#checklist-insert-wrapper5').css("display","block");
			$('#checklist-update-wrapper4').css("display","none");
			$('#checklist-update-wrapper5').css("display","block");
			$('#checklist-select-wrapper4').css("display","none");
			$('#checklist-select-wrapper5').css("display","block");
			$('#checklist-next-btn').css("display","none");
		}
		
		checklistPage += 1;
		
		if(modalPageCnt == checklistPage) {
			$('#checklist-next-btn').css("display","none");
		}
	}
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	<%=menuName%>
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
			<button type="button" id="insert-btn" class="btn btn-outline-dark">
				점검표 등록
			</button>
			<button type="button" id="update-btn" class="btn btn-outline-success">
				점검표 수정
			</button>
			<button type="button" id="delete-btn" class="btn btn-outline-danger">
				점검표 삭제
			</button>
			<button type="button" id="select-btn" class="btn btn-outline-dark">
				점검표 조회
			</button>
      	</div>
      </div><!-- /.col -->
    </div><!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content-header -->

<!-- Main content -->
<div class="content">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">
        <div class="card card-primary card-outline">
          <div class="card-header">
          	<h3 class="card-title">
          		<i class="fas fa-edit" id="InfoContentTitle"></i>
          		<%=menuName%> 목록
          	</h3>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
				   <!-- <th>점검표아이디</th>
					    <th>일련번호</th>
					    <th>양식수정이력번호</th>
				    	<th>작성자서명</th>
					    <th>점검자서명</th>
					    <th>승인자서명</th> -->
					</tr>
				</thead>
				<tbody id="ccpDataTableBody">		
				</tbody>
			</table>
          </div> 
        </div>
      </div>
      <!-- /.col-md-12 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->