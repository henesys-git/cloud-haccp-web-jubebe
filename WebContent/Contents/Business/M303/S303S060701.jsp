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
	Vector tIncongVector = CommonData.getDelayReasonDataAll(member_key);
	
	String  GV_JSPPAGE="",GV_NUM_GUBUN="",
			GV_ORDER_NO="",GV_LOTNO="",
			GV_PROD_CD="", GV_PROD_CD_REV="",
			GV_CUST_NAME="",GV_PROD_NM="",
			GV_PRODUCT_PROCESS_YN="",GV_PACKING_PROCESS_YN="",
			GV_LOT_COUNT="",GV_EXPIRATION_DATE="",GV_ORDERDETAIL="";

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
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
	
	if(request.getParameter("product_process_yn")== null) 
		GV_PRODUCT_PROCESS_YN="";
	else 
		GV_PRODUCT_PROCESS_YN = request.getParameter("product_process_yn");
	
	if(request.getParameter("packing_process_yn")== null) 
		GV_PACKING_PROCESS_YN="";
	else 
		GV_PACKING_PROCESS_YN = request.getParameter("packing_process_yn");
	
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
	
	String GV_PROC_CD="";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
	
// 	DoyosaeTableModel TableModel2 = new DoyosaeTableModel("M303S060700E004", jArray);
// 	int count = Integer.parseInt(TableModel2.getValueAt(0, 0).toString().trim());
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M303S060700E101 = {
			PID:  "M303S060700E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M303S060700E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    $(document).ready(function () {
    	
<%--     	if(<%=count%> > 3) { --%>
//     		alert("3개 이상 등록되어 등록이 불가합니다.");
//     		parent.$("#ReportNote").children().remove();
//      		parent.$('#modalReport').hide();
//     	}
    	
    	$("#txt_start_dt").daterangepicker({
        	singleDatePicker: true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: "YYYY-MM-DD HH:mm:ss"
        	}
        });
        $('#txt_finish_dt').daterangepicker({
        	singleDatePicker:true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: 'YYYY-MM-DD HH:mm:ss'
        	}
        });
        var today = new Date();
        today.setHours(9,0,0);
        $('#txt_start_dt').data('daterangepicker').setStartDate(today);
        today.setHours(17,0,0);
        $('#txt_finish_dt').data('daterangepicker').setStartDate(today);
    	
    	$("#txt_order_no").val("<%=GV_ORDER_NO%>");
    	$("#txt_order_detail_seq").val("<%=GV_ORDERDETAIL%>");
    	$("#txt_lotno").val("<%=GV_LOTNO%>");
    	$("#txt_cust_nm").val("<%=GV_CUST_NAME%>");
    	$("#txt_product_nm").val("<%=GV_PROD_NM%>");
    	$("#txt_prod_cd").val("<%=GV_PROD_CD%>");
    	$("#txt_prod_cd_rev").val("<%=GV_PROD_CD_REV%>");
    	$("#txt_lot_count").val("<%=GV_LOT_COUNT%>");
    	$("#txt_expiration_date").val("<%=GV_EXPIRATION_DATE%>");
<%--     	$("#txt_prod_return_cnt").val("<%=GV_PROD_RETURN_CNT%>"); --%>
		
		
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
	 
	 	
    });
    
	function add_txt(obj){
   	 var io_cnt = $("#txt_package_count").val() + $(obj).text();
   	 $("#txt_package_count").val(io_cnt)
   } 

	function clear_txt(obj){
   	 var io_cnt = $("#txt_package_count").val();
   	 var io_length = io_cnt.length;
   	 $("#txt_package_count").val(io_cnt.substr(0,io_length-1));
   } 
    
	function SaveOderInfo() {
// 		var prod_return_cnt = $("#txt_prod_return_cnt").val();
// 		if(prod_return_cnt<1) {
// 			alert("실적등록할 제품이 없습니다.");
// 			return false;
// 		}

		if($("#txt_package_count").val() < 1){
			alert("포장개수를 입력하여 주세요.");
			return false;
		}
		
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)	return;

		var contents_str = document.getElementById("txt_exec_note").value;
        contents_str = contents_str.replace(/(?:\r\n|\r|\n)/g, '<br/>');
		

		//JSON 변환부		
        var dataJsonHead = new Object(); // JSON Object 선언
        //dataJsonHead
		dataJsonHead.jsp_page			= '<%=GV_JSPPAGE%>';
		dataJsonHead.user_id 			= '<%=loginID%>';
		dataJsonHead.prefix 			= '<%=GV_NUM_GUBUN%>';
		dataJsonHead.order_detail_seq 	= '<%=GV_ORDERDETAIL%>';
		dataJsonHead.member_key = "<%=member_key%>";
		
		var jArray = new Array(); // JSON Array 선언
		var dataJson = new Object(); // BOM Data용
		
		dataJson.order_no 			= $("#txt_order_no").val();
		dataJson.order_detail_seq 	= $("#txt_order_detail_seq").val();
		dataJson.lotno 				= $("#txt_lotno").val();
		dataJson.prod_cd 			= $("#txt_prod_cd").val();
		dataJson.prod_cd_rev 		= $("#txt_prod_cd_rev").val();
		dataJson.package_no 		= ''; 								// package_no : 채번
		dataJson.start_dt 			= $("#txt_start_dt").val(); 		// start_dt
		dataJson.finish_dt 			= $("#txt_finish_dt").val();
		
		dataJson.package_count 		= $("#txt_package_count").val();
		
		dataJson.exec_note          = contents_str;	
		dataJson.member_key = "<%=member_key%>";
		
		jArray.push(dataJson); 
		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		
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

<div style="width: 100%"> 
	<div style="width: 450px;float: left; vertical-align: top; margin-left:30px;">		
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
			            	<input type="text" class="form-control" id="txt_package_count" numberPoint/>
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
			            	<textarea class="form-control" id="txt_exec_note"  style="cols:10;rows:4;resize:none;" ></textarea>
			            </td>
			        </tr>
	        	</table>
	        </td>
			</tr>
	        <tr style="height: 60px">
	            <td align="center" colspan="2">
	                <p>
	                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
	                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
	                </p>
	            </td>
	        </tr>
	    </table>
	</div>
	<div style="width: 330px;float: left; vertical-align: top; margin-left:30px;">
			<div style="width:330px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_1"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px; " onclick="add_txt(this)" >1</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_2"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >2</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_3"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >3</button>
				</div>
			</div>
			<div style="width:330px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_4"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >4</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_5"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >5</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_6"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">6</button>
				</div>
			</div>
			<div style="width:330px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_7"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">7</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_1"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">8</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_8"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">9</button>
				</div>
			</div>
			<div style="width:330px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_11"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="clear_txt(this)"><=</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_10"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">0</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_12"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">.</button>
				</div>
			</div>
		</div>
</div>


