<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
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
%>

<script>
	$(document).ready(function () {
		
		setTimeout(function(){
		
		let partGubunBig = "<%=GV_PARTGUBUN_BIG%>";
		let partGubunMid = "<%=GV_PARTGUBUN_MID%>";
		let partGubun = "<%=GV_PART_GUBUN%>";
		let custCode = "<%=GV_CUST_CODE%>";
		let caller = "<%=GV_CALLER%>";
		
		var customOpts = {
				retrieve: true,
				scrollX: true,
	    	    scrollCollapse: true,
	    	    ordering: true,
	    	    order: [[ 0, "asc" ]],
	    	    lengthMenu: [[10], [10]], // 페이지당 줄수 10개 고정
			    keys: true,
	    	    info: true,
	    	    paging: true,
	    	    searching: true,
	   		    processing: true,
				serverSide: true,
				lengthChange: false,
				ajax: {
					type: "POST",
					url: '<%=Config.this_SERVER_path%>/Contents/JSON/CommonView/JPartCodeView.jsp' ,
					data: { 
						partgubun_big: partGubunBig,
						partgubun_mid: partGubunMid,
						partgubun: partGubun,
						cust_code: custCode
					}
				},
				columns: [
	                { "data": "원부자재 대분류" },
	                { "data": "원부자재 중분류" },
	                { "data": "원부자재코드" },
	                { "data": "원부자재명" },
	                { "data": "규격" },
	                { "data": "원부자재Level" },
	                { "data": "개정번호" },
	                { "data": "단가" },
	                { "data": "안전재고" },
	                { "data": "바코드" },
	                { "data": "대체품코드" },
	                { "data": "대체품명" },
	                { "data": "대체개정번호" },
	                { "data": "적용일자" },
	                { "data": "적용만료일" },
	                { "data": "part_gubun_b" },
	                { "data": "part_gubun_m" },
	                { "data": "total" },
	                { "data": "원산지" },
	                { "data": "재고" },
	                { "data": "g단위규격" }
	            ],
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
		  		}]
		}
		
		var table = $('#tablePartView_pop').DataTable(
			mergeOptions(henePopup2TableOpts, customOpts)
		);
		
		$('#tablePartView_pop tbody').on( 'click', 'tr', function () {
			var td = $(this).children();
			
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
				
				if(parent.checkValue(checkval) == true){ 
					parent.$('#modalReport2').modal('hide');	
				}
				else if(parent.checkValue(checkval) == false) {
					parent.checkValue(true);
				}
				else{
					parent.$('#modalReport2').modal('hide');
				}
			
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
		});
		
		}, 300);
		
	});
		
	
	
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="tablePartView_pop" style="width: 100%">
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
	<tbody id="tablePartView_pop_body">		
	</tbody>
</table>