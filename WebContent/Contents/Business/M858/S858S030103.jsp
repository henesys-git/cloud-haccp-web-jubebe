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

	String  GV_TRANSPORT_NO="", GV_BAECHA_NO="", GV_BAECHA_SEQ="";
	
	if(request.getParameter("transport_no")== null)
		GV_TRANSPORT_NO="";
	else
		GV_TRANSPORT_NO = request.getParameter("transport_no");
	
	if(request.getParameter("baecha_no")== null)
		GV_BAECHA_NO="";
	else
		GV_BAECHA_NO = request.getParameter("baecha_no");	
	
	if(request.getParameter("baecha_seq")== null)
		GV_BAECHA_SEQ="";
	else
		GV_BAECHA_SEQ = request.getParameter("baecha_seq");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "transport_no", GV_TRANSPORT_NO);
	jArray.put( "baecha_no", GV_BAECHA_NO);
	jArray.put( "baecha_seq", GV_BAECHA_SEQ);
	jArray.put( "member_key", member_key);	
	
	DoyosaeTableModel TableModel;
	TableModel = new DoyosaeTableModel("M858S030100E154", jArray);
	int RowCount =TableModel.getRowCount();
%>
    
    <script type="text/javascript">
	var SQL_Param = {
			PID:  "M858S030100E103", 
			excute: "queryProcess",
			stream: "N",
			params: ""
	};

    $(document).ready(function () {
        if(<%=RowCount%>>0){
        	$('#txt_order_no').val("<%=TableModel.getValueAt(0,12).toString().trim()%>");
            $('#txt_lotno').val("<%=TableModel.getValueAt(0,13).toString().trim()%>");
            $('#txt_order_detail_seq').val("<%=TableModel.getValueAt(0,14).toString().trim()%>");
        	$('#txt_transport_no').val("<%=GV_TRANSPORT_NO%>");
        	$('#txt_baecha_no').val("<%=GV_BAECHA_NO%>");
            $('#txt_baecha_seq').val("<%=GV_BAECHA_SEQ%>");
            $('#txt_transport_start_dt').val("<%=TableModel.getValueAt(0,3).toString().trim()%>");
            $('#txt_transport_end_dt').val("<%=TableModel.getValueAt(0,4).toString().trim()%>");
            $('#txt_vehicle_cd').val("<%=TableModel.getValueAt(0,5).toString().trim()%>");
            $('#txt_vehicle_cd_rev').val("<%=TableModel.getValueAt(0,6).toString().trim()%>");
            $('#txt_vehicle_nm').val("<%=TableModel.getValueAt(0,7).toString().trim()%>");
            $('#txt_transport_total').val("<%=TableModel.getValueAt(0,8).toString().trim()%>");
            $('#txt_transport_distance').val("<%=TableModel.getValueAt(0,9).toString().trim()%>");
            $('#txt_driver').val("<%=TableModel.getValueAt(0,10).toString().trim()%>");
            $('#txt_bigo').val("<%=TableModel.getValueAt(0,11).toString().trim()%>");
        }
    });	

	
	function SaveOderInfo() {        
		
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.login_id =  '<%=loginID%>'; 
        dataJsonHead.detail_seq = '';
		
        var jArray = new Array(); // JSON Array 선언
    	var dataJson = new Object();
    	dataJson.transport_no 		= $('#txt_transport_no').val();	
    	dataJson.baecha_no 			= $('#txt_baecha_no').val();
    	dataJson.baecha_seq 		= $('#txt_baecha_seq').val();
    	dataJson.member_key 		= "<%=member_key%>";
		jArray.push(dataJson); 
		
	    var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)

		var chekrtn = confirm("삭제하시겠습니까?"); 
		
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
	         		alert('삭제가 완료되었습니다.');
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
            	<input type="text" class="form-control" id="txt_vehicle_cd" readonly></input>
            	<input type="hidden" class="form-control" id="txt_vehicle_cd_rev" readonly></input>
            </td>
            <td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">차량명칭</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_vehicle_nm" readonly></input>
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
            	<input type="text" class="form-control" id="txt_transport_total" readonly></input>
			</td>
        	<td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주행거리(운행km)</td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_transport_distance" readonly></input>
			</td>
        </tr>
        <tr style="background-color: #fff; ">
        	<td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">배송기사</td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_driver" readonly></input>
			</td>
			<td colspan="2"></td>
        </tr>
        <tr  style="background-color: #fff; ">
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:left">차량이상유무, 기타비용내역</td>
            <td style="width: 66.66%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:left" colspan="3">
            	<textarea class="form-control" id="txt_bigo" style="cols:10;rows:4;resize:none;" readonly></textarea>
            </td>
        </tr>
	</table>
	
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">삭제</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
	