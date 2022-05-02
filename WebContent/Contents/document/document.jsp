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
	
	String documentNum = "", menuName = "";
	
	if(request.getParameter("documentNum") != null) 
		documentNum = request.getParameter("documentNum");
	
	if(request.getParameter("MenuTitle") != null) 
		menuName = request.getParameter("MenuTitle");
%>
<style>
	input[type="date"]::-webkit-inner-spin-button,
	input[type="date"]::-webkit-calendar-picker-indicator {
   	color: rgba(0, 0, 0, 0);
}

</style>
<script type="text/javascript">
    
    var mainTable;
    
	$(document).ready(function () {
		//let mainTable;
		async function getData() {
	        var fetchedList = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/document"
				            	+ "?documentId=" + 'document' + '<%=documentNum%>'
				            	+ "&seqNo=all",
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedList;
	    };
	   
	    async function initTable() {
	    	var list = await getData();
			
		    var customOpts = {
		    		
				data : list,
				pageLength: 10,
				columns: [
					{ data: "documentId", defaultContent: '' },
					{ data: "revisionNo", defaultContent: '' },
					{ data: "seqNo", defaultContent: '' },
					{ data: "registDate", defaultContent: '' },
					{ data: "bigo", defaultContent: '' },
					{ data: "", defaultContent: '' }
		        ],
		        'columnDefs': [
		        	{
						'targets': [0,1],
			   			'createdCell':  function (td, cellData, rowData, rowinx, col) {
			   				$(td).attr('style', 'display: none;'); 
			   			}
					},
		        	{
						'targets': [5],
			   			'createdCell':  function (td, cellData, rowData, rowinx, col) {
			   				$(td).append('<button type="button" class="btn btn-warning" id="alarm" onclick = "modifyAlarmInfo(this);">문서 view</button>');
			   			}
					}
		        ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
		initTable();
    	
    	$("#insert-btn").off().click(function() {
    		let checklistId = 'document' + '<%=documentNum%>';
    		
    		// 제일 최신 포맷 수정이력번호 가져와야 함
    		let checklistFormatRevisionNo = 0;
    		var modal = new ChecklistInsertModal(checklistId, checklistFormatRevisionNo);
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
    		
    		var modal = new ChecklistUpdateModal(checklistId, checklistRevisionNo, checklistSeqNo);
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
    	            url: "<%=Config.this_SERVER_path%>/document",
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
    		
    		let documentId = selectedRow.documenttId;
    		let seqNo = selectedRow.seqNo;
    		let revisionNo = selectedRow.revisionNo;
    		
    		var modal = new ChecklistSelectModal(checklistId, seqNo, revisionNo);
    		modal.openModal();
    	});
    	
    	$('#checklist-insert-btn-close').off().click(function() {
    		var children = $('#checklist-insert-wrapper').children();
    		
    		for(let i=1; i<children.length; i++) {
    			children[i].remove();
    		}
    		
    		$('#checklist-insert-modal').modal('hide');
    	});
    	
    	$('#checklist-update-btn-close').off().click(function() {
    		var children = $('#checklist-update-wrapper').children();
    		
    		for(let i=1; i<children.length; i++) {
    			children[i].remove();
    		}
    		
    		$('#checklist-update-modal').modal('hide');
    	});
    	
    	$('#checklist-select-btn-close').off().click(function() {
    		var children = $('#checklist-select-wrapper').children();
    		
    		for(let i=1; i<children.length; i++) {
    			children[i].remove();
    		}
    		
    		$('#checklist-select-modal').modal('hide');
    	});
    	
    });
	<%-- 
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
	 --%>
	 
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
    	var docData = new DocumentData();
    	var docList = await docData.getAll('<%=documentNum%>');
    	console.log(docList);
		mainTable.clear().rows.add(docList).draw();
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
				문서정보 등록
			</button>
			<button type="button" id="update-btn" class="btn btn-outline-success">
				문서정보 수정
			</button>
			<button type="button" id="delete-btn" class="btn btn-outline-danger">
				문서정보 삭제
			</button>
			<button type="button" id="select-btn" class="btn btn-outline-dark">
				문서정보 조회
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
				   		<th style='display:none; width:0px'>메뉴아이디</th>
				   		<th style='display:none; width:0px'>양식수정이력번호</th>
					    <th>일련번호</th>
					    <th>등록일자</th>
					    <th>비고</th>
					    <th></th>
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