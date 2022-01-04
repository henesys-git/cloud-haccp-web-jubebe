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
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	Vector optCode =  null;
	Vector optName =  null;
	Vector tIncongVector = CommonData.getDelayReasonData(member_key);
	
	String  GV_ORDER_NO="",GV_LOTNO="",
			GV_PROD_CD="", GV_PROD_CD_REV="",
			GV_CUST_NAME="",GV_PROD_NM="",
			GV_PACKAGE_NO="", GV_EXEC_NOTE="",
			GV_LOT_COUNT="",GV_EXPIRATION_DATE="",GV_ORDERDETAIL="" ;

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
	
	if(request.getParameter("cust_name")== null) 
		GV_CUST_NAME="";
	else 
		GV_CUST_NAME = request.getParameter("cust_name");
	
	if(request.getParameter("prod_nm")== null) 
		GV_PROD_NM="";
	else 
		GV_PROD_NM = request.getParameter("prod_nm");
	
	if(request.getParameter("package_no")== null) 
		GV_PACKAGE_NO="";
	else 
		GV_PACKAGE_NO = request.getParameter("package_no");
	
	if(request.getParameter("lot_count")== null) 
		GV_LOT_COUNT="";
	else 
		GV_LOT_COUNT = request.getParameter("lot_count");
	
	if(request.getParameter("expiration_date")== null) 
		GV_EXPIRATION_DATE="";
	else 
		GV_EXPIRATION_DATE = request.getParameter("expiration_date");
	
	if(request.getParameter("OrderDetail")== null)
		GV_ORDERDETAIL="";
	else
		GV_ORDERDETAIL = request.getParameter("OrderDetail");	
	
	DoyosaeTableModel TableModel;
	
	String[] strColumnHead 	= { "order_no","lotno","proc_exec_no","proc_plan_no","proc_info_no",
								"공정순서","공정코드","proc_cd_rev","공정명","rout_dt",
								"공정시작일","공정완료일","실 투입공수","실 투입인원","공정지연여부",
								"지연시간","delay_reason_cd","지연사유","비고","작업자","공정완료 제품개수","계획투입공수" };
	
// 	String GV_PROC_CD = "P000002"; 	// SMT 공정코드 : P000002
	
// 	String param = GV_ORDER_NO + "|" + GV_LOTNO + "|" + GV_PROC_EXEC_NO + "|" + GV_PROC_CD + "|"  + member_key + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
// 	jArray.put( "proc_cd", GV_PROC_CD);
	jArray.put( "package_no", GV_PACKAGE_NO);
	jArray.put( "exec_note", GV_EXEC_NOTE);	
	jArray.put( "order_detail_seq", GV_ORDERDETAIL);
	jArray.put( "member_key", member_key);	
	
	TableModel = new DoyosaeTableModel("M303S060700E114", jArray);
	
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M303S060700E103 = {
			PID:  "M303S060700E103", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M303S060700E103", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    $(document).ready(function () {
    	var today = new Date();
    	
    	$("#txt_order_no").val("<%=GV_ORDER_NO%>");
    	$("#txt_order_detail_seq").val("<%=GV_ORDERDETAIL%>");
    	$("#txt_lotno").val("<%=GV_LOTNO%>");
    	$("#txt_cust_nm").val("<%=GV_CUST_NAME%>");
    	$("#txt_product_nm").val("<%=GV_PROD_NM%>");
    	$("#txt_prod_cd").val("<%=GV_PROD_CD%>");
    	$("#txt_prod_cd_rev").val("<%=GV_PROD_CD_REV%>");
    	$("#txt_lot_count").val("<%=GV_LOT_COUNT%>");
    	$("#txt_expiration_date").val("<%=GV_EXPIRATION_DATE%>");
    	$('#txt_package_no').val('<%=TableModel.getValueAt(0,2).toString().trim()%>');
   		$('#txt_start_dt').val('<%=TableModel.getValueAt(0,3).toString().trim()%>');
   		$('#txt_finish_dt').val('<%=TableModel.getValueAt(0,4).toString().trim()%>');
        
    	$('#txt_package_count').val('<%=TableModel.getValueAt(0,5).toString().trim()%>');
    	
    	$('#txt_exec_note').val('<%=TableModel.getValueAt(0,6).toString().trim()%>'); 
    	
    	textarea_encoding();
    	
    });
	
    function textarea_encoding(){
	       var str = '<%=TableModel.getValueAt(0,6).toString().trim()%>';
	       var result = str.replace(/(<br>|<br\/>|<br\/>)/g, '\r\n');
	        $('#txt_exec_note').val(result);
	}

	function SaveOderInfo() {

		var work_complete_delete_check = confirm("삭제하시겠습니까?");
		if(work_complete_delete_check == false)	return;
		
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.member_key = "<%=member_key%>";
        
		var jArray = new Array(); // JSON Array 선언
		var dataJson = new Object(); // BOM Data용
		
		dataJson.order_no 			= $("#txt_order_no").val();
		dataJson.order_detail_seq 	= $("#txt_order_detail_seq").val();
		dataJson.lotno 				= $("#txt_lotno").val();
		dataJson.prod_cd 			= $("#txt_prod_cd").val();
		dataJson.prod_cd_rev 		= $("#txt_prod_cd_rev").val();
		dataJson.package_no 		= $("#txt_package_no").val();	
		dataJson.member_key = "<%=member_key%>";
		
		jArray.push(dataJson); 
		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		alert(JSONparam);
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄	

	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.DetailInfo_List.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
    
    </script>

<div style="width: 100%;float: left; vertical-align: top">		
   <table class="table " style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 100%;">
   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">출고처</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_cust_nm" readonly/>
		            	<input type="hidden" class="form-control" id="txt_order_no" readonly/>
		            	<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly/>
		            	<input type="hidden" class="form-control" id="txt_package_no" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">제품명</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_product_nm" readonly/>
		            	<input type="hidden" class="form-control" id="txt_prod_cd" readonly/>
		            	<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		        	<td style=" font-weight: 900; font-size:14px; text-align:left">단위</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_lotno" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문수량</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_lot_count" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">유통기한</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_expiration_date" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">포장수량</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_package_count" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">포장시작일시</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_start_dt" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">포장종료일시</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
		            	<input type="text" class="form-control" id="txt_finish_dt" readonly/>
		            </td>
		        </tr>
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left">비고</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">
		            	<textarea class="form-control" id="txt_exec_note"  style="cols:10;rows:4;resize:none;" readonly></textarea>
		            </td>
		        </tr>
        	</table>
        </td>
		</tr>
        <tr style="height: 60px">
            <td align="center" colspan="2">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>
</div>
