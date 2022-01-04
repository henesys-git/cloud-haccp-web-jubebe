<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<%
/* 
ProcessView.jsp
 */
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
    Vector optCode =  null;
    Vector optName =  null;
	Vector bigGubun = CommonData.getWorkClassCdDataAll();
	Vector midGubun = CommonData.getMidClassCdDataAll("GPR02");
	
	int startPageNo = 1;
	
	String GV_CALLER="", GV_PROCESSGUBUN="";
	
	if(request.getParameter("caller")== null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");

	if(request.getParameter("processGubun")== null)
		GV_PROCESSGUBUN="";
	else
		GV_PROCESSGUBUN = request.getParameter("processGubun");

	JSONObject jArray = new JSONObject();
	
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M909S120100E194", jArray);
    //int ColCount =TableModel.getColumnCount();
    
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
    int RowCount =TableModel.getRowCount();

    
    makeGridData= new MakeGridData(TableModel);
    String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableProcessView";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

 
<script>
var txt_CustName;
	var caller="";
	var GV_BIG_CD="";
	var GV_MID_CD="";
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
//     		scrollY: 600,
    	    scrollCollapse: true,
    	    autoWidth: true,
    	    processing: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    data: <%=makeGridData.getDataArry()%>,
    	    order: [[ 0, "desc" ]],
    	    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");	      		
    	    },
	  		'columnDefs': [
				{
		   			'targets': [1,2,3,5,7,8,10,11,12,13,14,15,16,17,18,19,22],
		   			'createdCell':  function (td) {
		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],
    	    info: true,         
            language: {
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
    	    }
    	});
		

// 		//엑셀다운로드하는 모듈 ====> 시작
// 				function itoStr($num)
// 		        {
// 		            $num < 10 ? $num = '0'+$num : $num;
// 		            return $num.toString();
// 		        }
		         
// 		        var btn = $('#btnExport');
// 		        var tbl = 'tableProcessView';
		 
// 		        btn.on('click', function () {
// 		            var dt = new Date();
// 		            var year =  itoStr( dt.getFullYear() );
// 		            var month = itoStr( dt.getMonth() + 1 );
// 		            var day =   itoStr( dt.getDate() );
// 		            var hour =  itoStr( dt.getHours() );
// 		            var mins =  itoStr( dt.getMinutes() );
		 
// 		            var postfix = year + month + day + "_" + hour + mins;
// 		            var fileName = tbl + "_"+ postfix + ".xls";
		 
// 		            var uri = $("#"+tbl).excelexportjs({
// 		                containerid: tbl
// 		                , datatype: 'table'
// 		                , returnUri: true
// 		            });
		 
