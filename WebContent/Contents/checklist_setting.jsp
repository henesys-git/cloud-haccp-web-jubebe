<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
    
    var mainTable;
    
	$(document).ready(function () {
		
	    async function initTable() {
	    	var clInfo = new ChecklistInfo();
	    	var clList = await clInfo.getAll();
	    	
		    var customOpts = {
					data : clList,
					pageLength: 10,
					columns: [
						{ data: "checklistId", defaultContent: '' },
						{ data: "revisionNo", defaultContent: '' },
						{ data: "checklistName", defaultContent: '' },
						{ data: "imagePath", defaultContent: '' },
						{ data: "metaDataFilePath", defaultContent: '' },
						{ data: "signatureType", defaultContent: '' },
						{ data: "checkInterval", defaultContent: '' },
						{ data: "", defaultContent: '' }
			        ],
			        'columnDefs': [
			        	{
							'targets': [5],
				   			'createdCell':  function (td, cellData, rowData, rowinx, col) {
				   				var a = "";
				   				if(cellData != null) {
				   					a = cellData.replace('WRITE', '작성자').replace('APPRV', '승인자').replace('CHECK', '확인자');
				   				}
				   				$(td).text(a); 
				   			}
						},
			        	{
							'targets': [6],
				   			'createdCell':  function (td, cellData, rowData, rowinx, col) {
				   				$(td).attr('style', 'display: none;'); 
				   			}
						},
			        	{
							'targets': [7],
				   			'createdCell':  function (td, cellData, rowData, rowinx, col) {
				      			//$(td).append('<button type="button" class="btn btn-warning" id="alarm">알람주기 설정</button>');
				   				$(td).append('<button type="button" class="btn btn-warning" id="alarm" onclick = "modifyAlarmInfo(this);">알람주기 설정</button>');
				   			}
						}
			        ]
			}
					
			mainTable = $('#checklistInfoTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    
	    
	    async function refreshMainTable() {
	    	var clInfo = new ChecklistInfo();
	    	var clList = await clInfo.getAll();
	    	
    		mainTable.clear().rows.add(clList).draw();
		}
	    
	    var initModal = function () {
	    	$('#checklist-id').prop('disabled', false);
	    	$('#checklist-id').val('');
	    	$('#checklist-name').val('');
	    	$('#image-path').val('');
	    	$('#metadata-file-path').val('');
	    	
	    };
	    
	    var initModal2 = function () {
	    	$('#checklist-id-alarm').prop('disabled', false);
	    	$('#checklist-id-alarm').val(row[0].checklistId);
	    	$('#checklist-name-alarm').val(row[0].checklistName);
	    	$('#alarm-interval-hour').val(0);
	    	
	    };
	    
	    var initModal3 = function () {
	    	$('#checklist-id2').prop('disabled', false);
	    	$('#checklist-name').prop('disabled', false);
	    	$('#checklist-id2').val('');
	    	$('#checklist-name2').val('');
	    	$('#sign-writer').prop("checked", false);
	    	$('#sign-approver').prop("checked", false);
	    	$('#sign-checker').prop("checked", false);
	    	
	    };
	    
		initTable();
		
		// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#myModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#save').off().click(function() {
				var id = $('#checklist-id').val();
				var name = $('#checklist-name').val();
				var imagePath = $('#image-path').val();
				var metaDataFilePath = $('#metadata-file-path').val();
				
				if(id === '') {
					alert('선행요건 아이디를 입력해주세요');
					return false;
				}
				if(name === '') {
					alert('선행요건 명을 입력해주세요');
					return false;
				}
				if(imagePath === '') {
					alert('이미지 경로를 입력해주세요');
					return false;
				}
				if(metaDataFilePath === '') {
					alert('메타데이터 경로를 입력해주세요');
					return false;
				}
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/checklist-info",
		            data: {
		            	"type" : "insert",
		            	"id" : id, 
		            	"name" : name, 
		            	"imagePath" : imagePath, 
		            	"metaDataFilePath" : metaDataFilePath
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
				alert('수정할 선행요건을 선택해주세요.');
				return false;
			}
			
			$('#myModal').modal('show');
			$('.modal-title').text('수정');
			
			$('#checklist-id').val(row[0].checklistId);
			$('#checklist-name').val(row[0].checklistName);
			$('#image-path').val(row[0].imagePath);
			$('#metadata-file-path').val(row[0].metaDataFilePath);
			
			$('#checklist-id').prop('disabled', true);
			
			$('#save').off().click(function() {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/checklist-info",
		            data: { 
	            		"type" : "update",
	            		"id" : row[0].checklistId,
	            		"name" : $('#checklist-name').val(),
	            		"imagePath" : $('#image-path').val(),
	            		"metaDataFilePath" : $('#metadata-file-path').val(),
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
			});
		});
		
		// 삭제
		$('#delete').click(function() {
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('삭제할 제품을 선택해주세요.');
				return false;
			}
			
			if(confirm('삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/checklist-info",
		            data: { 
	            		"type" : "delete",
	            		"id" : row[0].checklistId 
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
		
		// 점검표 알람 수정
		$('#alarm').click(function() {
			console.log("click");
			initModal2();
			
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('알람 정보를 수정할 선행요건을 선택해주세요.');
				return false;
			}
			
			$('#myModal2').modal('show');
			$('.modal-title').text('선행요건 알람 정보 수정');
			
			$('#save_alarm').off().click(function() {
				var id = $('#checklist-id-alarm').val();
				var name = $('#checklist-name-alarm').val();
				var alarmYear = $('#alarm-interval-year').val();
				var alarmMonth = $('#alarm-interval-month').val();
				var alarmDay = $('#alarm-interval-day').val();
				var alarmHour = $('#alarm-interval-hour').val();

				if(id === '') {
					alert('선행요건 아이디를 입력해주세요');
					return false;
				}
				if(name === '') {
					alert('선행요건 명을 입력해주세요');
					return false;
				}
				if(alarmHour <= 0) {
					alert('주기값이 입력되지 않았습니다.');
					return false;
				}
				
				var check = confirm('해당 선행요건 알람 정보를 수정하시겠습니까?');
				
				if(check) {
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/checklist-info",
		            async : false,
		            data: {
		            	"type" : "alarm",
		            	"id" : id, 
		            	"name" : name, 
		            	"alarmInterval" : alarmTotal
		            },
		            success: function (alarmResult) {
		            	console.log(alarmResult);
		            	if(alarmResult == 'true') {
		            		alert('선행요건 정보가 수정되었습니다.');
		            		$('#myModal2').modal('hide');
		            		refreshMainTable();
		            	} else {
		            		alert('선행요건 수정에 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
			   }
			});
			
		});
		
		// 서명항목 설정
		$('#sign').click(function() {
			initModal3();
			
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('서명항목을 설정할 선행요건을 선택해주세요.');
				return false;
			}
			
			$('#myModal3').modal('show');
			$('.modal-title').text('서명항목설정');
			
			$('#checklist-id2').val(row[0].checklistId);
			$('#checklist-name2').val(row[0].checklistName);
			
			var signData1;
			var signData2;
			var signData3;
			console.log(row[0].signatureType);
			console.log(row[0].signatureType == null);
			
			if(row[0].signatureType != null) {
			
				signData1 = row[0].signatureType.includes('WRITE');
				signData2 = row[0].signatureType.includes('APPRV');
				signData3 = row[0].signatureType.includes('CHECK');
			}
			
			else {
				signData1 = "";
				signData2 = "";
				signData3 = "";
			}
			
			if(signData1 == true) {
				$('#sign-writer').prop("checked", true);
			}
			if(signData2 == true) {
				$('#sign-approver').prop("checked", true);
			}
			if(signData3 == true) {
				$('#sign-checker').prop("checked", true);
			}
			
			$('#checklist-id2').prop('disabled', true);
			$('#checklist-name2').prop('disabled', true);
			
			$('#save_sign').off().click(function() {
				var id = $('#checklist-id2').val();
				
				var arr = new Array();
				
				if($('input:checkbox[id="sign-writer"]').is(":checked") == true) {
					arr.push($('#sign-writer').val());
				}
				if($('input:checkbox[id="sign-approver"]').is(":checked") == true) {
					arr.push($('#sign-approver').val());
				}
				if($('input:checkbox[id="sign-checker"]').is(":checked") == true) {
					arr.push($('#sign-checker').val());
				}
				
				
				var arrStr = arr.toString();
				console.log(arrStr);
				
				var check = confirm('서명정보를 설정하시겠습니까?');
				
				if(check) {
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/checklist-info",
		            data: {
		            	"type" : "sign",
		            	"id" : id,
		            	"signData" : arrStr 
		            },
		            success: function (insertResult) {
		            	if(insertResult == 'true') {
		            		console.log(insertResult);
		            		alert('등록되었습니다.');
		            		$('#myModal3').modal('hide');
		            		refreshMainTable();
		            	} else {
		            		alert('등록 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
				
				}
				
			});
		});
		
    }); //document ready function end
    
	//점검표 알람 정보 수정
	function modifyAlarmInfo(obj) {
		
    	var rowIdx = $(obj).closest("tr").index();
		//var row = mainTable.rows( '.selected' ).data();
		var row = mainTable.rows(rowIdx).data();
		var interVal = row[0].checkInterval;
		console.log(interVal);
		
		var interValYear = Math.floor(interVal / 8760); // 알람주기 연단위 값
		var interValMonth; // 알람주기 월단위 값
		var interValDay; // 알람주기 일단위 값
		var interValHour; // 알람주기 시간단위 값
		
		if(interVal >= 8760) {
		 	interValMonth =  Math.floor(((parseInt(interVal) - 8760) * interValYear) / 720); 
		}
		else {
			interValMonth = Math.floor(interVal / 720); 
		}
		
		if(interVal >= 8760) {
		 	interValMonth =  Math.floor(((parseInt(interVal) - 8760) * interValYear) / 720); 
		}
		else {
			interValMonth = Math.floor(interVal / 720); 
		}
		
		var interValDay = Math.floor(interVal % (30 * 24)); 
		var interValHour = Math.floor(interVal % 24); 
		
		var initModal2 = function () {
	    	$('#checklist-id-alarm').prop('disabled', false);
	    	$('#checklist-id-alarm').val(row[0].checklistId);
	    	$('#checklist-name-alarm').val(row[0].checklistName);
	    	$('#alarm-interval-year').val(0);
	    	$('#alarm-interval-month').val(0);
	    	$('#alarm-interval-day').val(0);
	    	$('#alarm-interval-hour').val(0);
	    	
	    };
		
		initModal2();
		
		$('#myModal2').modal('show');
		$('.modal-title').text('선행요건 알람 정보 수정');
		
		$('#save_alarm').off().click(function() {
			var id = $('#checklist-id-alarm').val();
			var name = $('#checklist-name-alarm').val();
			var alarmYear = $('#alarm-interval-year').val();
			var alarmMonth = $('#alarm-interval-month').val();
			var alarmDay = $('#alarm-interval-day').val();
			var alarmHour = $('#alarm-interval-hour').val();
			
			var alarmTotal = parseInt(alarmHour) + parseInt(alarmDay * 24) + parseInt(alarmMonth * 24 * 30) + parseInt(alarmYear * 24 * 30 * 12);
			console.log("alarmTotal==");
			console.log(alarmTotal);
			
			$("#alarm-interval-year").keyup(function() { 
			});
			
			$("#alarm-interval-month").keyup(function() { 
			});
			
			$("#alarm-interval-day").keyup(function() { 
			});
			
			$("#alarm-interval-hour").keyup(function() { 
			});
			
			if(id === '') {
				alert('선행요건 아이디를 입력해주세요');
				return false;
			}
			if(name === '') {
				alert('선행요건 명을 입력해주세요');
				return false;
			}
			if(alarmHour <= 0) {
				alert('주기값이 입력되지 않았습니다.');
				return false;
			}
			
			var check = confirm('해당 선행요건 알람 정보를 수정하시겠습니까?');
			
			if(check) {
			
			$.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/checklist-info",
	            async : false,
	            data: {
	            	"type" : "alarm",
	            	"id" : id, 
	            	"name" : name, 
	            	"alarmInterval" : alarmTotal
	            },
	            success: function (alarmResult) {
	            	console.log(alarmResult);
	            	if(alarmResult == 'true') {
	            		alert('선행요건 정보가 수정되었습니다.');
	            		$('#myModal2').modal('hide');
	            		refreshMainTable2();
	            	} else {
	            		alert('선행요건 수정에 실패했습니다, 관리자에게 문의해주세요.');
	            	}
	            }
	        });
		   }
		});
		
	}
	
	async function refreshMainTable2() {
    	var clInfo = new ChecklistInfo();
    	var clList = await clInfo.getAll();
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
        	선행요건 관리
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
      	  <button type="button" class="btn btn-primary" id="sign">
      	  	서명항목설정
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
          		선행요건 목록
          	</h3>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="checklistInfoTable" style="width:100%">
				<thead>
					<tr>
					    <th>선행요건아이디</th>
					    <th>수정이력번호</th>
					    <th>선행요건명</th>
					    <th>이미지경로</th>
					    <th>메타데이터경로</th>
					    <th>서명항목</th>
					    <th style='width:0px; display: none;'>작성주기값</th>
					    <th></th>
					</tr>
				</thead>
				<tbody id="checklistInfoTableBody">		
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
      	<label for="checklist-id">선행요건아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="checklist-id">
		</div>
      	<label for="checklist-name">선행요건명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="checklist-name">
		</div>
      	<label for="image-path">이미지경로</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="image-path">
		</div>
      	<label for="metadata-file-path">메타데이터경로</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="metadata-file-path">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>

<!-- alarm modal -->
<div class="modal fade" id="myModal2" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title"></h4>  
      </div>  
      <div class="modal-body">
      	<label for="checklist-id-alarm">선행요건아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="checklist-id-alarm">
		</div>
      	<label for="checklist-name-alarm">선행요건명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="checklist-name-alarm">
		</div>
      	<label for="alarm-interval">알람주기</label>
		<div class="input-group mb-3">
		  <div class="alarm-interval" id ="alarm_interval">
		  	<h6>작성 후</h6>
		  </div>
		</div>
		<div class="input-group mb-3" style = "width:50%;">
		  <input type="number" class="form-control" id="alarm-interval-year" min="1" max ="99"><label for="alarm-interval-year">년</label> &nbsp;&nbsp;
		  <input type="number" class="form-control" id="alarm-interval-month" min="1" max ="11"><label for="alarm-interval-month">월</label> 
		</div> 
		<div class="input-group mb-3" style = "width:50%;">
		  <input type="number" class="form-control" id="alarm-interval-day" min="1" max ="29"><label for="alarm-interval-day">일</label> &nbsp;&nbsp;
		  <input type="number" class="form-control" id="alarm-interval-hour" min="1" max ="23"><label for="alarm-interval-hour">시간</label>
		</div>
		<div class="input-group mb-3">
			<h6>마다 알람이 전송됩니다.</h6>
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save_alarm">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>
<!-- Sign Setting Modal -->  
<div class="modal fade" id="myModal3" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title"></h4>  
      </div>  
      <div class="modal-body">
      	<label for="checklist-id2">선행요건아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="checklist-id2">
		</div>
      	<label for="checklist-name2">선행요건명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="checklist-name2">
		</div>
      	<label for="image-path">서명 항목</label>
		<div class="input-group mb-3">
		  작성자 <input type="checkbox" class="form-control" id="sign-writer" value = "WRITE">
		  승인자<input type="checkbox" class="form-control" id="sign-approver" value = "APPRV">
		  확인자 <input type="checkbox" class="form-control" id="sign-checker" value = "CHECK">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save_sign">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>