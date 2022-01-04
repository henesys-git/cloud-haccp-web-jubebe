<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_ORDERNO = "", GV_ORDER_DETAIL_SEQ = "",
		   GV_CUST_NM = "", GV_PROJECT_NAME = "", GV_PRODUCT_NM = "", GV_LOTNO = "";
	
	if(request.getParameter("OrderNo") == null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("OrderDetailSeq") == null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailSeq");
	
	if(request.getParameter("cust_nm") == null)
		GV_CUST_NM = "";
	else
		GV_CUST_NM = request.getParameter("cust_nm");	
	
	if(request.getParameter("project_name") == null)
		GV_PROJECT_NAME="";
	else
		GV_PROJECT_NAME = request.getParameter("project_name");
	
	if(request.getParameter("product_nm") == null)
		GV_PRODUCT_NM = "";
	else
		GV_PRODUCT_NM = request.getParameter("product_nm");	
	
	if(request.getParameter("LotNo") == null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
%>
    
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M303S010100E103 = {
			PID:  "M303S010100E103", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝

    var JOB_GUBUN = "";  

	var vTableS303S010130;
    var S303S010130_Row_index = -1;
	var TableS303S010130_info;
    var TableS303S010130_RowCount;
    
    $(document).ready(function () {
        $("#txt_order_no").val("<%=GV_ORDERNO%>");
        $("#txt_lotno").val("<%=GV_LOTNO%>");
        $("#txt_project_name").val("<%=GV_PROJECT_NAME%>");
        $("#txt_cust_nm").val("<%=GV_CUST_NM%>");
        $("#txt_product_nm").val("<%=GV_PRODUCT_NM%>");

        call_S303S010130();
    });	

    function call_S303S010130(){
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S010130.jsp", 
	        data: "order_no=" +  "<%=GV_ORDERNO%>"  + "&order_detail_seq=" + 
	        	  "<%=GV_ORDER_DETAIL_SEQ%>"+ "&caller=" + "S303S010103" + "&lotno=" + '<%=GV_LOTNO%>', 
	        beforeSend: function () {
	            $("#inspect_result_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_result_body").hide().html(html).fadeIn(100);
	        }
 		});
    }
	
	function SaveOderInfo() {        
		if(S303S010130_Row_index == -1){
    		alert("삭제할 항목을 선택하세요");
    	} else {
			var parmBody = $("#txt_proc_info_no").val()	+ "|"	// 0. proc_info_no 
	    				+ $("#txt_q_proc_seq").val()	+ "|" 	// 1. q_proc_seq
	    				+ $("#txt_order_no").val()		+ "|"	// 2. order_no
						+ $("#txt_lotno").val()			+ "|" 	// 3. order_detail_seq
						+ '<%=member_key%>' 			+ "|" 
						+ '<%=Config.DATATOKEN %>';
	    	
			SQL_Param.params = parmBody;
			
			SendTojsp(urlencode(SQL_Param.params), M303S010100E103.PID);
    	}
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {	
	        	 if(html>-1){
	        		 call_S303S010130();
	        		 parent.fn_DetailInfo_List();
	        		 clear_input();
	         	}
	         }
	     });
	}       
	
	function clear_input(obj){
		$('#txt_process_rev').val("");
		$('#txt_process_name').val("");
		$('#txt_process_cd').val("");
		$('#txt_proc_info_no').val("");
		$('#txt_q_proc_cd_rev').val("");
		$('#txt_q_proc_cd').val("");
		$('#txt_process_nm').val("");
		$('#txt_dept_gubun').val("");
		$('#txt_process_seq').val("");
		$('#txt_inspect_yn').prop("checked",false);
		$('#txt_std_proc_qnt').val("");
		$('#txt_man_amt').val("");
		$('#txt_start_date').val("");
		$('#txt_end_date').val("");
		S303S010130_Row_index = -1;
	}
</script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
            <td style="width: 25%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_order_no" readonly/>
				<input type="hidden" class="form-control" id="txt_lotno" readonly/>
			</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="1">프로젝트 명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
            	<input type="text" class="form-control" id="txt_project_name" readonly/>
            </td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2"></td>
		</tr>
		<tr  style="background-color: #fff; ">
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">고객사</td>
            <td style="width: 25%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_cust_nm" readonly/>
			</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="1">제품명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
            	<input type="text" class="form-control" id="txt_product_nm" readonly/>
            </td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2"></td>
        </tr>        
		<tr  style="background-color: #fff; ">
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" rowspan="2">공정명</td>
            <td style="width: 25%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" rowspan="2">
            	<input type="hidden" class="form-control" id="txt_process_rev" readonly/>
            	<input type="hidden" class="form-control" id="txt_process_cd" readonly/>
            	<input type="text" class="form-control" id="txt_process_name" style="width:65%;float:left;" readonly />
            	<button class="form-control btn btn-info" style="width:35%;float:left;" onclick="pop_fn_Process_View('PDPROCS',1)">생산공정검색</button>
			</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">자주검사여부</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">표준공수</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">필요인원수</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">공정시작예정일</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">공정완료예정일</td>
		</tr>
		<tr  style="background-color: #fff; ">
            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="checkbox" class="" id="txt_inspect_yn" disabled="disabled"/>	           
           	</td>
            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_std_proc_qnt" readonly/>
           	</td>
           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_man_amt" readonly/>
           	</td>
           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_start_date" readonly/>
           	</td>
           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_end_date" readonly/>
           	</td>
		</tr>
	</table>
	<table class="table table-bordered" style="width: 100%; margin: 0 ; align:center ;">
		<tr style="vertical-align: middle; background-color: #f4f4f4;">
			<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">품질공정코드</td>
	        <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">품질공정명</td>
	        <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">관련부서</td>
	        <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">공정순서</td>
		</tr>
		<tr style="vertical-align: middle">
			<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	        	<input type="hidden" class="form-control" id="txt_proc_info_no" readonly/>
	        	<input type="hidden" class="form-control" id="txt_q_proc_cd_rev" readonly/>
	        	<input type="hidden" class="form-control" id="txt_q_proc_seq" readonly/>
	        	<input type="text" class="form-control" id="txt_q_proc_cd" readonly/>
			</td>		           
			<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_process_nm" readonly/> 
           	</td>
        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_dept_gubun" readonly/>
			</td>
            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_process_seq" readonly/>	           
           	</td>
		</tr>
	</table>
	
	<div style="width:100%; text-align:center;clear:both" >
		<div id="inspect_result_body" style="width:100%; float:left"></div>
	</div>	