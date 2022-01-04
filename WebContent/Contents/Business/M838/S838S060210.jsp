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
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String GV_SUBCONSTRACTOR_NO = "", GV_SUBCONSTRACTOR_REV = "";
	
	if(request.getParameter("Subcontractor_no")== null)
		GV_SUBCONSTRACTOR_NO ="";
	else
		GV_SUBCONSTRACTOR_NO = request.getParameter("Subcontractor_no");
	
	if(request.getParameter("Subcontractor_rev")== null)
		GV_SUBCONSTRACTOR_REV ="";
	else
		GV_SUBCONSTRACTOR_REV = request.getParameter("Subcontractor_rev");
	
	System.out.println("GV_SUBCONSTRACTOR_REV : "+ GV_SUBCONSTRACTOR_REV);
	JSONObject jArray = new JSONObject();
	jArray.put( "subcontractor_no", GV_SUBCONSTRACTOR_NO);
	jArray.put( "subcontractor_rev", GV_SUBCONSTRACTOR_REV);
	jArray.put( "member_key", member_key);
	
// 	TableModel = new DoyosaeTableModel("M808S060200E114", strColumnHead, param);
	TableModel = new DoyosaeTableModel("M838S060200E114", jArray);
 	int RowCount =TableModel.getRowCount();	
    //int colspanCount =TableModel.getColumnCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS808S060210";
    
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
					'targets': [0,1,10,11,12],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
		
	});


</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th style='width:0px; display: none;'>협력업체 등록번호</th>
			<th style='width:0px; display: none;'>협력업체 rev</th>
			<th>구분</th>
			<th>인원</th>
			<th>사무직</th>
			<th>기술직</th>
			<th>생산직</th>
			<th>기타</th>
			<th>계</th>
			<th>비고</th>			
			<th style='width:0px; display: none;'>멤버키</th>
			<th style='width:0px; display: none;'>rev</th>
			<th style='width:0px; display: none;'>seq</th>
<!-- 			<th style='width:0px; display: none;'></th> -->
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>		
<div id="UserList_pager" class="text-center">
</div>
