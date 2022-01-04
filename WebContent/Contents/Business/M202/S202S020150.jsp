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

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "pop_fn_Balju_form(this)", "발주서"}};

	String GV_BALJU_REQ_DATE="",GV_BALJU_NO="",GV_LOTNO="";
	String GV_ORDERNO="", GV_CUSTCODE="", GV_PROCESS_STATUS="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");

	if(request.getParameter("BaljuNo")== null)
		GV_BALJU_NO="";
	else
		GV_BALJU_NO = request.getParameter("BaljuNo");	

	String param =  GV_ORDERNO + "|" + GV_LOTNO + "|" + GV_BALJU_NO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "baljuno", GV_BALJU_NO);
	jArray.put( "member_key", member_key);
		
//     TableModel = new DoyosaeTableModel("M202S020100E154", strColumnHead, param);
    TableModel = new DoyosaeTableModel("M202S020100E154", jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
  	makeGridData.htmlTable_ID	= "tableS202S020150";
//     int ColCount =TableModel.getColumnCount()+1;
//     out.println(makeTableHTML.getHTML());
%>
<script>
$(document).ready(function () {  
	
	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
	
	var customOpts = {
			data : <%=makeGridData.getDataArry()%>,
			columnDefs : [{
	       		'targets': [0,4,5,6,10,11,12,14],
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
	        return (! $(this).prop('checked'));
	    });

	
		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vOrderNo 			= td.eq(0).text().trim();
		vBaljuNo 			= td.eq(1).text().trim();
						

	}

	
</script>
<!--         order_no,		// 주문번호--	
        balju_no,		// 발주번호
        balju_text,		// 발주서명
        balju_send_date,	// 발주일
        b.cust_nm,		// 수신인--
        tell_no,		// 전화번호--
        fax_no,		// 팩스일--
        balju_nabgi_date,	// 납기일
        nabpoom_location,	// 납품장소
        qa_ter_condtion,	// 품질조건
        balju_status,		--
        review_no,		--
        confirm_no,		--
        lotno		// LOTNO -->
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		<th style='width:0px; display: none;'>주문번호</th>
		<th>발주번호</th>
		<th>발주서명</th>
		<th>발주일</th>
		<th style='width:0px; display: none;'>수신인</th>
		<th style='width:0px; display: none;'>전화번호</th>
		<th style='width:0px; display: none;'>팩스일</th>
		<th>납기일</th>
		<th>납품장소</th>
		<th>품질조건</th>
		<th style='width:0px; display: none;'>balju_status</th>
		<th style='width:0px; display: none;'>review_no</th>
		<th style='width:0px; display: none;'>confirm_no</th>
		<th>LOTNO</th>
		<th></th>		
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>	
	</table>    	
	 <div id="UserList_pager" class="text-center">
	</div>   