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
/* 
배차등록(S858S020102).jsp
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String  GV_BAECHA_NO="", GV_BAECHA_SEQ="",  GV_BAECHA_START_DT="", GV_BAECHA_END_DT="",
			GV_VEHICLE_CD="", GV_VEHICLE_CD_REV="", GV_VEHICLE_NM="", GV_DRIVER="", GV_BIGO="";
	
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
			PID:  "M858S020100E103",
			excute: "queryProcess",
			stream: "N",
			param: ""
	};

	var vTableS858S020130;
    var S858S020130_Row_index = -1;
	var TableS858S020130_info;
    var TableS858S020130_RowCount = 0;

    $(document).ready(function () {
        
        $('#txt_baecha_no').val("<%=GV_BAECHA_NO%>");
        $('#txt_baecha_seq').val("<%=GV_BAECHA_SEQ%>");
        $('#txt_baecha_start_dt').val("<%=GV_BAECHA_START_DT%>");
        $('#txt_baecha_end_dt').val("<%=GV_BAECHA_END_DT%>");
        $('#txt_vehicle_cd').val("<%=GV_VEHICLE_CD%>");
        $('#txt_vehicle_cd_rev').val("<%=GV_VEHICLE_CD_REV%>");
        $('#txt_vehicle_nm').val("<%=GV_VEHICLE_NM%>");
        $('#txt_driver').val("<%=GV_DRIVER%>");
        $('#txt_bigo').val("<%=GV_BIGO%>");
        
        call_S858S020130();
        
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
    });	

    function call_S858S020130(){
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S020130.jsp", 
	        data: "caller=" + "S858S020103" + "&baecha_no=" + "<%=GV_BAECHA_NO%>",
	        beforeSend: function () {
	            $("#inspect_result_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_result_body").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});
    }
    
    
	function SaveOderInfo() {   
		TableS858S020130_info = vTableS858S020130.page.info();
        TableS858S020130_RowCount = TableS858S020130_info.recordsTotal;
        
//         if(TableS858S020130_RowCount==0) {
//         	alert("공정을 하나이상 등록하세요");
// 			return false;
//         }
//         if($('#txt_vehicle_cd').val()== '' ) { 
//         	alert("차량번호를 입력하세요");
//    			return false;
//    		}
        
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.login_id =  '<%=loginID%>'; 
        dataJsonHead.detail_seq = '1';
        dataJsonHead.member_key = "<%=member_key%>";
        
        dataJsonHead.baecha_no 		= $('#txt_baecha_no').val();
        dataJsonHead.baecha_seq 	= $('#txt_baecha_seq').val();
        dataJsonHead.baecha_start_dt = $('#txt_baecha_start_dt').val();   
    	dataJsonHead.baecha_end_dt 	= $('#txt_baecha_end_dt').val();
    	dataJsonHead.vehicle_cd 	= $('#txt_vehicle_cd').val();
    	dataJsonHead.vehicle_cd_rev = $('#txt_vehicle_cd_rev').val();
    	dataJsonHead.vehicle_nm 	= $('#txt_vehicle_nm').val();
    	dataJsonHead.driver 		= $('#txt_driver').val();
    	dataJsonHead.bigo 			= $('#txt_bigo').val();
			
        var jArray = new Array(); // JSON Array 선언
		
	    for(var i=0; i<TableS858S020130_RowCount; i++){
	    	var dataJson = new Object(); // BOM Data용
	    	dataJson.baecha_no 		= $('#txt_baecha_no').val();
	    	dataJson.baecha_seq     = $('#txt_baecha_seq').val();
	    	dataJson.vehicle_cd 	= $('#txt_vehicle_cd').val();
	    	dataJson.vehicle_cd_rev = $('#txt_vehicle_cd_rev').val();
	    	dataJson.order_no    	= vTableS858S020130.cell(i, 1).data();
	    	dataJson.lotno       	= vTableS858S020130.cell(i, 2).data();
	    	dataJson.order_detail_seq = vTableS858S020130.cell(i, 11).data();
	    	dataJson.chulha_no = vTableS858S020130.cell(i, 12).data();
	    	dataJson.chulha_seq = vTableS858S020130.cell(i, 13).data();
	    	dataJson.member_key = "<%=member_key%>";	    	
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
 		console.log(JSONparam);
		var chekrtn = confirm("삭제하시겠습니까?"); 
		
		if(chekrtn){
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
			//alert(bomdata);
			},
			success: function (html) {	
				if(html>-1){
					fn_MainInfo_List();
					parent.$("#ReportNote").children().remove();
					parent.$('#modalReport').hide();
				}
			},
			error: function (xhr, option, error) {
			}
	     });	
	}       
    
    </script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right">배차차량번호</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="hidden" class="form-control" id="txt_baecha_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_baecha_seq" readonly value="0"></input>
				<input type="hidden" class="form-control" id="txt_vehicle_cd_rev" readonly></input>
				<input type="text" class="form-control" id="txt_vehicle_cd" readonly></input>
			</td>
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right">배차차량명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_vehicle_nm" readonly></input>
			</td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right" colspan="1">배송기사</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="1">
            	<input type="text" class="form-control" id="txt_driver" readonly></input>
            </td>
		</tr>
		<tr  style="background-color: #fff; ">
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right" colspan="1">배차시작예정일</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="1">
            	<input type="text" class="form-control" id="txt_baecha_start_dt" readonly></input>
            </td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right">배차완료예정일</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_baecha_end_dt" readonly></input>
			</td>
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right" rowspan="2">비고</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" rowspan="2">
            	<input type="text" class="form-control" id="txt_bigo" readonly></input>
			</td>
        </tr>        
	</table>
	
	<div style="width:100%; text-align:center;clear:both" >
		<div id="inspect_result_body" style="width:100%; float:left"></div>
	</div>
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">삭제</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>