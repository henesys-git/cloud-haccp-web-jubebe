<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
DoyosaeTableModel TableModel, TableHead;

// 	MakeTableHTML makeTableHTML;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDER_NO="",GV_LOTNO="", GV_BALJUNO=""  ;
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");	
	
	if(request.getParameter("BaljuNo")== null)
		GV_BALJUNO="";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
	
	
	String param = GV_ORDER_NO + "|" + GV_LOTNO + "|" + GV_BALJUNO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	jArray.put( "BaljuNo", GV_BALJUNO);

	 
//     TableModel = new DoyosaeTableModel("M202S040100E114", strColumnHead, param);	//검수정보를 가져와야 함
    TableModel = new DoyosaeTableModel("M202S040100E114", jArray);	//검수정보를 가져와야 함
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S040110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArry()%>,
    			columnDefs : [{
    	       		'targets': [0,1,2,4,6,7,9,11,12,13,17,18,19,21],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
    	
    	
    });
    
	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success
	}

    
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
		     	<th style='width:0px; display: none;'>주문번호</th>
				<th style='width:0px; display: none;'>Lot번호</th>
				<th style='width:0px; display: none;'>출고번호</th>
				<th>불출일자</th>
				<th style='width:0px; display: none;'>불출일련번호</th>
				<th>불출시간</th>
				<th style='width:0px; display: none;'>불출담당자</th>
				<th style='width:0px; display: none;'>파트코드</th>
				<th>원부자재명</th>
				<th style='width:0px; display: none;'>파트코드개정번호</th>
				<th>창고번호</th>
				<th style='width:0px; display: none;'>렉번호</th>
				<th style='width:0px; display: none;'>선반번호</th>
				<th style='width:0px; display: none;'>칸번호</th>
				<th>불출전재고량</th>
				<th>불출수량</th>
				<th>불출후재고량</th>
				<th style='width:0px; display: none;'>구분</th>
				<th style='width:0px; display: none;'>비고</th>
				<th style='width:0px; display: none;'>용도</th>
				<th>유통기한</th>
			     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
			     <th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              