<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String seq_no = "", ipgo_date = "";
			
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");	

	if(request.getParameter("ipgo_date") != null)
		ipgo_date = request.getParameter("ipgo_date");

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("ipgo_date", ipgo_date);
	jArray.put("seq_no", seq_no);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070100E114", jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS838S070110";
%>
<style>
.btn-open-file i{
	color: yellowgreen;
    font-size: 21px;
    cursor: pointer;
    margin-bottom: 0;
}

.btn-open-file:hover i, .btn-open-file:hover {
	color:darkseagreen;
	border-color:darkseagreen;	
}

.btn-open-file {
    border-color: yellowgreen;
    box-shadow: none;
    padding: 0px 11px;
    border-style: double;
    border-radius: 3px;
    padding-top: 3px;
}
</style>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,8,9,11],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [2,3,4,5],
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
					'targets': [6],
					'render': function(data) {
						if(data == 'O') {
							var str = "확인"
					  		
						} else {
							var str = "미확인"
						}
						return str;
					}
				},
				{
					'targets': [10],
					'render': function(data) {
						if(data == '') {
							var str = "";
					  		
						} else {
							var str = "<button type = 'button' class = 'btn-open-file' ><i class='far fa-file-image'></i></button>";
							file_path = data;
						}
						return str;
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    	$(".btn-open-file").click(function() {
		 	window.open("<%= request.getContextPath() %>"+file_path);
    	});
    	
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;

		regist_no 		= td.eq(8).text().trim();
		file_name 		= td.eq(9).text().trim();
		file_path 		= td.eq(10).text().trim();
		file_rev_no 	= td.eq(11).text().trim();
    }
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>일련번호</th>
		     <th style='width:0px; display:none;'>입고일자</th>
		     <th>차량청결상태</th>
		     <th>육안검사색깔</th>
		     <th>육안검사냄새</th>
		     <th>육안검사기타</th>
		     <th>성적서 확인</th>
		     <th>비고</th>
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