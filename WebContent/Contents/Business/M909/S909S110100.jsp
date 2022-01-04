<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_PARTGUBUN_BIG = "", GV_PARTGUBUN_MID = "", 
		   GV_PARTGUBUN_SM = "", GV_REV_CHECK = "", 
		   GV_PID = "";
	
	if(request.getParameter("partgubun_big") != null)
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");

	if(request.getParameter("partgubun_mid") != null)
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");
		
	if (request.getParameter("total_rev_check") != null)
		GV_REV_CHECK = request.getParameter("total_rev_check");
%>

<script type="text/javascript">

	var part_selected_row;
	var selectTable;

	$(document).ready(function () {
		selectTable = $('#tableS909S110100').DataTable({
			scrollX: true,
			scrollY: "570px",
			scrollCollapse: true,
		    ordering: true,
		    order: [[ 0, "asc" ],[ 1, "asc" ]],
		    keys: true,
		    info: false,
		    paging: true,
		    pagingType: "full_numbers",
		    pageLength: 10,
		    searching: true,
			processing: true,
			serverSide: true,
			select : true,
			"sDom": '<"top"if>rt<"bottom"pl><"clear">',
			ajax: {
				 type: "POST",
				 url: '<%=Config.this_SERVER_path%>/Contents/JSON/M909/J909S110100.jsp',
				 data:{ 
					 partgubun_big:"<%=GV_PARTGUBUN_BIG%>", 
					 partgubun_mid:"<%=GV_PARTGUBUN_MID%>",
					 total_rev_check:"<%=GV_REV_CHECK%>"
				 }
			},
			columns: [
	            { "data": "대분류" },
	            { "data": "중분류" },
	            { "data": "일련번호" },
	            { "data": "단위규격" },
	            { "data": "Level" },
	            { "data": "코드" },
	            { "data": "개정번호" },
	            { "data": "원자재명" },
	            { "data": "단가" },
	            { "data": "안전재고" },
	            { "data": "적용만료일" },
	            { "data": "part_gubun" },
	            { "data": "원부자재 구분" },
	            { "data": "토탈" }
	        ],
		    'createdRow': function(row) {
	      		$(row).attr('id',"tableS909S110100_rowID");
	      		$(row).attr('onclick',"S909S110100Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [2,4,6,11,13],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;');
	       		}
			},
   			{
	  			'targets': [8,9],
	  			'render': function(data){
	  				return addComma(data);
	  			},
	  			'className' : "dt-body-right"
	  		}],          
	        language: {
	            url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	        }
		});
	});

	function S909S110100Event(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
	
		$(tableS909S110100_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
	
		vPartCode = td.eq(5).text().trim();
	 	vRevisionNo = td.eq(6).text().trim();
	 	vPart_Gubun = td.eq(11).text().trim();
	}
</script>


<table class='table table-bordered' id="tableS909S110100" style="width:100%">
	<thead>
		<tr>
		     <th>대분류</th>
		     <th>중분류</th>
		     <th style="display:none">일련번호</th>
		     <th>개별규격</th>
		     <th style="display:none">Level</th>
		     <th>원자재코드</th>
		     <th style="display:none">개정번호</th>
		     <th>원자재명</th>
		     <th>단가</th>
		     <th>안전재고</th>
		     <th>적용만료일</th>
		     <th style="display:none">part_gubun</th>
		     <th>원부자재 구분</th>
		     <th style="display:none">토탈</th>
		</tr>
	</thead>
	<tbody id="tablePartView_body">
	</tbody>
</table>