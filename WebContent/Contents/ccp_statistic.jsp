<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
    
    var mainTable;
    
	$(document).ready(function () {
		
		new SetSingleDate2("", "#ccp_date", 0);
		
		async function getData() {
	    	var toDate = $('#ccp_date').val();
	    	var sensorId = $('#sensor_id option:selected').val();
    		
	        var fetchedData = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/ccpvm",
			            data: "method=statistic" +
			            	  "&toDate=" + toDate +
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
						{ data: "ccpDate", defaultContent: '' },
						{ data: "countAll", defaultContent: '' },
						{ data: "countDetect", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#ccpStatisticTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    async function refreshMainTable() {
			var newData = await getData();
    		mainTable.clear().rows.add(newData).draw();
    		
		}
	    
	    $('#date_change').on('click', function(){
	    	refreshMainTable();
	    });
	    
		initTable();
		
		
    }); //document ready function end
	
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	모니터링 통계
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
          		모니터링 정보 목록
          	</h3>
          	<div class="card-tools">
        					<table style="width:100%">
								<tr>
		                           	<td>
		                           		ccp종류
		                           	</td>
		                            <td>
			                        	<select class="form-control" id="ccp_gubun">
			                               <option value = 'metal'>금속검출</option>
			                               <option value = 'disinfect'>소독/세척</option>
										</select>
									</td>
									<td>
		                           		센서ID
		                           	</td>
		                            <td>
			                        	<select class="form-control" id="sensor_id">
			                        		<option value = ''>전체</option>
			                                <option value = 'CD01'>금속검출기1</option>
			                                <option value = 'CD02'>금속검출기2</option>
			                                <option value = 'CD03'>금속검출기3</option>
										</select>
									</td>
									<td>
		                           		날짜
		                           	</td> 
		                            <td>
		                            <div class="input-group input-group-sm" id="dateParent">
			                        	<input type="text" id="ccp_date" class="form-control">
			                        	<div class="input-group-append">
          	  	  							<button type="submit" class="btn btn-default" id="date_change">
          	  	    							<i class="fas fa-search"></i>
          	  	  							</button>
          	  							</div>
			                        </div>
									</td> 
								</tr>
							</table>
      		</div>
          	
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpStatisticTable" style="width:100%">
				<thead>
					<tr>
					    <th>일자</th>
					    <th>통과건수</th>
					    <th>검출건수</th>
					</tr>
				</thead>
				<tbody id="ccpStatisticTableBody">		
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