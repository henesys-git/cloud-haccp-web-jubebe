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

	String ipgo_date = "";
	
	

	if(request.getParameter("ipgo_date") != null)
		ipgo_date = request.getParameter("ipgo_date");
	

	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("ipgo_date", ipgo_date);
	
	
	
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070200E104", jArray);	
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S070200";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=tData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,4,6],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
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
				}]
		}
		
		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    	
    	// 승인자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-approve", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S070200E502";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(toDate);
    		});
    	});
    	
    	loadJs(heneServerPath + '/js/auth-button/auth-button.js');
    	
    });

    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		checklist_id		= td.eq(0).text().trim();
		checklist_rev_no 	= td.eq(1).text().trim();
		ipgo_date  			= td.eq(2).text().trim();
		ipgo_part_count		= td.eq(3).text().trim();
		person_write_id  	= td.eq(4).text().trim();
		person_writer  		= td.eq(5).text().trim();
		person_approve_id  	= td.eq(6).text().trim();
		person_approver  	= td.eq(7).text().trim();
		unsuit_detail 		= td.eq(8).text().trim();
		improve_action 		= td.eq(9).text().trim();
		
		
		console.log('체크리스트ID:' + checklist_id);
		console.log('체크리스트 수정이력:' + checklist_rev_no);
		console.log('입고일자:' + ipgo_date);
		
		parent.DetailInfo_List.click();
		
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>체크리스트 ID</th>
		     <th style='width:0px; display:none;'>체크리스트 수정이력</th>
		     <th>입고일자</th>
		     <th>입고검사 부자재 품목수</th>
			 <th style='width:0px; display:none;'>작성자 ID</th>
			 <th>작성자</th>
			 <th style='width:0px; display:none;'>승인자 ID</th>
			 <th>승인자</th>
			 <th>부적합 사항</th>
		     <th>개선조치 사항</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>