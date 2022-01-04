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
	String startDate = "", endDate = "";

	if(request.getParameter("startDate") != null) {
		startDate = request.getParameter("startDate");
	}
	
	if(request.getParameter("endDate") != null) {
		endDate = request.getParameter("endDate");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("startDate", startDate);
	jArray.put("endDate", endDate);

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S050100E104", jArray);

    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS303S050100";
%>

<script type="text/javascript">

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs : [
				{
					'targets': [9,10,11,12,13,14],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display:none');
		   			}
				},
	   			{
		  			'targets': [3,4],
		  			'render': function(data){
		  				return addComma(data);
		  			}
		  		},
		  		{
		  			'targets': [3,4,6],
		  			'className' : "dt-body-right"
		  		}
	  		],
	  		rowCallback : function( row, data, index ) {
	  		   	if ( data[7] == "확인" ) {
	  		        $('td', row).css({'background-color':'lightgray'});
	  		    }
	  		},
			order: [ 0, 'desc' ]
		}
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
		
		fn_Clear_varv();
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();

		vManufacturingDate = td.eq(0).text().trim();
		vProdName = td.eq(2).text().trim();
		vGugyuk = td.eq(1).text().trim();
		vPlanAmount = td.eq(3).text().trim();
		vRealAmount = td.eq(4).text().trim();
		vExpirationDate = td.eq(5).text().trim();
		vLossRate = td.eq(6).text().trim();
		vWorkStatus = td.eq(7).text().trim();
		vProdJournalNote = td.eq(8).text().trim();	// 생산일지에 보여줄 비고란
		vPlanStorageMapper = td.eq(9).text().trim();
		vRequestRevNo = td.eq(10).text().trim();
		vProdPlanDate = td.eq(11).text().trim();
		vPlanRevNo = td.eq(12).text().trim();
		vProdCd = td.eq(13).text().trim();
		vProdRevNo = td.eq(14).text().trim();
		
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
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		     <th>제조년월일</th>
			 <th>규격</th>
			 <th>제품명</th>
		     <th>계획 생산량</th>
		     <th>실제 생산량</th>
		     <th>유통기한</th>
		     <th>수율(%)</th>
		     <th>상태</th>
		     <th>비고</th>
		     <th style='width:0px; display:none'>생산계획-완제품재고 연결 값</th>
		     <th style='width:0px; display:none'>생산작업요정서 수정이력번호</th>
		     <th style='width:0px; display:none'>생산계획일자</th>
		     <th style='width:0px; display:none'>생산계획 수정이력번호</th>
		     <th style='width:0px; display:none'>완제품코드</th>
		     <th style='width:0px; display:none'>완제품 수정이력번호</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>