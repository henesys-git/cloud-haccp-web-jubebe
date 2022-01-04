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
	
	String checklist_id = "", checklist_rev_no = "", ccp_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	
	
	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("ccp_date", ccp_date);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);

	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S015200E114", jArray);	
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID = "TableS838S015210";
%>
<script>

	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,2,3],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [4],
					'render': function(data) {
						if(data.slice(0,2) == '07'){
							return "전일 온도기록 확인";	
						}
						return data;
					}
				},
				{
					'targets': [5],
					'render': function(data) {
						// 이탈이어도 무조건 적합으로
						if(data == 100.0) {
							return '적합'
						} else if(data == 200.0) {
							return '적합'
						} else {
							return data;
						} 
					}
				},
				{
					'targets': [6],
					'render': function(data) {
						if(data == '') {
							var btn = " <button class='btn btn-success btn-sm btn-checklist-inspect'> " +
					  				  " 	<i class='fas fa-signature'></i> " +
					  				  " </button>";
					  		return btn;
						} else {
							return data;
						}
					}
				}]
		}
		
		var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
		
		// 점검자 서명
		$('#<%=makeGridData.htmlTable_ID%>').on("click", ".btn-checklist-inspect", function() {
			var data = table.row( $(this).parents('tr') ).data();
			var pid = "M838S015200E532";
			confirmChecklist(data, pid, function() {
				parent.fn_MainInfo_List(startDate, endDate);
				parent.fn_DetailInfo_List.click();
			});
		});
		
		loadJs(heneServerPath + '/js/auth-button/auth-button.js');
		
	});
	
	function clickSubMenu(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		checklist_id 		= td.eq(0).text().trim();
		checklist_rev_no	= td.eq(1).text().trim();
		ccp_date 			= td.eq(2).text().trim();
		seq_no 				= td.eq(3).text().trim();
		check_time 			= td.eq(4).text().trim();
		result 				= td.eq(5).text().trim();
		person_inspect_id	= td.eq(6).text().trim();
		remarks  			= td.eq(7).text().trim();
	
	}

</script>

<table class='table table-bordered nowrap table-hover' 
	  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
<thead>
	<tr>
		 <th style='width:0px; display:none;'>체크리스트ID</th>
		 <th style='width:0px; display:none;'>체크리스트 수정이력</th>
	 	 <th style='width:0px; display:none;'>점검일자</th>
	 	 <th style='width:0px; display:none;'>일련번호</th>
	     <th>점검시간</th>
	     <th>완제품냉장실 온도</th>
	     <th>점검자</th>
	     <th>점검결과 특이사항</th>
	</tr>
</thead>
<tbody id="<%=makeGridData.htmlTable_ID%>_body">
</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>