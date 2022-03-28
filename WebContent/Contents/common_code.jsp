<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	$(document).ready(function () {
    	
		//let date = new SetRangeDate("dateParent", "dateRange", 7);
		let mainTable;
		
		async function getData() {
	    	//var startDate = date.getStartDate();
    		//var endDate = date.getEndDate();
	    	
	        var fetchedData = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/commonCode",
			            data: "id=all", 
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedData;
	    };
	    
	    async function initTable() {
	    	var data = await getData();
	    	
		    var customOpts = {
					data : data,
					pageLength: 10,
					columns: [
						/*
						{ data: "sensorKey", defaultContent: '' },
						{ data: "seqNo", defaultContent: '' },
						{ data: "createTime", defaultContent: '' },
						{ data: "sensorId", defaultContent: '' },
						{ data: "sensorValue", defaultContent: '' },
						{ data: "improvementCode", defaultContent: '' },
						{ data: "userId", defaultContent: '' },
						{ data: "eventCode", defaultContent: '' },
						{ data: "productId", defaultContent: '' }
						*/
						{ data: "commonCodeId", defaultContent: '' },
						{ data: "commonCodeName", defaultContent: '' },
						{ data: "commonCodeType", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    var initModal = function () {
	    	$('#code-id').prop('disabled', false);
	    	$('#code-id').val('');
	    	$('#code-name').val('');
	    	$('#code-type').val('');
	    };
	    
	 	// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#myModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#save').off().click(function() {
				var id = $('#code-id').val();
				var name = $('#code-name').val();
				var type = $('#code-type').val();
				
				if(id === '') {
					alert('공통코드를 입력해주세요');
					return false;
				}
				if(name === '') {
					alert('공통코드명을 입력해주세요');
					return false;
				}
				if(type === '') {
					alert('코드 타입을 입력해주세요');
					return false;
				}
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/commonCode",
		            data: {
		            	"type" : "insert",
		            	"id" : id, 
		            	"name" : name, 
		            	"valueType" : type
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
			});
		});   
	 
	 	// 수정
		$('#update').click(function() {
			initModal();
			
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('수정할 센서정보를 선택해주세요.');
				return false;
			}
			
			$('#myModal').modal('show');
			$('.modal-title').text('수정');
			
			$('#code-id').val(row[0].commonCodeId);
			$('#code-name').val(row[0].commonCodeName);
			$('#code-type').val(row[0].commonCodeType);
			
			$('#code-id').prop('disabled', true);
			
			$('#save').off().click(function() {
				
				var name = $('#code-name').val();
				var typeCode = $('#code-type').val();
				
				if(name === '') {
					alert('센서명을 입력해주세요');
					return false;
				}
				if(typeCode === '') {
					alert('공통코드 타입을 입력해주세요');
					return false;
				}
				
				var check = confirm('수정하시겠습니까?');
				
				if(check) {
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/commonCode",
		            data: { 
	            		"type" : "update",
	            		"id" : row[0].commonCodeId,
	            		"name" : $('#code-name').val(), 
		            	"valueType" : $('#code-type').val()
		           	},
		            success: function (updateResult) {
		            	if(updateResult == 'true') {
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
	    
	    
	 	// 삭제
		$('#delete').click(function() {
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('삭제할 센서정보를 선택해주세요.');
				return false;
			}
			
			if(confirm('삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/commonCode",
		            data: { 
	            		"type" : "delete",
	            		"id" : row[0].commonCodeId 
		            },
		            success: function (deleteResult) {
		            	console.log(deleteResult);
		            	if(deleteResult == 'true') {
		            		alert('삭제되었습니다.');
		            		refreshMainTable();
		            	} else {
		            		alert('삭제 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
			}
			
		});
	    
	    
		initTable();
    	/*
    	$("#getDataBtn").click(async function() {
    		var newData = await getData();
    		mainTable.clear().rows.add(newData).draw();
    	});
    	*/
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	공통 코드 관리
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      	  <button type="button" class="btn btn-info" id="insert">
      	  	등록
      	  </button>
      	  <button type="button" class="btn btn-success" id="update">
      	  	수정
      	  </button>
      	  <button type="button" class="btn btn-danger" id="delete">
      	  	삭제
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
          		공통 코드 목록
          	</h3>
          	<div class="card-tools">
          	  <!-- <div class="input-group input-group-sm" id="dateParent">
          	  	<input type="text" class="form-control float-right" id="dateRange">
          	  	<div class="input-group-append">
          	  	  <button type="submit" class="btn btn-default" id="getDataBtn">
          	  	    <i class="fas fa-search"></i>
          	  	  </button>
          	  	</div>
          	  </div> -->
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
				   <!-- <th>묶음값</th>
						<th>일련번호</th>
					    <th>생성시간</th>
					    <th>센서아이디</th>
					    <th>센서값</th>
					    <th>개선조치코드</th>
					    <th>사용자아이디</th>
					    <th>이벤트코드</th>
					    <th>제품아이디</th> -->
					    <th>공통코드</th>
					    <th>공통코드명</th>
					    <th>공통코드타입</th>
					</tr>
				</thead>
				<tbody id="ccpDataTableBody">		
				</tbody>
			</table>
          </div> 
        </div>
      </div>
      <!-- /.col-md-6 -->
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
      	<label for="code-id">공통코드아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="code-id">
		</div>
      	<label for="code-name">공통코드명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="code-name">
		</div>
      	<label for="code-type">코드 타입</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="code-type">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>