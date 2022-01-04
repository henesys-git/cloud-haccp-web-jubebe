<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	
	
	String  GV_ORDER_NO="",GV_LOTNO="", GV_PROD_CD="", GV_PROD_CD_REV="",
			GV_PROC_CD="",GV_MEMBER_KEY="",
			GV_PRODUCT_PROCESS_YN="",GV_PACKING_PROCESS_YN="" ;

	if(request.getParameter("order_no")== null) 
		GV_ORDER_NO="";
	else 
		GV_ORDER_NO = request.getParameter("order_no");
	
	if(request.getParameter("lotno")== null) 
		GV_LOTNO="";
	else 
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("proc_cd")== null) 
		GV_PROC_CD="";
	else 
		GV_PROC_CD = request.getParameter("proc_cd");
	
	if(request.getParameter("product_process_yn")== null) 
		GV_PRODUCT_PROCESS_YN="";
	else 
		GV_PRODUCT_PROCESS_YN = request.getParameter("product_process_yn");
	
	if(request.getParameter("packing_process_yn")== null) 
		GV_PACKING_PROCESS_YN="";
	else 
		GV_PACKING_PROCESS_YN = request.getParameter("packing_process_yn");
	
	if(request.getParameter("member_key")== null) 
		GV_MEMBER_KEY="";
	else 
		GV_MEMBER_KEY = request.getParameter("member_key");
	
// 	GV_PROC_CD = "P000002"; 	// SMT 공정코드 : P000002
// 	GV_PROD_RETURN_CNT = "0";  // 공정완료 제품개수 : 추후 카메라서버에서 넘겨받은 값 읽어오는 걸로 변경
	
	DoyosaeTableModel TableModel;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "proc_cd", GV_PROC_CD);
	jArray.put( "product_process_yn", GV_PRODUCT_PROCESS_YN);
	jArray.put( "packing_process_yn", GV_PACKING_PROCESS_YN);
	jArray.put( "member_key", GV_MEMBER_KEY);	
	
	TableModel = new DoyosaeTableModel("M303S060700E124", jArray);
 	int RowCount =TableModel.getRowCount();	
    
//     String zhtml = "";
//     if(RowCount>0) {
//     	zhtml += TableModel.getValueAt(0,0).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,1).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,2).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,3).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,4).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,5).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,6).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,7).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,8).toString().trim() + "|"
//     		   + TableModel.getValueAt(0,9).toString().trim() + "|"
// 			   + TableModel.getValueAt(0,10).toString().trim() + "|"
// 			   + TableModel.getValueAt(0,11).toString().trim() + "|" ;
//     }
    
    MakeGridData makeGridData;
	makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_work_start(this)", "생산시작"},{"off", "fn_work_complete(this)", "공정완료"}};
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS303S050140";
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
	
%>
<script>
    $(document).ready(function () {
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: true,
    		scrollY: 480,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 4, "asc" ]],
    	    info: true,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		},    
   	  		'columnDefs': [
				{
					// 제외할 컬럼 숫자 적기(0부터)
					'targets': [0,1,2,3,6],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [12],
		   			'createdCell':  function (td) {
		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
						}
		   		}
			], 
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }

		});
    });

   	function <%=makeGridData.htmlTable_ID%>Event(obj){
       	var tr = $(obj);
   		var td = tr.children();
   		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
   		
   		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
   		$(obj).attr("class", "hene-bg-color");
   		
   	 	$('#txt_proc_plan_no').val(td.eq(2).text().trim());
    	$('#txt_proc_info_no').val(td.eq(3).text().trim());
    	$('#txt_proc_odr').val(td.eq(4).text().trim());
     	$('#txt_proc_cd').val(td.eq(5).text().trim());
 		$('#txt_proc_cd_rev').val(td.eq(6).text().trim());
 		$('#txt_process_nm').val(td.eq(7).text().trim());
 		$('#txt_exec_qnt_plan').val(td.eq(8).text().trim());
 		$('#txt_man_amt').val(td.eq(9).text().trim());
// 	    $('#txt_start_dt').val(td.eq(10).text().trim());
// 	    $('#txt_finish_dt').val(td.eq(11).text().trim());
	    $('#txt_start_dt').data('daterangepicker').setStartDate(td.eq(10).text().trim());
		$('#txt_start_dt').data('daterangepicker').setEndDate(td.eq(10).text().trim());
        $('#txt_finish_dt').data('daterangepicker').setStartDate(td.eq(11).text().trim());
        $('#txt_finish_dt').data('daterangepicker').setEndDate(td.eq(11).text().trim());
	    
	    fn_delay_qnt_check();
    }
    
</script>

<%-- <%=zhtml%> --%>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>lot번호</th>
		     <th style='width:0px; display: none;'>생산계획번호</th>
		     <th style='width:0px; display: none;'>proc_info_no</th>
		     <th>생산공정순서</th>
		     
		     <th>공정코드</th>
		     <th style='width:0px; display: none;'>proc_cd_rev</th>
		     <th>공정명</th>
		     <th>표준공수(시간)</th>
		     <th>필요인원</th>
		     
		     <th>공정시작예정일</th>
		     <th>공정완료예정일</th>
		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>