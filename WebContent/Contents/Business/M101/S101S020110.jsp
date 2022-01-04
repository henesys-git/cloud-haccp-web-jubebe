<%@page import="java.net.URLDecoder"%>
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
	
	String GV_ORDERNO = "", GV_ORDER_REV_NO=""; 
	
	if(request.getParameter("OrderNo") != null)
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("OrderRevNo") != null)
		GV_ORDER_REV_NO = request.getParameter("OrderRevNo");
	
	JSONObject jArray = new JSONObject();
	jArray.put("order_no", GV_ORDERNO);
	jArray.put("order_rev_no", GV_ORDER_REV_NO);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M101S020100E114", jArray);	
 	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID	= "tableS101S120110";
%>

<script>
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
		  		}],
    	    	retrieve : true
    	}
    	
    	subtable = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
    	);
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>완제품 코드</th>
			<th style="display:none; width:0px">완제품 수정이력번호</th>
			<th>품목명</th>
			<th>규격</th>
			<th>주문 수량</th>
			<th>비고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>
