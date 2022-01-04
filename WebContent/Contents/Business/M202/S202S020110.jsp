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
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String GV_BALJU_REQ_DATE="",GV_BALJU_NO="", GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_LOTNO=""; 
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("Balju_req_date")== null)
		GV_BALJU_REQ_DATE="";
	else
		GV_BALJU_REQ_DATE = request.getParameter("Balju_req_date");
	
	if(request.getParameter("BaljuNo")== null)
		GV_BALJU_NO="";
	else
		GV_BALJU_NO = request.getParameter("BaljuNo");	

	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");

	String param = GV_ORDERNO + "|" + GV_LOTNO + "|" + GV_BALJU_NO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "baljuno", GV_BALJU_NO);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M202S020100E114", jArray); 	

	int RowCount =TableModel.getRowCount();
	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS202S010110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;

	String[] strHeadHead	= {"Head"};
 	TableHead = new DoyosaeTableModel("M202S020100E999", jArray);//발주 부속정보 요약
%>
<script>
	
    $(document).ready(function () {
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArry()%>,
    			columnDefs : [{
    	       		'targets': [0,8,9,10,11,13,14,15,18],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	}],
    	    	order = [[ 1, "asc" ]]
    	}
    	
    	var chk_data_tb = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
    							mergeOptions(heneSubTableOpts, customOpts)
					      );
    	
    	TableCD_RowCount = chk_data_tb.rows().count();
    	
    	balju_List_Count = '<%=TableHead.getValueAt(0,1).toString()%>';
		balju_Inspect_Count = '<%=TableHead.getValueAt(0,2).toString()%>';
    	balju_List_Count = '<%=TableHead.getValueAt(0,1).toString()%>';
		balju_Inspect_Count = '<%=TableHead.getValueAt(0,2).toString()%>';
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
		
// 		vOrderNo 			= td.eq(1).text().trim();
// 		vProd_serial_no	= td.eq(4).text().trim();
// 		vOrderDetailSeq 		= td.eq(11).text().trim();
// 		vCustCode 			= td.eq(12).text().trim();
		vPart_cd 			= td.eq(4).text().trim();
		vPart_nm 			= td.eq(13).text().trim();
	}

    function fn_Clear_varv(){
    	vOrderNo = "";  
    	vProd_serial_no = "";
    	vOrderDetailSeq = "";
    	vOrder_cnt = "";
    	vCustCode = "";
    	vPart_cd = "";
    	vPart_nm ="";
	}	
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		<th style='width:0px; display: none;'>balju_no</th>
		<th>순번</th>
		<th>배합(BOM)이름</th>
		<th>배합(BOM)번호</th>
		<th>원부자재코드</th>			
		<th>규격</th>
		<th>발주수</th>
		<th>검수수</th>
		<th style='width:0px; display: none;'>list_price</th>
		<th style='width:0px; display: none;'>balju_amt</th>
		<th style='width:0px; display: none;'>rev_no</th>
		<th style='width:0px; display: none;'>part_cd_rev</th>
		<th>미검수 수량</th>
		<th style='width:0px; display: none;'>원부자재명</th>
		<th style='width:0px; display: none;'>cust_cd</th>
		<th style='width:0px; display: none;'>cust_cd_rev</th>
		<th>수입검사여부</th>
		<th>검수합격여부</th>
		<th style='width:0px; display: none;'></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>