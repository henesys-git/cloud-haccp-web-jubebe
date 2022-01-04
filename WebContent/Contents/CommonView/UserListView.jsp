<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<%
	DoyosaeTableModel TableModel;

	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String RightButton[][] = {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							 };
	
	String GV_CALLER = "";
	String GV_ROWID = "";
	String SEARCH_USER_ID="", SEARCH_USER_NM="",SEARCH_JIKWI="",SEARCH_LOCATION="",SEARCH_OPTION_CODE="";

	if(request.getParameter("caller")== null)
		GV_CALLER = "0";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("rowId")== null)
		GV_ROWID = "0";
	else
		GV_ROWID = request.getParameter("rowId");		

	String param = "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put("GV_ROWID", GV_ROWID);
	jArray.put("member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M909S080100E114", jArray);
    int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();

 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
 	
  	makeGridData.htmlTable_ID	= "tableUserView";
%>

 
<script>
// document.body.onload = function () { window.print();}
	var txt_CustName;
	var caller = "";
	var rowId = "";
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
		rowId = "<%=GV_ROWID%>";
    	
		$('#<%=makeGridData.htmlTable_ID%>').DataTable({	    
    		scrollX: true,
    	    scrollCollapse: true,
    	    autoWidth: false,
    	    processing: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 0, "desc" ]],
    	    info: true,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{
    	    	'targets': [1,3,4,10,11,12,13,14,15,16,17,18],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    }],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
   	  	});
		
	});
	
	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });

		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");

		var user_id 	= td.eq(0).text().trim();
		var revision_no = td.eq(1).text().trim();
		var user_nm 	= td.eq(2).text().trim();
		var group_cd 	= td.eq(3).text().trim();
		var dept_cd 	= td.eq(4).text().trim();
		var jikwi 		= td.eq(5).text().trim();
		var LOCATION 	= td.eq(6).text().trim();
		var hpno 		= td.eq(7).text().trim();
		var email 		= td.eq(8).text().trim();
		var hour_pay 	= td.eq(9).text().trim();
		
		if(caller=="0") { //일반 화면에서 부를 때
			$('#txt_user_id', 		parent.document).val(user_id);
			$('#txt_revision_no', 	parent.document).val(revision_no);
			$('#txt_group_cd', 		parent.document).val(group_cd);
			$('#txt_dept_cd', 		parent.document).val(dept_cd);
			$('#txt_user_nm', 		parent.document).val(user_nm);
			$('#txt_jikwi', 		parent.document).val(jikwi);
			$('#txt_LOCATION', 		parent.document).val(LOCATION);
			$('#txt_hpno', 			parent.document).val(hpno);
			$('#txt_email', 		parent.document).val(email);
		} else if(caller == 1) { //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
 			parent.SetUser_Select(user_nm, rowId);
		} else if(caller == 2) {
			parent.SetUser_Select(user_id, revision_no, user_nm);
		} else if(caller == 3) {
			parent.SetUser_Select(user_id, revision_no, user_nm, hour_pay);
		}
		
		parent.$('#modalReport_nd').hide();
	}
</script>	

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>사용자 ID</th>
			<th style='width:0px; display: none;'>revision_no</th>
			<th>사용자명</th>
			<th style='width:0px; display: none;'>그룹코드</th>
			<th style='width:0px; display: none;'>부서코드</th>
			<th>직위</th>
			<th>지역</th>
			<th>전화번호</th>
			<th>이메일</th>
			<th>시급</th>
			<th style='width:0px; display: none;'>delyn</th>
			<th style='width:0px; display: none;'>start_date</th>
			<th style='width:0px; display: none;'>create_user_id</th>
			<th style='width:0px; display: none;'>create_date</th>
			<th style='width:0px; display: none;'>modify_user_id</th>
			<th style='width:0px; display: none;'>modify_date</th>
			<th style='width:0px; display: none;'>modify_reason</th>
			<th style='width:0px; display: none;'>duration_date</th>
			<!-- 버튼자리 -->
			<th style='width:0px; display: none;'></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div> 
