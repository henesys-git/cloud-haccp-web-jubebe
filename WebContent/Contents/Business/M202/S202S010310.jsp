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

	String GV_BALJU_REQ_DATE="",GV_LOTNO="",GV_BALJU_NO="",GV_ORDER_NO="";

	String GV_ORDERNO="", GV_CUSTCODE="", GV_PROCESS_STATUS="";

	if(request.getParameter("BaljuNo")== null)
		GV_BALJU_NO="";
	else
		GV_BALJU_NO = request.getParameter("BaljuNo");
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");

	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");

	String param =  GV_ORDERNO + "|" + GV_LOTNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put("order_no", GV_ORDER_NO);
	jArray.put("balju_no", GV_BALJU_NO);
	jArray.put("member_key", member_key);	

	TableModel = new DoyosaeTableModel("M202S010100E314", jArray);
 	int RowCount = TableModel.getRowCount();	
 	
 	makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton = RightButton;
 	
  	makeGridData.htmlTable_ID = "tableS202S010310";
%>

<script>
	
	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
	
		var customOpts = {
				data : <%=makeGridData.getDataArry()%>,
				columnDefs : [{
		       		'targets': [0,2,4,5,6,10,11,12],
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

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vBalju_no = td.eq(1).text().trim();
	}
	
    function fn_Clear_varv(){
    	vBalju_no = "";  
	}
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th>발주번호</th>
		     <th style='width:0px; display: none;'>balju_seq</th>
		     <th>배합(BOM)명</th>
		     <th style='width:0px; display: none;'>배합(BOM)번호</th>
		     <th style='width:0px; display: none;'>원부자재코드</th>
		     <th style='width:0px; display: none;'>규격</th>
		     <th>발주수량</th>
		     <th>단가</th>
		     <th>발주금액</th>
		     <th style='width:0px; display: none;'>rev_no</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     <th style='width:0px; display: none;'></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>