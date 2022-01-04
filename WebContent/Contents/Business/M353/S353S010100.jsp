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
	
	String partCd = "", startDate = "", endDate = "";
	
	if(request.getParameter("partCd") != null)
		partCd = request.getParameter("partCd");
	
	if(request.getParameter("startDate") != null)
		startDate = request.getParameter("startDate");

	if(request.getParameter("endDate") != null)
		endDate = request.getParameter("endDate");

	JSONObject jArray = new JSONObject();
	jArray.put("partCd", partCd);
	jArray.put("startDate", startDate);
	jArray.put("endDate", endDate);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M353S010100E004", jArray);
	MakeGridData makeGridData = new MakeGridData(table);
	makeGridData.htmlTable_ID = "tableS353S010100";
	
	VectorToJson vj = new VectorToJson();
	String jsonStr = vj.vectorToJson(table.getVector());
%>

<script type="text/javascript">

    $(document).ready(function () {
    	var dataArr = <%=jsonStr%>;
    	
    	if(dataArr.length > 0) {
	    	var prevStock = dataArr[0][5];	// 전기재고
	    	dataArr.splice(0, 1);			// 전기재고용 행 삭제
	    	
	    	var customOpts = {
	    			data : dataArr,
	    			dom: 'Bfrtip',
	    			buttons: [
	    	            'excel', 'print'
	    	        ],
	    	        language: {
	    	            buttons: {
	    	                excel: '엑셀',
	    	                print: '인쇄'
	    	            }
	    	        },
	    			columnDefs : [
			   			{
				  			'targets': [2,3,4,5],
				  			'render': function(data){
				  				return addComma(data);
				  			},
				  			'className' : "dt-body-right"
				  		}
			   		],
			   		pageLength: 10
	    	}
	    	
	    	var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
	    		mergeOptions(heneMainTableOpts, customOpts)
	    	);
	    	
	    	if ( table.data().any() ) {
	    		// 전기재고 기입
		    	table.cell({row:0, column:2}).data(prevStock);
	    	}
    	} else {
    		var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(heneMainTableOpts);
    	}
    });
    
    function clickMainMenu(obj) {}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>일자</th>
			<th>내역</th>
			<th>전기이월</th>
			<th>입고</th>
			<th>출고</th>
			<th>당일재고</th>
		</tr>
	</thead>
	<tbody id="tablePartView_body">		
	</tbody>
</table>