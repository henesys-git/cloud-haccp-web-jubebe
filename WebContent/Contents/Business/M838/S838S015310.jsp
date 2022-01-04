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
	
	String ccp_date = "";
			
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("ccp_date", ccp_date);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S015300E114", jArray);	
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S015310";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=tData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,2,3],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [8],
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
		
		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    	// 점검자 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-inspect", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S015300E542";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    			parent.fn_DetailInfo_List();
    		});
    	});
    	
    	loadJs(heneServerPath + '/js/auth-button/auth-button.js');
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		seq_no 	= td.eq(3).text().trim();
		check_time = td.eq(4).text().trim();
		remarks = td.eq(9).text().trim();	
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th style='width:0px; display:none;'>체크리스트 ID</th>
		    <th style='width:0px; display:none;'>체크리스트 수정이력</th>
		 	<th style='width:0px; display:none;'>작성일자</th>
		 	<th style='width:0px; display:none;'>일련번호</th>
		    <th>통과시간</th>
		    <th>제품명</th>
		    <th>Fe</th>
		    <th>SUS</th>
		    <th>점검자</th>
	     	<th>점검결과 특이사항</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>