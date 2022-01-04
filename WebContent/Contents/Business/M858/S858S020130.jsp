<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DBServletLink dbLink = new DBServletLink();
	DateTimeUtil dateTimeUtil = new DateTimeUtil();
	
	int startPageNo = 1;
	String[] HyperLink		= {""}; //strColumnHead의 수만큼

	String GV_CALLER="";
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");

	String GV_BAECHA_NO="";
	
	if(request.getParameter("baecha_no")== null)
		GV_BAECHA_NO="";
	else
		GV_BAECHA_NO = request.getParameter("baecha_no"); //구분 : QAPROCS

	JSONObject jArray = new JSONObject();
	jArray.put( "baecha_no", GV_BAECHA_NO);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M858S020100E134", jArray);
 	int RowCount =TableModel.getRowCount();	
  
  	makeGridData= new MakeGridData(TableModel);
  	
  	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};
  	
  	if(GV_CALLER.equals("S858S020103")) {
		RightButton[2][0] = "off"; // 삭제시 행삭제버튼 off
	} else if(GV_CALLER.equals("S858S020102")) {
		RightButton[2][1] = "fn_baecha_order_delete(this)"; // 수정시 DB에서 행 삭제하는 함수 매칭
	}
  	
 	makeGridData.RightButton	= RightButton;
 	makeGridData.htmlTable_ID	= "tableS858S020130";
 	makeGridData.Check_Box 	= "false";
 	makeGridData.HyperLink 	= HyperLink; 
%>
    
<script>
	$(document).ready(function () {
		vTableS858S020130 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	  
			scrollX: true,
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "desc" ]], //공정코드 순 정렬
    	    info: false,
//             className: 'select-checkbox',
            targets:   0,
    	    data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
<%-- 	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)"); --%>
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
	  			{
	  				'targets': [0,1,2,4,5,11,12,13],
		   			'createdCell': function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [14],
		   			'createdCell': function (td) {
//		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
              			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
// 		   				$(td).html('<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'); 
					}
		   		}
			],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS858S020130_RowCount = vTableS858S020130.rows().count();
		
		if(TableS858S020130_RowCount>0){
			$('#txt_baecha_no').val(vTableS858S020130.cell(0, 0).data());
		}
		
<%-- 		if("<%=GV_CALLER%>"=="S858S020101") {  --%>
// 			for(var i=0; i<TableS858S020130_RowCount; i++){  // DB에서 조회된 레코드 삭제버튼제거
// 				var trInput = $($("#TableS858S020130_tbody tr")[i]).find(":button");
// 				//trInput.eq(0).prop("disabled", true);
// 				trInput.eq(0).remove();
// 	 		}
// 		}

<%-- 		if("<%=GV_CALLER%>"=="S858S020102" || "<%=GV_CALLER%>"=="S858S020103" || "<%=GV_CALLER%>"=="S858S020122") { --%>
// 			if(TableS858S020130_RowCount<1) {
// 				alert("해당 주문의 생산계획이 없습니다."+"\n"+"생산계획을 먼저 등록해주세요.");
// 				parent.$("#ReportNote").children().remove();
// 	     		parent.$('#modalReport').hide();
// 			}
// 		}
	});
	
</script>

<div id="UserList_pager" class="text-center">
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
			<thead>
			<tr>		  	
				<th style='width:0px; display: none;'>baecha_no</th>
				<th style='width:0px; display: none;'>order_no</th>
				<th style='width:0px; display: none;'>lotno</th>
				<th>주문업체</th>
				<th style='width:0px; display: none;'>제품코드</th>
				<th style='width:0px; display: none;'>제품rev</th>
				<th>제품명</th>
				<th>주문갯수</th>
				<th>주문일</th>
				<th>납기일</th>
				<th>출하갯수</th>		
				<th style='width:0px; display: none;'>order_detail_seq</th>
				<th style='width:0px; display: none;'>chulha_no</th>
				<th style='width:0px; display: none;'>chulha_seq</th>
				<th></th>
			</tr>
			</thead>
			<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
			</tbody>
	</table>		
	<div id="UserList_pager" class="text-center">
</div>
