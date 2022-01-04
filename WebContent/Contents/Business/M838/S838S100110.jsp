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

	String GV_FROMDATE = "", GV_TODATE = "";
	
	String checklist_id = "", checklist_rev_no = "", regist_date = "";
			

	if(request.getParameter("From") != null)
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		GV_TODATE = request.getParameter("To");
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("fromdate", GV_FROMDATE);
	jArray.put("todate", GV_TODATE);
	jArray.put("regist_date", regist_date);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S100100E114", jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS838S100110";
%>
<script>

    $(document).ready(function () {
    	
    	setTimeout(function(){
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    	}, 100);
    	
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		seq_no 				= td.eq(0).text().trim();
		regist_date 		= td.eq(1).text().trim();
		approve_date 		= td.eq(2).text().trim();
		supply_item         = td.eq(3).text().trim();
		cust_nm 			= td.eq(4).text().trim();
		cust_address 		= td.eq(5).text().trim();
		cust_telno			= td.eq(6).text().trim();
		approve_reason		= td.eq(7).text().trim();
				
    }
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead ><!-- style = "display: block;" -->
		<tr>
		     <th style='width:0px; display:none;'>일련번호</th>
		     <th style='width:0px; display:none;'>작성일자</th>
		     <th>승인일자</th>
		     <th>공급 품목</th>
		     <th>공급 업체명</th>
		     <th>업체주소</th>
		     <th>연락처</th>
		     <th>승인이유</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body" >
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>