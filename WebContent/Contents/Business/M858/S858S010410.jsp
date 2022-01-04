<%@ page import="java.net.URLDecoder"%>
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

	String chulhaNo = "", chulhaRevNo = "", orderNo = "";
	
	if(request.getParameter("chulhaNo") != null) {
		chulhaNo = request.getParameter("chulhaNo");
	}
	
	if(request.getParameter("chulhaRevNo") != null) {
		chulhaRevNo = request.getParameter("chulhaRevNo");
	}
	
	if(request.getParameter("orderNo") != null) {
		orderNo = request.getParameter("orderNo");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("chulhaNo", chulhaNo);
	jArray.put("chulhaRevNo", chulhaRevNo);
	jArray.put("orderNo", orderNo);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M858S010400E114", jArray);	
 	
 	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS858S010410";
%>

<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [
   				{
	   	       		'targets': [2],
	   	       		'createdCell':  function (td) {
	   	          			$(td).attr('style', 'display: none;');
	   	       		}
   	    		},
	   			{
		  			'targets': [3],
		  			'render': function(data){
		  				return addComma(data);
		  			},
		  			'className' : "dt-body-right"
		  		}
   				
   			],
   	    	createdRow : ""
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
    });
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<!-- <th>생산일자</th> -->
			<th>완제품명</th>
			<th>완제품 코드</th>
			<th style="display:none; width:0px">완제품 수정이력번호</th>
			<th>출고량(EA)</th>
			<th>비고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>
