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

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S050100E204", jArray);

    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS303S020300";
%>

<script type="text/javascript">

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs : [{
				'targets': [],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display:none');
	   			}
			},
   			{
	  			'targets': [2],
	  			'render': function(data){
	  				return addComma(data);
	  			},
	  			'className' : "dt-body-right"
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
		
		vManufacturingDate = td.eq(0).text().trim();
		vPlanAmount = td.eq(1).text().trim();
		vRealAmount = td.eq(2).text().trim();
		vExpirationDate = td.eq(3).text().trim();
		vLossRate = td.eq(4).text().trim();
		vBlendingAmtPlan = td.eq(5).text().trim();
		vBlendingTimeGoal = td.eq(6).text().trim();
		vBlendingTimeReal = td.eq(7).text().trim();
		vWorkStatus = td.eq(8).text().trim();
		vRequestRevNo = td.eq(9).text().trim();
		vProdPlanDate = td.eq(10).text().trim();
		vPlanRevNo = td.eq(11).text().trim();
		vProdCd = td.eq(12).text().trim();
		vProdRevNo = td.eq(13).text().trim();
		
		//parent.DetailInfo_List.click();
    }

	function fn_Clear_varv() {
		vRequestRevNo = "";
		vProdPlanDate = "";
		vPlanRevNo = "";
		vProdCd = "";
		vProdRevNo = "";
	}

</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>제품명</th>
			<th>규격</th>
			<th>생산량(EA)</th>
			<th>유통기한</th>
			<th>비고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>   

