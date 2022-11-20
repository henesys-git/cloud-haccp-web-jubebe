<!-- 가열공정 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<style>
	.chartWrapper {
 position: relative;
}

.chartWrapper > canvas {
  position: absolute;
  left: 0;
  top: 0;
  pointer-events: none;
}

.chartAreaWrapper {
  min-width: 1000px;
  overflow-x: scroll;
}

</style>
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
	    
	    async function getSubData(sensorKey, sensorId) {
	    	
	        var fetchedData = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/ccpvm",
			            data: "method=heating-monitoring-detail" +
			            	  "&sensorKey=" + sensorKey + 
			            	  "&sensorId=" + sensorId,
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
						{ data: "state", defaultContent: '' },
						{ data: "sensorId", defaultContent: '' }
			        ],
			        columnDefs : [
			        	{
			        		targets: [0,6],
			        		'createdCell':  function (td) {
			   	      			$(td).attr('style', 'display:none'); 
			   	   			}
			        	}
				    ]
			}
					
			mainTable = $('#ccpHeatingDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    ccpHeatingDataJspPage.fillSubTable = async function () {
	    	
	    	$("#ccpHeatingsubTable").children().remove();
	    	
	    	var tpSensorId = "TP" + mainTableSelectedRow.sensorId.substr(2,3);
	    	console.log(tpSensorId);
	    	
	    	var data = await getSubData(mainTableSelectedRow.sensorKey, tpSensorId);
	    	console.log(data);
	    	console.log(data[0].sensorName);
	    	
	    	$("#ccpHeatingsubTable").append(
	    	`
	    	<div class="card-header row">
       				<div class="col-md-6">
	          			<h3 class="card-title">
	          				<i class="fas fa-edit" id="InfoContentTitle"></i>
	          				온도 데이터 그래프
	          				</h3>
	        		</div>
	         	<div class="col-md-6">
	        	</div>
          	</div>
	    	<div>
	        	<div class="card card-success">
	          		<div class="card-header" style="min-width:1000px;"">
	            		<h3 class="card-title" id = "title">`+data[0].sensorName+`</h3>
	
	            	<div class="card-tools">
	              		<button type="button" class="btn btn-tool" data-card-widget="collapse"><i class="fas fa-minus"></i>
	              		</button>
	              	<button type="button" class="btn btn-tool" data-card-widget="remove"><i class="fas fa-times"></i></button>
	            	</div>
	          		</div>
	          	<div class="card-body" style="min-width:1000px;">
	            <div class="chart chartAreaWrapper">
	              <canvas id="target" style="min-height: 350px; height: 350px; max-height: 250px; min-width: 1000px;"></canvas>
	            </div>
	          </div>
	        </div>
	      </div>
	    	`
	    	);
	    	
	    	//document.getElementById('title').innerHTML(data[0].sensorName);
	    	//$('#title').innerText(data.sensorName);
	    	
	    		// graph initialize
	    		
	    		/* db data processing */
	    		console.log(data);
	    		console.log(data[0]);
	    		var arr = data;
	    		var censor_info = data;
	    				
	    		var customOptions = {
	    				legend: { display: false },
	    				scales: {
	    					xAxes: [{
	    			            scaleLabel: {
	    			            	stacked: true,
	    			            	display: true,
	    			                labelString: "측정시간",
	    			                fontColor: "black"
	    			            }
	    			        }],
	    			        yAxes: [{
	    			            display: true,
	    			            stacked: true,
	    			            ticks: {
	    			                min: 0,
	    			                max: 200
	    			            },
	    			            scaleLabel: {
	    			            	display: true,
	    			                labelString: "온도(°C)",
	    			                fontColor: "red"
	    			            }
	    			        }]
	    			    }
	    			};
	    		
	    		
	    		// db에서 받은 데이터 [온도계 종류, 측정 시간, 온도값]의 이중 배열
	    		// 이걸 온도계별로 시간 배열과 온도값 배열을 가지는 객체로 변환한다
	    		var processData = function(arr, key) {
	    		    var newObj = new Object();
	    		    
	    		    var temp = arr.filter(function(arr) {
	    		    		return arr.sensorName == key;
	    		        });
	    		    newObj.time = temp.map(arr => arr.eachMinute);
	    		    newObj.value = temp.map(arr => arr.sensorValue);
	    		    newObj.minValue = temp.map(arr => arr.minValue);
	    		    newObj.maxValue = temp.map(arr => arr.maxValue);
	    		    console.log(newObj);
	    		    return newObj;
	    		   
	    		}
				
				
	    		for(var temp = 0; temp < 1; temp++){
	    						
	    			var tempVal = processData(arr, censor_info[temp].sensorName);
	    			var tempCtx = $('#target').get(0).getContext('2d');
	    			console.log(tempVal.minValue);
	    			console.log(tempVal.maxValue);
	    			var chart = new Chart(tempCtx, { 
	    				type: 'line',
	    				data: {
	    					labels: tempVal.time,
	    					datasets: [
	    					{	
	    						label : "온도",
	    						type : 'line',
	    						data: tempVal.value,
	    						fill: false,
	    						borderColor: "#"+ Math.round(Math.random() * 0xFFFFFF).toString(16)
	    					}/*,
	    					{
	    						label : "한계기준최소온도",
	    						type : 'line',
	    						data: tempVal.minValue,
	    						fill: false,
	    						borderColor: "#"+ Math.round(Math.random() * 0xFFFFFF).toString(16)
	    					},
	    					{
	    						label : "한계기준최대온도",
	    						type : 'line',
	    						data: tempVal.maxValue,
	    						fill: false,
	    						borderColor: "#"+ Math.round(Math.random() * 0xFFFFFF).toString(16)
	    					}*/
	    					]
	    				},
	    				options: customOptions
	    			});
	    			
	    		}
	    		
	    };
	    
	    
		initTable();
		
		async function refreshMainTable() {
			var newData = await getData();

			mainTable.clear().rows.add(newData).draw();
			dataLength = newData.length;
			
			/*
    		if(subTable) {
	    		subTable.clear().draw();
	    	}
			*/
		}
    	
		// 조회 버튼 클릭 시
    	$("#getDataBtn").click(async function() {
    		refreshMainTable();
    		
    		var selectedDate = date.getDate();
	    	var processCode = "PC30";
	    	/*
    		var ccpSign = new CCPSign();
    		var signInfo = await ccpSign.get(selectedDate, processCode);
    		
    		if(signInfo.checkerName != null) {
    			$("#ccp-sign-btn").hide();
    			$("#ccp-sign-text").text("서명 완료: " + signInfo.checkerName);
    		} else {
    			ccpHeatingDataJspPage.showSignBtn();
    		}
    		*/
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
					    <th style = "display:none; width:0px;">센서ID</th>
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