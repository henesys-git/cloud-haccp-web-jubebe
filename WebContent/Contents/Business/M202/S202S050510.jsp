<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;

	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "pop_fn_Balju_form(this)", "발주서"}};

	String GV_BALJUNO;

	if(request.getParameter("Balju_no")== null)
		GV_BALJUNO="";
	else
		GV_BALJUNO = request.getParameter("Balju_no");


	JSONObject jArray = new JSONObject();
	jArray.put( "balju_no", GV_BALJUNO);
	jArray.put( "member_key", member_key);	

	TableModel = new DoyosaeTableModel("M202S050100E514", jArray);
 	int RowCount =TableModel.getRowCount();	
 	
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
 	
  	makeGridData.htmlTable_ID	= "tableS202S050510";

%>
<script>
$(document).ready(function () {
	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
	
	var customOpts = {
			data : <%=makeGridData.getDataArry()%>,
			columnDefs : [{
	       		'targets': [0,1,3,10],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
	    	}]
	}
	
	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
		mergeOptions(heneSubTableOpts, customOpts)
	);
	
});

	function clickSubMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

	
		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

	}
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th style='width:0px; display: none;'>원부자재코드</th>
		     <th style='width:0px; display: none;'>원부자재코드리비전</th>
		     <th>원부자재명</th>
		     <th style='width:0px; display: none;'>발주번호</th>
		     <th>표준안내내용</th>
		     <th>표준값</th>
		     <th>점검내용</th>
		     <th>점검값</th>
		     <th>합격여부</th>
		     <th>검사일자</th>
		     <th style='width:0px; display: none;'></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>