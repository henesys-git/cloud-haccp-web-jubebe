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
		   GV_PARTGUBUN_MID = "",
		   ipgo_date = "",
		   caller = "";
	
	 if(request.getParameter("partgubun_big") == null)
		GV_PARTGUBUN_BIG = "";
	else
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") == null)
		GV_PARTGUBUN_MID = "";
	else
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid"); 
	
	if(request.getParameter("ipgo_date") == null)
		ipgo_date = "";
	else
		ipgo_date = request.getParameter("ipgo_date");
	
	if(request.getParameter("caller") == null)
		caller = "";
	else
		caller = request.getParameter("caller");
	
	
	
	JSONObject jArray = new JSONObject();
	jArray.put("partgubun_big", GV_PARTGUBUN_BIG);
	jArray.put("partgubun_mid", GV_PARTGUBUN_MID);
	jArray.put("ipgo_date", ipgo_date);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M202S120100E106", jArray);
	DoyosaeTableModel TableModel2 = new DoyosaeTableModel("M202S120100E107", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	MakeGridData makeGridData2 = new MakeGridData(TableModel2);
	makeGridData.htmlTable_ID = "tableS909S120100";
	makeGridData2.htmlTable_ID = "tableS909S120100";
	
%>

<script type="text/javascript">
    var part_selected_row;
    var selectTable;
	
    var caller = '<%=caller%>';
    console.log(caller);
    
    $(document).ready(function () {
    	
    	
    	setTimeout(function(){
    	
    	
    	if(caller == 1){
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArray()%>,
    			columnDefs : [{
    	       		'targets': [8,9,10,11],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(henePopup2TableOpts, customOpts)
    	);
    	}
    	else{
    		var htmlTable_ID = <%=makeGridData2.htmlTable_ID%>;
        	
        	var customOpts = {
        			data : <%=makeGridData2.getDataArray()%>,
        			columnDefs : [{
        	       		'targets': [8,9,10,11],
        	       		'createdCell':  function (td) {
        	          			$(td).attr('style', 'display: none;'); 
        	       		}
        	    	}]
        	}
        	
        	$('#<%=makeGridData2.htmlTable_ID%>').DataTable(mergeOptions(henePopup2TableOpts, customOpts));	
    		
    	}
    	
    	},200);
    });
    
    function clickPopup2Menu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		vPartgubun_big		= td.eq(0).text().trim();
		vPartgubun_mid		= td.eq(1).text().trim();
		part_cd 			= td.eq(2).text().trim();
		part_nm 			= td.eq(3).text().trim();
		warehousing_date 	= td.eq(4).text().trim();
		expiration_date 	= td.eq(5).text().trim();
		post_amt 			= td.eq(6).text().trim();
		note 				= td.eq(7).text().trim();
		trace_key 			= td.eq(8).text().trim();
		part_rev_no 		= td.eq(9).text().trim();
		balju_no 			= td.eq(10).text().trim();
		balju_rev_no 		= td.eq(11).text().trim();
		
		
		parent.SetpartName_code(part_cd, part_nm, part_rev_no, trace_key, balju_no, balju_rev_no);
		
		parent.$('#modalReport2').modal('hide');
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
			<th style="display:none; width:0">발주번호</th>
			<th style="display:none; width:0">발주수정이력</th>
		</tr>
	</thead>
	<tbody id="tablePartView_body">		
	</tbody>
</table>