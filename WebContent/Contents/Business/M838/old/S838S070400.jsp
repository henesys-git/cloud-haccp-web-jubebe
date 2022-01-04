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
	jArray.put("member_key", member_key);
	jArray.put("fromdate", GV_FROMDATE);
	jArray.put("todate", GV_TODATE);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070400E104", jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS838S070400";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,2,4,5,18,20,22],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
    });

    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		seqNo = td.eq(0).text().trim();
		checklistId = td.eq(1).text().trim();
		checklistRevNo = td.eq(2).text().trim();
		prodCd = td.eq(4).text().trim();
		prodRevNo = td.eq(5).text().trim();
		dateOccur = td.eq(6).text().trim();
		
		console.log('일련번호:' + seqNo);
		console.log('체크리스트ID:' + checklistId);
		console.log('체크리스트 수정이력:' + checklistRevNo);
		console.log('완제품 코드:' + prodCd);
		console.log('완제품 수정이력:' + prodRevNo);
		console.log('발생일자:' + dateOccur);
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>일련번호</th>
		     <th style='width:0px; display:none;'>체크리스트 ID</th>
		     <th style='width:0px; display:none;'>체크리스트 수정이력</th>
		     <th>부적합품(제품)</th>
		     <th style='width:0px; display:none;'>부적합품 코드</th>
		     <th style='width:0px; display:none;'>코드 수정이력번호</th>
			 <th>발생일시</th>
		     <th>작성일시</th>
		     <th>발생장소</th>
		     <th>수량</th>
		     <th>부적합내용</th>
		     <th>원인</th>
		     <th>대책</th>
		     <th>조치 내역</th>
		     <th>처리 일자</th>
		     <th>처리량</th>
		     <th>식별 및 처리 내용</th>
		     <th>결과 확인</th>
		     <th style='width:0px; display:none;'>작성자 ID</th>
		     <th>확인자</th>
		     <th style='width:0px; display:none;'>확인자 ID</th>
		     <th>승인자</th>
		     <th style='width:0px; display:none;'>승인자 ID</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>