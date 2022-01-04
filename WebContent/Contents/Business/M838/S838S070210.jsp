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

	
	String checklist_id = "", checklist_rev_no = "", ipgo_date = "";
			
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ipgo_date") != null)
		ipgo_date = request.getParameter("ipgo_date");

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("ipgo_date", ipgo_date);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070200E114", jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS838S070210";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,2,4,5,10,18,19],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    	
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		s_checklist_id			= td.eq(0).text().trim();
		s_checklist_rev_no 		= td.eq(1).text().trim();
		seq_no 					= td.eq(2).text().trim();
		s_ipgo_date 			= td.eq(3).text().trim();
		part_cd 				= td.eq(4).text().trim();
		part_rev_no 			= td.eq(5).text().trim();
		part_nm 				= td.eq(6).text().trim();
		supplier 				= td.eq(7).text().trim();
		ipgo_amount 			= td.eq(8).text().trim();
		trace_key 				= td.eq(10).text().trim();
		standard_yn  			= td.eq(11).text().trim();
		packing_status 			= td.eq(12).text().trim();
		visual_inspection 		= td.eq(13).text().trim();
		car_clean 				= td.eq(14).text().trim();
		docs_yn 				= td.eq(15).text().trim();
		unsuit_action 			= td.eq(16).text().trim();
		check_yn 				= td.eq(17).text().trim();
		balju_no 				= td.eq(18).text().trim();
		balju_rev_no 			= td.eq(19).text().trim();
		
		
		
		console.log('체크리스트ID:' + s_checklist_id);
		console.log('체크리스트 수정이력:' + s_checklist_rev_no);
		console.log('입고일자:' + ipgo_date);
		
    }
    
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>체크리스트 ID</th>
		     <th style='width:0px; display:none;'>체크리스트 수정이력</th>
		     <th style='width:0px; display:none;'>일련번호</th>
		     <th>입고일자</th>
		     <th style='width:0px; display:none;'>원부재료코드</th>
		     <th style='width:0px; display:none;'>원부재료 수정이력</th>
		     <th>원부재료명</th>
		     <th>공급업체명</th>
		     <th>수량</th>
		     <th>유통기한</th>
		     <th style='width:0px; display:none;'>추적 이력키</th>
		     <th>규격적부</th>
		     <th>포장상태</th>
		     <th>육안검사</th>
		     <th>차량청결상태</th>
		     <th>시험성적서 구비유무</th>
		     <th>부적합품 조치사항</th>
		     <th>확인</th>
		     <th style='width:0px; display:none;'>발주번호</th>
		     <th style='width:0px; display:none;'>발주수정이력</th>
		     
		    
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>