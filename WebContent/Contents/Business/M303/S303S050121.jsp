<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"PRDINSP"+"|");
	
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

	Vector optCode =  null;
	Vector optName =  null;
	Vector tIncongVector = CommonData.getProductCheckGubun_Code();
	
	String  GV_JSPPAGE="",GV_NUM_GUBUN="",
			GV_ORDER_NO="", GV_ORDER_DETAIL_SEQ="", 
// 			GV_PROC_PLAN_NO="", GV_PROC_INFO_NO="",GV_PROC_ODR="", GV_PRODUCT_SERIAL_NO="",
			GV_LOTNO=""	;

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	GV_JSPPAGE = JSPpage;
	GV_NUM_GUBUN = GV_GET_NUM_PREFIX;
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	if(request.getParameter("order_no")== null) GV_ORDER_NO="";
	else GV_ORDER_NO = request.getParameter("order_no");

	if(request.getParameter("order_detail_seq")== null) GV_ORDER_DETAIL_SEQ="";
	else GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
// 	if(request.getParameter("proc_plan_no")== null) GV_PROC_PLAN_NO="";
// 	else GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");
	
// 	if(request.getParameter("proc_info_no")== null) GV_PROC_INFO_NO="";
// 	else GV_PROC_INFO_NO = request.getParameter("proc_info_no");
	
// 	if(request.getParameter("proc_odr")== null) GV_PROC_ODR="";
// 	else GV_PROC_ODR = request.getParameter("proc_odr");
	
	if(request.getParameter("lotno")== null) GV_LOTNO="";
	else GV_LOTNO = request.getParameter("lotno");
	
// 	if(request.getParameter("product_serial_no")== null) GV_PRODUCT_SERIAL_NO="";
// 	else GV_PRODUCT_SERIAL_NO = request.getParameter("product_serial_no");
	
	DoyosaeTableModel TableModel;
	
	String[] strColumnHead 	= { "order_no","order_detail_seq","proc_plan_no", "proc_info_no", "proc_odr",
								"proc_cd","proc_qnt","man_amt","inspect_yn","inspect_request_yn",
								"start_dt","end_dt","proc_cd_rev","project_name","cust_nm",
								"cust_cd","cust_rev","product_nm","prod_cd","prod_rev",
								"product_serial_no","lotno","process_nm","order_count","delivery_date",
								"inspect_req_no","req_seq" };
	
	String param = GV_ORDER_NO + "|" 
// 				 + GV_ORDER_DETAIL_SEQ + "|" + GV_PROC_PLAN_NO + "|" + GV_PROC_INFO_NO + "|" + GV_PROC_ODR + "|" 
				 + GV_LOTNO + "|" 
// 				 + GV_PRODUCT_SERIAL_NO + "|" 
		 		 + member_key + "|"
				 ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);	
	
