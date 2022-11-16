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
</style>

<script src="<%=Config.this_SERVER_path%>/js/checklist.modal.js"></script>
<script type="text/javascript">
    
    var mainTable;
    
	$(document).ready(function () {
		
		var date = new SetRangeDate("dateParent", "dateRange", 7);
    	var startDate = date.start.format('YYYY-MM-DD');
       	var endDate = date.end.format('YYYY-MM-DD');
		
		async function getHeadDataList(startDate, endDate) {
			var fetchedList = $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/ccptestvm"
		            	+ "?method=" + 'head'
		            	+ "&startDate=" + startDate
		            	+ "&endDate=" + endDate
		            	+ "&processCode=PC10",
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
	    	var list = await getHeadDataList(startDate, endDate);
	    	var list2 = await getSignColumnData();
	    	//서명 칼럼 index 들어갈 배열
	    	var columnDefsKeys = new Array();
	    	
	    	console.log(list2);
	    	
	    	//html 고정th명(점검표아이디, 일련번호, 양식수정이력번호)
	    	var fixedTh = new Array();
	    	fixedTh[0] = "날짜";
			fixedTh[1] = "센서아이디";
			fixedTh[2] = "센서명";
			fixedTh[3] = "제품코드";
			
			//db로부터 받아온 칼럼명
			var fixedColumn = new Array();
			fixedColumn[0] = "createDate";
			fixedColumn[1] = "sensorId";
			fixedColumn[2] = "sensorName";
			fixedColumn[3] = "productId";

			// 하단 datatable 고정영역 columns 변수 array로 만들기  (점검표아이디, 일련번호, 양식수정이력번호) 
			var columnKeys = [
   				{data: fixedColumn[0] , defaultContent : '' }, 
   			  	{data: fixedColumn[1] , defaultContent : '' },
   			  	{data: fixedColumn[2] , defaultContent : '' },
   			 	{data: fixedColumn[3] , defaultContent : '' }
   			];
			
			// 고정영역 html th 태그 만들기(점검표아이디, 일련번호, 양식수정이력번호)
	    	for(var a = 0; a < 3; a++) {
				$("#ccpDataTable thead tr").append("<th>"+fixedTh[a]+"</th>");
	    	}
	    	
	    	$("#ccpDataTable thead tr").append("<th style = 'display:none;'>"+fixedTh[3]+"</th>");
			
			//점검표의 사인정보를 조회해온 데이터를 판단하여 동적으로 
			//columnKeys 배열에 push하여 칼럼을 늘리고 html th 태그를 생성한다.
	    	for(var i=0; i<list2.length; i++) {
	    		var column = new Object();
	    		var columnDef = new Object();
	    		
	    		if(list2[i].signatureType == "WRITE") {
	    			column.data = "signWriter";
	    			column.defaultContent = "";
	    			columnKeys.push(column);
	    			$("#ccpDataTable thead tr").append("<th>작성자서명</th>");
	    			columnDefsKeys[i] = (i + fixedColumn.length);
	    		}
	    		else if(list2[i].signatureType == "CHECK") {
	    			column.data = "signChecker";
	    			column.defaultContent = "";
	    			columnKeys.push(column);
	    			$("#ccpDataTable thead tr").append("<th>확인자서명</th>");
	    			columnDefsKeys[i] = (i + fixedColumn.length);
	    		}
	    		else if(list2[i].signatureType == "APPRV") {
	    			column.data = "signApprover";
	    			column.defaultContent = "";
	    			columnKeys.push(column);
	    			$("#ccpDataTable thead tr").append("<th>승인자서명</th>");
	    			columnDefsKeys[i] = (i + fixedColumn.length);
	    		}
	    	}
			
			//columns : 상단에서 정의된 columnKeys 사용
			//columnDefs - targets : 서명버튼 정의될 칼럼 index로 columnDefsKeys 사용
			//서명 칼럼에 데이터가 없으면 서명버튼을 칼럼명에 맞게 생성한다. 
		    var customOpts = {
				data : list,
				pageLength: 10,
				columns : columnKeys,
				columnDefs : [
					{
						targets : columnDefsKeys,
						createdCell : function(td, cellData, rowData, rowinx, col) {
							console.log(cellData);
							var colInfo = $('#ccpDataTable').DataTable().settings()[0].aoColumns[col];
						    
							if(cellData == "" && colInfo.sTitle == "작성자서명") {
						    	$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_writer" onclick="registSignInfo(this);">서명</button>');
						    }
						    else if(cellData == "" && colInfo.sTitle == "확인자서명") {
						    	$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_checker" onclick="registSignInfo(this);">서명</button>');
						    }
						    else if(cellData == "" && colInfo.sTitle == "승인자서명") {
						    	$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_approver" onclick="registSignInfo(this);">서명</button>');
						    }
						}
					},
					{
						targets: [3],
		        		'createdCell': function(td, cellData, rowData, row, col){
		        			$(td).attr('style', 'display:none;');
			  			}
					}
				]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
		initTable();
		
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
    		
    		let createDate = selectedRow.createDate;
    		let sensorId = selectedRow.sensorId;
    		let productId = selectedRow.productId;
    		console.log(productId);
    		console.log(selectedRow);
    		var modal = new ChecklistSelectModalCCP(createDate, sensorId, productId);
    		modal.openModal();
    	});
    	
    	$('#checklist-select-btn-close').off().click(function() {
    		var children = $('#checklist-select-wrapper').children();
    		
    		for(let i=1; i<children.length; i++) {
    			children[i].remove();
    		}
    		
    		$('#checklist-select-modal').modal('hide');
    	});
    	
    	$("#sign-writer").click(function() {
    		var rowIdx = $(obj).closest("tr").index();
    		var selectedRow = mainTable.rows(rowIdx).data()[0];
    		
    		if(confirm('서명하시겠습니까?')) {
    		
	    		let checklistId = "checklist05";
	    		let seqNo = 0;
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
    	
    	async function refreshMainTable() {
           	var startDate = date.getStartDate();
           	var endDate = date.getEndDate();
    		var list = await getHeadDataList(startDate, endDate);
    		mainTable.clear().rows.add(list).draw();
    	}
    	
    	$('#dateRange').change(function() {
    		refreshMainTable();
        });
    });
	
	function registSignInfo(obj){
		
		var rowIdx = $(obj).closest("tr").index();
		var selectedRow = mainTable.rows(rowIdx).data()[0];
		var signTarget = $(obj).attr("id");
		
		if(confirm('서명하시겠습니까?')) {
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

		if( image_file_name.indexOf(".") ) { // 파일명 검사(파일이 선택됐는지) 및  확장자 검사(이미지파일-jpg,jpeg,png,gif 맞는지)
			var aExt = image_file_name.split("."); // 파일명에서 확장자명 분리(aExt[1] : 파일 확장자)
			if( aExt[1]!='jpg' && aExt[1]!='JPG' && aExt[1]!='JPEG' && aExt[1]!='jpeg' 
				&& aExt[1]!='png' && aExt[1]!='PNG'  && aExt[1]!='gif' && aExt[1]!='GIF' ){
				swal("선택한 파일은 지원하지 않는 파일형식입니다." + "\n" + "jpg, jpeg, png, gif 형식의 파일을 선택하세요!!!");
				return;
			} else {
				vPicImageFileName1 = "<%=bizNo%>_" + 'checklist' + '<%=checklistNum%>_' + cellId2[0] + "_" + Math.random() + "." + aExt[1] ; 
				// 실제로 저장할 파일명(사업자등록번호_직인)
//				var image_save_name = "ex_pic1_1" + "." + aExt[1] ; // 저장할 파일명(임시)
				fn_image_file_upload(vPicImageFileName1, formId, cellId2[0]) ;
			}
		} else {
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
			var images = new Image();
			images.onload = function() {
				context.clearRect(0, 0, canvas.width, canvas.height);
				context.drawImage(this, 0, 0, canvas.width, canvas.height);
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
          	<div class="card-tools">
          	  <div class="input-group input-group-sm" id="dateParent">
          	  	<input type="text" class="form-control float-right" id="dateRange">
          	  	<div class="input-group-append">
          	  	  <button type="submit" class="btn btn-default">
          	  	    <i class="fas fa-search"></i>
          	  	  </button>
          	  	</div>
          	  </div>
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
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