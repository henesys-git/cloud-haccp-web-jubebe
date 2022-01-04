<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	DoyosaeTableModel TableModel, TableHead;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_PROD_CD = "", 
		   GV_PROD_REV_NO = "", 
		   GV_SEQ_NO = "", 
		   GV_PROD_DATE = "";
	
	if(request.getParameter("prod_cd") != null)
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("seq_no") != null)
		GV_SEQ_NO = request.getParameter("seq_no");	
	
	if(request.getParameter("prod_rev_no") != null)
		GV_PROD_REV_NO = request.getParameter("prod_rev_no");
	
	if(request.getParameter("prod_date") != null)
		GV_PROD_DATE = request.getParameter("prod_date");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("prod_cd", GV_PROD_CD);
	jArray.put("prod_rev_no", GV_PROD_REV_NO);
	jArray.put("seq_no", GV_SEQ_NO);
	jArray.put("prod_date", GV_PROD_DATE);
			
    TableModel = new DoyosaeTableModel("M858S060100E114", jArray);
 	makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS858S060110";
%>
<script>
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				createdRow : "",
				columnDefs : [
					{
				    	'targets': 6,
			   			'createdCell':  function (td) {
			      			$(td).attr('style', 'display: none;');
			   			}
			    	},
			    	{
				    	'targets': 4,
	                    'render': function ( data, type, row ) {
	                    	if(row[6] == 1) {	// 완제품 입고 테이블 (양수면 재고가 추가된 것)
	                    		if(data >= 0) {
		                    		return '<span style="color:blue">+'+addComma(data)+'</span>';
	                    		} else {
		                    		return '<span style="color:red">'+addComma(data)+'</span>';
	                    		}
	                    	} else if(row[6] == 2) {	// 완제품 출고 테이블 (양수면 재고가 빠져나간 것)
	                    		if(data >= 0) {
		                    		return '<span style="color:red">-'+addComma(data)+'</span>';
	                    		} else {
	                    			var absData = Math.abs(data);
		                    		return '<span style="color:blue">+'+absData+'</span>';
	                    		}
	                    	} else {
	                    		return data;
	                    	}
	                    },
			  			'className' : "dt-body-right"
	                }
				]
		}
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
	});
    
	function clickSubMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>품목명</th>
			<th>규격</th>
			<th>입출고 일자</th>
			<th>시간</th>
			<th>입출고 수량</th>
			<th>비고</th>
			<th style="display:none; width:0px">입고(1)/출고(2) 분류용 컬럼</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>   
<div id="UserList_pager" class="text-center">
</div>              