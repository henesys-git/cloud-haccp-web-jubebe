<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
// 	String zhtml = "";
	
	String GV_EXTNL_IN_DATE="" ;
	
	if(request.getParameter("extnl_in_date")== null)
		GV_EXTNL_IN_DATE="";
	else
		GV_EXTNL_IN_DATE = request.getParameter("extnl_in_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "extnl_in_date", GV_EXTNL_IN_DATE);
	
	TableModel = new DoyosaeTableModel("M838S050400E124", jArray);
	int ColCount =TableModel.getColumnCount();
// 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
// 	String JSPpage = jspPageName.GetJSP_FileName();
		
	// 데이터를 가져온다.
	Vector targetCustVector = (Vector)(TableModel.getVector().get(0));
		
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID: "M838S050400E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	$(document).ready(function () {
		
		
	});
	
	function SaveOderInfo() {
		// write_date 등록 날짜 세팅
// 	    var today = new Date("2019-06-02"); // 특정날짜
	    var today = new Date(); // 오늘날짜
		var write_date 	= today.getFullYear() 
						+ "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
						+ "-" + ("0" + today.getDate()).slice(-2) ;
		
		// JSON 파라미터 세팅
		var dataJson = new Object(); // jSON Object 선언 
		dataJson.member_key = "<%=member_key%>";
		
		dataJson.extnl_in_date = $("#txt_extnl_in_date").val();
		dataJson.extnl_in_object = $("#txt_extnl_in_object").val();
		dataJson.extnl_in_conpany = $("#txt_extnl_in_conpany").val();
		dataJson.extnl_in_title = $("#txt_extnl_in_title").val();
		dataJson.extnl_in_cust_name = $("#txt_extnl_in_cust_name").val();
		dataJson.extnl_in_signature = "";
		dataJson.qc_mgr_aprvl = "";
		dataJson.qc_mgr_aprvl_date = "";
		dataJson.approval_mgr = "";
		dataJson.approval_date = "";
		
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		var work_complete_delete_check = confirm("삭제하시겠습니까?");
		if(work_complete_delete_check == false)   return;
		
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	        	   	vCheckDuration="";
	        	   	parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}
	
    </script>
</head>
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">      
        
        <tr style="background-color: #fff; height: 40px">
            <td>방문일시</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_extnl_in_date" style="width: 300px; float:left" readonly
            		value="<%=targetCustVector.get(0).toString()%>"/>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>방문,점검 목적</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_extnl_in_object" style="width: 300px; float:left" readonly
            		value="<%=targetCustVector.get(1).toString()%>"/>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>방문자 소속</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_extnl_in_conpany" style="width: 300px; float:left" readonly
            		value="<%=targetCustVector.get(2).toString()%>"/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>방문자 직위</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_extnl_in_title" style="width: 300px; float:left" readonly
            		value="<%=targetCustVector.get(3).toString()%>"/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>방문자 성명</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_extnl_in_cust_name" style="width: 300px; float:left" readonly
            		value="<%=targetCustVector.get(4).toString()%>"/>
           	</td>
        </tr>
        
        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>
<!-- </form>     -->
</body>
</html>