<!-- 스마트HACCP 관리시스템(shm) 표준모듈 API 연동 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">

	var shmApiJspPage = {};
	var dataLength;
	
	$(document).ready(function () {
    	
		let date = new SetSingleDate2("", "#date", 0);
		let mainTable;
		let subTable;
		let mainTableSelectedRow;
		
		async function metalSensorList() {
			var itemList = new ItemList();
			var sensorList = await itemList.getSensorListAll();
	    	
	    	for(var i = 0; i < sensorList.length; i++) {
	    		sensorName = sensorList[i].sensorName;
	    		sensorId = sensorList[i].sensorId;
	    		$("#sensor-type").append("<option value = '"+sensorId+"'>"+sensorName+"</option>");
	    	}
	    };
		
	    metalSensorList();
	    
		async function getData() {
	    	var selectedDate = date.getDate();
	    	var testYN = $("input[name='test-yn']:checked").val();
	    	var sensorId = $("select[name=sensor-type]").val();
    		
	        var fetchedData = $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/shm/ccpvm",
	            data: "method=head" +
	            	  "&date=" + selectedDate +
	            	  "&testYN=" + testYN +
	            	  "&sensorId=" + sensorId,
	            success: function (result) {
	            	return result;
	            }
	        });

	        return fetchedData;
	    };
	    
	    async function getSubData(sensorKey) {
	    	
	        var fetchedData = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/shm/ccpvm",
			            data: "method=detail" +
			            	  "&sensorKey=" + sensorKey,
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedData;
	    };
	    
	    async function initTable() {
	    	var data = await getData();
			
	    	dataLength = data.length;
	    	
	    	var customOpts = {
					data : data,
					pageLength: 10,
					columns: [
						{ data: "sensorKey", defaultContent: '' },
						{ data: "processName", defaultContent: '' },
						{ data: "sensorName", defaultContent: '' },
						{ data: "productName", defaultContent: '' },
						{ data: "createTime", defaultContent: '' },
						{ data: "judge", defaultContent: '' },
						{ data: "improvementCompletion", defaultContent: '' },
						{ data: "shmSentYn", defaultContent: '' },
						{ data: "shmCcpType", defaultContent: '' }
			        ],
			        columnDefs : [
				  		{
				  			targets: [7],
				  			render: function(td, cellData, rowData, row, col){
				  				if(rowData.shmSentYn === 'Y') {
				  					return '전송 완료';
				  				}
				  				else {
					  				return `<button class='btn btn-success send-btn'>인증원전송</button>`;
				  				}
				  			}
				  		},
				  		{
				  			targets: 8,
				  			visible: false,
				  			searchable: false
				  		}
				    ],
			}
					
			mainTable = $('#shmApiTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    shmApiJspPage.fillSubTable = async function () {
	    	var data = await getSubData(mainTableSelectedRow.sensorKey);
	    	
	    	if(subTable) {
	    		// redraw
	    		subTable.clear().rows.add(data).draw();
	    	} else {
	    		// initialize
			    var option = {
						data : data,
						columns: [
							{ data: "sensorName", defaultContent: '' },
							{ data: "createTime", defaultContent: '' },
							{ data: "event", defaultContent: '' },
							{ data: "sensorValue", defaultContent: '' },
							{ data: "judge", defaultContent: '' },
							{ data: "improvementAction", defaultContent: '' }
				        ],
				        columnDefs : [
				        	{
					  			targets: [3],
					  			render: function(td, cellData, rowData, row, col){
					  				return rowData.sensorValue;
					  			}
					  		},
				   			{
					  			targets: [5],
					  			render: function(td, cellData, rowData, row, col){
					  				if (rowData.judge == '적합') {
					  					return 'n/a';
					  				} else {
					  					if(rowData.improvementAction != null && rowData.improvementAction != '') {
					  						return rowData.improvementAction;
					  					} else {
					  						return `<button class="btn btn-success fix-btn">
					  									개선조치
					  								</button>`;
					  					}
					  				}
					  			}
					  		}
					    ],
					    stateSave : true
				}
	    		
				subTable = $('#shmApiSubTable').DataTable(
					mergeOptions(heneMainTableOpts, option)
				);
	    	}
	    };
	    
		initTable();
		
		async function refreshMainTable() {
			var newData = await getData();

			mainTable.clear().rows.add(newData).draw();
			dataLength = newData.length;
			
    		if(subTable) {
	    		subTable.clear().draw();
	    	}
		}
    	
		// 조회 버튼 클릭 시
    	$("#getDataBtn").click(async function() {
    		refreshMainTable();
    		var selectedDate = date.getDate();
	    	var processCode = $("input[name='test-yn']:checked").val();
    	});
    	
    	$('#shmApiTable tbody').on('click', 'tr', function (e) {
    		
    		if ( !$(this).hasClass('selected') ) {
    			mainTableSelectedRow = mainTable.row( this ).data();
    			shmApiJspPage.fillSubTable();
            }
    	});
    	
    	// 개선조치
    	$('#shmApiSubTableBody').off().on('click', 'button', function() {
    		
    		let sensorKey = mainTableSelectedRow.sensorKey;
    		let subRow = subTable.row( $(this).closest('tr') ).data();
    		let createTime = subRow.createTime;
    		let selectedDate = date.getDate();
	    	let processCode = $("input[name='test-yn']:checked").val();
    		
    		$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/fixLimitOut.jsp',
                data: {
                	sensorKey: sensorKey,
                	createTime: createTime,
                	date: selectedDate,
                	processCode: processCode
                },
                success: function (html) {
                    $("#modalWrapper").html(html);
                }
            });
    	});
    	
    	// 인증원 전송
		$('#shmApiTable').off().on('click', '.send-btn', function(e) {
			e.stopPropagation();
			
			if(mainTableSelectedRow.improvementCompletion == '미완료') {
				alert('개선조치를 해주세요');
				return;
			}
			
    		let sensorKey = mainTableSelectedRow.sensorKey;
    		let shmCcpType = mainTableSelectedRow.shmCcpType;
    		
    		$.ajax({
                type: "GET",
                url: heneServerPath + '/shm',
                data: { sensorKey: sensorKey, shmCcpType: shmCcpType },
                success: function (rslt) {
                	console.log(rslt);
                	if(rslt.code == 200) {
                		refreshMainTable();
	                	alert(rslt.message);
                	} else if(rslt.code == 500) {
	                	alert(rslt.error);
                	} else {
                		alert('오류: 관리자에게 문의해주세요');
                	}
                }
            });
    	});
    	
    	$('#send-all-btn').click(async function() {
    		var selectedDate = date.getDate();
	    	var testYN = $("input[name='test-yn']:checked").val();
    		
	    	if(dataLength < 1) {
    			alert('전송할 데이터가 없습니다.');
    			return false;
    		}
	    	
	    	//TODO: 일괄 전송 기능 구현
    	});
	    
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  	<div class="container-fluid">
    	<div class="row mb-2">
	      	<div class="col-sm-3">
	        	<h1 class="m-0 text-dark">
	        		인증원 API
	        	</h1>
	      	</div>
	      	<div class="col-md-3 form-group">
				<label class="d-inline-block" for="sensor-type">종류:</label>
				<select class="form-control w-auto d-inline-block" id="sensor-type" name="sensor-type">
					<option value="%25">전체</option>
				</select>
	      	</div>
			<div class="col-md-3">
		      	<div class="form-check-inline">
				    <label class="form-check-label">
				      <input type="radio" class="form-check-input" name="test-yn" value="CCP_OPERATE" disabled>운영
				    </label>
				</div>
				<div class="form-check-inline">
				    <label class="form-check-label">
				      <input type="radio" class="form-check-input" name="test-yn" value="CCP_TEST" checked>테스트
				    </label>
				</div>
       	  	</div>
        	  
			<div class="col-md-2 input-group">
	         	  	<input type="text" class="form-control float-right" id="date">
			</div>
		
			<div class="col-md-1">
	   	  		<button type="submit" class="btn btn-success" id="getDataBtn">
	   	  	    	<i class="fas fa-search"></i>
	   	  	     	조회
	   	  	  	</button>
	   	  	</div>
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
          <div class="card-header row">
       		<div class="col-md-6">
	          	<h3 class="card-title">
	          		<i class="fas fa-edit" id="InfoContentTitle"></i>
	          		CCP 데이터 목록
	          	</h3>
	        </div>
	        <div class="col-md-6">
	        	<div class="float-right" id="send-all-btn-wrapper">
		          	<button class='btn btn-success' id="send-all-btn" disabled>
		          		<i class='fas fa-signature'></i>
		          		일괄 전송
		          	</button>
	        	</div>
	        </div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="shmApiTable" style="width:100%">
				<thead>
					<tr>
					    <th>묶음값</th>
					    <th>공정</th>
					    <th>센서명</th>
					    <th>제품</th>
					    <th>생성시간</th>
					    <th>적/부</th>
					    <th>개선완료</th>
					    <th>전송</th>
					    <th>CCP코드(인증원)</th>
					</tr>
				</thead>
				<tbody id="shmApiTableBody">
				</tbody>
			</table>
          </div> 
           
         <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="shmApiSubTable" style="width:100%">
				<thead>
					<tr>
					    <th>센서명</th>
					    <th>생성시간</th>
					    <th>이벤트</th>
					    <th>측정값</th>
					    <th>적/부</th>
					    <th>개선조치</th>
					</tr>
				</thead>
				<tbody id="shmApiSubTableBody">
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

<div id="modalWrapper"></div>