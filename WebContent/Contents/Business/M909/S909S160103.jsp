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
	DoyosaeTableModel TableModel;

	String zhtml = "";
	
	String[] strColumnHead = {""};
	
	String MEMBER_KEY = "", CODE_CD = "", CENSOR_NO = "", CCP_NO = "";

	if(request.getParameter("member_key")== null)
		MEMBER_KEY = "";
	else
		MEMBER_KEY = request.getParameter("member_key");
	
	if(request.getParameter("code_cd") == null)
		CODE_CD = "";
	else
		CODE_CD = request.getParameter("code_cd");
	
	if(request.getParameter("censor_no") == null)
		CENSOR_NO = "";
	else
		CENSOR_NO = request.getParameter("censor_no");
	
	if(request.getParameter("ccp_no") == null)
		CCP_NO = "";
	else
		CCP_NO = request.getParameter("ccp_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("code_cd", CODE_CD);
	jArray.put("censor_no", CENSOR_NO);
	jArray.put("ccp_no", CCP_NO);
	
    TableModel = new DoyosaeTableModel("M909S160100E115", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
		
    // 데이터를 가져온다.
    Vector CCP_Delete_Target_Vector = (Vector)(TableModel.getVector().get(0));
    
	jArray.put("code_value", CCP_Delete_Target_Vector.get(4).toString().trim());
    
    DBServletLink dbServletLink = new DBServletLink();
	dbServletLink.connectURL("M909S160100E996");
    Vector CodeValueTable = dbServletLink.doQuery(jArray, false);
    
    System.out.println("CodeValueTable : " + CodeValueTable);
    String ResultOfCodeValueTable = ((Vector)CodeValueTable.get(0)).get(0).toString();
    
    for( int i = 0 ; i < 7 ; i++ )
    {
    	System.out.println( "CCP_Delete_Target_Vector.get(" + i + ") : " + CCP_Delete_Target_Vector.get(i).toString().trim() );    	
    }
    
    String CCP_yn = TableModel.getValueAt(0, 6).toString().trim(); 
    String GET_auto_yn = TableModel.getValueAt(0, 7).toString().trim();

%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S160100E103 = {
			PID:  "M909S160100E103", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M909S160100E103", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;

    
    $(document).ready(function () {

		$('input[name=rdo_CCP_yn][value=<%=CCP_yn%>]').prop("checked", true).change();
		$('input[name=rdo_GET_auto_yn][value=<%=GET_auto_yn%>]').prop("checked", true).change();
    	
    });
	function SaveOderInfo() {        
		//SetRecvData();
		
		var delete_check = confirm("선택한 CCP 정보를 삭제합니다." + "\n" + "삭제하시겠습니까?");
		
		if(delete_check) {
			var dataJson = new Object();

			dataJson.member_key		= "<%=member_key%>";
			dataJson.censor_no		= $('#txt_CensorNo').val();
			dataJson.censor_channel	= $('#txt_CensorChannel').val();
			dataJson.ccp_no			= $('#txt_CCPNo').val();
			dataJson.ccp_name		= $('#txt_CCPName').val();
			dataJson.ccp_type		= $('#txt_CCPType').val();
			dataJson.ccp_value		= $('#txt_CCPValue').val();
		
			var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			
			SendTojsp(JSONparam, "M909S160100E103");
			
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
    
    function SetCustName_code(name, code, rev){
    	alert(code);
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);
		
    	alert(code);
		
    }
    
    function SetCustProjectInfo(cust_cd, cust_nm, project_name, cust_pono, prod_cd, product_nm, cust_rev, projrctCnt){
		$('#txt_projrctName').val(project_name);
		$('#txt_custname').val(cust_nm);
		$('#txt_projrctCnt').val(projrctCnt);
		
		$('#txt_custcode').val(cust_cd);
		$('#txt_cust_rev').val(cust_rev);
		$('#txt_cust_poNo').val(cust_pono);
		
    }
    function SetProductName_code(name, code, rev){

    	var len = $("#product_tbody tr").length-1;		
		var trInput = $($("#product_tbody tr")[len]).find(":input")
		trInput.eq(1).val(name);
		trInput.eq(3).val(code);
		trInput.eq(4).val(rev);
    }
    </script>

<!-- <form name="form1S909S050101" method="post" enctype="multipart/form-data" action="">  -->
<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">센서 번호</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CensorNo" style="width: 200px; float:left"
			value = "<%=CCP_Delete_Target_Vector.get(0).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">센서 채널 번호</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CensorChannel" style="width: 200px; float:left"
			value = "<%=CCP_Delete_Target_Vector.get(1).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">CCP 번호</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPNo" style="width: 200px; float:left"
			value = "<%=CCP_Delete_Target_Vector.get(2).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">CCP 이름</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPName" style="width: 200px; float:left"
			value = "<%=CCP_Delete_Target_Vector.get(3).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">CCP 타입</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPType" style="width: 200px; float:left"
			value = "<%=ResultOfCodeValueTable%>" readonly />
		</td>
	</tr>
	
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">CCP 값</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPValue" style="width: 200px; float:left"
			value = "<%=CCP_Delete_Target_Vector.get(5).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900; ">CCP 여부</td>
		<td> </td>
		<td>
			<p style="float: left; margin-top: 6px; margin-bottom: 6px;">
				<input type="radio"  id="rdo_CCP_yn"  name="rdo_CCP_yn" value="Y" > Y</input>
	            <input type="radio"  id="rdo_CCP_yn"  name="rdo_CCP_yn" value="N" style="margin-left:39px"> N</input>
            </p>
		</td>
	</tr>
	
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight: 900;">데이터 수집방법</td>
		<td> </td>
		<td>
			<p style="float: left; margin-top: 6px; margin-bottom: 6px;">
				<input type="radio"  id="rdo_GET_auto_yn"  name="rdo_GET_auto_yn" value="Y" > 자동</input>
	            <input type="radio"  id="rdo_GET_auto_yn"  name="rdo_GET_auto_yn" value="N" style="margin-left:20px"> 수동</input>
            </p>
		</td>
	</tr>

	<tr style="height: 60px">
		<td align="center" colspan="4">
			<p>
				<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
				<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
			</p>
		</td>
	</tr>
</table>
<!-- </form>  -->
