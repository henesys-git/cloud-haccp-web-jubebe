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

	String div = "", regist_seq_no = "";

	if(request.getParameter("div") != null)
		div = request.getParameter("div");	
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");	

	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);
	jArray.put("div", div);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070650E114", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S070660";
%>
<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = '<%=tData.htmlTable_ID%>';
    	
    	var detailDiv = '<%=div%>';
    	
    	let columnDef = [{
							'targets': [0],
							'createdCell': function (td) {
					  			$(td).attr('style', 'display: none;'); 
							}
						}];
    	
    	if(detailDiv == "2"){
			 columnDef.push({
								'targets': [5],
								'render': function(data) {
									if(data == "Y") {
								  		return "적합";
									} else {
										return "부적합";
									}
								}
							});
		}
    	
    	var customOpts = {
				data : <%=tData.getDataArray()%>,
				columnDefs : columnDef
		}
		
    	$('#<%=tData.htmlTable_ID%>').DataTable(
   			mergeOptions(heneSubTableOpts, customOpts)
   		);
    });
    
    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		var div = '<%=div%>';
		
		if(div == "1"){
			regist_seq_no = td.eq(0).text().trim();
			inferior_reason = td.eq(1).text().trim();
			inferior_solution = td.eq(2).text().trim();
		} else if(div == "2"){
			regist_seq_no = td.eq(0).text().trim();
			action_gubun = td.eq(1).text().trim();
			action_date = td.eq(2).text().trim();
			action_quantity = td.eq(3).text().trim();
			action_detail = td.eq(4).text().trim();
			result_check_yn = td.eq(5).text().trim();
		}
    }
</script>

<% if(div.equals("1")) { %>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		    <th style='width:0px; display:none;'>작성 일련번호</th>
		    <th>원인</th>
		    <th>대책</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>

<% } else if(div.equals("2")) { %>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>작성 일련번호</th>
		     <th>조치내역</th>
		     <th>처리일자</th>
		     <th>처리량</th>
		     <th>식별 및 처리내용</th><!-- 두개 나눠야하나?  -->
		     <th>결과확인</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>

<% } %>

<div id="UserList_pager" class="text-center">
</div>
