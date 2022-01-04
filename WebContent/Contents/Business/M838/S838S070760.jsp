<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String check_date = "";
	
	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");

	JSONObject jArray = new JSONObject();
	jArray.put( "check_date", check_date);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070750E114", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID	= "tableS838S070760";
%>
<style>
#rowsGroup_wrapper .row:nth-child(2) i{
	font-size : 27px; 
	color:#D43C13;
}

#rowsGroup_wrapper .row:nth-child(2) i:hover{
	cursor : pointer;
	color: #C43C13;
}

#rowsGroup_wrapper .row:first-child, #rowsGroup_info {
	display: none;
}
</style>

<script type="text/javascript">

	$(document).ready(function () {
			
		var dataArr = <%=makeGridData.getDataArray()%>;
		
    	var outerArr = [];
    	
    	dataArr.map(function (arr) {
    		var darr = arr.splice(0, 3);
    		arr.splice(-1, 1);
    		arr.push("<i class='fas fa-minus-circle seq_no_delete'></i><input type = 'hidden' id = 'seq_no' value = '"+darr[0]+"'/>");
    		outerArr.push(arr);
    	})
		
    	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
    	  var table = $('#rowsGroup').DataTable({
	    	    data: outerArr,
	    	    rowsGroup: [ 0 ],
	    	    pageLength: '5',
	    	    language: { 
	                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	             }
	    	    
   	    	});
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
    	$(".seq_no_delete").click(function() {
    		
    		var chekrtn = confirm("삭제하시겠습니까?"); 
    		
    		if(!chekrtn)	return false;
    		
    		var seq_no = $(this).next().val();
	
    		var dataJson = new Object();
            
            dataJson.seq_no = seq_no;
 
    		$.ajax({
    	        type: "POST",
    	        dataType: "json",
    	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
    	        data:  {"bomdata" : JSON.stringify(dataJson), "pid" : "M838S070750E113"},
    			success: function (html) {	
    				if(html > -1) {
    					heneSwal.success('점검표 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	        		parent.fn_DetailInfo_List();
    	         	} 
    	         }
    	     });
    		
    	});
    	
	});
</script>
<table id = "rowsGroup"  class='table table-bordered nowrap table-hover' >
	<thead>
		<tr>
   		     <th>구분항목</th>
		     <th>검체명</th>
		     <th>냉장/냉동</th>
		     <th>일반세균</th>
		     <th>대장균</th>
		     <th>살모넬라</th>
		     <th>평가</th>
		     <th></th>
		</tr>
	</thead>
</table>
<div id="UserList_pager" class="text-center"></div>