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
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070500E104", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S070500";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=tData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [8],
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
    		var pid = "M838S070500E502";
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
		
		
		checklist_id 		= td.eq(0).text().trim();
		checklist_rev_no 	= td.eq(1).text().trim();
		check_date 			= td.eq(2).text().trim();
		limit_unsuit 		= td.eq(3).text().trim();
		action_result 		= td.eq(4).text().trim();
		action_yn 			= td.eq(5).text().trim();
		check_yn 			= td.eq(6).text().trim();
		person_write		= td.eq(7).text().trim();
		person_approve		= td.eq(8).text().trim();
		check1				= td.eq(9).text().trim();
		check1_detail		= td.eq(10).text().trim();
		check2				= td.eq(11).text().trim();
		check2_detail		= td.eq(12).text().trim();
		check3				= td.eq(13).text().trim();
		check3_detail		= td.eq(14).text().trim();
		check4				= td.eq(15).text().trim();
		check4_detail		= td.eq(16).text().trim();
		check5				= td.eq(17).text().trim();
		check5_detail		= td.eq(18).text().trim();
		check6				= td.eq(19).text().trim();
		check6_detail		= td.eq(20).text().trim();
		check7				= td.eq(21).text().trim();
		check7_detail		= td.eq(22).text().trim();
		check8				= td.eq(23).text().trim();
		check8_detail		= td.eq(24).text().trim();
		
		console.log('체크리스트ID:' + checklist_id);
		console.log('체크리스트 수정이력:' + checklist_rev_no);
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>체크리스트 ID</th>
		     <th style='width:0px; display:none;'>체크리스트 수정이력</th>
		     <th>점검일자</th>
			 <th>한계기준 이탈내용</th>
			 <th>개선조치 및 결과</th>
			 <th>조치</th>
			 <th>확인</th>
		     <th>작성자</th>
		     <th>승인자</th>
		     <th style='width:0px; display:none;'>체크문항1</th>
		     <th style='width:0px; display:none;'>체크문항1상세</th>
		   	 <th style='width:0px; display:none;'>체크문항2</th>
		     <th style='width:0px; display:none;'>체크문항2상세</th>
		     <th style='width:0px; display:none;'>체크문항3</th>
		     <th style='width:0px; display:none;'>체크문항3상세</th>
		     <th style='width:0px; display:none;'>체크문항4</th>
		     <th style='width:0px; display:none;'>체크문항4상세</th>
		     <th style='width:0px; display:none;'>체크문항5</th>
		     <th style='width:0px; display:none;'>체크문항5상세</th>
		     <th style='width:0px; display:none;'>체크문항6</th>
		     <th style='width:0px; display:none;'>체크문항6상세</th>
		     <th style='width:0px; display:none;'>체크문항7</th>
		     <th style='width:0px; display:none;'>체크문항7상세</th>
		     <th style='width:0px; display:none;'>체크문항8</th>
		     <th style='width:0px; display:none;'>체크문항8상세</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>