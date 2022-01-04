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

	String fromdate = "", todate = "";
	
	if(request.getParameter("From") != null)
		fromdate = request.getParameter("From");

	if(request.getParameter("To") != null)
		todate = request.getParameter("To");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("fromdate", fromdate);
	jArray.put("todate", todate);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M404S010600E104", jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS404S010100";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,2,4],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}],
				"order": [[ 1, "desc" ]]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    });

    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		checklist_id		= td.eq(0).text().trim();
		//checklist_rev_no 	= td.eq(1).text().trim();
		ipgo_date  			= td.eq(1).text().trim();
		person_write_id  	= td.eq(2).text().trim();
		person_writer  		= td.eq(3).text().trim();
		person_approve_id  	= td.eq(4).text().trim();
		person_approver  	= td.eq(5).text().trim();
		unsuit_detail 		= td.eq(6).text().trim();
		improve_action 		= td.eq(7).text().trim();
		
		parent.DetailInfo_List.click();
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>체크리스트 ID</th>
		     <!-- <th style='width:0px; display:none;'>체크리스트 수정이력</th> -->
		     <th>입고일자</th>
			 <th style='width:0px; display:none;'>작성자 ID</th>
			 <th>작성자</th>
			 <th style='width:0px; display:none;'>승인자 ID</th>
			 <th>승인자</th>
			 <th>부적합 사항</th>
		     <th>개선조치 사항</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>