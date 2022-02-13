<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	$(document).ready(function () {
    	
		let date = new SetRangeDate("dateParent", "dateRange", 7);
		let mainTable;
		let subTable;
		
		async function getData() {
	    	var percentAsDefaultCcpType = "%25";

	    	var startDate = date.getStartDate();
    		var endDate = date.getEndDate();
	    	var ccpType = percentAsDefaultCcpType;
    		
	        var fetchedData = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/ccpvm",
			            data: "method=head" +
			            	  "&startDate=" + startDate + 
			            	  "&endDate=" + endDate + 
			            	  "&ccpType=" + ccpType,
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
	    	
		    var customOpts = {
					data : data,
					pageLength: 10,
					columns: [
						{ data: "sensorKey", defaultContent: '' },
						{ data: "ccpType", defaultContent: '' },
						{ data: "productName", defaultContent: '' },
						{ data: "createTime", defaultContent: '' },
						{ data: "judge", defaultContent: '' },
						{ data: "improvementCompletion", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    async function fillSubTable(row) {
	    	var data = await getSubData(row.sensorKey);
	    	
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
					  			targets: [5],
					  			render: function(td, cellData, rowData, row, col){
					  				if (rowData.judge == '적합') {
					  					return 'n/a';
					  				} else {
					  					if(rowData.improvementAction != null) {
					  						return rowData.improvementAction;
					  					} else {
					  						return `<button class='btn btn-success fix-btn'>개선조치</button>`;
					  					}
					  				}
					  			}
					  		}
					    ]
				}
	    		
				subTable = $('#ccpDataSubTable').DataTable(
					mergeOptions(heneMainTableOpts, option)
				);
	    	}
			
	    }
	    
		initTable();
    	
    	$("#getDataBtn").click(async function() {
    		var newData = await getData();
    		mainTable.clear().rows.add(newData).draw();
    	});
    	
    	$('#ccpDataTable tbody').on('click', 'tr', async function () {
    		
    		if ( !$(this).hasClass('selected') ) {
	            let row = mainTable.row( this ).data();
	            fillSubTable(row);
            }
    		
    	});
    	
    	$('#ccpDataSubTableBody').off().on('click', 'button', function() {
    		
    		let row = subTable.row( this ).data();
    		let sensorKey = row.sensorKey;
    		let createTime = row.createTime;
    		
    		$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/fixLimitOut.jsp',
                data: "sensorKey=" + sensorKey + "?createTime=" + createTime,
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
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	CCP 데이터 관리
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
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
          		CCP 데이터 목록
          	</h3>
          	<div class="card-tools">
          	  <div class="input-group input-group-sm" id="dateParent">
          	  	<input type="text" class="form-control float-right" id="dateRange">
          	  	<div class="input-group-append">
          	  	  <button type="submit" class="btn btn-default" id="getDataBtn">
          	  	    <i class="fas fa-search"></i>
          	  	  </button>
          	  	</div>
          	  </div>
          	</div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
					    <th>묶음값</th>
					    <th>CCP종류</th>
					    <th>제품</th>
					    <th>생성시간</th>
					    <th>적/부</th>
					    <th>개선완료</th>
					</tr>
				</thead>
				<tbody id="ccpDataTableBody">
				</tbody>
			</table>
          </div> 
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataSubTable" style="width:100%">
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
				<tbody id="ccpDataSubTableBody">
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