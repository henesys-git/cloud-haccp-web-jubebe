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

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M858S040100E104", jArray);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS858S010100";
%>

<script type="text/javascript">

	$(document).ready(function () {
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				pageLength : 10,
				columnDefs : [{
					'targets': [1,8,9,10,11,12,13,14],
					'createdCell': function (td) {
						$(td).attr('style', 'display:none;');
					}
				},
	   			{
		  			'targets': [4],
		  			'render': function(data){
		  				return addComma(data);
		  			}
		  		}],
				order : [[2, "DESC"]]
		}
				
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
	});
	    
   	function clickMainMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		discard_type = td.eq(0).text().trim();
	 	discard_seq_no = td.eq(1).text().trim();
	 	cust_nm = td.eq(2).text().trim();
	 	prod_name = td.eq(4).text().trim();
	 	amount = td.eq(5).text().trim();
	 	discard_date = td.eq(3).text().trim();
	 	note = td.eq(7).text().trim();
	 	chulha_no = td.eq(8).text().trim();
	 	chulha_rev_no = td.eq(9).text().trim();
	 	prod_date = td.eq(6).text().trim();
	 	seq_no = td.eq(10).text().trim();
	 	prod_cd	= td.eq(11).text().trim();
	 	prod_rev_no	= td.eq(12).text().trim();
	 	order_no	= td.eq(13).text().trim();
	 	order_rev_no	= td.eq(14).text().trim();
    }
    
	function fn_Clear_varv() {
		discard_type = "";
	 	discard_seq_no = "";
	 	prod_name = "";
	 	amount = "";
	 	discard_date = "";
	 	note = "";
	 	chulha_no = "";
	 	chulha_rev_no = "";
	 	prod_date = "";
	 	seq_no = "";
	 	prod_cd	= "";
	 	prod_rev_no	= "";
	 	cust_nm = "";
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>분류</th>
		    <th style="display:none; width:0px">일련번호</th>
		    <th>반품일자</th>
		    <th>가맹점명</th>
		    <th>제품명</th>
		    <th>반품/폐기량(EA)</th>
		    <th>생산일자</th>
		    <th>비고</th>
		    <th style="display:none; width:0px">출하번호</th>
		    <th style="display:none; width:0px">출하 수정이력</th>
		    <th style="display:none; width:0px">재고일련번호</th>
		    <th style="display:none; width:0px">완제품 코드</th>
		    <th style="display:none; width:0px">완제품 수정이력번호</th>
		    <th style="display:none; width:0px">주문번호</th>
		    <th style="display:none; width:0px">주문 수정이력번호</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>