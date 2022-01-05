<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
    
	$(document).ready(function () {
    	
		let mainTable;
		
		async function getData() {
	        var fetchedData = $.ajax({
			            type: "POST",
			            url: heneServerPath + "/sensor",
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
						{ data: "valueMax", defaultContent: '' },
						{ data: "valueMin", defaultContent: '' },
						{ data: "valueType", defaultContent: '' },
						{ data: "ipAddress", defaultContent: '' },
						{ data: "protocolInfo", defaultContent: '' },
						{ data: "packetInfo", defaultContent: '' },
						{ data: "typeCode", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	     
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
					    <th>최대값</th>
					    <th>최소값</th>
					    <th>값 타입</th>
					    <th>IP</th>
					    <th>프로토콜</th>
					    <th>패킷</th>
					    <th>타입 코드</th>
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