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
	
	String param = "";
	int startPageNo = 1;
// 	Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
		
// 	final int PageSize=15; 

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_PROCESSGUBUN="", GV_PROC_CD="", GV_LOTNO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("order_no");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("process_gubun")== null)
		GV_PROCESSGUBUN="";
	else
		GV_PROCESSGUBUN = request.getParameter("process_gubun"); //구분 : QAPROCS


	if(request.getParameter("proc_cd")== null)
		GV_PROC_CD="";
	else
		GV_PROC_CD = request.getParameter("proc_cd"); //구분 : QAPROCS
		
		if(request.getParameter("lotno")== null)
			GV_LOTNO="";
		else
			GV_LOTNO = request.getParameter("lotno");
			
	
//	param = GV_ORDERNO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_PROCESSGUBUN + "|" + GV_PROC_CD  + "|" + GV_LOTNO  + "|"+ "|" + member_key;	
	
	JSONObject jArray = new JSONObject();
 	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "process_gubun", GV_PROCESSGUBUN);
	jArray.put( "proc_cd", GV_PROC_CD);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M303S010100E124", jArray);
 	int RowCount =TableModel.getRowCount();	
    int colspanCount =TableModel.getColumnCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS303S010120";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
    
<script>
	$(document).ready(function () {
		vTableS303S010120 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	   
			scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 3, "asc" ]], //공정코드 순 정렬
    	    info: false,
			data: <%=makeGridData.getDataArry()%>,
				'createdRow': function(row) {	
			 		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
			 		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
			 		$(row).attr('role',"row");
					}, 
			columnDefs: [{
				'targets': [4],
					'createdCell':  function (td) {
						$(td).attr('style', 'display: none;'); 
					}
			},
				// 조회컬럼크기
			{
					'targets': [5],
					'createdCell':  function (td) {
					//	$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
			}],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    	
		TableS303S010120_RowCount = vTableS303S010120.rows().count();
		
		for(var i=0; i<TableS303S010120_RowCount; i++) { // 오른쪽테이블에 있는 왼쪽테이블 레코드제거
			var q_proc_cd_120 = vTableS303S010120.cell( i, 0).data().trim();
			for(var j=0; j<TableS303S010130_RowCount; j++) {
				var q_proc_cd_130 = vTableS303S010130.cell( j, 2).data().trim();
// 				alert("TableS303S010120_RowCount="+TableS303S010120_RowCount+"\n"+"q_proc_cd_120="+q_proc_cd_120+"\n"+"q_proc_cd_130="+q_proc_cd_130);
				if(q_proc_cd_120==q_proc_cd_130) {
// 					alert("q_proc="+q_proc_cd_120+"\n"+"레코드제거");
					vTableS303S010120.row(i).remove().draw();
					TableS303S010120_RowCount = vTableS303S010120.page.info().recordsTotal; //행제거하면 rowcount 다시계산
					i--; //행제거하면 index-1
				}
			}
 		}
		
    	$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
    		S303S010120_Row_index = vTableS303S010120.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS303S010120.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
// 	 		clear_input();
	 		
			$('#txt_q_proc_cd').val(vTableS303S010120.cell(S303S010120_Row_index, 0).data());	//0 품질공정코드
			$('#txt_process_nm').val(vTableS303S010120.cell(S303S010120_Row_index, 1).data());	//1 품질공정명
			$('#txt_dept_gubun').val(vTableS303S010120.cell(S303S010120_Row_index, 2).data());	//2 관련부서
			$('#txt_process_seq').val(vTableS303S010120.cell(S303S010120_Row_index, 3).data());	//3 공정순서
			$('#txt_q_proc_cd_rev').val(vTableS303S010120.cell(S303S010120_Row_index, 4).data());	//4 품질공정 rev
			
			$('#btn_plus').html("입력");
			S303S010130_Row_index = -1;
			vTableS303S010130.rows().nodes().to$().attr("class", "hene-bg-color_w");
		} );
		        
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS303S010120.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
	});

	function fn_Clear_varv(){
		vOrderNo 			= "";
		vProd_serial_no	= "";
		vOrderDetailSeq 		= "";
		vOrder_cnt 			= "";
		vCustCode 			= "";
	//		vGIJONG_CODE 		= "";
		$('#txt_custcode').val("");
	}

</script>

    		String[] strColumnHead 	= { "공정코드", "공정명", "관련부서", "공정순서",
			"revision_no"} ;
int[] colOff 			= { 1, 1, 1, 1, 
			0 };
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		<th>공정코드</th>
		<th>공정명</th>
		<th>관련부서</th>
		<th>공정순서</th>
		<th style='width:0px; display: none;'>revision_no</th>
		<th style='width:0px; display: none;'></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>				
			
<!-- <div id="UserList_pager" class="text-center"></div> -->


