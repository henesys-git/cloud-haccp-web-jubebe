<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel, TableHead;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "fn_mius_body(this)", "삭제"}
							  };
	
	String GV_ORDER_NO = "", GV_LOTNO = "", GV_BALJUNO = "";
	
	if(request.getParameter("order_no") == null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno") == null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");	
	
	if(request.getParameter("BaljuNo") == null)
		GV_BALJUNO="";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
	

	JSONObject jArray = new JSONObject();
	jArray.put("order_no", GV_ORDER_NO);
	jArray.put("lotno", GV_LOTNO);
	jArray.put("member_key", member_key);
	jArray.put("BaljuNo", GV_BALJUNO);

    TableModel = new DoyosaeTableModel("M202S030100E114", jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();

    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S030110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script>
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
    });
    
	function clickSubMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success
		
		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
	}
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>원부자재 코드</th>
			<th>원부자재명</th>
			<th>단위</th>
			<th>발주 수량</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              