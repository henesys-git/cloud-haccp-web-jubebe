<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	Vector optCode =  null;
	Vector optName =  null;
	Vector tIncongVector = CommonData.getDeptCode(member_key);	

	String  GV_JSPPAGE="", GV_NUM_GUBUN="" ;
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	String  GV_ORDER_NO="", GV_LOTNO="",  GV_ORDER_DETAIL_SEQ="",
			GV_BAECHA_NO="", GV_BAECHA_SEQ="",  GV_BAECHA_START_DT="", GV_BAECHA_END_DT="",
			GV_VEHICLE_CD="", GV_VEHICLE_CD_REV="", GV_VEHICLE_NM="", GV_DRIVER="", GV_BIGO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");	
	
	if(request.getParameter("baecha_no")== null)
		GV_BAECHA_NO="";
	else
		GV_BAECHA_NO = request.getParameter("baecha_no");	
	
	if(request.getParameter("baecha_seq")== null)
		GV_BAECHA_SEQ="";
	else
		GV_BAECHA_SEQ = request.getParameter("baecha_seq");
	
	if(request.getParameter("baecha_start_dt")== null)
		GV_BAECHA_START_DT="";
	else
		GV_BAECHA_START_DT = request.getParameter("baecha_start_dt");	
	
	if(request.getParameter("baecha_end_dt")== null)
		GV_BAECHA_END_DT="";
	else
		GV_BAECHA_END_DT = request.getParameter("baecha_end_dt");	
	
	if(request.getParameter("vehicle_cd")== null)
		GV_VEHICLE_CD="";
	else
		GV_VEHICLE_CD = request.getParameter("vehicle_cd");	
	
	if(request.getParameter("vehicle_cd_rev")== null)
		GV_VEHICLE_CD_REV="";
	else
		GV_VEHICLE_CD_REV = request.getParameter("vehicle_cd_rev");	
	
	if(request.getParameter("vehicle_nm")== null)
		GV_VEHICLE_NM="";
	else
		GV_VEHICLE_NM = request.getParameter("vehicle_nm");	
	
	if(request.getParameter("driver")== null)
		GV_DRIVER="";
	else
		GV_DRIVER = request.getParameter("driver");	
	
	if(request.getParameter("bigo")== null)
		GV_BIGO="";
	else
		GV_BIGO = request.getParameter("bigo");	
%>
    
    <script type="text/javascript">
	var SQL_Param = {
			PID:  "M858S030100E101", 
			excute: "queryProcess",
			stream: "N",
			params: ""
	};

    $(document).ready(function () {
    	$("#txt_transport_start_dt").daterangepicker({
        	singleDatePicker: true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: "YYYY-MM-DD HH:mm:ss"
        	}
        });
        $('#txt_transport_end_dt').daterangepicker({
        	singleDatePicker:true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: 'YYYY-MM-DD HH:mm:ss'
        	}
        });
//         var today = new Date();
//         today.setHours(9,0,0);
//         $('#txt_transport_start_dt').data('daterangepicker').setStartDate(today);
//         $('#txt_transport_end_dt').data('daterangepicker').setStartDate(today);
        
        $('#txt_order_no').val("<%=GV_ORDER_NO%>");
        $('#txt_lotno').val("<%=GV_LOTNO%>");
        $('#txt_order_detail_seq').val("<%=GV_ORDER_DETAIL_SEQ%>");
        $('#txt_baecha_no').val("<%=GV_BAECHA_NO%>");
        $('#txt_baecha_seq').val("<%=GV_BAECHA_SEQ%>");
        $('#txt_transport_start_dt').data('daterangepicker').setStartDate("<%=GV_BAECHA_START_DT%>");
        $('#txt_transport_end_dt').data('daterangepicker').setStartDate("<%=GV_BAECHA_END_DT%>");
        $('#txt_vehicle_cd').val("<%=GV_VEHICLE_CD%>");
        $('#txt_vehicle_cd_rev').val("<%=GV_VEHICLE_CD_REV%>");
        $('#txt_vehicle_nm').val("<%=GV_VEHICLE_NM%>");
        $('#txt_driver').val("<%=GV_DRIVER%>");
        $('#txt_bigo').val("<%=GV_BIGO%>");

     	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
