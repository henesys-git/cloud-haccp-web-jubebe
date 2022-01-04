<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String GV_PROD_CD = "", 
		   GV_PROD_REV_NO = "", 
		   GV_INPUT_AMT = "";
	
	if(request.getParameter("prodCd") != null)
		GV_PROD_CD = request.getParameter("prodCd");
	
	if(request.getParameter("prodRevNo") != null)
		GV_PROD_REV_NO = request.getParameter("prodRevNo");
	
	if(request.getParameter("inputAmt") != null)
		GV_INPUT_AMT = request.getParameter("inputAmt");
	
	JSONObject jArray = new JSONObject();
	jArray.put("prodCd", GV_PROD_CD);
	jArray.put("prodRevNo", GV_PROD_REV_NO);
			
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M353S015100E114", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS353S015110";
%>
<script>
    $(document).ready(function () {
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [
			    	{
				    	'targets': 1,
	                    'render': function (data, type, row) {
	                    	var blendingRatio = data * 100; // change to percentage
	                    	return blendingRatio + "%";
	                    },
			  			'className' : "dt-body-right"
	                },
					{
				    	'targets': 2,
	                    'render': function (data, type, row) {
	                    	var totalInput = "<%=GV_INPUT_AMT%>";
	                    	totalInput = parseInt((totalInput.replace(',','')))	// remove comma
	                    	
	                    	var blendingRatio = row[1];
	                    	
	                    	var inputAmt = blendingRatio * totalInput;
	                    	
	                    	return addComma(inputAmt);
	                    },
			  			'className' : "dt-body-right"
			    	}
				]
		}
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
	});
    
	function clickSubMenu(obj) {
		// no use
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>재료명</th>
			<th>배합비율</th>
			<th>투입량</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>