<%@ page import="java.net.URLDecoder"%>
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

	String GV_STANDARD_DATE = "";
	
	if(request.getParameter("standard_date") != null) {
		GV_STANDARD_DATE = request.getParameter("standard_date");
	}
	
	
	
	JSONObject jArray = new JSONObject();
	jArray.put("standard_date", GV_STANDARD_DATE);

	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S190100E114", jArray);	
 	
 	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S190110";
%>

<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	       		'targets': [],
   	       		
   	       		'createdCell':  function (td) {
   	          			$(td).attr('style', 'display: none;');
   	       		}
   	    	}],
   	    	createdRow : ""
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
    });
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			
			<th>완제품명</th>
			<th>완제품 코드</th>
			<th>규격</th>
			<th>판매가</th>
			<th>별도가</th>
			<th>출고가</th>
			<th>출고량</th>
			<th>생산량</th>
			<th>포장비</th>
			<th>포장금액</th>
			<th>총판매가</th>
			<th>월 총출고가</th>
			<th>월 총생산가</th>
			<th>재료비(포장비 포함)</th>
			<th>총출고량 원재료비</th>
			<th>총생산 원재료비</th>
			<th>제조원가(재료비+인건비+제조경비)</th>
			<th>소요시간대비 1개당 노무비</th>
			<th>소요시간</th>
			<th>소요시간 소계(노무)</th>
			<th>출고가대비 노무비율</th>
			<th>품목당 소요 노무비율(월간)</th>
			<th>실제 투입 1개당 노무비</th>
			<th>실제 투입 노무비</th>
			<th>소요시간당 경비비율(%)</th>
			<th>1개당 제조경비</th>
			<th>제조경비</th>
			<th>생산량기준 이윤</th>
			<th>생산량기준 이윤율</th>
			<th>출고량기준 이윤</th>
			<th>출고량기준 이윤율</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>
