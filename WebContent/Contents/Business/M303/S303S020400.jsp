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
	
	String toDate = "";
	
	if(request.getParameter("toDate") != null) {
		toDate = request.getParameter("toDate");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("toDate", toDate);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S020100E020", jArray);	

	MakeGridData makeGridData= new MakeGridData(TableModel);
	makeGridData.htmlTable_ID	= "tableS303S020400";
	    
	makeGridData.Check_Box 	= "false";
	String[] HyperLink		= {""};
	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">
		
	$(document).ready(function () {
		
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;

		var customOpts = {
		data : <%=makeGridData.getDataArray()%>,
		columnDefs : [{
      		'targets': [1],
      		'createdCell':  function (td) {
         			$(td).attr('style', 'display: none;'); 
      		}
   		},
			{
  			'targets': [4],
  			'render': function(data){
  				return addComma(data);
  			},
  			'className' : "dt-body-right"
  		}]
	   }

		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
		mergeOptions(heneMainTableOpts, customOpts)
	   );
	});
	
		
		
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vProd_cd 				= td.eq(1).text().trim();
		vManufacturing_date 	= td.eq(2).text().trim();
		
		parent.DetailInfo_List.click();
		
		}
	
</script>
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>제품명</th>
			<th style='width:0px; display: none;'>제품코드</th> 
			<th>작업일자</th>
			<th>작업자</th>
			<th>총배합량</th>
			<th>목표배합시간</th>
			<th>총배합시간</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
	