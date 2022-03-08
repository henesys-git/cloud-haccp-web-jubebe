<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	$(document).ready(function () {
		let mainTable;
		
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
	    
	    async function initTable() {
	    	var list = await getData();
	    	
		    var customOpts = {
					data : list,
					pageLength: 10,
					columns: [
						{ data: "checklistId", defaultContent: '' },
						{ data: "seqNo", defaultContent: '' },
						{ data: "revisionNo", defaultContent: '' },
						{ data: "signWriter", defaultContent: '' },
						{ data: "signChecker", defaultContent: '' },
						{ data: "signApprover", defaultContent: '' }
			        ]
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
    	
    	$("#select-btn").click(function() {
    		var selectedRow = mainTable.rows('.selected').data()[0];
    		
    		let checklistId = selectedRow.checklistId;
    		let seqNo = selectedRow.seqNo;
    		
    		var modal = new ChecklistSelectModal(checklistId, seqNo);
    		modal.openModal();
    	});
    });
	
	
    
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
					    <th>점검표아이디</th>
					    <th>일련번호</th>
					    <th>양식수정이력번호</th>
					    <th>작성자서명</th>
					    <th>점검자서명</th>
					    <th>승인자서명</th>
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