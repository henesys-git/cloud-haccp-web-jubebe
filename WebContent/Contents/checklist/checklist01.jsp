<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String login_name = session.getAttribute("login_name").toString();
%>
<script type="text/javascript">
    
    var mainTable;
    
	$(document).ready(function () {
		//let mainTable;
		
		async function getData() {
	        var fetchedList = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/checklist"
				            	+ "?checklistId=" + 'checklist01'
				            	+ "&seqNo=all",
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedList;
	    };
	    
	    async function getSignColumnData() {
	        var fetchedList = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/checklist"
				            	+ "?checklistId=" + 'checklist01'
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
	    	console.log(list2);
	    	
	    	var columnsContent = new Array();
	    	var columnDefsContent = new Array();
	    	
	    	var fixedTh = new Array();
	    	fixedTh[0] = "점검표아이디";
			fixedTh[1] = "일련번호";
			fixedTh[2] = "양식수정이력번호";
			var fixedColumn = new Array();
			fixedColumn[0] = "checklistId";
			fixedColumn[1] = "seqNo";
			fixedColumn[2] = "revisionNo";
	    	
	    	for(var a = 0; a < 3; a++) {
	    		
	    		
	    		//var column = new Object();
				//column.data = fixedColumn[a];
				//column.defaultContent = '';
				//columnsContent.push(column);
				$("#ccpDataTable thead tr").append("<th>"+fixedTh[a]+"</th>");
	    	}
	    	var columnKeys =
    			[ {data: fixedColumn[0] , defaultContent : ''}, {data:fixedColumn[1] , defaultContent : ''}, {data:fixedColumn[2] , defaultContent : ''}];
	    	
	    	console.log(columnKeys);
	    	console.log(columnsContent);
	    	
	    	for(var i = 0; i<list2.length; i++) {
	    		var column = new Object();
	    		var columnDef = new Object();
	    		if(list2[i].signatureType == "WRITE") {
	    			column.data = "signWriter";
	    			column.defaultContent = "";
	    			columnKeys.push(column);
					columnsContent.push(column);
	    			$("#ccpDataTable thead tr").append("<th>작성자서명</th>");
	    			
	    			/*
	    			columnDef.targets = "[" + i + "]";
	    			columnDef.creadtedCell = "function(td, cellData, rowData, rowinx, col) {if(cellData == null) {$(td).append('<button type='button' class='btn btn-success checklist-sign' id='sign_writer' onclick = 'registSignInfo(this);'>서명</button>');}}";
	    			
	    			columnDefsContent.push(
	    					'targets' : [i],
			        		'createdCell' : function(td, cellData, rowData, rowinx, col) {
			        			if(cellData == null) {
			        				$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_writer" onclick = "registSignInfo(this);">서명</button>');
			        			}
			        		}		
	    			);
	    			*/
	    		}
	    		else if(list2[i].signatureType == "APPRV") {
	    			column.data = "signApprover";
	    			column.defaultContent = "";
	    			columnKeys.push(column);
					columnsContent.push(column);
	    			$("#ccpDataTable thead tr").append("<th>승인자서명</th>");
	    			/*
	    			columnDefsContent.push(
	    					'targets' : [i],
			        		'createdCell' : function(td, cellData, rowData, rowinx, col) {
			        			if(cellData == null) {
			        				$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_approver" onclick = "registSignInfo(this);">서명</button>');
			        			}
			        		}		
	    			);
	    			*/
	    		}
	    	}
	    	console.log(columnKeys);
	    	console.log(columnsContent);
	    	//console.log(columnsDefsContent);
		    var customOpts = {
		    		
					data : list,
					pageLength: 10,
					columns : columnKeys
					//'columnDefs' : columnDefsContent
					//columns = columnsContent
					//columns: [
					//	columnsContent
						/*,
						{ data: "checklistId", defaultContent: '' },
						{ data: "seqNo", defaultContent: '' },
						{ data: "revisionNo", defaultContent: '' }
						
						
						{ data: "signWriter", defaultContent: '' },
						{ data: "signChecker", defaultContent: '' },
						{ data: "signApprover", defaultContent: '' }
						*/
			        //]
		    		//columns.concat(columnsContent);
		    		/*,
			        'columnDefs' : [
			        	
			        	{
			        		'targets' : [3],
			        		'createdCell' : function(td, cellData, rowData, rowinx, col) {
			        			if(cellData == null) {
			        				$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_writer" onclick = "registSignInfo(this);">서명</button>');
			        			}
			        		}
			        	},
			        	{
			        		'targets' : [4],
			        		'createdCell' : function(td, cellData, rowData, rowinx, col) {
			        			if(cellData == null) {
			        				$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_checker" onclick = "registSignInfo(this);">서명</button>');
			        			}
			        		}
			        	},
			        	{
			        		'targets' : [5],
			        		'createdCell' : function(td, cellData, rowData, rowinx, col) {
			        			if(cellData == null) {
			        				$(td).append('<button type="button" class="btn btn-success checklist-sign" id="sign_approver" onclick = "registSignInfo(this);">서명</button>');
			        			}
			        		}
			        	}
			        	
			        ]*/
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
		initTable();
    	
    	$("#insert-btn").click(function() {
    		let checklistId = 'checklist01';
    		// 제일 최신 포맷 수정이력번호 가져와야 함
    		let checklistFormatRevisionNo = 0;
    		var modal = new ChecklistInsertModal(checklistId, checklistFormatRevisionNo);
    		modal.openModal();
    	});
    	
    	$("#update-btn").click(function() {
    		var selectedRow = mainTable.rows('.selected').data()[0];
    		
    		if(selectedRow.length == 0) {
				alert('정보를 수정할 선행요건을 선택해주세요.');
				return false;
			}
    		
    		let checklistId = selectedRow.checklistId;
    		// 제일 최신 포맷 수정이력번호 가져와야 함
    		let checklistFormatRevisionNo = 0;
    		
    		var modal = new ChecklistUpdateModal(checklistId, checklistFormatRevisionNo);
    		modal.openModal();
    		
    	});
    	
    	$("#delete-btn").click(function() {
    		var selectedRow = mainTable.rows('.selected').data()[0];
    		
    		if(selectedRow.length == 0) {
				alert('정보를 삭제할 선행요건을 선택해주세요.');
				return false;
			}
    		
    		let checklistId = selectedRow.checklistId;
    		let seqNo = selectedRow.seqNo;
    		
    		var check = confirm("해당 점검표를 삭제하시겠습니까?");
    		
    		if(check) {
    			
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
    	
    	$("#select-btn").click(function() {
    		var selectedRow = mainTable.rows('.selected').data()[0];
    		
    		let checklistId = selectedRow.checklistId;
    		let seqNo = selectedRow.seqNo;
    		let revisionNo = selectedRow.revisionNo;
    		
    		var modal = new ChecklistSelectModal(checklistId, seqNo, revisionNo);
    		modal.openModal();
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
	
	async function refreshMainTable() {
    	var clData = new ChecklistData();
    	var clList = await clData.getAll();
    	console.log(clList);
		mainTable.clear().rows.add(clList).draw();
	}
	
	
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	CCP 담당 교육일지
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
          		CCP 담당 교육일지 목록
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