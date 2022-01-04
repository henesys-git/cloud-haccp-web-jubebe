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
	String zhtml = "";

	Vector CCPCode = new Vector();
	Vector CCPName = new Vector();
	
	String MEMBER_KEY = "", CODE_CD = "";

	if(request.getParameter("member_key")== null)
		MEMBER_KEY = "";
	else
		MEMBER_KEY = request.getParameter("member_key");
	
	if(request.getParameter("code_cd") == null)
		CODE_CD = "";
	else
		CODE_CD = request.getParameter("code_cd");	

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("code_cd", CODE_CD);
	
	Vector CCP_Type_Vector = CommonData.getCCPType(jArray);
%>
    
    <script type="text/javascript">
    
    $(document).ready(function () {
    	
    });

	function SaveOderInfo() {
		// SetRecvData();

// 		alert("rdo_CCP_yn : " + $("input[name='rdo_CCP_yn']:checked").val() + " / get_auto_yn : " + $("input[name='rdo_GET_auto_yn']:checked").val());
		
		var dataJson = new Object();
			dataJson.ccp_no			= $('#txt_CCPNo').val();
			dataJson.ccp_name		= $('#txt_CCPName').val();
			dataJson.censor_no		= $('#txt_CensorNo').val();
			dataJson.censor_channel	= $('#txt_CensorChannel').val();
			dataJson.censor_name	= $('#txt_CensorName').val();
			dataJson.ccp_type		= $('#txt_CCPType').val();
			dataJson.ccp_value		= $('#txt_CCPValue').val();
			dataJson.ccp_yn			= $("input[name='rdo_CCP_yn']:checked").val();
			dataJson.record_yn		= $("input[name='rdo_RECORD_yn']:checked").val();
			dataJson.monitor_yn		= $("input[name='rdo_MONITOR_yn']:checked").val();
			dataJson.get_auto_yn		= $("input[name='rdo_GET_auto_yn']:checked").val();
			dataJson.member_key		= "<%=MEMBER_KEY%>";
			
			var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn){
				SendTojsp(JSONparam, "M909S160100E101");
			}
	}

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	     	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", // insert_update_delete_json.jsp로 연결
	     	 data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	 
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         		//fn_DetailInfo_List();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });

	    vCensorNo = "";
	}  
	
    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }

    function pop_fn_CensorInfo_View(obj){
    	var modalContentUrl;

   		modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/Censor_view.jsp"
   							+ "?member_key=" + "<%=member_key%>";

   		modalFramePopup.setTitle("센서 정보 검색");
   		/* pop_fn_popUpScr_nd(modalContentUrl, "센서 정보 검색", "630px", "680px"); */
   		pop_fn_popUpScr_nd(modalContentUrl, "센서 정보 검색", "90%", "90%");

   		return false;
    }
    
    function SetCensorInfo(Number, Name,cNno)
    {
    	$('#txt_CensorNo').val(Number);
    	$('#txt_CensorName').val(Name);
    	$('#txt_CensorChannel').val(cNno);
    }
    
    $('#txt_CCPType').on('change', function() {
    	console.log("선택된 CCP 타입명 : " + $('#txt_CCPType').val());
    });
    </script>

<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	<%-- <tr style="background-color: #fff; height: 40px">
		<td>member_key</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_MemberKey" style="width: 200px; float:left" readonly
			value="<%=member_key%>" />
		</td>
	</tr> --%>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">CCP 번호</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_CCPNo" style="width: 200px; float:left"/>
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">CCP 이름</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPName" style="width: 200px; float:left"/>
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">센서 번호</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CensorNo" style="width: 200px; float:left;" readonly />
			
			<button type="button" id="btn_CensorSearch" class="btn btn-info"
					onclick="pop_fn_CensorInfo_View(this)" style="width:65px; float:left;margine-left:10px">검색</button>
		 </td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">센서 채널번호</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_CensorChannel" style="width: 200px; float:left" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">센서 이름</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_CensorName" style="width: 200px; float:left" readonly />
		</td>
	</tr>
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">CCP 타입</td>
		<td> </td>
		<td>
			<select class="form-control" id="txt_CCPType" style="width: 200px">
				<%CCPCode = (Vector)CCP_Type_Vector.get(0);%>
				<%CCPName = (Vector)CCP_Type_Vector.get(1);%>
				<%for( int i = 0 ; i < CCPName.size() ; i++ ){ %>
					<option value='<%=CCPCode.get(i).toString()%>'><%=CCPName.get(i).toString()%></option>
				<%} %>
			</select>
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">CCP 값</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPValue" style="width: 200px; float:left"/>
		</td>
	</tr>
	
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900; ">CCP 여부</td>
		<td> </td>
		<td>
			<p style="float: left; margin-top: 6px; margin-bottom: 6px;">
				<input type="radio"  id="rdo_CCP_yn"  name="rdo_CCP_yn" value="Y" checked="checked" > Y</input>
	            <input type="radio"  id="rdo_CCP_yn"  name="rdo_CCP_yn" value="N" style="margin-left:39px"> N</input>
            </p>
		</td>
	</tr>
	
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900; ">온도기록지 여부</td>
		<td> </td>
		<td>
			<p style="float: left; margin-top: 6px; margin-bottom: 6px;">
				<input type="radio"  id="rdo_RECORD_yn"  name="rdo_RECORD_yn" value="Y" checked="checked"> Y</input>
	            <input type="radio"  id="rdo_RECORD_yn"  name="rdo_RECORD_yn" value="N" style="margin-left:39px"> N</input>
            </p>
		</td>
	</tr>
	
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900; ">모니터링 여부</td>
		<td> </td>
		<td>
			<p style="float: left; margin-top: 6px; margin-bottom: 6px;">
				<input type="radio"  id="rdo_MONITOR_yn"  name="rdo_MONITOR_yn" value="Y" checked="checked"> Y</input>
	            <input type="radio"  id="rdo_MONITOR_yn"  name="rdo_MONITOR_yn" value="N" style="margin-left:39px"> N</input>
            </p>
		</td>
	</tr>
	
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">데이터 수집방법</td>
		<td> </td>
		<td>
			<p style="float: left; margin-top: 6px; margin-bottom: 6px;">
				<input type="radio"  id="rdo_GET_auto_yn"  name="rdo_GET_auto_yn" value="Y" checked="checked" > 자동</input>
	            <input type="radio"  id="rdo_GET_auto_yn"  name="rdo_GET_auto_yn" value="N" style="margin-left:20px"> 수동</input>
            </p>
		</td>
	</tr>
	
	<tr style="height: 60px">
		<td align="center" colspan="3">
			<p>
				<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
				<button id="btn_Canc"  class="btn btn-info" style="width: 100px"
						onclick="$('#modalReport').modal('hide');vCensorNo = '';console.log('초기화 됐는지 봅시다 : (' + vCensorNo + ') 됐나요???');">취소</button>
			</p>
		</td>
	</tr>
</table>
