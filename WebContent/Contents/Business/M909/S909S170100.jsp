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
	
	JSONObject jArray = new JSONObject();
	jArray.put("empty", "empty");
		
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S170100E104",jArray);	
 	
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID	= "tableS909S170100";
%>

<script type="text/javascript">
	
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [1,9,10],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
	   			{
		  			'targets': [5,6,7,8],
		  			'render': function(data){
		  				return addComma(data);
		  			},
		  			'className' : "dt-body-right"
		  		}],
				pageLength : 10
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		censor_no = td.eq(0).text().trim();
		censor_rev_no = td.eq(1).text().trim();
    }

</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>센서 No</th>
			<th style='width:0px; display: none;'>센서 수정이력번호</th>
			<th>센서명</th>
			<th>센서타입</th>
			<th>센서위치</th>
			<th>최소값</th>
			<th>최대값</th>
			<th>표준값</th>
			<th>수집주기</th>
			<th style='width:0px; display: none;'>적용시작일자</th>
			<th style='width:0px; display: none;'>적용만료일자</th>
		</tr>
	</thead>

	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>