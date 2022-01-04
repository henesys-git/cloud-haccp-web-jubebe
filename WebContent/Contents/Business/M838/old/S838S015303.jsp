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
	
	String  GV_CENSOR_NO="",GV_IMPROVE_TYPE="",GV_IMPROVE_PROGRAM="",GV_IMPROVE_HACCP_PLAN="",GV_IMPROVE_PREVENT_PLAN="",GV_IMPROVE_PRODUCT_HANDLE=""
			,GV_IMPROVE_BEFORE="",GV_IMPROVE_AFTER="",GV_WRITE_DATE="";

	if(request.getParameter("censor_no")== null)
		GV_CENSOR_NO="";
	else
		GV_CENSOR_NO = request.getParameter("censor_no");
	
	if(request.getParameter("improve_type")== null)
		GV_IMPROVE_TYPE="";
	else
		GV_IMPROVE_TYPE = request.getParameter("improve_type");
	
	if(request.getParameter("improve_program")== null)
		GV_IMPROVE_PROGRAM="";
	else
		GV_IMPROVE_PROGRAM = request.getParameter("improve_program");
	
	if(request.getParameter("improve_haccp_plan")== null)
		GV_IMPROVE_HACCP_PLAN="";
	else
		GV_IMPROVE_HACCP_PLAN = request.getParameter("improve_haccp_plan");
	
	if(request.getParameter("improve_prevent_plan")== null)
		GV_IMPROVE_PREVENT_PLAN="";
	else
		GV_IMPROVE_PREVENT_PLAN = request.getParameter("improve_prevent_plan");
	
	if(request.getParameter("improve_product_handle")== null)
		GV_IMPROVE_PRODUCT_HANDLE="";
	else
		GV_IMPROVE_PRODUCT_HANDLE = request.getParameter("improve_product_handle");
	
	if(request.getParameter("improve_before")== null)
		GV_IMPROVE_BEFORE="";
	else
		GV_IMPROVE_BEFORE = request.getParameter("improve_before");
	
	if(request.getParameter("improve_after")== null)
		GV_IMPROVE_AFTER="";
	else
		GV_IMPROVE_AFTER = request.getParameter("improve_after");
	
	if(request.getParameter("write_date")== null)
		GV_WRITE_DATE="";
	else
		GV_WRITE_DATE = request.getParameter("write_date");
	
	
	
// 	JSONObject jArray = new JSONObject();
// 	jArray.put( "censor_no", GV_CENSOR_NO);
// 	jArray.put( "member_key", member_key);
	
	
// 	TableModel = new DoyosaeTableModel("M838S015300E114", jArray);
// 	int ColCount =TableModel.getColumnCount();
// 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
// 	String JSPpage = jspPageName.GetJSP_FileName();
		
	// 데이터를 가져온다.
// 	Vector targetCustVector = (Vector)(TableModel.getVector().get(0));
		
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID: "M838S015300E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	var checkValue1 = '<%=GV_IMPROVE_TYPE%>';
	
	$(document).ready(function () {
		$("#txt_writor_main").val("<%=loginID%>"); //로그인한 유저
		$("#txt_writor_main_rev").val("<%=optCode%>"); //로그인한 유저rev	
		
		// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
		
	    $("input[name=txt_improve_type]").filter("input[value='"+checkValue1+"']").attr("checked",true);
		
	});
	
	function SaveOderInfo() {
		var today = new Date(); // 오늘날짜
		
		var check_date    = today.getFullYear() 
        + "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
        + "-" + ("0" + today.getDate()).slice(-2) ;
		var check_time    = ("0" + today.getHours()).slice(-2) 
        + ":" + ("0" + today.getMinutes()).slice(-2) 
        + ":" + ("0" + today.getSeconds()).slice(-2) ;
		
		var qa1 = $(':input[name="txt_improve_type"]:radio:checked').val();
		
		// JSON 파라미터 세팅
		var dataJson = new Object(); // jSON Object 선언 
		dataJson.member_key = "<%=member_key%>";
		
		dataJson.write_date = '<%=GV_WRITE_DATE%>';
		  
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
// 	        	   	parent.fn_MainInfo_List();
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
            <td style="font-weight:900;">개선 조치 분야</td>
            <td> </td>
        	<td>
        		<input type="radio" id="txt_improve_type" name="txt_improve_type" checked="checked" value="01" style="width: 60px;" disabled="disabled">선행요건프로그램</input>
        		<input type="radio" id="txt_improve_type" name="txt_improve_type" value="02" style="width: 60px;" disabled="disabled">HACCP계획</input>
        		<input type="hidden" class="form-control" id="txt_censor_no"  />
            </td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">선행요건 프로그램</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_improve_program" style="width: 500px; float:left" value="<%=GV_IMPROVE_PROGRAM%>" readonly="readonly" />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">HACCP계획</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_improve_haccp_plan" style="width: 500px; float:left" value="<%=GV_IMPROVE_HACCP_PLAN%>" readonly="readonly" />
           	</td>
        </tr>
        
        <tr style="height: 40px">
            <td style="font-weight:900;">재발 방지 대책 수립</td>
            <td></td>
            <td ><input type="text" class="form-control" id="txt_improve_prevent_plan" style="width: 500px; float:left" value="<%=GV_IMPROVE_PREVENT_PLAN%>" readonly="readonly" />
            </td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">영향받은 제품의 적절한 처리</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_improve_product_handle" style="width: 500px; float:left" value="<%=GV_IMPROVE_PRODUCT_HANDLE%>" readonly="readonly" />
           	</td>
        </tr>
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개선 전</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_improve_before" style="width: 500px; float:left" value="<%=GV_IMPROVE_BEFORE%>" readonly="readonly" />
           	</td>
        </tr>
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개선 후</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_improve_after" style="width: 500px; float:left" value="<%=GV_IMPROVE_AFTER%>" readonly="readonly" />
            	<input type="hidden" class="form-control" id="txt_writor_main"  />
				<input type="hidden" class="form-control" id="txt_writor_main_rev"  />
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