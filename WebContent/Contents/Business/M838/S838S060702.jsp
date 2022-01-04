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
	
	// 로그인한 사용자의 정보
	JSONObject jArrayUser = new JSONObject();
	jArrayUser.put( "member_key", member_key);
	jArrayUser.put( "USER_ID", loginID);
	DoyosaeTableModel TableModelUser = new DoyosaeTableModel("M909S080100E107", jArrayUser);
	
	int RowCountUser =TableModelUser.getRowCount();
	String loginIDrev = "", loginIDjikwi = "", loginIDdept = "";
	
	if(RowCountUser > 0) {
		loginIDrev = TableModelUser.getValueAt(0, 1).toString().trim();
	} else {
		loginIDrev = "0";
	}
	
	String GV_PART_CODE = "", GV_COMPANY_CODE = "", GV_CHECK_DATE = "";
	
	if(request.getParameter("part_cd") == null)
		GV_PART_CODE = "";
	else
		GV_PART_CODE = request.getParameter("part_cd");
	
	if(request.getParameter("company_cd") == null)
		GV_COMPANY_CODE = "";
	else
		GV_COMPANY_CODE = request.getParameter("company_cd");
	
	if(request.getParameter("check_date") == null)
		GV_CHECK_DATE = "";
	else
		GV_CHECK_DATE = request.getParameter("check_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "part_code_value", GV_PART_CODE);
	jArray.put( "company_code_value", GV_COMPANY_CODE);
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "member_key", member_key);

	System.out.println("????????????" + GV_PART_CODE + "###################");
	System.out.println("!!!!!!!!!!!!!!" + GV_COMPANY_CODE + "@@@@@@@@@@@@@@@@@@@@");
	System.out.println("&&&&&&&&&&&&&&&" + GV_CHECK_DATE + "$$$$$$$$$$$$$$$$$$$$$$");
	
	
	/* DoyosaeTableModel TableModel;
	TableModel = new DoyosaeTableModel("M838S060700E914", jArray);
	int RowCount =TableModel.getRowCount(); */
	
	DBServletLink dbServletLink = new DBServletLink();
    dbServletLink.connectURL("M838S060700E914");
    
    Vector Update_Part_Info_List = dbServletLink.doQuery(jArray, false);

    Update_Part_Info_List = (Vector)(Update_Part_Info_List.get(0));
    
    /* for( int i = 0 ; i < 6 ; i++ )
    {
    	System.out.println( "Update_Part_Info_List.get(" + i + ") : " + Update_Part_Info_List.get(i).toString() );
    } */
    System.out.println( "???????????????????????????????????????" + Update_Part_Info_List.toString() + "");
    
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M838S060700E102", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	//웹소켓 통신을 위해서 필요한 변수들 ---끝	

	function SaveOderInfo() {
	 	var dataJson = new Object();
		//SetRecvData();

		dataJson.member_key			= "<%=member_key%>";
		dataJson.part_code_value	= $('#txt_part_code_value').val();
		dataJson.company_code_value	= $('#txt_company_code_value').val();
		dataJson.part_check_value	= $('#txt_part_check_value').val();
		dataJson.check_date			= "<%=GV_CHECK_DATE%>";
		
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn){
		SendTojsp(JSONparam, SQL_Param.PID);
		}

	}
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
// 	        	 alert(bomdata);
	         },
	         /* success: function (html) {	
	        	if(html>-1){
	        		opener.parent.fn_MainInfo_List();
		         	window.close();
	         	}
	         }, */
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
</script>
<!-- <form name="form1S909S050101" method="post" enctype="multipart/form-data" action="">  -->
<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	<tr style="background-color: #fff; height: 40px; display:none">
		<td>제품코드</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_part_code_value" style="width: 200px; float:left"
			value = "<%=Update_Part_Info_List.get(0).toString()%>" readonly />
		</td>
		
		<td>회사코드</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_company_code_value" style="width: 200px; float:left"
			value = "<%=Update_Part_Info_List.get(2).toString()%>" readonly />
		</td>
	</tr>
	<tr style="background-color: #fff; height: 40px">
		<td>제품명</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_part_name_value" style="width: 200px; float:left"
			value = "<%=Update_Part_Info_List.get(1).toString()%>" readonly />
		</td>
		
		<td>제조원</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_company_name_value" style="width: 200px; float:left"
			value = "<%=Update_Part_Info_List.get(3).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td>주소</td>
		<td> </td>
		<td colspan="4">
			<input type="text" class="form-control" id="txt_company_address_value" style=" float:left"
			value = "<%=Update_Part_Info_List.get(4).toString()%>" readonly/>
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td>위반사항</td>
		<td> </td>
		<td colspan="4">
			<input type="text" class="form-control" id="txt_part_check_value" style=" float:left"
			value = "<%=Update_Part_Info_List.get(5).toString()%>" />
		</td>
	</tr>

	<tr style="height: 60px">
		<td align="center" colspan="6">
			<p>
				<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
				<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
			</p>
		</td>
	</tr>
</table>
<!-- </form>  -->