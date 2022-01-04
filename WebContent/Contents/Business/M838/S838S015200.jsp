<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_FROMDATE = "", GV_TODATE = "";
	
	if(request.getParameter("From") != null)
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		GV_TODATE = request.getParameter("To");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("fromdate", GV_FROMDATE);
	jArray.put("todate", GV_TODATE);
		
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S015200E104", jArray);	
 	MakeGridData tData = new MakeGridData(TableModel);
 	tData.htmlTable_ID = "TableS838S015200";
%>
<script>

	$(document).ready(function () {
	
		var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [
					{
						'targets': [0,1,4],
						'createdCell': function (td) {
				  			$(td).attr('style', 'display: none;'); 
						}
					},
					{
						'targets': [6],
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
						'targets': [7],
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
						'targets': [8],
						'render': function(data) {
							if(data == '') {
								var btn = " <button class='btn btn-success btn-sm btn-checklist-confirm'> " +
						  				  " 	<i class='fas fa-signature'></i> " +
						  				  " </button>";
						  		return btn;
							} else {
								return data;
							}
						}
					}
				]
		}
	
		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
		// 승인자 서명
		$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-approve", function() {
			var data = table.row( $(this).parents('tr') ).data();
			var pid = "M838S015200E502";
			confirmChecklist(data, pid, function() {
				parent.fn_MainInfo_List(startDate, endDate);
			});
		});
		
		// 검토자 서명
		$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-check", function() {
			var data = table.row( $(this).parents('tr') ).data();
			var pid = "M838S015200E512";
			confirmChecklist(data, pid, function() {
				parent.fn_MainInfo_List(startDate, endDate);
			});
		});
		
		// 품질관리팀장 서명
		$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-confirm", function() {
			let pid = "M838S015200E522";
			let btn = $(this);
			let reload = function() {
				parent.fn_MainInfo_List(startDate, endDate);
			}
			
			let sign = new ChecklistSignature(table, pid, btn);
	   		sign.selectTimeAndSign(reload);
		});
		
		loadJs(heneServerPath + '/js/auth-button/auth-button.js');
	});
	
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		checklist_id		= td.eq(0).text().trim();
		checklist_rev_no 	= td.eq(1).text().trim();
		ccp_date  			= td.eq(2).text().trim();
		record_time			= td.eq(3).text().trim();
		person_monitoring_id 	= td.eq(4).text().trim();
		person_write_id  	= td.eq(5).text().trim();
		person_check_id  	= td.eq(6).text().trim();
		person_approve_id  	= td.eq(7).text().trim();
		person_qm_id  		= td.eq(8).text().trim();
		
		parent.DetailInfo_List.click();
	}
</script>

<table class='table table-bordered nowrap table-hover' 
	  id="<%=tData.htmlTable_ID%>" style="width:100%">
<thead>
	<tr>
	     <th style='width:0px; display:none;'>체크리스트 ID</th>
	     <th style='width:0px; display:none;'>체크리스트 수정이력</th>
	     <th>점검일자</th>
	     <th>기록검증 시간</th>
		 <th style='width:0px; display:none;'>담당자</th>
		 <th>작성자</th>
		 <th>검토자</th>
		 <th>승인자</th>
		 <th>품질관리팀장</th>			
	</tr>
</thead>
<tbody id="<%=tData.htmlTable_ID%>_body">
</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>