// 		            $(this).attr('download', fileName).attr('href', uri).attr('target', '_blank');
// 		        });
// 		      //엑셀다운로드하는 모듈 ====> 끝    	
	});
	
	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });


		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
		var txt_process_gubun		= td.eq(0).text().trim();
		var txt_process_gubun_rev	= td.eq(1).text().trim();
		var txt_proc_code_gb_big	= td.eq(2).text().trim();
		var txt_proc_code_gb_mid	= td.eq(3).text().trim();
		var txt_process_cd			= td.eq(4).text().trim();
		var txt_process_rev			= td.eq(5).text().trim();
		var txt_process_name		= td.eq(6).text().trim();
		var txt_work_order_index	= td.eq(7).text().trim();
		var txt_process_seq			= td.eq(8).text().trim();
		var txt_bigo				= td.eq(9).text().trim();
		var txt_start_date			= td.eq(10).text().trim();
		var txt_create_date			= td.eq(11).text().trim();
		var txt_create_user_id		= td.eq(12).text().trim();
		var txt_modify_date			= td.eq(13).text().trim();
		var txt_modify_user_id		= td.eq(14).text().trim();
		var txt_duration_date		= td.eq(15).text().trim();
		var txt_modify_reason		= td.eq(16).text().trim();
		var txt_check_data_type		= td.eq(17).text().trim();
		var txt_dept_gubun			= td.eq(18).text().trim();
		var txt_delyn				= td.eq(19).text().trim();
		var txt_product_process_yn	= td.eq(20).text().trim();
		var txt_packing_process_yn	= td.eq(21).text().trim();
	
		if(caller==0){ //일반 화면에서 부를 때
			$('#txt_process_name').val(txt_process_name);
			$('#txt_process_cd').val(txt_process_cd);
			$('#txt_process_rev').val(txt_process_rev);
			
/* 	 		$("#txt_process_gubun", parent.document).val(txt_process_gubun);
	 		$("#txt_process_gubun_rev", parent.document).val(txt_process_gubun_rev);
	 		$("#txt_proc_code_gb_big", parent.document).val(txt_proc_code_gb_big);
	 		$("#txt_proc_code_gb_mid", parent.document).val(txt_proc_code_gb_mid);
	 		$("#txt_proc_cd", parent.document).val(txt_proc_cd);
	 		$("#txt_revision_no", parent.document).val(txt_revision_no);
	 		$("#txt_process_nm", parent.document).val(txt_process_nm);
	 		$("#txt_work_order_index", parent.document).val(txt_work_order_index);
	 		$("#txt_process_seq", parent.document).val(txt_process_seq);
	 		$("#txt_product_process_yn", parent.document).val(txt_product_process_yn);
	 		$("#txt_bigo", parent.document).val(txt_bigo);
	 		$("#txt_start_date", parent.document).val(txt_start_date);
	 		$("#txt_create_date", parent.document).val(txt_create_date);
	 		$("#txt_create_user_id", parent.document).val(txt_create_user_id);
	 		$("#txt_modify_date", parent.document).val(txt_modify_date);
	 		$("#txt_modify_user_id", parent.document).val(txt_modify_user_id);
	 		$("#txt_duration_date", parent.document).val(txt_duration_date);
	 		$("#txt_modify_reason", parent.document).val(txt_modify_reason);
	 		$("#txt_check_data_type", parent.document).val(txt_check_data_type);
	 		$("#txt_dept_gubun", parent.document).val(txt_dept_gubun);
	 		$("#txt_delyn", parent.document).val(txt_delyn);
	 		$("#txt_packing_process_yn", parent.document).val(txt_packing_process_yn); */
	 		
		} else if(caller==1){ //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때			
 			parent.SetProcessInfo(txt_process_name,txt_process_cd, txt_process_rev);
		} else if(caller==2){ 			
 			parent.SetProcessName_code(
 				txt_process_gubun,
 				txt_process_gubun_rev,
 				txt_proc_code_gb_big,
 				txt_proc_code_gb_mid,
 				txt_process_cd,
 				txt_process_rev,
 				txt_process_name,
 				txt_work_order_index,
 				txt_process_seq,
 				txt_product_process_yn,
 				txt_bigo,
 				txt_start_date,
 				txt_create_date,
 				txt_create_user_id,
 				txt_modify_date,
 				txt_modify_user_id,
 				txt_duration_date,
 				txt_modify_reason,
 				txt_check_data_type,
 				txt_dept_gubun,
 				txt_delyn,
 				txt_packing_process_yn);
		}
		parent.$('#modalReport_nd').hide();
	}
	

	
</script>	
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>공정구분</th>
		     <th style='width:0px; display: none;'>공정구분개정번호</th>
		     <th style='width:0px; display: none;'>대분류코드</th>
		     <th style='width:0px; display: none;'>중분류코드</th>
		     <th>공정코드</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     <th>공정명</th>
		     <th style='width:0px; display: none;'>순서</th>
		     <th style='width:0px; display: none;'>공정seq</th>
		     <th>비고</th>
		     <th style='width:0px; display: none;'>시작일자</th>
		     <th style='width:0px; display: none;'>생성일자</th>
		     <th style='width:0px; display: none;'>생성자</th>
		     <th style='width:0px; display: none;'>수정일자</th>
		     <th style='width:0px; display: none;'>수정자</th>
		     <th style='width:0px; display: none;'>지속기간</th>
		     <th style='width:0px; display: none;'>수정사유</th>
		     <th style='width:0px; display: none;'>체크데이터유형</th>
		     <th style='width:0px; display: none;'>부서구분</th>
		     <th style='width:0px; display: none;'>지연여부</th>
		     <th>생산공정여부</th>
		     <th>포장공정여부</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th> 
<!-- 		     <th></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<div id="UserList_pager" class="text-center">
</div> 