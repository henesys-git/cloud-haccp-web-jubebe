<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	DBServletLink dbLink = new DBServletLink();
	DateTimeUtil dateTimeUtil = new DateTimeUtil();
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	
	String param = "";
	int startPageNo = 1;
// 	Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
		
// 	final int PageSize=15; 

	String[] strColumnHead 	= { "order_no",
// 								"order_detail_seq",
								"lotno",
								"bulchul_req_no","원부자재코드","part_cd_rev",
								"원부자재명","req_date","dept_code","부서명","용도",
								"구분","요청수량","단위","비고","불출일자",
								"req_userid","수령인 ID","damdanja" };
	int[] colOff 			= { 0, 0, 0, 1, 0, 
								1, 0, 0, 1,	1, 
								1, 1, 1, 1, 1, 
								0, 1 ,0 };	
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};

	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_CALLER="", GV_LOTNO="" ;
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("order_no");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");
	
	if(GV_CALLER.equals("S303S070102") || GV_CALLER.equals("S303S070103") || GV_CALLER.equals("S303S070122")) {
		RightButton[2][0] = "off"; // 수정&삭제시 행삭제버튼 off
	}
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");

	param = GV_ORDERNO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|" + member_key + "|" ;	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);

	TableModel = new DoyosaeTableModel("M303S070100E134", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS303S070130";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton;
    String zhtml=makeTableHTML.getHTML();
%>

    
<script>
	$(document).ready(function () {
		var columnDefs;
    	if("<%=GV_CALLER%>"=="S303S070101") { 
    		columnDefs = [
        		{
    	       		'targets': [0,1,2,4,6,7,15,17],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0px; display: none;'); 
    	          			$(td).parent().attr('id', 'TableS303S070130_rowID'); 
    	       		}
           		},
           		{
    	       		'targets': [18],
    	       		'createdCell':  function (td) {
              			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
    	          			$(td).html('<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'); 
    	       		}
    			}
           	];
    	} 
		
		vTableS303S070130 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	   
			scrollX: true,
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 2, "asc" ]],
    	    info: true,
    	    'columnDefs': columnDefs,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS303S070130_RowCount = vTableS303S070130.rows().count();
		
		if("<%=GV_CALLER%>"=="S303S070101") { 
			for(var i=0; i<TableS303S070130_RowCount; i++){  // DB에서 조회된 레코드 삭제버튼제거
				var trInput = $($("#TableS303S070130_tbody tr")[i]).find(":button");
				//trInput.eq(0).prop("disabled", true);
				trInput.eq(0).remove();
	 		}
		}

		if("<%=GV_CALLER%>"=="S303S070102" || "<%=GV_CALLER%>"=="S303S070103" || "<%=GV_CALLER%>"=="S303S070122") {
			if(TableS303S070130_RowCount<1) {
				alert("해당 주문의 자재불출 신청건이 없습니다."+"\n"+"자재불출요청을 먼저 해주세요.");
				parent.$("#ReportNote").children().remove();
	     		parent.$('#modalReport').hide();
			}
		}
		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S303S070130_Row_index = vTableS303S070130.row( this ).index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS303S070130.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
<%-- 	 	if("<%=GV_CALLER%>"=="S303S070101") { --%>
// 	 			clear_input();
// 	 		}
	 		
	 		$('#txt_order_no').val(vTableS303S070130.cell(S303S070130_Row_index, 0).data());
	 		$('#txt_order_detail_seq').val(vTableS303S070130.cell(S303S070130_Row_index, 1).data());
	 		$('#txt_bulchul_req_no').val(vTableS303S070130.cell(S303S070130_Row_index, 2).data());
	 		$('#txt_part_cd').val(vTableS303S070130.cell(S303S070130_Row_index, 3).data());
	 		$('#txt_part_cd_rev').val(vTableS303S070130.cell(S303S070130_Row_index, 4).data());
	 		
	 		$('#txt_part_nm').val(vTableS303S070130.cell(S303S070130_Row_index, 5).data());
	 		$('#txt_req_date').val(vTableS303S070130.cell(S303S070130_Row_index, 6).data());
	 		$('#txt_dept_code').val(vTableS303S070130.cell(S303S070130_Row_index, 7).data());
	 		$('#txt_yongdo').val(vTableS303S070130.cell(S303S070130_Row_index, 9).data());
	 		
	 		$('#txt_gubun').val(vTableS303S070130.cell(S303S070130_Row_index, 10).data());
			$('#txt_req_count').val(vTableS303S070130.cell(S303S070130_Row_index, 11).data());
			$('#txt_unit').val(vTableS303S070130.cell(S303S070130_Row_index, 12).data());
			$('#txt_bigo').val(vTableS303S070130.cell(S303S070130_Row_index, 13).data());
// 			$('#txt_bulchul_date').val(vTableS303S070130.cell(S303S070130_Row_index, 14).data());
			$('#txt_bulchul_date').datepicker('update', new Date(vTableS303S070130.cell(S303S070130_Row_index, 14).data()));
			
			$('#txt_req_userid').val(vTableS303S070130.cell(S303S070130_Row_index, 15).data());
			$('#txt_reciept_userid').val(vTableS303S070130.cell(S303S070130_Row_index, 16).data());
	        $('#txt_damdanja').val(vTableS303S070130.cell(S303S070130_Row_index, 17).data());
			
			if("<%=GV_CALLER%>"=="S303S070101") { 
				$('#btn_plus').html("수정");
				S303S070120_Row_index = -1;
				vTableS303S070120.rows().nodes().to$().attr("class", "hene-bg-color_w");
			}
		} );
		        
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS303S070130.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
	});
	
</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>
