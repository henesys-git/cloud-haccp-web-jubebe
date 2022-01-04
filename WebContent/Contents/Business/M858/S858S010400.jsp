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
	String toDate = "", location_type = "";

	if(request.getParameter("toDate") != null)
		toDate = request.getParameter("toDate");
	
	if(request.getParameter("location_type") != null)
		location_type = request.getParameter("location_type");
	
	JSONObject jArray = new JSONObject();
	jArray.put("toDate", toDate);
	jArray.put("location_type", location_type);

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M858S010400E104", jArray);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS858S010400";
%>

<script type="text/javascript">

	$(document).ready(function () {
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [1,4,7,8,9,10,11,12,13,14,15],
					'createdCell': function (td) {
						$(td).attr('style', 'display:none;');
					}
				}],
				order : [[ 0, "desc" ]]
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
	 	vCompanyTypeNm 		= td.eq(15).text().trim();
	 	
		fn_DetailInfo_List();
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
		    <th style="display:none; width:0px">배송지역구분명</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>