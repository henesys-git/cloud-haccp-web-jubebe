<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>

<!-- 현재고량 조회(NwStockView).jsp  -->
<!-- 
20201106
작성자 : 신무승
-->
<%	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	JSONObject jArray = new JSONObject();
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S020100E010", jArray);
	
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID = "tableNwStockView";
%>

 <!-- Theme style -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/css/adminlte.min.css">
	
	<!-- Daterange picker -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.css">
	<!-- summernote -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/summernote/summernote-bs4.css">
	
	<!-- Henesys Icon -->
	<link rel="shotcut icon" type="image/x-icon" href="<%=Config.this_SERVER_path%>/images/henesys.jpg"/>
	<!-- SweetAlert2 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.css">
 	<!-- DataTables -->
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/css/select.bootstrap4.min.css">
    
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/cdnjs/select2.min.css">
  	<!-- Henesys CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/css/henesys.css">
  	
 	<!-- jQuery -->
 	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.js"></script>
 	<!-- Canvas 공통함수 부분 -->
	<script src="<%=Config.this_SERVER_path%>/js/canvas.comm.func.js"></script>
  	
	<!-- DataTables -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables/jquery.dataTables.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/js/dataTables.select.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
	
	<!-- For DataTables Default Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/datatables.custom.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/cdnjs/select2.min.js"></script>
	<!--1000단위 콤마(,) -->
	<script src="<%=Config.this_SERVER_path%>/js/hene.number.js"></script>	
	
<script type="text/javascript">
	var txt_CustName;
	var caller="";
	var part_selected_row;
	var selectTable_Part;
	
	
	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
	   			data : <%=makeGridData.getDataArray()%>,
	   			columnDefs : [{
		  			'targets': [1,2],
		  			'render': function(data){
		  				return addComma(data);
		  			}
		  		}],
	   			'rowCallback': function(row, data){
		  		  	if(parseInt(data[1]) > parseInt(data[2])){
		  			   $(row).find('td:eq(2)').css('color','red');
		  		   }
		  		}, pageLength : 10
		  		, paging : true
		  		
	    	}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
	    		mergeOptions(heneSubTableOpts, customOpts)
	    	);
		
	});		 
</script>
	
<section class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">
				<div class="card card-info">
                    <div class="card-header"> 
                     <h3 class="card-title">현재고량 조회</h3>
                    </div> <!-- card-header -->
                    <div class="card-body" style = "width:100%;">
                    	<table class="table table-bordered"  style = "width:100%;" id="<%=makeGridData.htmlTable_ID%>">
                    		<thead>
                                <tr>
                                    <th>완제품명</th>
                                    <th>적정재고량</th>
                                    <th>현재재고량</th>
                                </tr>
                            </thead>
                            <tbody id="<%=makeGridData.htmlTable_ID%>_body"></tbody>
                    	</table>
                    </div> <!-- card-body  -->
                    <div class="card-tools">
                    	<button id="btn_Canc"  class="btn btn-info" style="float:right;margin: 0 10px 10px 0;" onclick="window.close();">닫기</button>
                    </div>
				</div> <!-- card card-info -->
			</div> <!-- col-md-6 -->
		</div> <!-- row -->
	</div> <!-- container-fluid -->
</section> <!-- content -->