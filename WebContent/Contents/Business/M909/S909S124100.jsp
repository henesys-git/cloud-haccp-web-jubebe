<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;

	int[]   colOff 			= {1, 1, 0, 0, 0, 0, 0, 1,0,0,0,1,1,0,1,1,1,1};
	String[] TR_Style		= {""," onclick='S909S124100Event(this)' "};
	String[] TD_Style		= {""};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
	
	String param =   "|"  ;
	
	String GV_REV_CHECK = "", GV_PID = "" ;
	
	if (request.getParameter("total_rev_check") == null)
		GV_REV_CHECK = "";
	else
		GV_REV_CHECK = request.getParameter("total_rev_check");

	if(GV_REV_CHECK.equals("true")) GV_PID = "M909S124100E104";
	else if(GV_REV_CHECK.equals("false")) GV_PID = "M909S124100E105";
		
%>
<script type="text/javascript">

	var part_selected_row;
	var selectTable;
	
    $(document).ready(function () {
    	$('#tableS909S124100').DataTable({
    		scrollX: true,
    	    scrollCollapse: true,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
		    keys: true,
    	    info: false,
    	    language: {
		           "info": "총 _TOTAL_ 중  _START_ ~  _END_"
			       },   			
    	    paging: true,
		    lengthMenu: [[5,9,-1], [5,9,"All"]],
    	    searching: false,
   		    processing: true,
			serverSide: true,
			select : true,
			"dom": '<"top"i>rt<"bottom"flp><"clear">',
			ajax: {
				 type: "POST",
				 url: '<%=Config.this_SERVER_path%>/Contents/JSON/CommonView/JPartCodeView.jsp'
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
	      		$(row).attr('id',"tableS909S124100_rowID");
	      		$(row).attr('onclick',"S909S124100Event(this)");
	      		$(row).attr('role',"row");
	  		},         
	  		'columnDefs': [{
	       		'targets': [2,3,10,12,13,14,15,16,17,18,19],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display:none;'); 
	       		}
			},
   			{
	  			'targets': [7,8],
	  			'render': function(data){
	  				return addComma(data);
	  			}
	  		}],  
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
  		});
    });
    
    function S909S124100Event(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		$(tableS909S124100_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vPart_cd = td.eq(4).text().trim();
		vPart_cd_rev = td.eq(5).text().trim();
		vPart_name = td.eq(6).text().trim();
		
		DetailInfo_List.click();
		
    }
</script>

<table class='table table-bordered' id="tableS909S124100" style="width:100%">
	<thead>
		<tr>
			<th>원부자재 대분류</th>
			<th>원부자재 중분류</th>
			<th style='width:0px; display: none;'>규격(Size)</th>
			<th style='width:0px; display: none;'>원부자재Level</th>
			<th>원부자재코드</th>
			<th>개정번호</th>
			<th>원부자재명</th>
			<th>단가</th>
			<th>안전재고</th>
			<th>바코드</th>
			<th style='width:0px; display:none;'>대체품코드</th>
			<th>대체품명</th>
			<th style='width:0px; display:none;'>대체개정번호</th>
			<th style='width:0px; display:none;'>적용일자</th>
			<th style="width:0px; display:none;">적용만료일</th>
			<th style='width:0px; display:none;'>part_gubun_b</th>
			<th style='width:0px; display:none;'>part_gubun_m</th>
			<th style='width:0px; display:none;'>total</th>
			<th style='width:0px; display:none;'>원산지</th>
			<th style='width:0px; display:none;'>재고</th>
		</tr>
	</thead>
	<tbody id="tablePartView_body">		
	</tbody>
</table>