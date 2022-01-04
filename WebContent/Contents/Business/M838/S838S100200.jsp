<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_FROMDATE = "", GV_TODATE = "";

	if(request.getParameter("From") != null)
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		GV_TODATE = request.getParameter("To");	

	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", GV_FROMDATE);
	jArray.put("todate", GV_TODATE);					
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S100200E104", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S100200";
%>
<style>
.open_file i {
	color: yellowgreen;
    font-size: 21px;
    cursor: pointer;
    margin-bottom: 0;
}

.open_file:hover i,.open_file:hover {
	color:darkseagreen;
	border-color:darkseagreen;	
}

.open_file {
    border-color: yellowgreen;
    box-shadow: none;
    padding: 0px 11px;
    border-style: double;
    border-radius: 3px;
    padding-top: 3px;
}
</style>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=tData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,3,5,6,7,12,13,14,16],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [9],
					'render': function(data) {
						if(data == '') {
							var btn = " <button class='btn btn-success btn-sm btn-checklist-check'> " +
					  				  " 	<i class='fas fa-signature'></i> " +
					  				  " </button>";
					  		return btn;
						} else {
							return data;
						}
					}
				},
				{
					'targets': [10],
					'render': function(data) {
						if(data == '') {
							var btn = " <button class='btn btn-success btn-sm btn-checklist-approve'> " +
					  				  " 	<i class='fas fa-signature'></i> " +
					  				  " </button>";
					  		return btn;
						} else {
							return data;
						}
					}
				},
				{
					'targets': [11],
					'render': function(data) {
						if(data == '') {
							var btn = " <button class='btn btn-success btn-sm btn-checklist-action'> " +
					  				  " 	<i class='fas fa-signature'></i> " +
					  				  " </button>";
					  		return btn;
						} else {
							return data;
						}
					}
				},
				{
					'targets': [15],
					'render': function(data) {
						if(data == '') {
							var str = "";
						} else {
							var str = "<button type = 'button' class = 'open_file' ><i class='far fa-file-image'></i></button>";
						}
						return str;
					}
				}]
		}
		
		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
    	// 승인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-approve", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S100200E502";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    		});
    	});
    	
    	// 확인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-check", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S100200E522";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    		});
    	});
    	
    	// 개선조치확인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-action", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S100200E532";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    		});
    	});
    	
    	$(".open_file").click(function() {
    		clickMainMenu($(this).closest("tr"));
    		var url = "<%=Config.this_SERVER_path%>/docDisplay?filePath=" + file_path;
        	window.open(url);
    		<%-- window.open("<%= request.getContextPath() %>/viewimg/"+file_path.slice(13)); --%>
    	});
    	
    	loadJs(heneServerPath + '/js/auth-button/auth-button.js');
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		checklist_id = td.eq(0).text().trim();;
		checklist_rev_no = td.eq(1).text().trim();
		drive_date = td.eq(2).text().trim();
		regist_seq_no = td.eq(3).text().trim();
		
		regist_no = td.eq(12).text().trim();
		file_name = td.eq(13).text().trim();
		file_path = td.eq(14).text().trim();
		file_rev_no = td.eq(16).text().trim();
		
		parent.DetailInfo_List.click();
    }
</script>
<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		    <th style='width:0px; display:none;'>체크리스트 ID</th>
		    <th style='width:0px; display:none;'>체크리스트 수정이력</th>
		    <th>운행일자</th>
		    <th style='width:0px; display:none;'>작성일련번호</th>
		    <th>운행구분</th>
		    <th style='width:0px; display:none;'>부적합 사항</th>
		    <th style='width:0px; display:none;'>개선조치사항</th>
		    <th style='width:0px; display:none;'>특이사항</th>
		    <th>작성자</th>
		    <th>확인자</th>
		    <th>승인자</th>
		    <th>개선조치 확인</th>
		    <th style='width:0px; display:none;'>car_temp_regist_no</th>
			<th style='width:0px; display:none;'>file_name</th>
			<th style='width:0px; display:none;'>file_path</th>
			<th style = "width: 50px;">첨부</th>
			<th style='width:0px; display:none;'>file_rev_no</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>
<div id="UserList_pager" class="text-center"></div>