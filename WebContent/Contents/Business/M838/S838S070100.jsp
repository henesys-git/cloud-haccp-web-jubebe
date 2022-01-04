<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
String member_key = session.getAttribute("member_key").toString();

String ipgo_date = "";

if (request.getParameter("ipgo_date") != null)
	ipgo_date = request.getParameter("ipgo_date");

JSONObject jArray = new JSONObject();
jArray.put("member_key", member_key);
jArray.put("ipgo_date", ipgo_date);

DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070100E104", jArray);
MakeGridData tData = new MakeGridData(TableModel);
tData.htmlTable_ID = "TableS838S070100";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=tData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,2,3,4,5,6,7,8,9],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [13],
					'render': function(data) {
						data = parseInt(data);
						return data;
					}
				},
				{
					'targets': [15],
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
					'targets': [16],
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
				}]
		}
		
		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
    	// 승인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-approve", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S070100E502";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(toDate);
    		});
    	});
    	
    	// 승인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-check", function() {
			var data = table.row($(this).parents('tr')).data();
			var pid = "M838S070100E522";
			confirmChecklist(data, pid, function() {
				parent.fn_MainInfo_List(toDate);
			});
		});

		loadJs(heneServerPath + '/js/auth-button/auth-button.js');
	});

	function clickMainMenu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
	
		checklist_id 	 = td.eq(0).text().trim();
		checklist_rev_no = td.eq(1).text().trim();
		ipgo_date 		 = td.eq(2).text().trim();
		seq_no 			 = td.eq(3).text().trim();
		regist_seq_no 	 = td.eq(4).text().trim();
		trace_key		 = td.eq(9).text().trim();
		part_cd 		 = td.eq(7).text().trim();
		
		cust_nm 		 = td.eq(11).text().trim();
		part_nm 		 = td.eq(12).text().trim();
		ipgo_amount 	 = td.eq(13).text().trim();
		ipgo_amount	= parseInt(ipgo_amount);
			
		parent.DetailInfo_List.click();
	}
</script>

<table class='table table-bordered nowrap table-hover'
	id="<%=tData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th style='width: 0px; display: none;'>체크리스트 ID</th>
			<th style='width: 0px; display: none;'>체크리스트 수정이력</th>
			<th style='width: 0px; display: none;'>상세일련번호</th>
			<th style='width: 0px; display: none;'>작성일련번호</th>
			<th style='width: 0px; display: none;'>입고일자</th>
			<th style='width: 0px; display: none;'>업체코드</th>
			<th style='width: 0px; display: none;'>업체 수정이력</th>
			<th style='width: 0px; display: none;'>원부재료코드</th>
			<th style='width: 0px; display: none;'>원부재료 수정이력</th>
			<th style='width: 0px; display: none;'>이력 추적키</th>
			<th>입고일자</th>
			<th>업체명</th>
			<th>제품명</th>
			<th>입고량</th>
			<th>작성자</th>
			<th>확인자</th>
			<th>승인자</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>
<div id="UserList_pager" class="text-center"></div>