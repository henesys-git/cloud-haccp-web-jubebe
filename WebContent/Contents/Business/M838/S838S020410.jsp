<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String regist_date = "";
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");

	JSONObject jArray = new JSONObject();
	jArray.put( "regist_date", regist_date);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020400E114", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID	= "tableS838S020410";

%>

<style>
.td_icon i{
	font-size : 27px; 
	color:#D43C13;

}

.td_icon i:hover{
	cursor : pointer;
	color: #C43C13;
}

</style>

<script type="text/javascript">

	$(document).ready(function () {
		
		var htmlTable_ID = '<%=makeGridData.htmlTable_ID%>';
    	
    	var dataArr = <%=makeGridData.getDataArray()%>;
    	
    	var customOpts = {
				data : dataArr,
				columnDefs : [{
					'targets': [0,1],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
 		var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		); 
		
    	if(dataArr.length > 0){
    		$("#tableS838S020410_wrapper .no-footer thead:first tr").append("<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>")
        	$("#<%=makeGridData.htmlTable_ID%>_body tr").append('<td><i class="fas fa-minus-circle seq_no_delete"></i></td>')	
    	}
    	
    	$(".seq_no_delete").click(function() {
    		
    		var chekrtn = confirm("삭제하시겠습니까?"); 
    		
    		if(!chekrtn)	return false;
    		
    		var seq_no = $(this).closest("tr").children("td:eq(1)").text();
	
    		var dataJson = new Object();
            
            dataJson.seq_no = seq_no;
 
    		$.ajax({
    	        type: "POST",
    	        dataType: "json",
    	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
    	        data:  {"bomdata" : JSON.stringify(dataJson), "pid" : "M838S020400E113"},
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
	
    function clickSubMenu(obj){
   	 
    	var tr = $(obj);
		var td = tr.children();
    			
		regist_date 	= td.eq(0).text().trim();
		seq_no			= td.eq(1).text().trim();
		unsuit_place 	= td.eq(2).text().trim();
		standard_unsuit = td.eq(3).text().trim();
		improve_action 	= td.eq(4).text().trim();
		action_result 	= td.eq(5).text().trim();
		
    } 
	
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			 <th style='width:0px; display:none;'>작성일자</th>
		     <th style='width:0px; display:none;'>상세일련번호</th>
   		     <th>이상장소</th>
		     <th>기준이탈</th>
		     <th>개선조치</th>
		     <th>조치결과</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body" class = "td_icon">
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>