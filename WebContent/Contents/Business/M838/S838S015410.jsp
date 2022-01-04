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
	
	String checklist_id = "", checklist_rev_no = "", ccp_date = "";
			

	if(request.getParameter("From") != null)
		GV_FROMDATE = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		GV_TODATE = request.getParameter("To");
	
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
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S015400E114", jArray);	
 	MakeGridData tData = new MakeGridData(TableModel);
 	tData.htmlTable_ID = "TableS838S015410";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=tData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,3,4,5,6,7,8,9,12],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
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
				}]
		}
		
		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    	//서명인 서명
    	$('#<%=tData.htmlTable_ID%>').on("click", ".btn-checklist-action", function() {
    		var data = table.row( $(this).parents('tr') ).data();
    		var pid = "M838S015400E532";
    		confirmChecklist(data, pid, function() {
    			parent.fn_MainInfo_List(startDate, endDate);
    		});
    	});
    	
    	loadJs(heneServerPath + '/js/auth-button/auth-button.js');
    	
    	
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		s_ccp_date 			= td.eq(0).text().trim();
		check_time			= td.eq(1).text().trim();
		prod_nm 			= td.eq(2).text().trim();
		prod_cd 			= td.eq(3).text().trim();
		revision_no 		= td.eq(4).text().trim();
		fe_only 			= td.eq(5).text().trim();
		sus_only 			= td.eq(6).text().trim();
		prod_only  			= td.eq(7).text().trim();
		fe_with_prod  		= td.eq(8).text().trim();
		sus_with_prod  		= td.eq(9).text().trim();
		result 				= td.eq(10).text().trim();
		person_signer		= td.eq(11).text().trim();
		person_sign_id		= td.eq(12).text().trim();
		note_unusual		= td.eq(13).text().trim();
		console.log('통과시간:' + check_time);
		
    }
    
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		 	 <th style='width:0px; display:none;'>작성일자</th>
		     <th>통과시간</th>
		     <th>제품명</th>
		     <th style='width:0px; display:none;'>제품코드</th>
		     <th style='width:0px; display:none;'>제품수정이력</th>
		     <th style='width:0px; display:none;'>Fe만 통과</th>
		     <th style='width:0px; display:none;'>SUS만 통과</th>
		     <th style='width:0px; display:none;'>제품만 통과</th>
		     <th style='width:0px; display:none;'>Fe+제품 통과</th>
		     <th style='width:0px; display:none;'>SUS+제품 통과</th>
		     <th>판정</th>
		     <th>서명인</th>
		     <th style='width:0px; display:none;'>서명인 ID</th>
		     <th>특이사항</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>