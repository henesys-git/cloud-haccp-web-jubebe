<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!-- yumsam -->
<%
	String member_key = session.getAttribute("member_key").toString();

	String GV_CALLER = "", GV_PARTGUBUN_BIG = "", 
	   GV_PARTGUBUN_MID = "", GV_PART_GUBUN = "",
	   GV_CUST_CODE = "";

	if(request.getParameter("caller") != null)
		GV_CALLER = request.getParameter("caller");	

	if(request.getParameter("partgubun_big") != null)
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") != null)
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");

	if(request.getParameter("part_gubun") != null)
		GV_PART_GUBUN = request.getParameter("part_gubun");

	if(request.getParameter("cust_code") != null)
		GV_CUST_CODE = request.getParameter("cust_code");
	
	JSONObject jObj = new JSONObject();
	jObj.put("partgubun_big", GV_PARTGUBUN_BIG);
	jObj.put("partgubun_mid", GV_PARTGUBUN_MID);
	jObj.put("partgubun", GV_PART_GUBUN);
	jObj.put("cust_code", GV_CUST_CODE);
		
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S110100E214", jObj);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tablePartView_pop";
%>

<script>
	var caller = "";
	var sub_caller = "";
	
	$(document).ready(function () {
		
		setTimeout(function(){
		
			caller = "<%=GV_CALLER%>";
	    	
	    	var customOpts = {
	   			data : <%=makeGridData.getDataArray()%>,
	   			columnDefs : [{
					'targets': [5,6,9,10,11,12,13,14,15,16,17,18,19,20],
		       		'createdCell': function (td) {
		          			$(td).attr('style', 'width:0px; display: none;'); 
		       		}
		    	},
	   			{
		  			'targets': [7, 8],
		  			'render': function(data){
		  				return addComma(data);
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
	    	
	    	if(caller == 1 || caller == 0) {	// 1차 모달창
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
	
	function clickPopupMenu(obj) {
		if(caller == 0) {
			var tr = $(obj);
			var td = tr.children();
			
			var partCd = td.eq(2).text().trim(); 
			var partRevNo = td.eq(6).text().trim();
			var partName = td.eq(3).text().trim();
			
			parent.SetpartName_code(partCd, partRevNo, partName);
			parent.$('#modalReport2').modal('hide');
		}
	}
	
	// 클릭 시 해당 제품의 정보를 부모창으로 보낸다
	function clickPopup2Menu(obj) {
		var tr = $(obj);
		var td = tr.children();
		
		var txt_part_cd 			= td.eq(2).text().trim(); 
		var txt_part_revision_no 	= td.eq(6).text().trim();
		var txt_part_name 			= td.eq(3).text().trim();
		var txt_gyugeok 			= td.eq(4).text().trim();
		var txt_part_level 			= td.eq(5).text().trim();
		var txt_unit_price 			= td.eq(7).text().trim();
		var txt_part_gubun_b		= td.eq(15).text().trim();
		var txt_part_gubun_m		= td.eq(16).text().trim();
		var txt_wonsanji			= td.eq(18).text().trim();
		var txt_jaego				= td.eq(19).text().trim();
		var txt_detail_gyugyeok		= td.eq(20).text().trim();
		
		if(caller == "0") { //일반 화면에서 부를 때
	 		$("#txt_part_name", parent.document).val(txt_part_name);
	 		$("#txt_part_revision_no", parent.document).val(txt_part_revision_no);
	 		$("#txt_part_cd", parent.document).val(txt_part_cd);
	 		$("#txt_gyugeok", parent.document).val(txt_gyugeok);
	 		$("#txt_part_level", parent.document).val(txt_part_level);
	 		$("#txt_unit_price", parent.document).val(txt_unit_price);
	 		$("#txt_part_gubun_b", parent.document).val(txt_part_gubun_b);
	 		$("#txt_part_gubun_m", parent.document).val(txt_part_gubun_m);
		}
		else if(caller == 1) { //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
			parent.SetpartName_code(txt_part_name, txt_part_cd,
									txt_part_revision_no, txt_gyugeok, txt_unit_price);
		}
		else if(caller == 2) { //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때 - 원산지까지 물고 감
 			parent.SetpartName_code(txt_part_name, txt_part_cd, txt_part_revision_no, 
 									txt_gyugeok, txt_unit_price, txt_wonsanji);
		}
		else if(caller == 3) { //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
 			parent.SetpartName_code(txt_part_name, txt_part_cd, 
 									txt_part_revision_no, txt_jaego);
		}
		else if(caller == 4) { 
 			parent.SetpartName_code(txt_part_name, txt_part_cd, txt_part_revision_no, 
 									txt_gyugeok, txt_detail_gyugyeok, txt_jaego);
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
			<th>원자재코드</th>
			<th>원부자재명</th>
			<th>규격</th>
			<th style='width:0px; display: none;'>원자재Level</th>
			<th style='width:0px; display: none;'>개정번호</th>
			<th>단가</th>
			<th>안전재고</th>
			<th style='width:0px; display: none;'>바코드</th>
			<th style='width:0px; display: none;'>대체품코드</th>
			<th style='width:0px; display: none;'>대체품명</th>
			<th style='width:0px; display: none;'>대체개정번호</th>
			<th style='width:0px; display: none;'>적용일자</th>
			<th style='width:0px; display: none;'>적용만료일</th>
			<th style='width:0px; display: none;'>대분류</th>
			<th style='width:0px; display: none;'>중분류</th>
			<th style='width:0px; display: none;'>total</th>
			<th style='width:0px; display: none;'>원산지</th>
			<th style='width:0px; display: none;'>현재재고</th>
			<th style='width:0px; display: none;'>상세규격(g단위규격)</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>