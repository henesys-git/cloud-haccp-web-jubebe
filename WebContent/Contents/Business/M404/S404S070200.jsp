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
	
	int startPageNo = 1;

	String[] strColumnHead 	= {"고객사","제품명","PO번호", "제품구분_code", "원부자재공급방법_code","주문일","lot번호","lot수량","자재출고일", "rohs_code", "특이사항","납기일",
			"bom_ver","order_no","현상태명","비고","일련번호","일련번호끝","cust_cd","cust_rev","prod_cd","prod_cd_rev","order_status","제품구분네임","원부자재공급방법","rohs"};


	String Fromdate="",Todate="",Custcode ="", GV_PROCESS_STATUS="",GV_INSPECT_GUBUN="",GV_JSPPAGE=""; 

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	

	if(request.getParameter("Custcode")== null)
		Custcode="";
	else
		Custcode = request.getParameter("Custcode");	
	
	if(request.getParameter("Process_status")== null)
		GV_PROCESS_STATUS="";
	else
		GV_PROCESS_STATUS = request.getParameter("Process_status");	
	
	if(request.getParameter("InspectGubun")== null)
		GV_INSPECT_GUBUN="";
	else
		GV_INSPECT_GUBUN = request.getParameter("InspectGubun");	
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	String param = Fromdate	+ "|" + Todate	+ "|" + Custcode + "|" +  GV_JSPPAGE + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", Custcode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M404S070100E204", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();	
    
 	makeGridData= new MakeGridData(TableModel);
 	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
  	makeGridData.RightButton	= RightButton;
    
  	
	makeGridData.htmlTable_ID	= "tableS404S070200";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink; 
    
//     int ColCount =TableModel.getColumnCount()+1;
//     out.println(zhtml);
%>
<script>
$(document).ready(function () {
	
	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
	
	var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs : [{
				'targets': [3,4,8,9,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26],
				'createdCell': function (td) {
		  			$(td).attr('style', 'display: none;'); 
				}
			}]
	}
	
	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
		mergeOptions(heneMainTableOpts, customOpts)
	);
	
	fn_Clear_varv();
});

	function fn_Clear_varv(){
		vOrderNo = "";  
		vLotNo = "";
	}
	
	function clickMainMenu(obj){
		
		var tr = $(obj);
			var td = tr.children();
			var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
			
			$(MainMenu_rowID).attr("class", "");
			$(obj).attr("class", "hene-bg-color");

			/* ==============복사하여 수정 할 부분================================  */   
  			vOrderNo	= td.eq(13).text().trim(); 
			vLotNo 		= td.eq(6).text().trim();
			vLotCount	= td.eq(7).text().trim();
		 	vOrderDate 	= td.eq(5).text().trim();
		 	
			vCustCode 	= td.eq(18).text().trim();
			vCustRev 	= td.eq(19).text().trim();
			vCustName   = td.eq(0).text().trim(); 
			vStatus  	= td.eq(22).text().trim();  
			
			vProdCd 	= td.eq(20).text().trim();
			vProdRev 	= td.eq(21).text().trim();
			vProdNm		= td.eq(1).text().trim();
			
			vDeliveryDate 		= td.eq(11).text().trim();
			vProductSerialNo	= td.eq(16).text().trim();
			vProductSerialNoEnd	= td.eq(17).text().trim();
			
			vProduct_Gubun 		= td.eq(3).text().trim();
			vPart_Source		= td.eq(4).text().trim();
			vRohs  				= td.eq(8).text().trim();
			
			vOrderDetailSeq		= td.eq(26).text().trim();
			/* ==============복사하여 수정 할 부분=====끝=========================  */   
			parent.DetailInfo_List.click();
		
	}
	
	     
    
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>고객사</th>
		     <th>제품명</th>
		     <th>PO번호</th>
		     <th style='width:0px; display: none;'>제품구분</th>
		     <th style='width:0px; display: none;'>원부자재재료</th>
		     <th>주문일자</th>
		     <th>포장단위</th>
		     <th>주문수량</th>
		     <th style='width:0px; display: none;'>자재출고일</th>
		     <th style='width:0px; display: none;'>rohs</th>
		     <th>특이사항</th>
		     <th>납기일</th>
		     <th style='width:0px; display: none;'>bom_ver</th>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>현상태명</th>
		     <th style='width:0px; display: none;'>비고</th>
		     <th style='width:0px; display: none;'>제품일련번호</th>
		     <th style='width:0px; display: none;'>제품일련번호끝</th>
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>고객사개정번호</th>
		     <th style='width:0px; display: none;'>제품코드</th>
		     <th style='width:0px; display: none;'>제품개정번호</th>
		     <th style='width:0px; display: none;'>현상태명</th>
		     <th style='width:0px; display: none;'>제품구분네임</th>
		     <th style='width:0px; display: none;'>원부자재공급방법</th>
		     <th style='width:0px; display: none;'>rohs</th>
		     <th style='width:0px; display: none;'>order_detail_seq</th>
		     
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div>              