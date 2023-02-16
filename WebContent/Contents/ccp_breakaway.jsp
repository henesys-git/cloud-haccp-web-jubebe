<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
	
	var ccpBreakawayJSPPage = {};
	var startDate;
	var endDate;
	
	$(document).ready(function () {
		var mainTable;
		var date = new SetRangeDate("dateParent", "date", 30);
	    
		async function CCPList() {
			var itemList = new ItemList();
			var type_cd = "PC";
			var ccpList = await itemList.getCCPList(type_cd);
	    	for(var i = 0; i < ccpList.length; i++) {
	    		ccpName = ccpList[i].sensorName;
	    		ccp = ccpList[i].sensorId;
	    		$("#ccp-type").append("<option value = '"+ccp+"'>"+ccpName+"</option>");
	    	}
	    };
	    
	    CCPList();
	    
		async function getSensorList() {
			var itemList = new ItemList();
			var sensorList = await itemList.getSensorListAll();

	    	for(var i = 0; i < sensorList.length; i++) {
	    		sensorName = sensorList[i].sensorName;
	    		sensorId = sensorList[i].sensorId;
	    		$("#sensor-type").append("<option value = '"+sensorId+"'>"+sensorName+"</option>");
	    	}
	    	
	    };
	    
	    getSensorList();
		
		async function getData() {
			
			var dateVal = $("#date").val();
			startDate = dateVal.substr(0, 10);
			endDate = dateVal.substr(13, 10);
			
	    	var processCode = $("#ccp-type option:selected").val();
	    	var sensorType = $("#sensor-type option:selected").val();
	    	var fetchedData = $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/ccpvm",
	            data: "method=metal-breakaway" +
	            	  "&toDate=" + startDate +
	            	  "&fromDate=" + endDate +
	            	  "&sensorId=" + sensorType +
	            	  "&processCode=" + processCode,
	            success: function (result) {
	            	return result;
	            }
	        });

	        return fetchedData;
	    };
	  
	    async function initTable() {
	    	var data = await getData();
			
	    	var customOpts = {
				data: data,
				pageLength: 10,
				stateSave : true,
				columns: [
					{ data: "sensorKey", defaultContent: '' },
					{ data: "sensorName", defaultContent: '' },
					{ data: "productName", defaultContent: '' },
					{ data: "createTime", defaultContent: '' },
					{ data: "event", defaultContent: '' },
					{ data: "sensorValue", defaultContent: '' },
					{ data: "judge", defaultContent: '' },
					{ data: "improvementAction", defaultContent: '' },
					{ data: "sensorId", defaultContent: '' }
		        ],
		        columnDefs : [
		        	{
		        		targets: [0,6,8],
		        		'createdCell': function(td, cellData, rowData, row, col){
		        			$(td).attr('style', 'display:none;');
			  			}
		        	},
		        	{
			  			targets: [5],
			  			render: function(td, cellData, rowData, row, col){
			  				if(rowData.sensorId.includes('CD') == true) {
			  					if (rowData.sensorValue == '1') {
			  						return '검출';
			  					} else {
			  						return '비검출';
			  					}
			  				}
			  				else {
			  					return rowData.sensorValue;
			  				}
			  			}
			  		},
		   			{
			  			targets: [7],
			  			render: function(td, cellData, rowData, row, col){
		  					if(rowData.improvementAction != null && rowData.improvementAction != '') {
		  						return rowData.improvementAction;
		  					} else {
		  						return `<button class='btn btn-success fix-btn'>개선조치</button>`;
		  					}
			  			}
			  		}
			    ],
			    stateSave : true
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);

	    	mainTable.draw();
	    }

	    initTable();
	    
	    ccpBreakawayJSPPage.refreshTable = async function () {
			var newData = await getData();
			mainTable.clear().rows.add(newData).draw();
		}
		
		// 조회 버튼 클릭 시
    	$("#getDataBtn").click(function() {
    		ccpBreakawayJSPPage.refreshTable();
    	});
    	
    	//개선조치
    	$('#ccpDataTableBody').off().on('click', 'button', function() {
			var tr = $(this).parents('tr')[0];
			var row = mainTable.rows(tr).data()[0];
			
    		var sensorKey = row.sensorKey;
    		var createTime = row.createTime;
    		
    		var selectedDate = createTime.toString().substr(0, 10);
	    	var processCode = $("#ccp-type option:selected").val();
    		
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
		
    	// 일괄 개선조치 버튼 클릭 시
    	$("#improve-all-btn").click(function() {
    		var toDate = $('#date').val();
    		
    		var selectedDate = toDate.toString().substr(0, 10);
    		var selectedDate2 = toDate.toString().substr(13);
	    	var processCode = $("#ccp-type option:selected").val();
    		
    		$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/fixLimitOut.jsp',
                data: {
                	date: selectedDate,
                	date2: selectedDate2,
                	processCode: processCode,
                	limitOutParam : "All",
                },
                success: function (html) {
                    $("#modalWrapper").html(html);
                }
            });
    	});
    	
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  	<div class="container-fluid">
    	<div class="row mb-2">
	      	<div class="col-sm-3">
	        	<h1 class="m-0 text-dark">
	        		CCP 이탈 데이터 관리
	        	</h1>
	      	</div>
	      	<div class="col-md-3 form-group">
				<label class="d-inline-block" for="ccp-type">CCP 타입:</label>
				<select class="form-control w-auto d-inline-block" id="ccp-type">
					<!-- <option value='%25'>전체</option> -->
					<option value=''>전체</option>
				</select>
	      	</div>
	      	<div class="col-md-3 form-group">
				<label class="d-inline-block" for="sensor-type">센서명:</label>
				<select class="form-control w-auto d-inline-block" id="sensor-type">
					<option value='%25'>전체</option>
				</select>
	      	</div>
			<div class="col-md-2 input-group" id = 'dateParent'>
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
	          		CCP 이탈 데이터 목록
	          	</h3>
	        </div>
	        <div class="col-md-6">
	        	<div class="float-right" id="ccp-sign-btn-wrapper">
		          	<button class='btn btn-success' id="improve-all-btn">
		          	일괄 개선조치
		          	</button>
		          	<div id="ccp-sign-text">
		          	</div>
	        	</div>
	        </div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
					    <th style = 'width:0px; display:none;'>묶음값</th>
					    <th>센서명</th>
					    <th>제품명</th>
					    <th>생성시간</th>
					    <th>이벤트</th>
					    <th>측정값</th>
					    <th style = 'width:0px; display:none;'>적/부</th>
					    <th>개선조치</th>
					    <th style = 'width:0px; display:none;'>센서Id</th>
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

<div id="modalWrapper"></div>