// 	 		$(this).val($(this).val().replace(/^[0-9]*.[0-9]*[1-9]+$/g,""));
	 	});
    });	

	function SetVehicle_code(txt_vehicle_nm, txt_vehicle_cd, txt_vehicle_cd_rev){ //차량검색 완료후 실행
		$('#txt_vehicle_nm').val(txt_vehicle_nm);
		$('#txt_vehicle_cd').val(txt_vehicle_cd);
		$('#txt_vehicle_cd_rev').val(txt_vehicle_cd_rev);
	}
	
	function SaveOderInfo() {        
		
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.jsp_page = '<%=GV_JSPPAGE%>';
        dataJsonHead.login_id =  '<%=loginID%>'; 
        dataJsonHead.prefix = '<%=GV_NUM_GUBUN%>'; 
        dataJsonHead.detail_seq = '';
		
        var jArray = new Array(); // JSON Array 선언
    	var dataJson = new Object();
    	dataJson.order_no 			= $('#txt_order_no').val();
    	dataJson.lotno 				= $('#txt_lotno').val();
    	dataJson.order_detail_seq 	= $('#txt_order_detail_seq').val();
    	dataJson.transport_no 		= $('#txt_transport_no').val();	//transport_no : 채번
    	dataJson.baecha_no 			= $('#txt_baecha_no').val();
    	dataJson.baecha_seq 		= $('#txt_baecha_seq').val();
    	dataJson.transport_start_dt = $('#txt_transport_start_dt').val();
    	dataJson.transport_end_dt	= $('#txt_transport_end_dt').val();
    	dataJson.vehicle_cd 		= $('#txt_vehicle_cd').val();
    	dataJson.vehicle_cd_rev 	= $('#txt_vehicle_cd_rev').val();
    	dataJson.vehicle_nm 		= $('#txt_vehicle_nm').val();
    	dataJson.driver 			= $('#txt_driver').val();				
    	dataJson.bigo 				= $('#txt_bigo').val();
    	dataJson.transport_total 	= $('#txt_transport_total').val();
    	dataJson.transport_distance = $('#txt_transport_distance').val();
    	dataJson.member_key 		= "<%=member_key%>";
		jArray.push(dataJson); 
		
	    var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)

		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
// 			console.log(JSONparam);
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄		
		}
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	         },
	         success: function (html) {	
	        	 if(html>-1){
	        		parent.BaechaInfo_List.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         		alert('등록이 완료되었습니다.');
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}       
    
    </script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">차량번호</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="hidden" class="form-control" id="txt_order_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_lotno" readonly></input>
            	<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly></input>
            	<input type="hidden" class="form-control" id="txt_transport_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_baecha_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_baecha_seq" readonly></input>
            	<input type="text" class="form-control" id="txt_vehicle_cd" style="width:70%;float:left;" ></input>
            	<input type="hidden" class="form-control" id="txt_vehicle_cd_rev" readonly></input>
				<button class="form-control btn btn-info" style="width:30%;float:left;" onclick="pop_fn_Vehicle_View(1)">차량검색</button>
            </td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">차량명칭</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_vehicle_nm" ></input>
            </td>
        </tr>
        <tr style="background-color: #fff; ">
			<td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">운송시작일시</td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_transport_start_dt" readonly></input>
			</td>
			<td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">운송종료일시</td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_transport_end_dt" readonly></input>
			</td>
		</tr>
        <tr style="background-color: #fff; ">
        	<td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주행거리(주행후)</td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_transport_total" numberPoint></input>
			</td>
        	<td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주행거리(운행km)</td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_transport_distance" numberPoint></input>
			</td>
        </tr>
        <tr style="background-color: #fff; ">
        	<td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">배송기사</td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_driver" ></input>
			</td>
			<td colspan="2"></td>
        </tr>
        <tr  style="background-color: #fff; ">
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:left">차량이상유무, 기타비용내역</td>
            <td style="width: 66.66%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:left" colspan="3">
            	<textarea class="form-control" id="txt_bigo" style="cols:10;rows:4;resize:none;"></textarea>
            </td>
        </tr>
	</table>
	
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
	