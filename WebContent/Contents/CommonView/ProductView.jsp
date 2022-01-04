<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<!-- yumsam -->
<%
	String GV_CALLER = "", GV_SUB_CALLER = "", GV_PRODGUBUN_BIG = "", GV_PRODGUBUN_MID = "";
	
	if(request.getParameter("caller") != null) {
		GV_CALLER = request.getParameter("caller");	
	}
	
	if(request.getParameter("sub_caller") != null) {
		GV_SUB_CALLER = request.getParameter("sub_caller");	
	}
	
	if(request.getParameter("prodgubun_big") != null) {
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");
	}

	if(request.getParameter("prodgubun_mid") != null) {
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");
	}
	
	JSONObject jObj = new JSONObject();
	jObj.put("prodgubun_big", GV_PRODGUBUN_BIG);
	jObj.put("prodgubun_mid", GV_PRODGUBUN_MID);
		
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S060100E194", jObj);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableProductView";
%>

<script>
	var caller = "";
	var sub_caller = "";
	
	$(document).ready(function () {
		
		setTimeout(function(){
		
		caller = "<%=GV_CALLER%>";
		sub_caller = "<%=GV_SUB_CALLER%>";
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	   			'targets': [3,4,6,7],
   	   			'createdCell':  function (td) {
   	   				$(td).attr('style', 'display: none;');
   				}
   		   	}],
   		   	scrollX : true,
   		   	scrollCollapse : true,
   		   	autoWidth : true,
   		   	processing : true,
   		   	order : [[0, "desc"]],
   		   	info : true,
   		   	searching : true
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
    	
		}, 300);
    	
	});
	
	// 클릭 시 해당 제품의 정보를 부모창으로 보낸다
	function clickPopup2Menu(obj) {
		var tr = $(obj);
		var td = tr.children();
		
		console.log("td0(대분류):" + td.eq(0).text().trim());
		console.log("td1(중분류):" + td.eq(1).text().trim());
		console.log("td2(제품명):" + td.eq(2).text().trim());
		console.log("td3(제품코드):" + td.eq(3).text().trim());
		console.log("td4(제품 수정이력번호):" + td.eq(4).text().trim());
		console.log("td5(규격):" + td.eq(5).text().trim());
		console.log("td6(안전재고):" + td.eq(6).text().trim());
		console.log("td7(현재고):" + td.eq(7).text().trim());
		
		var prodName = td.eq(2).text().trim();
		var prodCode = td.eq(3).text().trim();
		var prodRevNo = td.eq(4).text().trim();
		var prodGyugyuk = td.eq(5).text().trim();
		var prodSafeStock = td.eq(6).text().trim();
		var prodCurStock = td.eq(7).text().trim();
		
		if(caller == "0") { // 일반 화면에서 부를 때
	 		$("#txt_ProductName", parent.document).val(txt_ProductName);
	 		$("#txt_Productcode", parent.document).val(txt_Productcode);
	 		$("#txt_prod_rev", parent.document).val(txt_prod_rev);
	 		$("#txt_safe_stock", parent.document).val(txt_safe_stock);
	 		$("#txt_cur_stock", parent.document).val(txt_cur_stock);
		} else if((caller == 1 || caller == 2) && sub_caller == 1) { // 팝업 화면에서 부를 때(오전생산계획)
			parent.SetProductName_code(prodName, prodCode, prodRevNo, 
									   prodGyugyuk, prodSafeStock, 
									   prodCurStock);
			
			if(parent.checkValue(checkval) == true){ 
				parent.$('#modalReport2').modal('hide');	
			}
			else if(parent.checkValue(checkval) == false) {
				parent.checkValue(true);
			}
			else {
				parent.$('#modalReport2').modal('hide');
			}
		}
		 else if((caller == 1 || caller == 2) && sub_caller == 2) { // 팝업 화면에서 부를 때(오후생산계획)
			parent.SetProductName_code2(prodName, prodCode, prodRevNo, 
										prodGyugyuk, prodSafeStock, 
										prodCurStock);
		 
			if(parent.checkValue(checkval) == true){ 
				parent.$('#modalReport2').modal('hide');	
			}
			else if(parent.checkValue(checkval) == false) {
				parent.checkValue(true);
			}
			else {
				parent.$('#modalReport2').modal('hide');
			}
		 
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
		    <th style='width:0px; display: none'>제품코드</th>
		    <th style='width:0px; display: none'>제품 수정이력번호</th>
		    <th>규격</th>
		    <th style='width:0px; display: none'>안전재고</th>
		    <th style='width:0px; display: none'>현재고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>