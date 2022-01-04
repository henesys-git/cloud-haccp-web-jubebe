<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<!-- yumsam -->
<%
	/* String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString(); */

	String SEARCH_GIJONG_CODE = "", GV_CALLER = "",
		   SEARCH_SIZE_CODE = "", SEARCH_MYUNSU_CODE = "",
		   SEARCH_FOLDING_CODE = "", SEARCH_OPTION_CODE = "",
		   GV_PRODGUBUN_BIG = "", GV_PRODGUBUN_MID = "";

	if(request.getParameter("caller") != null)
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("prodgubun_big") != null)
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");

	if(request.getParameter("prodgubun_mid") != null)
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");
	
	JSONObject jArray = new JSONObject();
	jArray.put("prodgubun_big", GV_PRODGUBUN_BIG);
	jArray.put("prodgubun_mid", GV_PRODGUBUN_MID);
		
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S060100E174", jArray);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableChulgoProductView";
%>

<script>
	var caller = "";

	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	   			'targets': [6,7,8,9],
   	   			'createdCell':  function (td) {
   	   				$(td).attr('style', 'display: none;');
   				}
   		   	}],
   		   	scrollX : true,
   		   	scrollCollapse : true,
   		   	autoWidth : true,
   		   	processing : true,
   		   	order : [[0, "desc"]],
   		   	info : true
    	}
    	
    	if(caller == 1) {	// 1차 모달창
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
   	    		mergeOptions(henePopupTableOpts, customOpts)
   	    	);
    	} else if(caller == 2) {	// 2차 모달창
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
   	    		mergeOptions(henePopup2TableOpts, customOpts)
   	    	);	
    	}
	});
	
	// 클릭 시 해당 제품의 정보를 부모창으로 보낸다
	function clickPopup2Menu(obj) {
		var tr = $(obj);
		var td = tr.children();
		
		
		
		var prodName 		= td.eq(2).text().trim();
		var prodDate 		= td.eq(3).text().trim();
		var expirationDate 	= td.eq(5).text().trim();
	 	var prodCode 		= td.eq(6).text().trim();
		var prodRevNo 		= td.eq(7).text().trim();
		var chulgoSeqNo 	= td.eq(8).text().trim();
		var seqNo 			= td.eq(9).text().trim(); 
		
		if(caller == "0") { // 일반 화면에서 부를 때
	 		$("#txt_ProductName", parent.document).val(txt_ProductName);
	 		$("#txt_Productcode", parent.document).val(txt_Productcode);
	 		$("#txt_prod_rev", parent.document).val(txt_prod_rev);
	 		$("#txt_safe_stock", parent.document).val(txt_safe_stock);
	 		$("#txt_cur_stock", parent
	 				.document).val(txt_cur_stock);
		} else if(caller == 1 || caller == 2) { // 팝업 화면에서 부를 때
			parent.SetChulgoProductName_code(prodName, prodCode, prodRevNo, 
									   prodDate, expirationDate, chulgoSeqNo, seqNo);
		}
		
		parent.$('#modalReport2').modal('hide');
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>대분류</th>
		    <th>중분류</th>
		    <th>제품명</th>
		    <th>생산일자</th>
		    <th>출고일자</th>
		    <th>유통기한</th>
		    <th style='width:0px; display: none'>제품코드</th> 
		    <th style='width:0px; display: none'>제품 수정이력번호</th>  
		    <th style='width:0px; display: none'>출고일련번호</th>
		    <th style='width:0px; display: none'>일련번호</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>