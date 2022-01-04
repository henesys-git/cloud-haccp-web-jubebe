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
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", "입고문서"}
							  };


	String Fromdate="", Todate="", custCode="", GV_JSPPAGE="";

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
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", Fromdate);
	jArray.put( "todate", Todate);
	jArray.put( "custcode", custCode);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M202S030100E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	 
    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS202S040100";
    
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
    	       		'targets': [1,2,3,4,5,6,8,9,10,12,14,15,16,17,18,19,20],
    	       		'createdCell':  function (td) {
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
		vOrderNo	= "";
		vLotNo		= "";
		vBaljuNo		= "";
    }
    
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success
	
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		vOrderNo	= td.eq(2).text().trim(); 
		vLotNo		= td.eq(3).text().trim(); 
		vBaljuNo	= td.eq(4).text().trim(); 
		
		DetailInfo_List.click();
	}
	

    
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			    <th>업체</th>
		     	<th style='width:0px; display: none;'>멤버키</th>
				<th style='width:0px; display: none;'>주문번호</th>
				<th style='width:0px; display: none;'>LOT NO</th>
				<th style='width:0px; display: none;'>발주번호</th>
				<th style='width:0px; display: none;'>발주명</th>
				<th style='width:0px; display: none;'>제품명</th>
				<th>발주일자</th>
				<th style='width:0px; display: none;'>고객코드</th>
				<th style='width:0px; display: none;'>고객코드개정번호</th>
				<th style='width:0px; display: none;'>고객사담당자명</th>
				<th>전화번호</th>
				<th style='width:0px; display: none;'>팩스번호</th>
				<th>발주납기일자</th>
				<th style='width:0px; display: none;'>납품장소</th>
				<th style='width:0px; display: none;'>품질조건내용</th>
				<th style='width:0px; display: none;'>발주처리상태</th>
				<th style='width:0px; display: none;'>검토번호</th>
				<th style='width:0px; display: none;'>승인번호</th>
				<th style='width:0px; display: none;'>주문상세번호</th>
			     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
			     <th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              