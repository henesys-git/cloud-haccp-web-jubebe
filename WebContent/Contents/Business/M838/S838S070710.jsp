<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String seq_no = "";
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");

	JSONObject jArray = new JSONObject();
	jArray.put( "seq_no", seq_no);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070700E114", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID	= "tableS838S070710";

%>
<style>
#open_file i {
	color: yellowgreen;
    font-size: 21px;
    cursor: pointer;
    margin-bottom: 0;
}

#open_file:hover i,#open_file:hover {
	color:darkseagreen;
	border-color:darkseagreen;	
}

#open_file {
    border-color: yellowgreen;
    box-shadow: none;
    padding: 0px 11px;
    border-style: double;
    border-radius: 3px;
    padding-top: 3px;
}
</style>
<script type="text/javascript">

	$(document).ready(function () {
		
		var htmlTable_ID = '<%=makeGridData.htmlTable_ID%>';
    	
    	var dataArr = <%=makeGridData.getDataArray()%>;
    	
    	var customOpts = {
				data : dataArr,
				columnDefs : [{
					'targets': [0,1,2,3,7,8,10],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [4],
					'render': function(data) {
						if(data == 'O') {
							var str = "적합"
					  		
						} else {
							var str = "부적합"
						}
						return str;
					}
				},
				{
					'targets': [9],
					'render': function(data) {
						if(data == '') {
							var str = "";
					  		
						} else {
							var str = "<button type = 'button' id = 'open_file' ><i class='far fa-file-image'></i></button>";
							file_path = data;
						}
						return str;
					}
				}]
		}
		
 		var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		); 
    	
    	$("#open_file").click(function() {
		 	window.open("<%= request.getContextPath() %>"+file_path);
    	});
   	});
	
	function clickSubMenu(obj){

    	var tr = $(obj);
		var td = tr.children();
		
		regist_no = td.eq(7).text().trim();
		file_name = td.eq(8).text().trim();
		file_path = td.eq(9).text().trim();
		file_rev_no = td.eq(10).text().trim();
		
		
    }
</script>
<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th style='width:0px; display:none;'>입고수량</th>
			<th style='width:0px; display:none;'>검수수량</th>
			<th style='width:0px; display:none;'>입고시작 시간</th>
			<th style='width:0px; display:none;'>입고완료 시간</th>
		    <th>판정결과</th>
		    <th>부적합내역</th>
		    <th>개선조치결과</th>
		    <th style='width:0px; display:none;'>regist_no</th>
			<th style='width:0px; display:none;'>file_name</th>
			<th style = "width: 50px;">첨부</th>
			<th style='width:0px; display:none;'>file_rev_no</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>