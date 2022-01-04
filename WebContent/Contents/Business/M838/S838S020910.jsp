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

	String check_date = "", regist_date = "";

	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("check_date", check_date);		
	jArray.put("regist_date", regist_date);		
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020900E114", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S020910";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = '<%=tData.htmlTable_ID%>';
    	
    	var dataArr = <%=tData.getDataArray()%>;
    	
    	var customOpts = {
    			data : dataArr,
    			columnDefs : [{
					'targets': [0, 1, 3],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},{
					'targets': [5],
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
				}]
		};
		
 		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		); 
 			
 		// HACCP 팀장 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-check", function() {
    		var data = table.row( $(this).parents('tr') ).data();   		
    		var pid = "M838S020900E532";
    		confirmChecklist(data, pid, function() {
    			parent.DetailInfo_List.click();
    		});
    	});
    	
    });
      
     function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
    	
		checklist_id 		= td.eq(0).text().trim();
		checklist_rev_no	= td.eq(1).text().trim();
		check_date 			= td.eq(2).text().trim();
		regist_date 		= td.eq(3).text().trim();
		person_produce_id	= td.eq(4).text().trim();
		person_haccp_id		= td.eq(5).text().trim();

    } 
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>체크리스트ID</th>
		     <th style='width:0px; display:none;'>체크리스트 작성일자</th>
		     <th>점검일자</th>
		     <th style='width:0px; display:none;'>작성일자</th>
   		     <th>생산팀장</th>
		     <th>HACCP팀장</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>
<div id="UserList_pager" class="text-center"></div>