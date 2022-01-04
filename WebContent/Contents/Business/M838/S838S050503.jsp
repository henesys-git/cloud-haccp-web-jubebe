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
	
	// 로그인한 사용자의 정보
	JSONObject jArrayUser = new JSONObject();
	jArrayUser.put( "USER_ID", loginID);
	jArrayUser.put( "member_key", member_key);
	DoyosaeTableModel TableModelUser = new DoyosaeTableModel("M909S080100E107", jArrayUser);
	int RowCountUser =TableModelUser.getRowCount();
	String loginIDrev = "",loginIDdept = "";
	if(RowCountUser > 0) {
		loginIDrev = TableModelUser.getValueAt(0, 1).toString().trim();
		loginIDdept = TableModelUser.getValueAt(0, 10).toString().trim();
	} else {
		loginIDrev = "0";
	}
	
	String GV_CLEANER_REG_NO="", GV_CLEANER_REG_REV="", GV_CLEANER_REG_DATE="";
	
	if(request.getParameter("cleaner_reg_no")== null)
		GV_CLEANER_REG_NO = "";
	else
		GV_CLEANER_REG_NO = request.getParameter("cleaner_reg_no");
	
	if(request.getParameter("cleaner_reg_rev")== null)
		GV_CLEANER_REG_REV = "";
	else
		GV_CLEANER_REG_REV = request.getParameter("cleaner_reg_rev");
	
	if(request.getParameter("cleaner_reg_date")== null)
		GV_CLEANER_REG_DATE = "";
	else
		GV_CLEANER_REG_DATE = request.getParameter("cleaner_reg_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "cleaner_reg_no", GV_CLEANER_REG_NO);
	jArray.put( "cleaner_reg_rev", GV_CLEANER_REG_REV);
	jArray.put( "cleaner_reg_date", GV_CLEANER_REG_DATE);
	
	DoyosaeTableModel TableModel;
	TableModel = new DoyosaeTableModel("M838S050500E114", jArray);
	int ColCount =TableModel.getColumnCount();
	
	// 데이터를 가져온다.
	Vector targetCustVector = (Vector)(TableModel.getVector().get(0));
	
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID: "M838S050500E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	$(document).ready(function () {
// 		$("#txt_cleaner_reg_date").datepicker({
//         	format: 'yyyy-mm-dd',
//         	autoclose: true,
//         	language: 'ko'
//         });
// 		var today = new Date();
// 		$('#txt_cleaner_reg_date').datepicker('update', today);
		
<%-- 		$("#txt_write_dept").val("<%=loginIDdept%>"); --%>
<%-- 		$("#txt_writor_main").val("<%=loginID%>"); --%>
<%-- 		$("#txt_writor_main_rev").val("<%=loginIDrev%>"); --%>
		
// 		// 숫자만
// 	    $("input:text[numberOnly]").on("keyup", function() {
// 	        $(this).val($(this).val().replace(/[^0-9]/g,""));
// 	    });
	});
	
	function SaveOderInfo() {
		// JSON 파라미터 세팅
		var dataJson = new Object(); // jSON Object 선언 
		dataJson.member_key = "<%=member_key%>";
		
		dataJson.cleaner_reg_no = $("#txt_cleaner_reg_no").val();
		dataJson.cleaner_reg_rev = $("#txt_cleaner_reg_rev").val();
		
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
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}
	
// 	function pop_fn_PartStorage_View(obj) {
// 		var vPartGubunB = ""; // part_gubun 세척제 코드 정해지면 변경
// 		var vPartGubunM = ""; // part_gubun 세척제 코드 정해지면 변경
// 		var vPartGubunS = ""; // part_gubun 세척제 코드 정해지면 변경
		
<%-- 		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Tablet/M838/T838S050520.jsp" --%>
// 							 + "?part_gubun_b=" + vPartGubunB
// 							 + "&part_gubun_m=" + vPartGubunM
// 							 + "&part_gubun_s=" + vPartGubunS ;
//     	pop_fn_popUpScr_nd(modalContentUrl, obj.innerText + "(T838S050520)", '40%', '90%');
// 		return false;
// 	}

    </script>
</head>
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        <tr style="background-color: #fff; height: 40px">
            <td>사용일자</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_cleaner_reg_date" style="width: 200px; float:left;" readonly
            		value="<%=targetCustVector.get(2).toString()%>"/>
            	<input type="hidden" class="form-control" id="txt_cleaner_reg_no" readonly
            		value="<%=targetCustVector.get(0).toString()%>"/>
            	<input type="hidden" class="form-control" id="txt_cleaner_reg_rev" readonly
            		value="<%=targetCustVector.get(1).toString()%>"/>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>세척소독제명</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_part_nm" readonly style="width: 200px; float:left;"
            		value="<%=targetCustVector.get(5).toString()%>"/>
				<input type="hidden" class="form-control" id="txt_part_cd" readonly
					value="<%=targetCustVector.get(3).toString()%>"/>
				<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly
					value="<%=targetCustVector.get(4).toString()%>"/>
<!-- 				<button type="button" onclick="pop_fn_PartStorage_View(this)" id="btn_SearchCust" class="btn btn-info" > -->
<!-- 					세척소독제 검색 -->
<!-- 				</button> -->
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>사용용도</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_cleaner_usage" style="width: 200px; float:left;" readonly
            		value="<%=targetCustVector.get(6).toString()%>"/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>사용량</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_usage_amt" style="width: 200px; float:left;" readonly
            		value="<%=targetCustVector.get(8).toString()%>"/>
            	<p style="float:left;">( 재고량 :</p> 
            	<input type="text" class="form-control" id="txt_store_amt" readonly 
            		style="width: 100px; float:left;" value="<%=targetCustVector.get(9).toString()%>"/>
            	<p style="float:left;">)</p>
            	<input type="hidden" class="form-control" id="txt_ipgo_amt" value=0 readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>비고</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_bigo" style="width: 200px; float:left;" readonly
            		value="<%=targetCustVector.get(15).toString()%>"/>
				<input type="hidden" class="form-control" id="txt_write_dept" readonly/>
				<input type="hidden" class="form-control" id="txt_writor_main" readonly/>
				<input type="hidden" class="form-control" id="txt_writor_main_rev" readonly/>
				<input type="hidden" class="form-control" id="txt_approval" readonly/>
				<input type="hidden" class="form-control" id="txt_approval_date" readonly/>
           	</td>
        </tr>
        
        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>

    </table>
<!-- </form>     -->
</body>
</html>