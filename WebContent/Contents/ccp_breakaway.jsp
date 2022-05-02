<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">

	var ccpMetalDataJspPage = {};
	var startDate;
	var endDate;
	var mainTable;
	$(document).ready(function () {
    	
		var date = new SetRangeDate("dateParent", "date", 30);
		//startDate = date.start.format('YYYY-MM-DD');
	    //endDate = date.end.format('YYYY-MM-DD');
	    
		let mainTableSelectedRow;
		
		async function CCPList() {
	    	
			var itemList = new ItemList();
			var type_cd = "PC";
			var ccpList = await itemList.getCCPList(type_cd);
	    	
	    	$("#ccp_gubun").prepend("<option value='PC%25'>전체</option>");

	    	
	    	for(var i = 0; i < ccpList.length; i++) {
	    		
	    		ccpName = ccpList[i].sensorName;
	    		ccp = ccpList[i].sensorId;
	    		$("#ccp_gubun").append("<option value = '"+ccp+"'>"+ccpName+"</option>");
	    	}
	    	
	    };
	    
	    CCPList();
	    
		async function metalSensorList() {
	    	
			var itemList = new ItemList();
			var type_cd = "CD";
			var sensorList = await itemList.getSensorList(type_cd);
	    	
	    	$("#md-type").prepend("<option value='CD%25'>전체</option>");

	    	
	    	for(var i = 0; i < sensorList.length; i++) {
	    		
	    		sensorName = sensorList[i].sensorName;
	    		sensorId = sensorList[i].sensorId;
	    		$("#md-type").append("<option value = '"+sensorId+"'>"+sensorName+"</option>");
	    	}
	    	
	    };
	    
	    metalSensorList();
		
		
		async function getData() {
			
			var dateVal = $("#date").val();
			startDate = dateVal.substr(0, 10);
			endDate = dateVal.substr(13, 10);
			
	    	var processCode = $("input[name='test-yn']:checked").val();
	    	var ccpType = $("#md-type option:selected").val();
    		console.log(ccpType);
	        var fetchedData = $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/ccpvm",
	            data: "method=metal-breakaway" +
	            	  "&toDate=" + startDate +
	            	  "&fromDate=" + endDate +
	            	  "&sensorId=" + ccpType +
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
					data : data,
					pageLength: 10,
					columns: [
						{ data: "sensorKey", defaultContent: '' },
						{ data: "sensorName", defaultContent: '' },
						{ data: "createTime", defaultContent: '' },
						{ data: "event", defaultContent: '' },
						{ data: "sensorValue", defaultContent: '' },
						{ data: "judge", defaultContent: '' },
						{ data: "improvementAction", defaultContent: '' }
			        ],
			        columnDefs : [
			        	{
			        		targets: [0,5],
			        		'createdCell': function(td, cellData, rowData, row, col){
			        			$(td).attr('style', 'display:none;');
				  			}
			        	},
			        	{
				  			targets: [4],
				  			render: function(td, cellData, rowData, row, col){
				  				console.log(cellData);
				  				if (rowData.sensorValue == '1') {
				  					return '검출';
				  				}
				  				else {
				  					return '비검출';
				  				}
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
				  						return `<button class='btn btn-success fix-btn' id = 'fixLimit(this);'>개선조치</button>`;
				  					}
				  				}
				  			}
				  		}
				    ]
	    			//,
				    //stateSave : true
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    ccpMetalDataJspPage.fillSubTable = async function () {
	    	
	    };
	     
	    ccpMetalDataJspPage.showSignBtn = function() {
	    	refreshMainTable();
	    } 
	    
	    
		initTable();
		
		async function refreshMainTable() {
			console.log();
			var newData = await getData();

			mainTable.clear().rows.add(newData).draw();
    		
		}
    	
		// 조회 버튼 클릭 시
    	$("#getDataBtn").click(async function() {
    		refreshMainTable();
    		
    		//var selectedDate = date.getDate();
	    	//var processCode = $("input[name='test-yn']:checked").val();
	    	//var ccpType = $("#md-type option:selected").val();
    		
    		//var ccpSign = new CCPSign();
    		//var signInfo = await ccpSign.get(toDate, fromDate, ccpType, processCode);
    		/*
    		if(signInfo.checkerName != null) {
    			$("#ccp-sign-btn").hide();
    			$("#ccp-sign-text").text("서명 완료: " + signInfo.checkerName);
    		} else {
    			ccpMetalDataJspPage.showSignBtn();
    		}
    		*/
    	});
    	
    	//개선조치
		function fixLimit(obj) {
			
			var rowIdx = $(obj).closest("tr").index();
			var row = mainTable.rows(rowIdx).data();
				
    		let sensorKey = row.sensorKey;
			
    		let createTime = row.createTime;
    		let selectedDate = row.createTime.substr(0, 10);
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
			
		}
		
    	$('#ccpDataTableBody').on('click', 'tr', function () {
    		console.log('clickclick');
    		if ( !$(this).hasClass('selected') ) {
    			mainTableSelectedRow = mainTable.row( this ).data();
            }
    		console.log(mainTableSelectedRow);
    	});
    	
    	//개선조치
    	$('#ccpDataTableBody').off().on('click', 'button', function() {
    		var rowIdx = $(this).closest("tr").index();
			var row = mainTable.rows(rowIdx).data();
    		
			console.log(rowIdx);
			console.log(row);
			
    		var sensorKey = row[0].sensorKey;
    		var createTime = row[0].createTime;
    		
    		console.log(sensorKey);
    		console.log(createTime);
    		
    		var selectedDate = createTime.toString().substr(0, 10);
	    	var processCode = $("input[name='test-yn']:checked").val();
    		
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
	      	<div class="col-md-2 form-group">
				<label class="d-inline-block" for="md-type">CCP 타입:</label>
				<select class="form-control w-auto d-inline-block" id="ccp_gubun">
				</select>
	      	</div>
	      	<div class="col-md-2 form-group">
				<label class="d-inline-block" for="md-type">센서명:</label>
				<select class="form-control w-auto d-inline-block" id="md-type">
				</select>
	      	</div>
			<div class="col-md-2">
		      	<div class="form-check-inline">
				    <label class="form-check-label">
				      <input type="radio" class="form-check-input" name="test-yn" value="PC15" checked>운영
				    </label>
				</div>
				<div class="form-check-inline">
				    <label class="form-check-label">
				      <input type="radio" class="form-check-input" name="test-yn" value="PC10">테스트
				    </label>
				</div>
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
	        </div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
					    <th style = 'width:0px; display:none;'>묶음값</th>
					    <th>센서명</th>
					    <th>생성시간</th>
					    <th>이벤트</th>
					    <th>측정값</th>
					    <th style = 'width:0px; display:none;'>적/부</th>
					    <th>개선조치</th>
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