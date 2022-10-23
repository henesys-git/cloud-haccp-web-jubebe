<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
	
	var year;
	
	$(document).ready(function () {
    	
		//let date = new SetSingleDate2("", "#date", 0);
		year = new Date().getFullYear();
		let date = $('#date').datepicker({
			 format: "yyyy",
			 viewMode: "years", 
			 minViewMode: "years",
			 updateViewDate: true,
			 changeYear: true,
			
        });
		$('#date').val(year);
		
		let mainTable;
		
		async function packingSensorList() {
	    	
			var itemList = new ItemList();
			var type_cd = "CD";	// 금속검출기 코드 대분류
			var sensorList = await itemList.getSensorList(type_cd);
	    	
	    	for(var i = 0; i < sensorList.length; i++) {
	    		sensorName = sensorList[i].sensorName;
	    		sensorId = sensorList[i].sensorId;
	    		$("#sensor-type").append("<option value = '"+sensorId+"'>"+sensorName+"</option>");
	    	}
	    };
		
	    packingSensorList();
	    
		async function getData() {
	    	var selectedDate = $('#date').val();
	    	var processCode = "PC15"; //금속검출 운영
	    	var sensorId = $("select[name=sensor-type]").val();
	    	
	        var fetchedData = $.ajax({
	            type: "GET",
	            url: "<%=Config.this_SERVER_path%>/kpi",
	            data: "method=quality" +
	            	  //"&date=" + selectedDate +
	            	  "&date=" + selectedDate +
	            	  "&processCode=" + processCode + 
	            	  "&sensorId=" + sensorId,
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
						{ data: "dataMonth", defaultContent: '' },
						{ data: "totalCount", defaultContent: '' },
						{ data: "totalDetection", defaultContent: '' }
					],
					columnDefs : [
			   			
				    ]
			}
			
			mainTable = $('#kpiProductionTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
		initTable();
		
		async function refreshMainTable() {
			var newData = await getData();
			mainTable.clear().rows.add(newData).draw();
		}
    	
		// 조회 버튼 클릭 시
    	$("#getDataBtn").click(async function() {
    		refreshMainTable();
    	});
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  	<div class="container-fluid">
    	<div class="row mb-2">
	      	<div class="col-sm-3">
	        	<h1 class="m-0 text-dark">
	        		품질
	        	</h1>
	      	</div>
	      	<div class="col-md-3 form-group">
				<label class="d-inline-block" for="sensor-type">종류:</label>
				<select class="form-control w-auto d-inline-block" id="sensor-type" name="sensor-type">
					<option value="">전체</option>
				</select>
	      	</div>
			<div class="col-md-3">
       	  	</div>
        	  
			<div class="col-md-2 input-group">
	         	  	<input type="text" class="form-control float-right" id="date">
	         	  		<div class="">
			        		<span class="input-group-text">년</span>
			      		</div>
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
       		<div class="col-md-12">
	          	<h3 class="card-title">
	          		<i class="fas fa-edit" id="InfoContentTitle"></i>
	          		품질 KPI 목록
	          	</h3>
	        </div>
          </div>
           
		  <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="kpiProductionTable" style="width:100%">
				<thead>
					<tr>
					    <th>연월</th>
					    <th>총운영횟수</th>
					    <th>총검출횟수</th>
					</tr>
				</thead>
				<tbody id="kpiProductionTableBody">
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