<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
S838S020610 공정관리 점검표 - 상세(작업점검 기록)
2021-03-31 서승헌
 -->

<%

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklist_id = "", checklist_rev_no = "", regist_date = "";
			
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");

	JSONObject jArray = new JSONObject();
	jArray.put("regist_date", regist_date);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020600E114", jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS838S020610";
%>
<script>

    $(document).ready(function () {
    	
    	setTimeout(function(){
    	
    	var htmlTable_ID = '<%=makeGridData.htmlTable_ID%>';
    	
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,2],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    	}, 100);
    	
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		seq_no 				= td.eq(0).text().trim();
		regist_date		 	= td.eq(1).text().trim();
		ampm_gubun			= td.eq(2).text().trim();
		check_time 			= td.eq(3).text().trim();
		temp_processing1 	= td.eq(4).text().trim();
		temp_processing2 	= td.eq(5).text().trim();
		temp_packing		= td.eq(6).text().trim();
		temp_prod			= td.eq(7).text().trim();
		temp_defrosting		= td.eq(8).text().trim();
		temp_frosting		= td.eq(9).text().trim();
		
    }
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead >
		<tr>
		 <!--     <th style='width:0px; display:none;'>체크리스트 ID</th>
		     <th style='width:0px; display:none;'>체크리스트 수정이력</th> -->
		     <th style='width:0px; display:none;'>일련번호</th>
		     <th style='width:0px; display:none;'>작성일자</th>
			 <th style='width:0px; display:none;'>작업구분</th>
		     <th>작업점검일시</th>
		     <th>가공실 1구역 온도</th><!--  &#8451; -->
		     <th>가공실 2구역 온도</th>
		     <th>포장실 온도</th>
		     <th>제품 심부온도</th>
		     <th>해동실 온도</th>
		     <th>냉동실 온도</th> 
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body" >
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>