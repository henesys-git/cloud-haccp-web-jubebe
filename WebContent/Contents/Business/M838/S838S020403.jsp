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
	
	//로그인한 아이디의 개정번호(rev)를 가져오는 벡터
	Vector UserIDrev = CommonData.getUserRevDataID(loginID,member_key);
	Vector optCodeVector = (Vector)UserIDrev.get(0); 
	String optCode =  optCodeVector.get(0).toString();
	
	DoyosaeTableModel TableModel;
// 	String zhtml = "";
	
	String GV_CHECK_DURATION="", GV_CHECK_DATE="", GV_CHECK_TIME="" ;
	
	if(request.getParameter("check_duration")== null)
		GV_CHECK_DURATION="";
	else
		GV_CHECK_DURATION = request.getParameter("check_duration");
	
	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE="";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	if(request.getParameter("check_time")== null)
		GV_CHECK_TIME="";
	else
		GV_CHECK_TIME = request.getParameter("check_time");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_duration", GV_CHECK_DURATION);
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "check_time", GV_CHECK_TIME);
	
	TableModel = new DoyosaeTableModel("M838S020400E124", jArray);
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
			PID: "M838S020400E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	$(document).ready(function () {
		$("#txt_writor_main").val("<%=loginID%>"); //로그인한 유저
		$("#txt_writor_main_rev").val("<%=optCode%>"); //로그인한 유저rev	
		
		// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
		
	});
	
	function SaveOderInfo() {
		// JSON 파라미터 세팅
		var dataJson = new Object(); // jSON Object 선언 
		dataJson.member_key = "<%=member_key%>";
		
		dataJson.check_duration = "<%=targetCustVector.get(0).toString()%>";
		dataJson.check_date = "<%=targetCustVector.get(1).toString()%>";
		dataJson.check_time = "<%=targetCustVector.get(2).toString()%>";
		  
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
	
	function SetCustName_code(txt_custname, txt_custcode, txt_cust_rev) {
		$("#txt_cust_nm").val(txt_custname);
 		$("#txt_cust_cd").val(txt_custcode);
 		$("#txt_cust_cd_rev").val(txt_cust_rev);
	}
	
	function SetProductName_code(txt_ProductName, txt_Productcode,txt_prod_rev) {
		$("#txt_waste_subject").val(txt_ProductName);
	}

    </script>
</head>
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">      
        <tr style="background-color: #fff; height: 40px">
            <td>품목</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_waste_subject" style="width: 200px; float:left" readonly 
            		value="<%=targetCustVector.get(4).toString()%>"/>
<!-- 				<button type="button" onclick="parent.pop_fn_ProductName_View(1,'ALL')" id="btn_SearchCust" class="btn btn-info" > -->
<!-- 					품목 검색 -->
<!-- 				</button> -->
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>수거업체</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_cust_nm" style="width: 200px; float:left" readonly 
            		value="<%=targetCustVector.get(8).toString()%>"/>
				<input type="hidden" class="form-control" id="txt_cust_cd" value="<%=targetCustVector.get(6).toString()%>"/>
				<input type="hidden" class="form-control" id="txt_cust_cd_rev" value="<%=targetCustVector.get(7).toString()%>"/>
<!-- 				<button type="button" onclick="parent.pop_fn_CustName_View(1,'O')" id="btn_SearchCust" class="btn btn-info" > -->
<!-- 					수거업체 검색 -->
<!-- 				</button> -->
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>수거자</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_waste_collector" style="width: 200px; float:left"
            		value="<%=targetCustVector.get(9).toString()%>" readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>수거량</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_waste_weight" style="width: 200px; float:left" numberOnly
					value="<%=targetCustVector.get(10).toString()%>" readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>이탈사항</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_incong_note" style="width: 500px; float:left"
            		value="<%=targetCustVector.get(16).toString()%>" readonly/>
           	</td>
        </tr>
        
        <tr style="height: 40px">
            <td>개선조치</td>
            <td></td>
            <td >
            	<input type="text" class="form-control" id="txt_improve_note" style="width: 500px; float:left"
            		value="<%=targetCustVector.get(17).toString()%>" readonly/>
            </td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>특이사항</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_uniqueness" style="width: 500px; float:left"
					value="<%=targetCustVector.get(18).toString()%>" readonly/>
            	<input type="hidden" class="form-control" id="txt_writor_main" value="<%=targetCustVector.get(12).toString()%>"/>
				<input type="hidden" class="form-control" id="txt_writor_main_rev" value="<%=targetCustVector.get(13).toString()%>"/>
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