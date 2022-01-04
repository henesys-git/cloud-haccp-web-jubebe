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

	
	int startPageNo =1; //Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());

	String Fromdate="",Todate="",custCode="", GV_JSPPAGE;
	
	
	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("custcode")== null)
		custCode="";
	else
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");
	
	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
	
// 	수입검사신청서 조회
    TableModel = new DoyosaeTableModel("M404S010100E804", jArray);	

 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS404S010800";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	

   // int ColCount =TableModel.getColumnCount()+1;
//     out.println(makeTableHTML.getHTML());
%>
<script>
	$(document).ready(function () {
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
	
		var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs : [{
				'targets': [1,2,3,7,8,9,10,11,12,13,14,15,16,17,18],
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

	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success
	
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

// 		vHistNo 	= td.eq(0).text().trim();  
// 		vOrderNo	= td.eq(1).text().trim(); 
// 		vLotNo		= td.eq(2).text().trim();  
// 		vIpgo_no 	= td.eq(3).text().trim(); 
// 		vIo_seqno 	= td.eq(5).text().trim(); 
// 		vPart_cd 	= td.eq(8).text().trim(); 
// 		vPart_cd_rev 	= td.eq(9).text().trim();
		
//		vOrderNo	= td.eq(2).text().trim(); 
//		vLotNo		= td.eq(3).text().trim(); 
		vBaljuNo	= td.eq(4).text().trim(); 
		
// 		DetailInfo_List.click();
		parent.DetailInfo_List.click();
	}

	function fn_Clear_varv(){
	//		vHistNo 	= "";
	//		vIpgo_no	= "";
	//		vIo_seqno	= "";
	//		vPart_cd	= "";
	//		vPart_cd_rev	= "";
	//	vOrderNo	= "";
	//	vLotNo		= "";
		vBaljuNo		= "";
	}

	
   
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			
			<th>업체</th>
	     	<th style='width:0px; display: none;'>멤버키</th>
			<th style='width:0px; display: none;'>주문번호</th>
			<th style='width:0px; display: none;'>LOT NO</th>
			<th>발주번호</th>
			<th>발주명</th>
			<th>발주일자</th>
			<th style='width:0px; display: none;'>고객코드</th>
			<th style='width:0px; display: none;'>고객코드개정번호</th>
			<th style='width:0px; display: none;'>고객사담당자명</th>
			<th style='width:0px; display: none;'>전화번호</th>
			<th style='width:0px; display: none;'>팩스번호</th>
			<th style='width:0px; display: none;'>발주납기일자</th>
			<th style='width:0px; display: none;'>납품장소</th>
			<th style='width:0px; display: none;'>품질조건내용</th>
			<th style='width:0px; display: none;'>발주처리상태</th>
			<th style='width:0px; display: none;'>검토번호</th>
			<th style='width:0px; display: none;'>승인번호</th>
			<th style='width:0px; display: none;'>주문상세번호</th>
			<!-- <th>체크값</th> -->
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<div id="UserList_pager" class="text-center">
</div>              