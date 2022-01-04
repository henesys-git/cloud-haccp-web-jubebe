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

	JSONObject jArray = new JSONObject();
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S115100E104", jArray);	
 	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS909S115100";
%>
<script type="text/javascript">

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [
					{
						'targets': [0,1,4,6,7,9,10,11,12,13,14],
						'createdCell': function (td) {
				  			$(td).attr('style', 'display: none;'); 
						}
					}
				]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
		  mergeOptions(heneMainTableOpts, customOpts)
		);
		
    });

    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		driver_id 		= td.eq(0).text().trim(); 
		driver_rev_no 	= td.eq(1).text().trim();
		driver_nm 		= td.eq(2).text().trim();
		drive_location 	= td.eq(3).text().trim();
		location_gubun2 = td.eq(4).text().trim();
		vehicle_nm 		= td.eq(5).text().trim();
		vehicle_cd 		= td.eq(6).text().trim(); 
		vehicle_rev_no  = td.eq(7).text().trim(); 
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th style='width:0px; display: none;'>아이디</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     <th>배송기사명</th>
		     <th>담당 지역명</th>
		     <th style='width:0px; display: none;'>체인점지역구분</th>
		     <th>차량명</th>
		     <th style='width:0px; display: none;'>차량코드</th>
		     <th style='width:0px; display: none;'>차량수정이력</th>
		     <th>적용시작일자</th>
		     <th style='width:0px; display: none;'>적용종료일자</th>
		     <th style='width:0px; display: none;'>create_user_id</th>
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>modify_date</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>