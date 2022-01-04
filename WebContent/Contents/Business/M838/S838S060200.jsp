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
	String GV_DELETE_CHECK ="", GV_PID ="";
	
	String GV_FROMDATE="",GV_TODATE="",custCode="", GV_JSPPAGE;

	if(request.getParameter("From")== null)
		GV_FROMDATE="";
	else
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		GV_TODATE="";
	else
		GV_TODATE = request.getParameter("To");	
	
	if(request.getParameter("custcode")== null)
		custCode="";
	else
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");
	
	if (request.getParameter("delete_check") == null)
		GV_DELETE_CHECK = "";
	else
		GV_DELETE_CHECK = request.getParameter("delete_check");
	
	//jArray.put( "custcode", custCode);
	//jArray.put( "jsppage", GV_JSPPAGE);
	JSONObject jArray = new JSONObject();
	jArray.put( "fromdate", GV_FROMDATE);
	jArray.put( "todate", GV_TODATE);	
	jArray.put( "member_key", member_key);
	
	if(GV_DELETE_CHECK.equals("true")) GV_PID = "M838S060200E105";
	else if(GV_DELETE_CHECK.equals("false")) GV_PID = "M838S060200E104";
	
	TableModel = new DoyosaeTableModel(GV_PID, jArray);
	
 	int RowCount =TableModel.getRowCount();	
    //int colspanCount =TableModel.getColumnCount();
 
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
 	makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"on", "fn_HACCP_View_Canvas(this)", "점검표"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	makeGridData.RightButton	= RightButton;
	
 	makeGridData.htmlTable_ID	= "tableS838S060200";
 
	makeGridData.Check_Box 	= "false";
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	makeGridData.HyperLink 	= HyperLink; 
%>

    
<script>
	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [1,2,10,11,12,13],
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
	var vSubcontractor_no 	= "";
	var vSubcontractor_rev 	= "";
	var vSubcontractor_seq 	= "";
	
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		vSubcontractor_no  = td.eq(0).text().trim();
	    vSubcontractor_rev = td.eq(1).text().trim();
	    vSubcontractor_seq = td.eq(2).text().trim();
        vCust_nm           = td.eq(3).text().trim();
        vBoss_name         = td.eq(4).text().trim();
        vUptae             = td.eq(5).text().trim();
        vJongmok           = td.eq(6).text().trim();
        vIo_gb             = td.eq(7).text().trim();
        vStart_date        = td.eq(8).text().trim();
        vCreate_date       = td.eq(9).text().trim();
        vCreate_user_id    = td.eq(10).text().trim();
        vModify_date       = td.eq(11).text().trim();
        vModify_user_id    = td.eq(12).text().trim();
        vDuration_date     = td.eq(13).text().trim();
	    
        DetailInfo_List.click();
	}
	
	function fn_Clear_varv(){
		vSubcontractor_no  = "";
		vSubcontractor_rev = "";
		vSubcontractor_seq = "";
		vCust_nm           = "";
		vBoss_name         = "";
		vUptae             = "";
		vJongmok           = "";
		vIo_gb             = "";
		vStart_date        = "";
		vCreate_date       = "";
		vCreate_user_id    = "";
		vModify_date       = "";
		vModify_user_id    = "";
		vDuration_date     = "";
	}


</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			<th>협력업체 등록번호</th>
			<th style='width:0px; display: none;'>협력업체 rev</th>
			<th style='width:0px; display: none;'>협력업체 seq</th>
			<th>협력업체 이름</th>
			<th>협력업체 대표자</th>
			<th>업태</th>
			<th>종목</th>
			<th>공급/납품구분</th>
			<th>거래개시일</th>
			<th>작성일</th>
			<th style='width:0px; display: none;'>작성자</th>
			<th style='width:0px; display: none;'>수정일</th>
			<th style='width:0px; display: none;'>수정자</th>
			<th style='width:0px; display: none;'>지속기간</th>
			<!-- <th></th> --> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center"></div>

