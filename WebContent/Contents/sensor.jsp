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
			            url: heneServerPath + "/sensor?id=all",
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
						{ data: "sensorId", defaultContent: '' },
						{ data: "sensorName", defaultContent: '' },
						{ data: "valueType", defaultContent: '' },
						{ data: "ipAddress", defaultContent: '' },
						{ data: "protocolInfo", defaultContent: '' },
						{ data: "packetInfo", defaultContent: '' },
						{ data: "typeCode", defaultContent: '' },
						{ data: "checklistId", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	 
	    async function refreshMainTable() {
	    	var sensor = new HENESYS_API.Sensor();
	    	var sensorList = await sensor.getSensors();
	    	
    		mainTable.clear().rows.add(sensorList).draw();
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
	    
	 	// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#myModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#save').off().click(function() {
				var id = $('#sensor-id').val();
				var name = $('#sensor-name').val();
				var valueType = $('#sensor-valueType').val();
				var IP = $('#sensor-IP').val();
				var protocol = $('#sensor-protocol').val();
				var packet = $('#sensor-packet').val();
				var typeCode = $('#sensor-typeCode').val();
				var checklistId = $('#sensor-checklist').val();
				
				if(id === '') {
					alert('센서 아이디를 입력해주세요');
					return false;
				}
				if(name === '') {
					alert('센서명을 입력해주세요');
					return false;
				}
				if(typeCode === '') {
					alert('타입 코드를 입력해주세요');
					return false;
				}
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/sensor",
		            data: {
		            	"type" : "insert",
		            	"id" : id, 
		            	"name" : name, 
		            	"valueType" : valueType,
		            	"IP" : IP,
		            	"protocol" : protocol,
		            	"packet" : packet,
		            	"typeCode" : typeCode,
		            	"checklistId" : checklistId
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
			
			$('#sensor-id').val(row[0].sensorId);
			$('#sensor-name').val(row[0].sensorName);
			$('#sensor-valueType').val(row[0].valueType);
			$('#sensor-IP').val(row[0].ipAddress);
			$('#sensor-protocol').val(row[0].protocolInfo);
			$('#sensor-packet').val(row[0].packetInfo);
			$('#sensor-typeCode').val(row[0].typeCode);
			$('#sensor-checklist').val(row[0].checklistId);
			
			$('#sensor-id').prop('disabled', true);
			
			$('#save').off().click(function() {
				
				var name = $('#sensor-name').val();
				var typeCode = $('#sensor-typeCode').val();
				
				if(name === '') {
					alert('센서명을 입력해주세요');
					return false;
				}
				if(typeCode === '') {
					alert('타입 코드를 입력해주세요');
					return false;
				}
				
				var check = confirm('수정하시겠습니까?');
				
				if(check) {
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/sensor",
		            data: { 
	            		"type" : "update",
	            		"id" : row[0].sensorId,
	            		"name" : $('#sensor-name').val(), 
		            	"valueType" : $('#sensor-valueType').val(),
		            	"IP" : $('#sensor-IP').val(),
		            	"protocol" : $('#sensor-protocol').val(),
		            	"packet" : $('#sensor-packet').val(),
		            	"typeCode" : $('#sensor-typeCode').val(),
		            	"checklistId" : $('#sensor-checklist').val()
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
		            url: "<%=Config.this_SERVER_path%>/sensor",
		            data: { 
	            		"type" : "delete",
	            		"id" : row[0].sensorId 
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
        	센서 관리
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
          		센서 목록
          	</h3>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
					    <th>아이디</th>
						<th>센서명</th>
					    <th>값 타입</th>
					    <th>IP</th>
					    <th>프로토콜</th>
					    <th>패킷</th>
					    <th>타입 코드</th>
					    <th>연관선행요건ID</th>
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
      	<label for="sensor-id">센서아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="sensor-id">
		</div>
      	<label for="sensor-name">센서명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="sensor-name">
		</div>
      	<label for="sensor-valueType">값 타입</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="sensor-valueType">
		</div>
		<label for="sensor-IP">IP</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="sensor-IP">
		</div>
		<label for="sensor-protocol">프로토콜</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="sensor-protocol">
		</div>
		<label for="sensor-packet">패킷</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="sensor-packet">
		</div>
      	<label for="sensor-typeCode">타입코드</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="sensor-typeCode">
		</div>
		<label for="sensor-checklist">연관선행요건ID</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="sensor-checklist">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>