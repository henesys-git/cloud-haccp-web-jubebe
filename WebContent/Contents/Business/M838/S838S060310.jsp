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
	String GV_SUBCONTRACTOR_NO = "", GV_SUBCONTRACTOR_REV = "", GV_SUBCONTRACTOR_SEQ = "";

	if(request.getParameter("SubcontractorNo")== null)
		GV_SUBCONTRACTOR_NO = "";
	else
		GV_SUBCONTRACTOR_NO = request.getParameter("SubcontractorNo");
	if(request.getParameter("SubcontractorRev")== null)
		GV_SUBCONTRACTOR_REV = "";
	else
		GV_SUBCONTRACTOR_REV = request.getParameter("SubcontractorRev");
	if(request.getParameter("SubcontractorSeq")== null)
		GV_SUBCONTRACTOR_SEQ = "";
	else
		GV_SUBCONTRACTOR_SEQ = request.getParameter("SubcontractorSeq");
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "subcontractor_no", GV_SUBCONTRACTOR_NO);
	jArray.put( "subcontractor_rev", GV_SUBCONTRACTOR_REV);
	jArray.put( "subcontractor_seq", GV_SUBCONTRACTOR_SEQ);
	jArray.put( "member_key", member_key);
    TableModel = new DoyosaeTableModel("M838S060300E114", jArray);
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"on", "pop_fn_DetailInfo_List(this)", "상세"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS838S060310";
    
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
					'targets': [0,1,2,3],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
  		fn_Clear_varv();
    });
    
    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		subcontractor_no    = td.eq(0).text().trim();
		subcontractor_rev   = td.eq(1).text().trim();
		subcontractor_seq   = td.eq(2).text().trim();
		assessment_no       = td.eq(3).text().trim();
		assessment_division = td.eq(4).text().trim();
		assessment_article  = td.eq(5).text().trim();
		assessment_standard = td.eq(6).text().trim();
		assessment_result   = td.eq(7).text().trim();
		assessment_bigo     = td.eq(8).text().trim(); 
		
    }
   	function fn_Clear_varv(){
   		subcontractor_no    = "";
		subcontractor_rev   = "";
		subcontractor_seq   = "";
		assessment_no       = "";
		assessment_division = "";
		assessment_article  = "";
		assessment_standard = "";
		assessment_result   = "";
		assessment_bigo     = "";
   	}

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			<th style='width:0px; display: none;'>협력업체 등록번호</th>
            <th style='width:0px; display: none;'>협력업체 rev</th>
            <th style='width:0px; display: none;'>협력업체 seq</th>       
			<th style='width:0px; display: none;'>검사항목번호</th>
            <th>분류</th>
            <th>항목</th>
            <th>기준</th>
            <th>평가결과</th>
            <th>비고</th>             
<!-- 			<th style='width:0px; display: none;'></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div>   
    