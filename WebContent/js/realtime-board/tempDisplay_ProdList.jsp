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
	String date = "";

	if(request.getParameter("date") != null) {
		date = request.getParameter("date");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("date", date);

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S020200E104", jArray);

    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS303S020200";
%>

<!-- <style>

  .table{
    max-width: 100%;
    margin-left : 0 auto;
    margin-right : 0 auto;
    position : relative;
    horizontal-align : middle;
    
  }

</style> -->

<script type="text/javascript">

    $(document).ready(function () {
    	
    	setTimeout(function(){
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs : [{
				'targets': [5,6,7,8,9,10,11,12],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display:none');
	   			}
			},
   			{
	  			'targets': [2,3],
	  			'render': function(data){
	  				return addComma(data);
	  			}
	  		}],
	  		paging : false,
	  		ordering : false,
	  		"scrollX": false
		}
		
    	$('#<%=makeGridData.htmlTable_ID%>').removeAttr('width').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)		
    	);
		
    	}, 1000);
		
		fn_Clear_varv();
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		vProdName = td.eq(0).text().trim();
		vManufacturingDate = td.eq(1).text().trim();
		vPlanAmount = td.eq(2).text().trim();
		vRealAmount = td.eq(3).text().trim();
		vWorkStatus = td.eq(4).text().trim();
		vRequestRevNo = td.eq(5).text().trim();
		vProdPlanDate = td.eq(6).text().trim();
		vPlanRevNo = td.eq(7).text().trim();
		vProdCd = td.eq(8).text().trim();
		vProdRevNo = td.eq(9).text().trim();
		vWorkTime = td.eq(10).text().trim();
		vWorkStartTime = td.eq(11).text().trim();
		vWorkEndTime = td.eq(12).text().trim();
		
		console.log(vWorkStartTime);
		
		parent.DetailInfo_List.click();
    }

	function fn_Clear_varv() {
		vRequestRevNo = "";
		vProdPlanDate = "";
		vPlanRevNo = "";
		vProdCd = "";
		vProdRevNo = "";
	}

</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style=" width: 100%">
<%-- <table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%"> --%>
	<thead>
		<tr>
			 <th>제품명</th>
		     <th>제조일자</th>
		     <th>계획 생산량(EA)</th>
		     <th>실제 생산량(EA)</th>
		     <th>상태</th>
		     <th style='width:0px; display:none'>생산작업요정서 수정이력번호</th>
		     <th style='width:0px; display:none'>생산계획일자</th>
		     <th style='width:0px; display:none'>생산계획 수정이력번호</th>
		     <th style='width:0px; display:none'>완제품코드</th>
		     <th style='width:0px; display:none'>완제품 수정이력번호</th>
		     <th style='width:0px; display:none'>작업소요시간</th>
		     <th style='width:0px; display:none'>작업시작시간</th>
		     <th style='width:0px; display:none'>작업종료시간</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>