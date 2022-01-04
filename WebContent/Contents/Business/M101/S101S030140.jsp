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

	String GV_PROC_PLAN_NO = "";

	if (request.getParameter("proc_plan_no") == null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put( "member_key", member_key);

	TableModel = new DoyosaeTableModel("M101S030100E144", jArray);
	
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"on", "fn_inspect_result_delete(this)", "삭제"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS101S030140";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;  
%>

<script type="text/javascript">
	var Rowcount='<%=RowCount%>';
	$(document).ready(function () {
		vTableS101S030140 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
// 		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [
	  			{
		       		'targets': [1,2,4,6,8,9,10,11,12,13,14,15,16,18,19,20,21,22,23],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:0px; display: none;'); 
	       			}
				},
				{
		       		'targets': [25],
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
		
		TableS101S030140_info = vTableS101S030140.page.info();
     	TableS101S030140_Row_Count = TableS101S030140_info.recordsTotal;
	
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			TableS101S030140_Row_Index = vTableS101S030140
		        .row( this )
		        .index();
			$('#btn_plus').html("수정");
		} );
		if(Rowcount > 0){
			var max_seq = 0;
	        for(i=0; i<TableS101S030140_Row_Count; i++) {
	        	if(max_seq < parseInt(vTableS101S030140.cell( i, 0 ).data()))
	        		max_seq = parseInt(vTableS101S030140.cell( i, 0 ).data());
	        }
        	$('#txt_lastseq').val(max_seq);		
			$('#txt_bom_cd').val(		vTableS101S030140.cell( 0, 1 ).data());	//4 bom_cd 
			$('#txt_bom_cd_rev').val(	vTableS101S030140.cell( 0, 2 ).data());	//5 bom_cd_rev
// 			$('#txt_bom_name').val(	vTableS101S030140.cell( 0, 4 ).data());	//6 bom_name
			$('#txt_type_code').val(	vTableS101S030140.cell( 0, 19 ).data());	//9 type_no 형식번호
			$('#txt_A_productname').val(vTableS101S030140.cell( 0, 20 ).data());	//10 geukyongpoommok 적용품목
			$('#txt_deptcode').val(	vTableS101S030140.cell( 0, 22 ).data());	//11 dept_code 부서코드
// 			$('#txt_deptcode').val(	vTableS101S030140.cell( 0, 22 ).data()).prop("selected",true);  //11 dept_code 부서코드
			$('#approval_date').val(	vTableS101S030140.cell( 0, 21 ).data());	//12 approval_date 승인일자
			$('#approval').val(		vTableS101S030140.cell( 0, 23 ).data());	//13 approval 승인
		}
	});


    
	function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
		$(obj).attr("class", "hene-bg-color");
		// 		$(obj).attr("class", "bg-danger");
		// 		$(obj).attr("class", "bg-success"); 

		$('#txt_seq').val(td.eq(0).text().trim());
// 		$('#txt_bom_cd').val(td.eq(1).text().trim());
		$('#txt_bom_cd_click').val(td.eq(1).text().trim());
		$('#txt_part_cd').val(td.eq(3).text().trim());
// 		$('#txt_bom_nm').val(td.eq(4).text().trim());
		$('#txt_part_nm').val(td.eq(5).text().trim());
		$('#txt_part_cd_rev').val(td.eq(6).text().trim());
		$('#txt_part_cnt').val(td.eq(7).text().trim());
		$('#txt_maesu').val(td.eq(8).text().trim());
		$('#txt_gubun').val(td.eq(9).text().trim());
		$('#txt_qar').val(td.eq(10).text().trim())
		$('#txt_inspectequep').val(td.eq(11).text().trim())
		$('#txt_package').val(td.eq(12).text().trim())
		$('#txt_modify').val(td.eq(13).text().trim());
		$('#txt_bom_custcode').val(td.eq(14).text().trim());
		$('#txt_bom_CustName').val(td.eq(15).text().trim());
		$('#txt_cust_rev').val(td.eq(16).text().trim());
		$('#txt_bigo').val(td.eq(17).text().trim());
		$('#txt_jaego').val(td.eq(24).text().trim());
		
		
		

	}
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>순번</th>
		     <th style='width:0px; display: none;'>배합(BOM)코드</th>
		     <th style='width:0px; display: none;'>배합(BOM)개정번호</th>
		     <th>원부자재코드</th>
		     <th style='width:0px; display: none;'>배합(BOM)명</th>
		     <th>원부자재명</th>
		     <th style='width:0px; display: none;'>원부자재개정번호</th>
		     <th>원부자재중량(g)</th>
		     <th style='width:0px; display: none;'>매수</th>
		     <th style='width:0px; display: none;'>구분</th>
		     <th style='width:0px; display: none;'>qar</th>
		     <th style='width:0px; display: none;'>inspect</th>
		     <th style='width:0px; display: none;'>package</th>
		     <th style='width:0px; display: none;'>수정</th>
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>거래처</th>
		     <th style='width:0px; display: none;'>고객사개정번호</th>
		     <th>비고</th>
		     <th style='width:0px; display: none;'>last_no</th>
		     <th style='width:0px; display: none;'>type_no</th>
		     <th style='width:0px; display: none;'>geukyongpoommok</th>
		     <th style='width:0px; display: none;'>approval_date</th>
		     <th style='width:0px; display: none;'>dept_code</th>
		     <th style='width:0px; display: none;'>approval</th>
		     <th>재고</th>

<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div> 
