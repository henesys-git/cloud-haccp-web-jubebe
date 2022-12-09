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
					{ data: "documentData", defaultContent: '' },
					{ data: "", defaultContent: '' }
		        ],
		        'columnDefs': [
		        	{
						'targets': [0,1,5],
			   			'createdCell':  function (td, cellData, rowData, rowinx, col) {
			   				$(td).attr('style', 'display: none;'); 
			   			}
					},
		        	{
						'targets': [6],
			   			'createdCell':  function (td, cellData, rowData, rowinx, col) {
			   				$(td).append('<button type="button" class="btn btn-warning" id="view" onclick = "docDownload(this);">문서 view</button>');
			   				//$(td).append('<button type="button" class="btn btn-success" id="download" onclick = "docDownload(this);">문서 다운로드</button>');
			   			}
					}
		        ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
		initTable();
    	
		var initModal = function () {
	    	//$('#file-data').prop('disabled', false);
	    	$('#bigo').val('');
	    };
		
    	$("#insert-btn").click(function() {
    		initModal();
    		
    		$('#myModal').modal('show');
			$('.modal-title').text('문서정보등록');
			
			$('#save').off().click(function() {
			
			var document_id = 'document' + '<%=documentNum%>';
			var fileVal = $('#file-data').val();
			console.log(fileVal);
			var fileRealNameSplit = fileVal.split("\\");
			var fileRealName = fileRealNameSplit[fileRealNameSplit.length - 1];
			console.log(fileRealName);
			var fileNames = fileRealName.split(".");
			var fileName = fileRealName.replace(fileRealName.split(".")[fileNames.length - 1], "");
			var fileExtension = fileRealName.split(".")[fileNames.length - 1];
			var upLoadedFileName =  fileName + "_" + Math.random() +  "." + fileExtension;
			
			var bigo = $('#bigo').val();
			
			var form = $('#upload_form')[0];	
			var data2 = new FormData(form);
			data2.append("fileName", upLoadedFileName);
			console.log(data2);
			
			if(fileVal == '' || fileVal == null) {
				alert('문서파일을 등록해주세요');
				return false;
			}
			
			console.log("data2 in form : =================");
			for (var pair of data2.entries()) {
				console.log(pair[0]+ ', ' + pair[1]);
			}
			
			console.log(document_id);
			console.log(upLoadedFileName);
			console.log(bigo);
			var check = confirm('등록하시겠습니까?');
			
			if(check) {
			
			$.ajax({
				type: "POST",
				async: true,
	   	        enctype: "multipart/form-data",
	   	        acceptcharset: "UTF-8",
	   	        url: "<%=Config.this_SERVER_path%>/DocServer/upload/fileUploadNew.jsp", 
	   	        data: data2,
	   	        processData: false,
	   	        contentType: false,
				cache: false,
	   	        timeout: 600000,
	   	        success: function (data) {
					if(data.length > 0) {
						
						//파일 업로드 성공하면 db에 data insert
						$.ajax({
				            type: "POST",
				            url: "<%=Config.this_SERVER_path%>/document",
				            data: {
				            	"type" : "insert",
				            	"id" : document_id,
				            	"revisionNo" : 0,
				            	"data" : upLoadedFileName,
				            	"bigo" : bigo
				            },
				            success: function (insertResult) {
				            	if(insertResult == '1') {
				            		alert('문서 등록에 성공하였습니다.');
				            		$('#myModal').modal('hide');
				            		refreshMainTable();
				            	} else {
				            		console.log('db 등록 실패');
				            		alert('등록 실패했습니다, 관리자에게 문의해주세요. \n 한번에 올릴 수 있는 파일의 최대용량은 20MB를 초과할 수 없습니다.');
				            		return false;
				            	}
				            }
				           });
					} else {
						console.log("error2");
						alert('등록 실패했습니다, 관리자에게 문의해주세요. \n 한번에 올릴 수 있는 파일의 최대용량은 20MB를 초과할 수 없습니다.');
					}
				},
	   	        error: function (e) {
	   	        	console.log("error3");
	   	        	alert('등록 실패했습니다, 관리자에게 문의해주세요. \n 한번에 올릴 수 있는 파일의 최대용량은 20MB를 초과할 수 없습니다.');
	   	        }
	   	    });
		   } 
		  });
    	});
    	
    	$("#update-btn").click(function() {
    		var row = mainTable.rows( '.selected' ).data();
    		
    		if(row.length == 0) {
				alert('수정할 문서정보를 선택해주세요.');
				return false;
			}

    		$('#myModal').modal('show');
			$('.modal-title').text('문서정보수정');
			
			$('#file-data').val(row[0].document_data);
			$('#bigo').val(row[0].bigo);
    		
			$('#save').off().click(function() {
				
				var check = confirm('수정하시겠습니까?');
				
				if(check) {
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/menu",
		            data: { 
	            		"type" : "update",
	            		"id" : row[0].documentId,
	            		"data" : $('#file-data').val(), 
	            		"bigo" : $('#bigo').val(),
	            		"seq_no" : row[0].seqNo
		           	},
		            success: function (updateResult) {
		            	console.log(updateResult);
		            	if(updateResult == '1') {
		            		alert('수정되었습니다.');
		            		$('#myModal').modal('hide');
		            		refreshMainTable();
		            	} else {
		            		alert('수정 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
				
				}
				
			});
    	});
    	
    	$("#delete-btn").click(function() {
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('삭제할 문서정보를 선택해주세요.');
				return false;
			}
    		
    		if(confirm("해당 문서정보를 삭제하시겠습니까?")) {
    			
    			$.ajax({
    	            type: "POST",
    	            url: "<%=Config.this_SERVER_path%>/document",
    	            data: {
    	            	"type" : "delete",
    	            	"id" : row[0].documentId, 
    	            	"seqNo" : row[0].seqNo
    	            },
    	            success: function (deleteResult) {
    	            	console.log("deleteResult");
    	            	console.log(deleteResult);

    	            	if(deleteResult == '1') {
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
	 
	function docView(obj) {
		var fileName = $(obj).closest('tr').children().eq(5).text().trim();
		
		<%-- var url = "<%=Config.this_SERVER_path%>" + "/DocServer/upload/files/" + fileName; --%>
		var url = "file_upload/" + fileName;
    	window.open(url);
		
	}
	
	function docDownload(obj) {
		var fileName = $(obj).closest('tr').children().eq(5).text().trim();
		var fileNameSplit = fileName.split('.');
		var aExt = fileNameSplit[fileNameSplit.length - 1];
		console.log(aExt);
		console.log("file_upload/"+ fileName);
		if(aExt == "pdf" || aExt == "PDF"){
			<%-- fn_CommonPopup("<%=Config.this_SERVER_path%>/pdfjs-dist/web/viewer.html?file=http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=Config.this_SERVER_path%><%=Config.DOC_FILE_SAVEPATH%>/" + fileName , "", 1024, 950); --%>
			fn_CommonPopup("<%=Config.this_SERVER_path%>/pdfjs-dist/web/viewer.html?file=http://<%=request.getServerName()%>:<%=request.getServerPort()%>/file_upload/" + fileName , "", 1024, 950);
		} else if(aExt == "xls" || aExt == "XLS" || aExt == "xlsx" || aExt == "XLSX") {
			<%-- window.open("http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=Config.this_SERVER_path%><%=Config.DOC_FILE_SAVEPATH%>/" + fileName); --%>
			window.open("file_upload/" + fileName);
		} else{
			<%-- var url = "http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=Config.this_SERVER_path%><%=Config.DOC_FILE_SAVEPATH%>/" + fileName; --%>
			var url = "file_upload/" + fileName;
			window.open(url);
		}
		<%-- 
		// FileDownload.jsp 호출
		$.ajax({
			type: "POST",
			//enctype: "multipart/form-data",
			url: "<%=Config.this_SERVER_path%>/DocServer/upload/fileDownloadNew.jsp?fileName=" + fileName,
			//data: "fileName=" + fileName,
			processData: false,
			contentType: false,
			//async : false,
			cache: false,
			timeout: 600000,
			success: function (html) {
				console.log(html);
				
	        },
			error: function (e) {
				alert('문서 다운로드 실패');
				console.log("ERROR : ", e);
			}
		});
		 --%>
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
		<!-- 	<button type="button" id="select-btn" class="btn btn-outline-dark">
				문서정보 조회
			</button> -->
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
					    <th style='display:none; width:0px'>파일명</th>
					    <th style=' width:100px'></th>
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
<!-- Modal -->  
<div class="modal fade" id="myModal" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title"></h4>  
      </div>  
      <div class="modal-body">
      	<label for="menu-id">파일명</label>
		<div class="input-group mb-3">
			<form id="upload_form" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/DocServer/upload/fileUploadNew.jsp" method="post">
		  		<input type="file" class="form-control" id="file-data" name = "filename">
		  	</form>
		</div>
      	<label for="menu-name">비고</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="bigo">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>