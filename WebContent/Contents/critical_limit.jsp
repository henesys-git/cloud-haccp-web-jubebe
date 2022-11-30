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
	        var fetchedData = $.ajax({
			            type: "GET",
			            url: heneServerPath + "/limit?id=all",
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
						{ data: "eventCode", defaultContent: '' },
						{ data: "eventName", defaultContent: '' },
						{ data: "objectId", defaultContent: '' },
						{ data: "objectName", defaultContent: '' },
						{ data: "minValue", defaultContent: '' },
						{ data: "maxValue", defaultContent: '' },
						{ data: "valueUnit", defaultContent: '' }
			        ],
			        columnDefs : [
			        	{
				  			'targets': [0,2],
				  			'createdCell':  function (td) {
			   	      			$(td).attr('style', 'display: none;'); 
							}
				  		}
				    ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	 
	    async function refreshMainTable() {
	    	var limit = new HENESYS_API.Limit();
	    	var limitList = await limit.getLimit();
	    	
    		mainTable.clear().rows.add(limitList).draw();
		}   
	    
	    var initModal = function () {
	    	$('#sensor-id').prop('disabled', false);
	    	$('#sensor-id').val('');
	    	$('#sensor-name').val('');
	    	$('#sensor-valueType').val('');
	    	$('#sensor-IP').val('');
	    	$('#sensor-protocol').val('');
	    	$('#sensor-packet').val('');
	    	$('#sensor-typeCode').val('');
	    	$('#sensor-checklist').val('');
	    };
	    
	    var initModal2 = function () {
	    	$('#sensor-id').prop('disabled', false);
	    	$('#sensor-id').val('');
	    	$('#sensor-name').val('');
	    	$('#sensor-valueType').val('');
	    	$('#sensor-IP').val('');
	    	$('#sensor-protocol').val('');
	    	$('#sensor-packet').val('');
	    	$('#sensor-typeCode').val('');
	    	$('#sensor-checklist').val('');
	    };
	    
	 	// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#myModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#save').off().click(function() {
				
				var code = $('#limit-type2 option:selected').val();
            	var code2 = $('#limit-objectName option:selected').val();
				var min = $('#limit-minValue').val();
				var max = $('#limit-maxValue').val();
				
				if(min === '') {
					alert('최소값을 입력해주세요');
					return false;
				}
				if(max === '') {
					alert('최대값을 입력해주세요');
					return false;
				}
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/limit",
		            data: {
		            	"type" : "insert",
		            	"eventCode" : $('#limit-type2 option:selected').val(),
		            	"objectId" : $('#limit-objectName option:selected').val(),
		            	"minValue" : $('#limit-minValue2').val(),
	            		"maxValue" : $('#limit-maxValue2').val(),
	            		"valueUnit" : $('#limit-valueUnit2').val()
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
			console.log(row[0]);
			console.log(row[0].minValue);
			console.log(row[0].maxValue);
			$('#myModal2').modal('show');
			$('.modal-title').text('수정');
			
			$('#limit-eventName2').val(row[0].eventName);
			$('#limit-objectName2').val(row[0].objectName);
			$('#limit-minValue2').val(row[0].minValue);
			$('#limit-maxValue2').val(row[0].maxValue);
			$('#limit-valueUnit2').val(row[0].valueUnit);
			
			$('#limit-eventName2').prop('disabled', true);
			$('#limit-objectName2').prop('disabled', true);
			
			$('#save2').off().click(function() {
				
				var min = $('#limit-minValue2').val();
				var max = $('#limit-maxValue2').val();
				
				if(min === '') {
					alert('최소값을 입력해주세요');
					return false;
				}
				if(max === '') {
					alert('최대값을 입력해주세요');
					return false;
				}
				
				var check = confirm('수정하시겠습니까?');
				
				if(check) {
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/limit",
		            data: { 
	            		"type" : "update",
	            		"eventCode" : row[0].eventCode,
	            		"objectId" : row[0].objectId,
	            		"minValue" : $('#limit-minValue2').val(),
	            		"maxValue" : $('#limit-maxValue2').val(),
	            		"valueUnit" : $('#limit-valueUnit2').val()
		           	},
		            success: function (updateResult) {
		            	if(updateResult == 'true') {
		            		alert('수정되었습니다.');
		            		$('#myModal2').modal('hide');
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
				alert('삭제할 한계기준 정보를 선택해주세요.');
				return false;
			}
			
			if(confirm('삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/limit",
		            data: { 
	            		"type" : "delete",
	            		"eventCode" : row[0].eventCode,
	            		"objectId" : row[0].objectId,
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
    	
    	$("#getDataBtn").click(async function() {
    		var newData = await getData();
    		mainTable.clear().rows.add(newData).draw();
    	});
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	한계기준 관리
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
          		한계기준 목록
          	</h3>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
					    <th style="width:0px; display: none;">이벤트코드</th>
					    <th>이벤트명</th>
					    <th style="width:0px; display: none;">개체아이디</th>
						<th>개체명</th>
					    <th>최소값</th>
					    <th>최대값</th>
					    <th>값단위</th>
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
      	<label for="limit-type">한계기준 등록 대분류</label>
		<div class="input-group mb-3">
		  <select class="form-control" id="limit-type">
		    <option value = "MC">금속검출</option>
		    <option value = "HT">가열</option>
		    <option value = "CR">크림공정</option>
		  	<option value = "TP">온도</option>
		  </select>
		</div>
		<label for="limit-type2">한계기준 등록 중분류</label>
		<div class="input-group mb-3">
		  <select class="form-control" id="limit-type2">
		  </select>
		</div>
      	<label for="limit-objectName">한계기준 개체명</label>
		<div class="input-group mb-3">
		  <select class="form-control" id="limit-objectName">
		  </select>
		</div>
      	<label for="limit-minValue">최소값</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="limit-minValue">
		</div>
		<label for="limit-maxValue">최대값</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="limit-maxValue">
		</div>
		<label for="limit-valueUnit">값 단위</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="limit-valueUnit">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>
<div class="modal fade" id="myModal2" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title"></h4>  
      </div>  
      <div class="modal-body">
		<label for="limit-eventName2">이벤트명</label>
		<div class="input-group mb-3">
		 <input type="text" class="form-control" id="limit-eventName2">
		</div>
      	<label for="limit-objectName2">한계기준 개체명</label>
		<div class="input-group mb-3">
		 <input type="text" class="form-control" id="limit-objectName2">
		</div>
      	<label for="limit-minValue2">최소값</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="limit-minValue2">
		</div>
		<label for="limit-maxValue2">최대값</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="limit-maxValue2">
		</div>
		<label for="limit-valueUnit2">값 단위</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="limit-valueUnit2">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save2">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>