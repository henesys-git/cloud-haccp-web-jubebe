<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<%
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	int startPageNo = 1;

	String GV_PARTNO = "" , GV_PROD_CD, GV_MANUFACTURING_DATE;

	if(request.getParameter("PartNo")== null)
	GV_PARTNO = "";
	else
	GV_PARTNO = request.getParameter("PartNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("manufacturing_date")== null)
		GV_MANUFACTURING_DATE = "";
	else
		GV_MANUFACTURING_DATE = request.getParameter("manufacturing_date");	

	String param = GV_PROD_CD;
	
	

	JSONObject jArray = new JSONObject();
	
	jArray.put("prod_cd", GV_PROD_CD);
	jArray.put("manufacturing_date",GV_MANUFACTURING_DATE);

	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S020100E030", jArray);

	makeGridData= new MakeGridData(TableModel);
	makeGridData.htmlTable_ID	= "tableS303S020410";
%>
<script type="text/javascript">
		
		$(document).ready(function(){
			var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
	    	
	    	var customOpts = {
	   			data : <%=makeGridData.getDataArray()%>,
	   			columnDefs : [
		   			{
			  			'targets': [1],
			  			'className' : "dt-body-right",
			  			'render': function(data){
			  				return addComma(data);
			  			}
			  		}
		   		]
	    	}
	    	
	    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
	    		mergeOptions(heneSubTableOpts, customOpts)
	    	);
	    });
			
		function clickSubMenu(obj) {
			var tr = $(obj);
			var td = tr.children();
			var trNum = $(obj).closest('tr').prevAll().length;
			
			$($("input[id='checkbox1']")[trNum]).prop("checked", function() {
		        return !$(this).prop('checked');
		    });
		
			$(SubMenu_rowID).attr("class", "");
			$(obj).attr("class", "hene-bg-color");
		}
		
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>원료명</th>
			<th>배합투입량</th>
			<th>불일치사유</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>