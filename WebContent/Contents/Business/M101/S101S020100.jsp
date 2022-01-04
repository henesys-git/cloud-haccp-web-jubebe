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
	
	String fromDate = "", 
		   toDate = "",
		   orderType = "",
		   GV_CALLER = "";

	if(request.getParameter("From") != null)
		fromDate = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		toDate = request.getParameter("To");	

	if(request.getParameter("orderType") != null)
		orderType = request.getParameter("orderType");	
	
	if(request.getParameter("Caller") != null)
		GV_CALLER = request.getParameter("Caller");
	
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", fromDate);
	jArray.put("todate", toDate);
	jArray.put("orderType", orderType);

	DoyosaeTableModel TableModel = new DoyosaeTableModel("M101S020100E104", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS101S020100";
%>

<script type="text/javascript">

<%if(GV_CALLER.equals("1")) {%>
	$(document).ready(function () {
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [3],
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
	
<%} else {%>
    $(document).ready(function () {
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [7,8,9,10],
					'createdCell': function (td) {
						$(td).attr('style', 'display:none;');
					}
				}],
				order : [[ 1, "desc" ]]
		}
				
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
   
		fn_Clear_varv();
    });
<%}%>
    
   	function clickMainMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
        vOrderType	= td.eq(0).text().trim();
	 	vOrderDate 	= td.eq(1).text().trim();
        vOrderNo	= td.eq(2).text().trim();
        vOrderRevNo = td.eq(7).text().trim();
	 	
		vCustName   = td.eq(3).text().trim();
		vCustCode 	= td.eq(8).text().trim();
		vCustRevNo 	= td.eq(9).text().trim();
		vLocationType = td.eq(10).text().trim();
		
		vDeliveryDate = td.eq(4).text().trim();
		vDeliveryYN = td.eq(6).text().trim();
		vNote = td.eq(5).text().trim();
		
		parent.DetailInfo_List.click();
    }
    
	function fn_Clear_varv() {
		vOrderNo = "";  
		vOrderDate = "";
		vOrderRevNo = "";
		vOrderType = "";
		vCustCode = "";
		vCustRevNo = "";
		vCustName = "";
		vDeliveryDate = "";
		vNote = "";
	}

</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		    <th>주문구분</th>
			<th>주문날짜</th>
		    <th>주문번호</th>
		    <th>고객사</th>
		    <th>요청 납품일자</th>
		    <th>비고</th>
		    <th>납품여부</th>
		    <th style="display:none; width:0px">주문 수정이력번호</th>
		    <th style="display:none; width:0px">고객사 코드</th>
		    <th style="display:none; width:0px">고객사 수정이력번호</th>
		    <th style="display:none; width:0px">가맹점 지역타입</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>      