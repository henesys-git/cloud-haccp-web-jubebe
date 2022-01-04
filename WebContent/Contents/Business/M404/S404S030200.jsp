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
	
	String Fromdate = "", Todate = "", 
		   custCode = "", GV_PROCESS_STATUS = "", 
		   GV_JSPPAGE;
	
	if(request.getParameter("From") != null)
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		Todate = request.getParameter("To");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	jArray.put("member_key", member_key);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M404S030100E104", jArray);	 	
    
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID = "tableS404S030100";
%>
<script>
	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,2,7],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
		fn_Clear_varv();
	});

	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;		
		
		vProc_plan_no 		= td.eq(0).text().trim();
		vProd_cd 			= td.eq(1).text().trim();
		vProd_cd_rev 		= td.eq(2).text().trim();
		vProduct_nm 		= td.eq(3).text().trim();
		vMix_recipe_cnt 	= td.eq(4).text().trim();
		vStart_dt 			= td.eq(5).text().trim();
		vEnd_dt				= td.eq(6).text().trim();
		vProduction_status 	= td.eq(7).text().trim();
		vCode_name 			= td.eq(8).text().trim();
		vGugyuk				= td.eq(9).text().trim();
		DetailInfo_List.click();
	}
	
	function fn_Clear_varv(){
		vProc_plan_no 		= "";
		vProd_cd 			= "";
		vProd_cd_rev 		= "";
		vProduct_nm 		= "";
		vMix_recipe_cnt 	= "";
		vExpiration_date	= "";
		vStart_dt 			= "";
		vEnd_dt				= "";
		vProduction_status 	= "";
		vCode_name 			= "";
		vGugyuk				= "";
	}
	     
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th style='width:0px; display: none;'>생산계획no</th>
		     <th style='width:0px; display: none;'>제품코드</th>
		     <th style='width:0px; display: none;'>제품코드rev</th>
		     <th>제품명</th>
		     <th>배합수량</th>
		     <th>생산시작예정일시</th>
		     <th>생산완료예정일시</th>
		     <th style='width:0px; display: none;'>production_status</th>
		     <th>생산상태</th>
		     <th>규격</th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div>              