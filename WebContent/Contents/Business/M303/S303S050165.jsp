<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	/* 
	제품(모델별) BOM 선택하는 화면
	 */
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_PROC_PLAN_NO = "", GV_PROD_CD = "", GV_PROD_CD_REV = "" ;

	if (request.getParameter("proc_plan_no") == null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");
	
	if (request.getParameter("prod_cd") == null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if (request.getParameter("prod_cd_rev") == null)
		GV_PROD_CD_REV = "";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);

	TableModel = new DoyosaeTableModel("M303S050100E165", jArray);
	
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"on", "fn_production_storage_delete(this)", "삭제"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS303S050165";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;  
%>

<script type="text/javascript">
	
	var Rowcount='<%=RowCount%>';

	$(document).ready(function () {
		vTableS303S050165 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
// 		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 0, "desc" ]],
		    keys: false,
		    info: true,
		    data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
<%-- 	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)"); --%>
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [
	  			{
		       		'targets': [0,1,2,3,4,8,9,11,12,13,14,16],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:0px; display: none;'); 
	       			}
				},
				{
		       		'targets': [17],
		       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
// 		          		$(td).html('<button style="width: auto; float: left; " type="button" id="right_btn" onclick="fn_inspect_result_delete(this)" class="btn-outline-success">삭제</button>'); 
		       		}
				}
	  		],         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
		});
		
		TableS303S050165_info = vTableS303S050165.page.info();
     	TableS303S050165_Row_Count = TableS303S050165_info.recordsTotal;
	
     	if(Rowcount > 0){
			$('#txt_warehousing_datetime').val(vTableS303S050165.cell(0,0).data()); // 날짜 넣어줌
			$('#txt_io_gubun').val(vTableS303S050165.cell(0,1).data()); // 입출고구분 : O
		}
     	
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			TableS303S050165_Row_Index = vTableS303S050165.row( this ).index();
			$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS303S050165.rows(this).nodes().to$().attr("class", "hene-bg-color");
			
			$('#txt_warehousing_datetime').val(vTableS303S050165.cell(TableS303S050165_Row_Index, 0).data());
			$('#txt_io_gubun').val(vTableS303S050165.cell(TableS303S050165_Row_Index,1).data());
			$('#txt_expiration_date').val(vTableS303S050165.cell(TableS303S050165_Row_Index,2).data());
			$('#txt_part_cd').val(vTableS303S050165.cell(TableS303S050165_Row_Index,3).data());
			$('#txt_part_cd_rev').val(vTableS303S050165.cell(TableS303S050165_Row_Index,4).data());
			$('#txt_part_nm').val(vTableS303S050165.cell(TableS303S050165_Row_Index,5).data());
			$('#txt_gyugyeok').val(vTableS303S050165.cell(TableS303S050165_Row_Index,6).data());
			$('#txt_detail_gyugyeok').val(vTableS303S050165.cell(TableS303S050165_Row_Index,7).data());
			$('#txt_pre_amt').val(vTableS303S050165.cell(TableS303S050165_Row_Index,8).data());
			$('#txt_post_amt').val(vTableS303S050165.cell(TableS303S050165_Row_Index,9).data());
			$('#txt_io_amt').val(vTableS303S050165.cell(TableS303S050165_Row_Index,10).data());
//	 		$('#txt_proc_plan_no').val(vTableS303S050165.cell(TableS303S050165_Row_Index,11).data());
//	 		$('#txt_prod_cd').val(vTableS303S050165.cell(TableS303S050165_Row_Index,12).data());
//	 		$('#txt_prod_cd_rev').val(vTableS303S050165.cell(TableS303S050165_Row_Index,13).data());
//	 		$('#txt_prod_nm').val(vTableS303S050165.cell(TableS303S050165_Row_Index,14).data());
			$('#txt_bigo').val(vTableS303S050165.cell(TableS303S050165_Row_Index,15).data());
			
			$('#btn_plus').html("수정");
			$('#btn_SearchPart').attr("disabled", true);
		} );
		
	});

	function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
		$(obj).attr("class", "hene-bg-color");
	}
	
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th style='width:0px; display: none;'>warehousing_datetime</th>
		     <th style='width:0px; display: none;'>io_gubun</th>
		     <th style='width:0px; display: none;'>유통기한</th>
		     <th style='width:0px; display: none;'>part_cd</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     <th>원재료명</th>
		     <th>규격</th>
		     <th>규격(g단위)</th>
		     <th style='width:0px; display: none;'>불출 전 재고</th>
		     <th style='width:0px; display: none;'>불출 후 재고</th>
		     <th>불출 중량(g)</th>
		     <th style='width:0px; display: none;'>proc_plan_no</th>
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th style='width:0px; display: none;'>prod_nm</th>
		     <th>비고</th>
		     <th style='width:0px; display: none;'>insert_yn(최초등록여부:Y면등록,N이면수정)</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div> 
