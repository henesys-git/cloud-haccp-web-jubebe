<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String member_key = session.getAttribute("member_key").toString();
	String GV_CALLER = "", GV_PARTGUBUN_BIG="", 
		   GV_PARTGUBUN_MID = "", GV_CHECK_GUBUN = "";

	if(request.getParameter("caller") == null)
		GV_CALLER = "";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("partgubun_big") == null)
		GV_PARTGUBUN_BIG = "";
	else
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") == null)
		GV_PARTGUBUN_MID = "";
	else
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");
	
	if(request.getParameter("check_gubun") == null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
    Vector optCode = null;
    Vector optName = null;
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("",member_key);
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);	
%>

<script>

	var txt_CustName;
	var caller = "";
	var part_selected_row;
	var selectTable_Part;
	var vPartgubun_big_pop = "";
	var vPartgubun_mid_pop = "";
	
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";

    	vPartgubun_big_pop = $("#partgubun_big_pop").val();
    	vPartgubun_mid_pop = $("#partgubun_mid_pop").val();
    	
		if(vPartgubun_big_pop == "ALL")
			vPartgubun_big_pop = "";
		if(vPartgubun_mid_pop == "ALL")
			vPartgubun_mid_pop = "";
		
		selectTable_Part = $('#tablePartView_pop').DataTable({
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
			lengthChange: false, //페이지당 줄 수 없애기
			ajax: {
				 type: "POST",
				 url: '<%=Config.this_SERVER_path%>/Contents/JSON/CommonView/JPartCodeView_tyens.jsp' ,
				 data:{ 
					 partgubun_big: "<%=GV_PARTGUBUN_BIG%>",
					 partgubun_mid: "<%=GV_PARTGUBUN_MID%>",
					 check_gubun: "<%=GV_CHECK_GUBUN%>"
				 },
			},			
			columns: [
                { "data": "원부자재 대분류" },
                { "data": "원부자재 중분류" },
                { "data": "규격" },
                { "data": "원부자재Level" },
                { "data": "원부자재코드" },
                { "data": "개정번호" },
                { "data": "원부자재명" },
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
                { "data": "재고" }
            ],
		    'createdRow': function(row) {	
	      		$(row).attr('id',"tablePartView_pop_rowID");
	      		$(row).attr('onclick',"PartViewEvent(this)");
	      		$(row).attr('role',"row");
	  		},         
	  		'columnDefs': [{
	       		'targets': [3,5,9,10,11,12,13,14,15,16,17],
	       		'createdCell':  function (td) {
	          		$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],   
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
  		});

		$('#tablePartView_pop tbody').on( 'click', 'tr', function () {
			part_selected_row = selectTable_Part.row( this ).index();

			$($("input[id='checkbox1']")[part_selected_row]).prop("checked", function(){
		        return !$(this).prop('checked');
		    });

			var td = $(this).children();
			
			var txt_part_cd 			= td.eq(4).text().trim(); 
			var txt_part_revision_no 	= td.eq(5).text().trim();
			var txt_part_name 			= td.eq(6).text().trim();
			var txt_gyugeok 			= td.eq(2).text().trim();
			var txt_part_level 			= td.eq(3).text().trim();
			var txt_unit_price 			= td.eq(7).text().trim();
			var txt_part_gubun_b		= td.eq(15).text().trim();
			var txt_part_gubun_m		= td.eq(16).text().trim();
			var txt_wonsanji			= td.eq(18).text().trim();
			var txt_jaego				= td.eq(19).text().trim();
			
			if(caller == "0") { //일반 화면에서 부를 때
		 		$("#txt_part_name", parent.document).val(txt_part_name);
		 		$("#txt_part_revision_no", parent.document).val(txt_part_revision_no);
		 		$("#txt_part_cd", parent.document).val(txt_part_cd);
		 		$("#txt_gyugeok", parent.document).val(txt_gyugeok);
		 		$("#txt_part_level", parent.document).val(txt_part_level);
		 		$("#txt_unit_price", parent.document).val(txt_unit_price);
		 		$("#txt_part_gubun_b", parent.document).val(txt_part_gubun_b);
		 		$("#txt_part_gubun_m", parent.document).val(txt_part_gubun_m);
			} else if(caller == 1) { //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
	 			parent.SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugeok,txt_unit_price);
			} else if(caller == 2) { //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때 - 원산지까지 물고 감
	 			parent.SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugeok,txt_unit_price,txt_wonsanji);
			} else if(caller == 3) { //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
	 			parent.SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_jaego);
			}

			parent.$('#modalReport_nd').hide();	// modalReport2로 완전 교체되면 없앨 예정
		});
        

		$('#tablePartView_pop tbody').on( 'blur', 'tr', function () {
			selectTable_Part.row( this ).attr("class", "hene-bg-color_w");
		});
    	
	});
	
    function fn_clearList() { 
        if ($("#tablePartView_pop").children().length > 0) {
            $("#tablePartView_pop").children().remove();
        }
    }
	
	function PartViewEvent(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return 

		/* $(tablePartView_pop_rowID).attr("class", "");
		$(obj).attr("class", "bg-success"); */

	}

	
</script>

<div id="UserList_pager" class="text-center">
	<table class='table table-bordered nowrap table-hover nowrap' 
			  id="tablePartView_pop" style="width: 100%">
		<thead>
			<tr>
				<th>대분류</th>
				<th>중분류</th>
				<th>규격(Size)</th>
				<th style='width:0px; display: none;'>원자재Level</th>
				<th>원자재코드</th>
				<th style='width:0px; display: none;'>개정번호</th>
				<th>원자재명</th>
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
				<th>원산지</th>
				<th>재고</th>
			</tr>
		</thead>
		<tbody id="tablePartView_pop_body"></tbody>
	</table>
	<button id="btn_Canc" class="btn btn-info" onclick="parent.$('#modalReport_nd').hide();">
		닫기
	</button>
</div> 