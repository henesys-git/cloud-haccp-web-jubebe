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
	String history_yn = session.getAttribute("history_yn").toString();
	
	String GV_PARTGUBUN_BIG = "",
		   GV_PARTGUBUN_MID = "";
	
	if(request.getParameter("partgubun_big") == null)
		GV_PARTGUBUN_BIG = "";
	else
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") == null)
		GV_PARTGUBUN_MID = "";
	else
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");
	
	JSONObject jArray = new JSONObject();
	jArray.put("partgubun_big", GV_PARTGUBUN_BIG);
	jArray.put("partgubun_mid", GV_PARTGUBUN_MID);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M202S120100E104", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID = "tableS909S120100";
%>

<script type="text/javascript">
    var part_selected_row;
    var selectTable;

    $(document).ready(function () {
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArray()%>,
    			order :[["4", "desc"]], 
    			columnDefs : [{
    	       		'targets': [8,9],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	},
	   			{
		  			'targets': [6],
		  			'render': function(data){
		  				return addComma(data);
		  			},
		  			'className' : "dt-body-right"
		  		}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    });
    
    function clickMainMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		vPartgubun_big	= td.eq(0).text().trim();
		vPartgubun_mid	= td.eq(1).text().trim();
		vPartCd = td.eq(2).text().trim();
		vPartNm = td.eq(3).text().trim();
		vPartCurStock = td.eq(6).text().trim();
		vPartRevNo = td.eq(9).text().trim();
		vTraceKey = td.eq(8).text().trim();
		
		DetailInfo_List.click();
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="tableS909S120100" style="width: 100%">
	<thead>
		<tr>
			<th>대분류</th>
			<th>중분류</th>
			<th>코드</th>
			<th>품목명</th>
			<th>입고날짜</th>
			<th>유통기한</th>
			<th>현재 재고</th>
			<th>비고</th>
			<th style="display:none; width:0">이력 추적 키</th>
			<th style="display:none; width:0">수정이력번호</th>
		</tr>
	</thead>
	<tbody id="tablePartView_body">		
	</tbody>
</table>