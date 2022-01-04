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
	
	String GV_FROMDATE="",GV_TODATE="";

	if(request.getParameter("From")== null)
		GV_FROMDATE = "";
	else
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		GV_TODATE="";
	else
		GV_TODATE = request.getParameter("To");	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "fromdate", GV_FROMDATE);
	jArray.put( "todate", GV_TODATE);
	
    TableModel = new DoyosaeTableModel("M838S060300E104", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"on", "fn_HACCP_View_Canvas(this)", "점검표"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS838S060300";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	
%>
<script type="text/javascript">
	
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [1,2,5,9],
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
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vSubcontractor_no   = td.eq(0).text().trim();
		vSubcontractor_rev  = td.eq(1).text().trim();
		vSubcontractor_seq  = td.eq(2).text().trim();
		vSubcontractor_name = td.eq(3).text().trim();
		vInspector          = td.eq(4).text().trim();
		vInspector_rev      = td.eq(5).text().trim();
		vUptae              = td.eq(6).text().trim();
		vAssessment_date    = td.eq(7).text().trim();
		vWritor             = td.eq(8).text().trim();
		vWritor_rev         = td.eq(9).text().trim();
		vWrite_date         = td.eq(10).text().trim();
		vIo_gb         		= td.eq(11).text().trim(); 
//		console.log(vSubcontractor_no + "~~" + vSubcontractor_rev + "~~" + vSubcontractor_seq);
		parent.DetailInfo_List.click();
    }
	function fn_Clear_varv(){
		vSubcontractor_no   = "";
		vSubcontractor_rev  = "";
		vSubcontractor_seq  = "";
		vSubcontractor_name = "";
		vInspector          = "";
		vInspector_rev      = "";
		vUptae              = "";
		vAssessment_date    = "";
		vWritor             = "";
		vWritor_rev         = "";
		vWrite_date         = ""; 
		vIo_gb				= "";
	}
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			<th>협력업체 등록번호</th>
            <th style='width:0px; display: none;'>협력업체 rev</th>
            <th style='width:0px; display: none;'>협력업체 seq</th>
            <th>협력업체명</th>
            <th>점검자</th>
            <th style='width:0px; display: none;'>점검자rev</th>
            <th>업태</th>
            <th>검사일자</th>
            <th>작성자</th>
            <th style='width:0px; display: none;'>작성자rev</th>
            <th>작성일</th>
            <th>입출고구분</th>
<!--           	<th></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div>   
    