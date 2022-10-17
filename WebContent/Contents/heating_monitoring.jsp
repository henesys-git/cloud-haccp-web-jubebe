<!-- 가열공정 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">

	var ccpHeatingDataJspPage = {};
	var dataLength;
	$(document).ready(function () {
    	
		let date = new SetSingleDate2("", "#date", 0);
		let mainTable;
		let subTable;
		let mainTableSelectedRow;
		
		async function metalSensorList() {
			var itemList = new ItemList();
			var type_cd = "HM";	// 가열기 코드 대분류
			var sensorList = await itemList.getSensorList(type_cd);
	    	
	    	for(var i = 0; i < sensorList.length; i++) {
	    		sensorName = sensorList[i].sensorName;
	    		sensorId = sensorList[i].sensorId;
	    		$("#sensor-type").append("<option value = '"+sensorId+"'>"+sensorName+"</option>");
	    	}
	    };
		
	    metalSensorList();
	    
		async function getData() {
	    	var selectedDate = date.getDate();
	    	var processCode = "PC30";
	    	var sensorId = $("select[name=sensor-type]").val();
    		
	        var fetchedData = $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/ccpvm",
	            data: "method=heating-monitoring" +
	            	  "&date=" + selectedDate +
	            	  "&processCode=" + processCode +
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
			            url: "<%=Config.this_SERVER_path%>/ccpvm",
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
						{ data: "sensorName", defaultContent: '' },
						{ data: "productName", defaultContent: '' },
						{ data: "createTime", defaultContent: '' },
						{ data: "completeTime", defaultContent: '' },
						{ data: "state", defaultContent: '' }
			        ],
			        columnDefs : [
			        	{
			        		targets: [0],
			        		'createdCell':  function (td) {
			   	      			$(td).attr('style', 'display:none'); 
			   	   			}
			        	},
			   			{
				  			targets: [6],
				  			render: function(td, cellData, rowData, row, col){
				  				if (rowData.judge == '적합') {
				  					return 'n/a';
				  				} else {
				  					if(rowData.improvementAction != null && rowData.improvementAction != '') {
				  						return rowData.improvementAction;
				  					} else {
				  						return `<button class='btn btn-success fix-btn'>개선조치</button>`;
				  					}
				  				}
				  			}
				  		}
				    ]
			}
					
			mainTable = $('#ccpHeatingDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    ccpHeatingDataJspPage.fillSubTable = async function () {
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
					  						return `<button class='btn btn-success fix-btn'>개선조치</button>`;
					  					}
					  				}
					  			}
					  		}
					    ],
					    stateSave : true
				}
	    		
				subTable = $('#ccpHeatingDataSubTable').DataTable(
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
	    	
    		var ccpSign = new CCPSign();
    		var signInfo = await ccpSign.get(selectedDate, processCode);
    		
    		if(signInfo.checkerName != null) {
    			$("#ccp-sign-btn").hide();
    			$("#ccp-sign-text").text("서명 완료: " + signInfo.checkerName);
    		} else {
    			ccpHeatingDataJspPage.showSignBtn();
    		}
    	});
    	
    	$('#ccpHeatingDataTable tbody').on('click', 'tr', function () {
    		
    		if ( !$(this).hasClass('selected') ) {
    			mainTableSelectedRow = mainTable.row( this ).data();
    			ccpHeatingDataJspPage.fillSubTable();
            }
    	});
	    
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  	<div class="container-fluid">
    	<div class="row mb-2">
	      	<div class="col-sm-3">
	        	<h1 class="m-0 text-dark">
	        		가열공정 온도 모니터링
	        	</h1>
	      	</div>
	      	<div class="col-md-3 form-group">
				<label class="d-inline-block" for="sensor-type">종류:</label>
				<select class="form-control w-auto d-inline-block" id="sensor-type" name="sensor-type">
					<option value="HM%25">전체</option>
				</select>
	      	</div>
			<div class="col-md-3">
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
	          		가열공정 데이터 목록
	          	</h3>
	        </div>
	        <div class="col-md-6">
	        </div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpHeatingDataTable" style="width:100%">
				<thead>
					<tr>
						<th style = "display:none; width:0px;">센서key</th>
					    <th>센서명</th>
					    <th>제품</th>
					    <th>생성시간</th>
					    <th>완료시간</th>
					    <th>상태</th>
					</tr>
				</thead>
				<tbody id="ccpHeatingDataTableBody">
				</tbody>
			</table>
          </div> 
           
         <div class="card-body" id = "ccpHeatingsubTable">
          
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