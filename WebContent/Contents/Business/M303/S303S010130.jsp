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

// 	Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
		
// 	final int PageSize=15; 

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};

	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_CALLER="", GV_LOTNO="";
	
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
	
	if(GV_CALLER.equals("S303S010102") || GV_CALLER.equals("S303S010103") || GV_CALLER.equals("S303S010122")) {
		RightButton[2][0] = "off"; // 수정&삭제시 행삭제버튼 off
	}
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");

	//param =GV_ORDERNO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|";	
	JSONObject jArray = new JSONObject();
 	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M303S010100E134", jArray);
 	int RowCount =TableModel.getRowCount();	
    int colspanCount =TableModel.getColumnCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS303S010130";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

    
<script>
	$(document).ready(function () {
		var columnDefs;
    	if("<%=GV_CALLER%>"=="S303S010101") { 
    		columnDefs = [
        		{
    	       		'targets': [5,8,9,10,11,12,13,14,15],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0px; display: none;'); 
    	          			$(td).parent().attr('id', 'TableS303S010130_rowID'); 
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
		
		vTableS303S010130 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: false,
    	    'columnDefs': columnDefs,
    	    data: <%=makeGridData.getDataArry()%>,
			'createdRow': function(row) {	
		 		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
		 		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
		 		$(row).attr('role',"row");
				}, 
			columnDefs: [{
				'targets': [6,9,10,11,12,13,14,15,16],
					'createdCell':  function (td) {
						$(td).attr('style', 'display: none;'); 
					}
			},
			// 조회컬럼크기
			{
					'targets': [19],
					'createdCell':  function (td) {
					//	$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
			}],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});

		S303S010130_Row_index = -1;
		TableS303S010130_RowCount = vTableS303S010130.rows().count();
		
		if("<%=GV_CALLER%>"=="S303S010101") { 
			for(i=0;i<TableS303S010130_RowCount;i++) {  // q_proc_seq 최대값 구하기
				//alert(vTableS303S010130.cell(i, 13).data());
				if(qProcSeq_Max < vTableS303S010130.cell(i, 13).data())
					qProcSeq_Max = vTableS303S010130.cell(i, 13).data();
			}
			
			for(var i=0; i<TableS303S010130_RowCount; i++){  // DB에서 조회된 레코드 삭제버튼제거
				var trInput = $($("#TableS303S010130_tbody tr")[i]).find(":button");
				//trInput.eq(0).prop("disabled", true);
				trInput.eq(0).remove();
	 		}
		}

		if("<%=GV_CALLER%>"=="S303S010102" || "<%=GV_CALLER%>"=="S303S010103" || "<%=GV_CALLER%>"=="S303S010122") {
			if(TableS303S010130_RowCount<1) {
				alert("해당 주문의 생산공정이 없습니다."+"\n"+"생산공정을 먼저 등록해주세요.");
				parent.$("#ReportNote").children().remove();
	     		parent.$('#modalReport').hide();
			}
		}
		
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S303S010130_Row_index = vTableS303S010130.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS303S010130.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
	 		if("<%=GV_CALLER%>"=="S303S010101") {
	 			clear_input();
	 		}
	 		
// 	 		$('#txt_order_no').val(vTableS303S010130.cell(S303S010130_Row_index, 9).data());	//9 주문번호
// 	 		$('#txt_order_detail_seq').val(vTableS303S010130.cell(S303S010130_Row_index, 10).data());	//10 주문상세
	 		$('#txt_process_cd').val(vTableS303S010130.cell(S303S010130_Row_index, 0).data());	//0 공정코드
	 		$('#txt_process_name').val(vTableS303S010130.cell(S303S010130_Row_index, 1).data());	//1 공정명
	 		$('#txt_process_rev').val(vTableS303S010130.cell(S303S010130_Row_index, 11).data());	//11 공정 rev
			$('#txt_proc_info_no').val(vTableS303S010130.cell(S303S010130_Row_index, 8).data());	//8 공정정보번호
			$('#txt_q_proc_cd_rev').val(vTableS303S010130.cell(S303S010130_Row_index, 12).data());	//12 품질공정 rev
			$('#txt_q_proc_seq').val(vTableS303S010130.cell(S303S010130_Row_index, 13).data());	//13 품질공정순번
			$('#txt_q_proc_cd').val(vTableS303S010130.cell(S303S010130_Row_index, 2).data());	//2 품질공정코드
			$('#txt_process_nm').val(vTableS303S010130.cell(S303S010130_Row_index, 3).data());	//3 품질공정명
			$('#txt_dept_gubun').val(vTableS303S010130.cell(S303S010130_Row_index, 14).data());	//14 관련부서
			$('#txt_process_seq').val(vTableS303S010130.cell(S303S010130_Row_index, 15).data());	//15 공정순서
			if(vTableS303S010130.cell(S303S010130_Row_index, 4).data()=='Y') $('#txt_inspect_yn').prop("checked",true); //4 자주검사여부(checkbox)
			else if(vTableS303S010130.cell(S303S010130_Row_index, 4).data()=='N') $('#txt_inspect_yn').prop("checked",false); //4 자주검사여부(checkbox)
			if(vTableS303S010130.cell(S303S010130_Row_index, 5).data()=='Y') $('#txt_inspect_request_yn').prop("checked",true); //5 품질검사요청여부(checkbox)
			else if(vTableS303S010130.cell(S303S010130_Row_index, 5).data()=='N') $('#txt_inspect_request_yn').prop("checked",false); //5 품질검사요청여부(checkbox)
			$('#txt_std_proc_qnt').val(vTableS303S010130.cell(S303S010130_Row_index, 6).data());	//6 표준공수
			$('#txt_man_amt').val(vTableS303S010130.cell(S303S010130_Row_index, 7).data());	//7 필요인원수
			$('#txt_start_date').val(vTableS303S010130.cell(S303S010130_Row_index, 16).data());	//6 표준공수
			$('#txt_end_date').val(vTableS303S010130.cell(S303S010130_Row_index, 17).data());	//7 필요인원수
			
			if("<%=GV_CALLER%>"=="S303S010101") { 
				$('#btn_plus').html("수정");
				S303S010120_Row_index = -1;
				vTableS303S010120.rows().nodes().to$().attr("class", "hene-bg-color_w");
			}
		} );
		        
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS303S010130.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
	});
	
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		<th>공정코드</th>
		<th>공정명</th>
		<th>품질공정코드</th>
		<th>품질공정명</th>
		<th>자주검사여부</th>
		<th style='width:0px; display: none;'>품질검사요청여부</th>
		<th>표준공수</th>
		<th>필요인원</th>
		<th style='width:0px; display: none;'>proc_info_no</th>
		<th style='width:0px; display: none;'>order_no</th>
		<th style='width:0px; display: none;'>order_detail_seq</th>
		<th style='width:0px; display: none;'>lotno</th>
		<th style='width:0px; display: none;'>proc_cd_rev</th>
		<th style='width:0px; display: none;'>q_proc_cd_rev</th>
		<th style='width:0px; display: none;'>q_proc_seq</th>
		<th style='width:0px; display: none;'>dept_gubun</th>
		<th style='width:0px; display: none;'>process_seq</th>
		<th>공정시작예정일</th>
		<th>공정완료예정일</th>
		<th></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>	
<div id="UserList_pager" class="text-center">
</div>
