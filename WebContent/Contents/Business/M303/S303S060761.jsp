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
			GV_PROD_CD="", GV_PROD_CD_REV="",GV_PACKAGE_NO=""
			;

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

	if(request.getParameter("package_no")== null) 
		GV_PACKAGE_NO="";
	else 
		GV_PACKAGE_NO = request.getParameter("package_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "package_no", GV_PACKAGE_NO);
	jArray.put( "member_key", member_key);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S060700E704", jArray);
	DoyosaeTableModel TableModel2 = new DoyosaeTableModel("M303S060700E765", jArray);
	
	int count = Integer.parseInt(TableModel2.getValueAt(0, 0).toString().trim());

%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M303S060700E761 = {
			PID:  "M303S060700E761", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M303S060700E761", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    $(document).ready(function () {
    	
    	// 한 공정 실적당 4개 이상 등록되면 등록 불가능한 alert
    	
<%--     	if(<%=count%> == 4) { --%>
//     		alert("4개 이상 등록되어 등록이 불가합니다.");
//     		parent.$("#ReportNote").children().remove();
//       		parent.$('#modalReport').hide();
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
        
        $('#txt_package_checktime').daterangepicker({
        	singleDatePicker:true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: 'HH:mm'
        	}
        });
        
        $("#txt_inbox_expiration_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        
        $("#txt_outbox_expiration_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        
        var today = new Date();
        var today2 = new Date();
        today2.setDate(today.getDate()+90);
        
        
    	$("#txt_cust_nm").val('<%=TableModel.getValueAt(0,1).toString().trim()%>');
    	$("#txt_lot_count").val('<%=TableModel.getValueAt(0,3).toString().trim()%>');
        $('#txt_start_dt').data('daterangepicker').setStartDate('<%=TableModel.getValueAt(0,4).toString().trim()%>');
        $('#txt_finish_dt').data('daterangepicker').setStartDate('<%=TableModel.getValueAt(0,5).toString().trim()%>');
        $('#txt_package_count').val('<%=TableModel.getValueAt(0,6).toString().trim()%>');
        $("#txt_inbox_barcode_no").val('<%=TableModel.getValueAt(0,7).toString().trim()%>');
        $("#txt_outbox_barcode_no").val('<%=TableModel.getValueAt(0,7).toString().trim()%>');
        
        $('#txt_package_checktime').data('daterangepicker').setStartDate(today);
        $('#txt_inbox_expiration_date').datepicker('update', today2);
        $('#txt_outbox_expiration_date').datepicker('update', today2);
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
    });
    
    

	function SaveOderInfo() {
		
		
		
		
		var dataJson = new Object();

		dataJson.jsp_page 				= '<%=GV_JSPPAGE%>'; 
		dataJson.user_id 				= '<%=loginID%>';
		
		dataJson.order_no 				= '<%=GV_ORDER_NO%>';
		dataJson.lotno 					= '<%=GV_LOTNO%>';
		dataJson.prod_cd 				= '<%=GV_PROD_CD%>';
		dataJson.prod_cd_rev 			= '<%=GV_PROD_CD_REV%>';
		dataJson.package_no 			= '<%=GV_PACKAGE_NO%>';
		dataJson.package_checktime		= $("#txt_package_checktime").val();
		dataJson.package_weight		 	= $("#txt_package_weight").val();
		dataJson.inbox_barcode_no 		= $("#txt_inbox_barcode_no").val();
		dataJson.inbox_expiration_date 	= $("#txt_inbox_expiration_date").val();
		dataJson.outbox_barcode_no 		= $("#txt_outbox_barcode_no").val();
		dataJson.writor_main_rev 		= $("#txt_writor_main_rev").val();
		dataJson.outbox_expiration_date = $('#txt_outbox_expiration_date').val();
		dataJson.member_key 			= "<%=member_key%>";
		
		var JSONparam = JSON.stringify(dataJson);
		
// 		console.log(JSONparam);
		
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn){
			SendTojsp(JSONparam, SQL_Param.PID);		
		}
			
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

<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        <tr style="background-color: #fff; ">
            <td>출고처</td>
            <td>
            	<input type="text"   class="form-control" id="txt_cust_nm" style="float:left; width: 100%; height:100%; margin-right:10px;"  readonly/>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; ">
            <td>주문 수량</td>
            <td>
            	<input type="text" class="form-control" id="txt_lot_count"  style="float:left; width: 100%; height:100%; margin-right:10px;" readonly />
           	</td>
        </tr>
         
        <tr style="background-color: #fff; height: 50px">
            <td>포장 시간</td>
            <td style='width:60%; height:26px; vertical-align: middle; text-align:left; '>
		        <input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_start_dt' style="float:left; width: 80%; height:50%; border: solid 1px #cccccc; " readonly/>  
            	<p style="margin-left: 5px; padding-bottom:5px; width:5px; height:8px;">~</p>
		        <input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_finish_dt' style="float:right; width: 80%; height:50%; border: solid 1px #cccccc; " readonly/>  
           	</td>
<!--             <td style='width:10%; height:26px; vertical-align: middle; text-align:left;'> -->
<!--            	</td> -->
        </tr>
        
        <tr style="background-color: #fff; ">
            <td>포장수량</td>
            <td style='width:5%; height:26px; vertical-align: middle; text-align:left; '>
            	<input type="hidden" class="form-control" id="txt_package_no" style="float:left; width: 100%; height:100%; margin-right:10px;"  readonly/>
                <input type="text" class="form-control"   id="txt_package_count"  style="float:left; width: 100%; height:100%; margin-right:10px;" readonly />
            </td>
        </tr>

        <tr style="background-color: #fff; ">
            <td>포장상태 확인 시간</td>
           	<td style='width:5%; height:26px; vertical-align: middle; text-align:left; '>
                <input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_package_checktime' style="width: 100%; height:100%; border: solid 1px #cccccc; " />
            </td>
        </tr>
        
        <tr style="background-color: #fff; ">
            <td>제품 중량</td>
            <td>
            	<input type="text" class="form-control" id="txt_package_weight" style="width: 100%; height:100%;"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; ">
            <td>스티커(or 따지) 바코드</td>
            <td>
            	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_inbox_barcode_no' style="width: 100%; height:100%; border: solid 1px #cccccc; " />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; ">
            <td>내박스(RRP) 유통기한</td>
            <td>
            	<input type="text" class="form-control" id="txt_inbox_expiration_date" style="width: 100%; height:100%"  />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; ">
            <td>외박스 바코드</td>
            <td>
            	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_outbox_barcode_no'
            	style="width: 100%; height:100%; border: solid 1px #cccccc; " />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; ">
            <td>외박스 유통기한</td>
            <td>
            	<input type="text" class="form-control" id="txt_outbox_expiration_date" style="width: 100%; height:100%"  />
           	</td>
        </tr>
        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>
