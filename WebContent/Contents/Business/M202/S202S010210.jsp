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
	String RightButton[][] = {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "pop_fn_Balju_form(this)", "발주서"}
							  };

	String GV_BALJU_REQ_DATE="", GV_TRACE_KEY="", GV_BALJU_NO="",
		   GV_ORDERNO = "", GV_CUSTCODE = "", GV_PROCESS_STATUS = "",
		   GV_BALJU_REV_NO;

	if(request.getParameter("BaljuNo") == null)
		GV_BALJU_NO ="";
	else
		GV_BALJU_NO = request.getParameter("BaljuNo");
	
	if(request.getParameter("BaljuRevNo") == null)
		GV_BALJU_REV_NO ="";
	else
		GV_BALJU_REV_NO = request.getParameter("BaljuRevNo");

	if(request.getParameter("TraceKey") == null)
		GV_TRACE_KEY = "";
	else
		GV_TRACE_KEY = request.getParameter("TraceKey");

	String param = GV_ORDERNO + "|" + GV_TRACE_KEY + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put("balju_no", GV_BALJU_NO);
	jArray.put("balju_rev_no", GV_BALJU_REV_NO);
	jArray.put("trace_key", GV_TRACE_KEY);
	jArray.put("member_key", member_key);

	TableModel = new DoyosaeTableModel("M202S010100E214", jArray);
 	int RowCount =TableModel.getRowCount();
 	
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton = RightButton;
 	
  	makeGridData.htmlTable_ID = "tableS202S010210";
%>

<script>
	$(document).ready(function () {
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
			data : <%=makeGridData.getDataArry()%>,
			createdRow : "",
			columnDefs : [{
	  			'targets': [3],
	  			'render': function(data){
	  				return addComma(data);
	  			},
	  			'className' : "dt-body-right"
	  		}]
		}
		
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
	});
	
	function clickSubMenu(obj) {
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;
	}
	
    function fn_Clear_varv() {
    	vBalju_no = "";
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th>코드</th>
		     <th>품목명</th>
		     <th>규격</th>
		     <th>주문량</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>