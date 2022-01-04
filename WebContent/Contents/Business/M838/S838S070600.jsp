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
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070600E104", jArray);	
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS8838S070600";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=tData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,3,11,12,13],
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
				}],
				pageLength: 10
		}
		
		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
    	// 승인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-approve", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S070600E502";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    		});
    	});
    	
    	// 확인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-check", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S070600E522";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    		});
    	});
    	
    	loadJs(heneServerPath + '/js/auth-button/auth-button.js');
    });

    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		checklist_id 		 = td.eq(0).text().trim();
		checklist_rev_no 	 = td.eq(1).text().trim();
		regist_date 		 = td.eq(2).text().trim();
		seq_no 				 = td.eq(3).text().trim();
		unsuit		 		 = td.eq(4).text().trim();
		defect_date 		 = td.eq(5).text().trim();
		unsuit_detail 		 = td.eq(6).text().trim();
		defect_result 		 = td.eq(7).text().trim();
		person_write_id		 = td.eq(8).text().trim();
		person_check_id 	 = td.eq(9).text().trim();
		person_approve_id	 = td.eq(10).text().trim();
		file_name		 	 = td.eq(11).text().trim();
		file_path			 = td.eq(12).text().trim();
		regist_no			 = td.eq(13).text().trim();
		
		$("txt_doccode").val(file_name);
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>체크리스트 ID</th>
		     <th style='width:0px; display:none;'>체크리스트 수정이력</th>
		     <th>작성일자</th>
		     <th style='width:0px; display:none;'>일련번호</th>
			 <th>부적합 사항 기록</th>
			 <th>이탈일시</th>
		     <th>이탈발생내용</th>
		     <th>이탈원인 조사 및 결과</th>
		     <th>작성자</th>
		     <th>확인자</th>
		     <th>승인자</th>
		     <th style='width:0px; display:none;'>file_name</th>
		     <th style='width:0px; display:none;'>file_path</th>
		     <th style='width:0px; display:none;'>regist_no</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>