<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String memberKey = session.getAttribute("member_key").toString();	
	String startDate = "", endDate = "";

	if(request.getParameter("startDate") != null)
		startDate = request.getParameter("startDate");
	
	if(request.getParameter("endDate") != null)
		endDate = request.getParameter("endDate");
	
	JSONObject jArray = new JSONObject();
	jArray.put("startDate", startDate);
	jArray.put("endDate", endDate);

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M858S010100E104", jArray);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS858S010100";
%>

<script type="text/javascript">

	$(document).ready(function () {
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [1,4,7,8,9,10,11,12,13,14,16,17,18,19,20],
					'createdCell': function (td) {
						$(td).attr('style', 'display:none;');
					}
				}],
				order : [[ 2, "desc" ]]
		}
				
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
	});
	    
   	function clickMainMenu(obj) {
   		console.log('clicked main manu');
   		
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		vChulhaNo 			= td.eq(0).text().trim();;
	 	vChulhaRevNo 		= td.eq(1).text().trim();;
	 	vChulhaDate 		= td.eq(2).text().trim();;
	 	vOrderNo 			= td.eq(3).text().trim();;
	 	vOrderRevNo 		= td.eq(4).text().trim();;
	 	vCustNm				= td.eq(5).text().trim();
	 	vChulhaNote			= td.eq(6).text().trim();
	 	vOrderDate			= td.eq(7).text().trim();
	 	vDeliveryDate		= td.eq(8).text().trim();
	 	vOrderNote			= td.eq(9).text().trim();
	 	vProdNm				= td.eq(10).text().trim();
	 	vChulhaCount		= td.eq(11).text().trim();
	 	vChulhaDetailNote	= td.eq(12).text().trim();
	 	vCustCd				= td.eq(13).text().trim();
	 	vCustRevNo 			= td.eq(14).text().trim();
	 	vDriver 			= td.eq(15).text().trim();
	 	vVehicleCd 			= td.eq(16).text().trim();
	 	vVehicleRevNo 		= td.eq(17).text().trim();
	 	vCompanyType 		= td.eq(18).text().trim();
	 	vDriverId 			= td.eq(19).text().trim();
	 	vCompanyTypeNm 		= td.eq(20).text().trim();
	 	
	 	
		parent.DetailInfo_List.click();
    }
    
	function fn_Clear_varv() {
		chulhaNo = "";
		orderRevNo = "";
		chulhaRevNo = "";
		chulhaeDate = "";
		orderNo = "";
	}
	
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>출하번호</th>
		    <th style="display:none; width:0px">출하 수정이력번호</th>
		    <th>출하일자</th>
		    <th>주문번호</th>
		    <th style="display:none; width:0px">주문 수정이력번호</th>
		    <th>고객사</th>
		    <th>비고</th>
		    <th style="display:none; width:0px">주문일자</th>
		    <th style="display:none; width:0px">납기일자</th>
		    <th style="display:none; width:0px">주문비고</th>
		    <th style="display:none; width:0px">제품명</th>
		    <th style="display:none; width:0px">출하수량</th>
		    <th style="display:none; width:0px">출하상세비고</th>
		    <th style="display:none; width:0px">고객사코드</th>
		    <th style="display:none; width:0px">고객사 수정이력번호</th>
		    <th>배송기사</th>
		    <th style="display:none; width:0px">배송차량코드</th>
		    <th style="display:none; width:0px">배송차량수정이력</th>
		    <th style="display:none; width:0px">배송지역구분</th>
		    <th style="display:none; width:0px">배송기사ID</th>
		    <th style="display:none; width:0px">배송지역구분명</th>
		    
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>