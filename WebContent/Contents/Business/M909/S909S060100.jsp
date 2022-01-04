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

	String GV_PRODGUBUN_BIG = "", 
		   GV_PRODGUBUN_MID = "", 
		   REV_CHECK = "", 
		   PID_FOR_REV_CHECK = "", 
		   FLAG_CHECK = "";
	
	if(request.getParameter("prodgubun_big") != null)
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");

	if(request.getParameter("prodgubun_mid") != null)
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");	

	if (request.getParameter("total_rev_check") != null)
		REV_CHECK = request.getParameter("total_rev_check");

	if(REV_CHECK.equals("true")) {
		PID_FOR_REV_CHECK = "M909S060100E104";
	} else if (REV_CHECK.equals("false")) {
		PID_FOR_REV_CHECK = "M909S060100E105";
	}

	JSONObject jArray = new JSONObject();
	jArray.put("prodgubun_big", GV_PRODGUBUN_BIG);
	jArray.put("prodgubun_mid", GV_PRODGUBUN_MID);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel(PID_FOR_REV_CHECK, jArray);	
	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S060100";
%>
<script type="text/javascript">

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [1,3,5,13,14],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
	   			{
		  			'targets': [8],
		  			
		  			'className' : "dt-body-right"
		  		},
	   			{
		  			'targets': [8,9,10,11,12],
		  			'render': function(data){
		  				return addComma(data);
		  			},
		  			'className' : "dt-body-right"
		  		}],
				pageLength : 10
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
    	prod_gubun_b	= "";
    	prod_gubun_m	= "";
    	prod_cd			= "";
	 	revision_no 	= "";
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		prod_gubun_b	= td.eq(1).text().trim();
		prod_gubun_m	= td.eq(3).text().trim();
		prod_cd			= td.eq(4).text().trim();
		revision_no		= td.eq(5).text().trim();
    }

</script>
<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>대분류</th>
			<th style='width:0px; display:none;'>대분류 코드</th>
			<th>중분류</th>
			<th style='width:0px; display:none;'>중분류 코드</th>
			<th>제품코드</th>
			<th style='width:0px; display:none;'>제품 수정이력번호</th>
			<!-- <th>제품코드2</th> -->
			<th>제품명</th>
			<th>낱개 중량</th>
			<th>팩당 낱개 수량</th>
			<th>박스당 팩 수량</th>
			<th>안전재고</th>
			<th>포장비용</th>
			<th>유통기한 기준일</th>
			<th style='width:0px; display:none;'>적용시작일자</th>
			<th style='width:0px; display:none;'>적용종료일자</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>