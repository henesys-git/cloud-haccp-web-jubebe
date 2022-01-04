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
	
	String param = "";
	int startPageNo = 1;
// 	Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
		
// 	final int PageSize=15; 

	String[] strColumnHead 	= { "order_no","order_detail_seq","proc_plan_no","product_serial_no","lotno","start_dt","end_dt","production_status","proc_info_no","proc_odr",
								"공정코드","proc_cd_rev","자주검사여부","품질검사요청여부","표준공수","필요인원","공정시작예정일","공정완료예정일","process_nm","dept_gubun","process_seq" };
	int[] colOff 			= { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
								1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0 };
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};

	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_CALLER="", GV_LOTNO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("order_no");	
	
	
		
	
	
	if(GV_CALLER.equals("S303S020102") || GV_CALLER.equals("S303S020103") || GV_CALLER.equals("S303S020122")) {
		RightButton[2][0] = "off"; // 수정&삭제시 행삭제버튼 off
	}

	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);

	TableModel = new DoyosaeTableModel("M353S020100E105",  jArray);	
 	int RowCount =TableModel.getRowCount();
    int colspanCount =TableModel.getColumnCount();
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS353S020130";
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
    		columnDefs = [
        		{
    	       		'targets': [0,1,2,3,4,5,6,7,8,9,11,13,18,19,20],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0px; display: none;'); 
    	          			$(td).parent().attr('id', 'TableS353S020130_rowID'); 
    	       		}
           		},
           		{
    	       		'targets': [21],
    	       		'createdCell':  function (td) {
              			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
    	          			$(td).html('<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'); 
    	       		}
    			}
           	];
		
		vTableS353S020130 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    	    
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: false,
    	    'columnDefs': columnDefs,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS353S020130_RowCount = vTableS353S020130.rows().count();
		
		if("<%=GV_CALLER%>"=="S303S020101") { 
			for(var i=0; i<TableS353S020130_RowCount; i++){  // DB에서 조회된 레코드 삭제버튼제거
				var trInput = $($("#TableS353S020130_tbody tr")[i]).find(":button");
				//trInput.eq(0).prop("disabled", true);
				trInput.eq(0).remove();
	 		}
		}

		if("<%=GV_CALLER%>"=="S303S020102" || "<%=GV_CALLER%>"=="S303S020103" || "<%=GV_CALLER%>"=="S303S020122") {
			if(TableS353S020130_RowCount<1) {
				alert("해당 주문의 생산계획이 없습니다."+"\n"+"생산계획을 먼저 등록해주세요.");
				parent.$("#ReportNote").children().remove();
	     		parent.$('#modalReport').hide();
			}
		}
		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S353S020130_Row_index = vTableS353S020130.row( this ).index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS353S020130.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
	 		if("<%=GV_CALLER%>"=="S303S020101") {
	 			clear_input();
	 		}
	 		
	 		var startDt = new Date(vTableS353S020130.cell(S353S020130_Row_index, 16).data());
    		var endDt = new Date(vTableS353S020130.cell(S353S020130_Row_index, 17).data());
			
// 	 		$('#txt_order_no').val(vTableS353S020130.cell(S353S020130_Row_index, 0).data());
// 	 		$('#txt_order_detail_seq').val(vTableS353S020130.cell(S353S020130_Row_index, 1).data());
	 		$('#txt_proc_plan_no').val(vTableS353S020130.cell(S353S020130_Row_index, 2).data());
// 	 		$('#txt_product_serial_no').val(vTableS353S020130.cell(S353S020130_Row_index, 3).data());
// 	 		$('#txt_lotno').val(vTableS353S020130.cell(S353S020130_Row_index, 4).data());
// 	 		$('#txt_total_start_dt').val(vTableS353S020130.cell(S353S020130_Row_index, 5).data());
// 	 		$('#txt_total_end_dt').val(vTableS353S020130.cell(S353S020130_Row_index, 6).data());
	 		$('#txt_production_status').val(vTableS353S020130.cell(S353S020130_Row_index, 7).data());
	 		$('#txt_proc_info_no').val(vTableS353S020130.cell(S353S020130_Row_index, 8).data());
	 		$('#txt_proc_odr').val(vTableS353S020130.cell(S353S020130_Row_index, 9).data());
			$('#txt_proc_cd').val(vTableS353S020130.cell(S353S020130_Row_index, 10).data());
			$('#txt_proc_cd_rev').val(vTableS353S020130.cell(S353S020130_Row_index, 11).data());
			if(vTableS353S020130.cell(S353S020130_Row_index, 12).data()=='Y') $('#txt_inspect_yn').prop("checked",true);
			else if(vTableS353S020130.cell(S353S020130_Row_index, 12).data()=='N') $('#txt_inspect_yn').prop("checked",false);
			if(vTableS353S020130.cell(S353S020130_Row_index, 13).data()=='Y') $('#txt_inspect_request_yn').prop("checked",true);
			else if(vTableS353S020130.cell(S353S020130_Row_index, 13).data()=='N') $('#txt_inspect_request_yn').prop("checked",false);
			$('#txt_std_proc_qnt').val(vTableS353S020130.cell(S353S020130_Row_index, 14).data());
			$('#txt_man_amt').val(vTableS353S020130.cell(S353S020130_Row_index, 15).data());
			$('#txt_start_dt').data('daterangepicker').setStartDate(startDt);
			$('#txt_start_dt').data('daterangepicker').setEndDate(startDt);
	        $('#txt_end_dt').data('daterangepicker').setStartDate(endDt);
	        $('#txt_end_dt').data('daterangepicker').setEndDate(endDt);
			$('#txt_process_nm').val(vTableS353S020130.cell(S353S020130_Row_index, 18).data());
			$('#txt_dept_gubun').val(vTableS353S020130.cell(S353S020130_Row_index, 19).data());
			$('#txt_process_seq').val(vTableS353S020130.cell(S353S020130_Row_index, 20).data());
			
			if("<%=GV_CALLER%>"=="S303S020101") { 
				$('#btn_plus').html("수정");
				S303S020120_Row_index = -1;
				vTableS303S020120.rows().nodes().to$().attr("class", "hene-bg-color_w");
			}
		} );
		        
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS353S020130.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
	});
	
</script>

<%=zhtml%>
<div id="UserList_pager" class="text-center">
</div>
