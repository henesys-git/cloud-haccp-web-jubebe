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
	
	String GV_FROMDATE = "",GV_TODATE = "" ;

	if(request.getParameter("From") != null)
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		GV_TODATE = request.getParameter("To");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("fromdate", GV_FROMDATE);
	jArray.put("todate", GV_TODATE);
	
    TableModel = new DoyosaeTableModel("M838S070300E104", jArray);

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
    
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {
    							{"off", "fn_HACCP_View_Canvas(this)", "점검표"},
    							{"off", "fn_Doc_Reg()", rightbtnDocSave},
    							{"on", "file_real_name", rightbtnDocShow}};

    makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS838S070300";
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
					'targets': [1,2,4,5,7,8,9],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
    	vCheckDate = "";
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
    	vCheckDate = td.eq(0).text().trim();
    	
    	parent.DetailInfo_List.click();
    }

</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th>점검일자</th>
		     <th style='width:0px; display: none;'>점검자id</th>
		     <th style='width:0px; display: none;'>점검자rev</th>
		     <th>점검자</th>
		     <th style='width:0px; display: none;'>업소명코드</th>
		     <th style='width:0px; display: none;'>업소명코드rev</th>
		     <th>작성자</th>
		     <th style='width:0px; display: none;'>작성일</th>
		     <th style='width:0px; display: none;'>승인</th>
		     <th style='width:0px; display: none;'>승인일</th>
			 <th></th> <!-- for button -->
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>