// 	TableModel = new DoyosaeTableModel("M303S050100E144", strColumnHead, param);
	TableModel = new DoyosaeTableModel("M303S050100E125", strColumnHead, jArray);
	
	
	String[] strColumnHead_Process_Status 	= { "Head_STUS103_Count" };
	
	String param_Process_Status = GV_ORDER_NO + "|" + GV_LOTNO + "|" ;
	
	DoyosaeTableModel TableModel_Process_Status = new DoyosaeTableModel("M303S050100E126", strColumnHead_Process_Status, param_Process_Status);
	
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M303S050100E121 = {
			PID:  "M303S050100E121", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M303S050100E121", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    $(document).ready(function () {
    	var processStatusCount = "<%=TableModel_Process_Status.getValueAt(0,0).toString().trim()%>"
    	if(processStatusCount < 1) {
    		alert("모든 제품이 생산완료 상태일 때만 제품검사요청 가능합니다.");
    		parent.$("#ReportNote").children().remove();
     		parent.$('#modalReport').hide();
    		return false;
    	}
    	
    	$('#txt_inspect_desire_date').datepicker({
    		format: 'yyyy-mm-dd',
    		autoclose: true,
    		language: 'ko'
    	});
    	var today = new Date();
    	$('#txt_inspect_desire_date').datepicker('update', today);
    	
        $("#txt_order_no").val("<%=GV_ORDER_NO%>");
        $("#txt_order_detail_seq").val("<%=GV_ORDER_DETAIL_SEQ%>");
<%--         $("#txt_inspect_gubun").val("<%=GV_PROC_PLAN_NO%>"); // 입력받기(콤보박스) --%>
        $("#txt_inspect_req_no").val("<%=TableModel.getValueAt(0,25).toString().trim()%>"); // 채번(없으면)
<%--         $("#txt_proc_info_no").val("<%=GV_PROC_INFO_NO%>"); --%>
        $("#txt_proc_info_no").val("<%=TableModel.getValueAt(0,3).toString().trim()%>");
        $("#txt_proc_cd").val("<%=TableModel.getValueAt(0,5).toString().trim()%>");
        $("#txt_proc_cd_rev").val("<%=TableModel.getValueAt(0,12).toString().trim()%>");
<%--         $("#txt_request_date").val("<%=GV_PROC_PLAN_NO%>"); // SYSDATE --%>
<%--         $("#txt_inspect_desire_date").val("<%=GV_PROC_PLAN_NO%>"); // 입력받기(날짜) --%>
        $("#txt_req_seq").val("<%=TableModel.getValueAt(0,26).toString().trim()%>"); // Max(req_seq) + 1(없으면)
        $("#txt_prod_cd").val("<%=TableModel.getValueAt(0,18).toString().trim()%>");
        $("#txt_prod_cd_rev").val("<%=TableModel.getValueAt(0,19).toString().trim()%>");
        $("#txt_lot_no").val("<%=TableModel.getValueAt(0,21).toString().trim()%>");
        $("#txt_order_count").val("<%=TableModel.getValueAt(0,23).toString().trim()%>");
        $("#txt_delivery_date").val("<%=TableModel.getValueAt(0,24).toString().trim()%>");
<%--         $("#txt_bigo").val("<%=GV_PROC_PLAN_NO%>"); // 입력받기(textarea) --%>
        
    });
	

	function SaveOderInfo() {
		var parmHead= "" 
			+ '<%=GV_JSPPAGE%>'			+ "|"
			+ '<%=loginID%>' 			+ "|" 
			+ '<%=GV_NUM_GUBUN%>' 		+ "|" 
			+ '<%=GV_ORDER_DETAIL_SEQ%>'+ "|" 
			+ '<%=member_key%>'			+ "|" 
			+ "<%=Config.HEADTOKEN %>";
		
		var parmBody = $("#txt_order_no").val() 			+ "|"
				     + $("#txt_order_detail_seq").val() 	+ "|"
				     + $("#txt_inspect_gubun").val() 		+ "|"
				     + $("#txt_inspect_req_no").val()  		+ "|" // inspect_req_no : 없으면 채번
				     + $("#txt_proc_info_no").val() 		+ "|"
				     + $("#txt_proc_cd").val() 				+ "|"
				     + $("#txt_proc_cd_rev").val() 			+ "|"
				     + ''									+ "|" // request_date : sysdate
				     + $("#txt_inspect_desire_date").val()  + "|"
				     + $("#txt_req_seq").val()				+ "|" // req_seq : db에서 조회후 max+1
				     + $("#txt_prod_cd").val() 				+ "|"
				     + $("#txt_prod_cd_rev").val() 			+ "|"
				     + $("#txt_lot_no").val() 				+ "|"
				     + $("#txt_order_count").val() 			+ "|"
				     + $("#txt_delivery_date").val() 		+ "|"
				     + $("#txt_bigo").val() 				+ "|"
				     + '<%=GV_LOTNO%>'						+ "|"
<%-- 				     + '<%=TableModel.getValueAt(0,20).toString().trim()%>'	+ "|" // product_serial_no --%>
				     + '<%=member_key%>' 					+ "|" 
				     + '<%=Config.DATATOKEN %>';
					 
		SQL_Param.param = parmHead + parmBody ;

		SendTojsp(urlencode(SQL_Param.param),SQL_Param.PID);
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
				//alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.SubInfo_inspect_request.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
    
    </script>

   <table class="table " style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 100%;">
   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
		            <td style="width: 15%%; font-weight: 900; font-size:14px; text-align:left">주문번호</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_order_no" readonly/>
						<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly/>
						<input type="hidden" class="form-control" id="txt_inspect_req_no" readonly/>
						<input type="hidden" class="form-control" id="txt_proc_info_no" readonly/>
						<input type="hidden" class="form-control" id="txt_proc_cd_rev" readonly/>
						<input type="hidden" class="form-control" id="txt_request_date" readonly/>
						<input type="hidden" class="form-control" id="txt_req_seq" readonly/>
						<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly/>
		           	</td>
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:left">공정코드</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_proc_cd" readonly/>
		           	</td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">제품코드</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_prod_cd" readonly/>
		            </td>
		            
		            <td style=" font-weight: 900; font-size:14px; text-align:left">LOT No</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_lot_no" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문수량</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_order_count" readonly/>
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">납품일</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_delivery_date" readonly/>
		            </td>
		        </tr>
				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">검사구분</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<select class="form-control" id="txt_inspect_gubun">
						<%
							optCode = (Vector) tIncongVector.get(0);
							optName = (Vector) tIncongVector.get(1);
	
							for (int i = 0; i < optName.size(); i++) {
						%>
							<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
						<%
							}
						%>
						</select>
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">검사희망일</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_inspect_desire_date" />
		            </td>
		        </tr>
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left">비고</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">
		            	<textarea class="form-control" id="txt_bigo"  style="cols:10;rows:4;resize:none;" ></textarea>
		            </td>
		        </tr>
        	</table>
        </td>
		</tr>
        <tr style="height: 60px">
            <td align="center" colspan="2">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">입력</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>
