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
		
		async function getData() {
	    	var startDate = date.getStartDate();
    		var endDate = date.getEndDate();
	    	
	        var fetchedData = $.ajax({
			            type: "POST",
			            url: "<%=Config.this_SERVER_path%>/ccp",
			            data: "startDate=" + startDate + 
			            	  "&endDate=" + endDate + 
			            	  "&ccpType=" + "%25",
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
						{ data: "seqNo", defaultContent: '' },
						{ data: "createTime", defaultContent: '' },
						{ data: "sensorId", defaultContent: '' },
						{ data: "sensorValue", defaultContent: '' },
						{ data: "improvementCode", defaultContent: '' },
						{ data: "userId", defaultContent: '' },
						{ data: "eventCode", defaultContent: '' },
						{ data: "productId", defaultContent: '' }
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
        	사용자 관리
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
          		사용자 목록
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
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
					    <th>묶음값</th>
						<th>일련번호</th>
					    <th>생성시간</th>
					    <th>센서아이디</th>
					    <th>센서값</th>
					    <th>개선조치코드</th>
					    <th>사용자아이디</th>
					    <th>이벤트코드</th>
					    <th>제품아이디</th>
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