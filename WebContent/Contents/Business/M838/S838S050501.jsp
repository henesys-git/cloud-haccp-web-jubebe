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
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID: "M838S050500E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	$(document).ready(function () {
		
		new SetSingleDate2("", "#txt_cleaner_reg_date", 0);
		
		var today = new Date();
		
		$("#txt_write_dept").val("<%=loginIDdept%>");
		$("#txt_writor_main").val("<%=loginID%>");
		$("#txt_writor_main_rev").val("<%=loginIDrev%>");
		
		// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	});
	
	function SaveOderInfo() {
		// write_date 등록 날짜 세팅
// 	    var today = new Date("2019-06-02"); // 특정날짜
	    var today = new Date(); // 오늘날짜
		var write_date 	= today.getFullYear() 
						+ "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
						+ "-" + ("0" + today.getDate()).slice(-2) ;
	    
	    // 사용일자 검사
		var cleaner_reg_date = new Date($("#txt_cleaner_reg_date").val());
		if(today < cleaner_reg_date) {
			alert("사용일자를 오늘이나 이전날자로 선택하세요");
			return;
		}
		
		// 세척제 선택했는지 검사
		if($("#txt_part_cd").val().length<1){
			alert("세척제 검색하여 선택하세요");
			return;
		}
		
		// 사용량 세팅
		var usage_amt = 0;
		if($("#txt_usage_amt").val().length < 0) {
			alert("사용량을 최소 1이상 입력하세요");
			return;
		} else {
			usage_amt = parseInt($("#txt_usage_amt").val());
			if(usage_amt < 1) {
				alert("사용량을 최소 1이상 입력하세요");
				return;
			}
			if(usage_amt > parseInt($("#txt_store_amt").val())) {
				alert("사용량을 재고량보다 적게 입력하세요");
				return;
			}
		}
	    
		// JSON 파라미터 세팅
		var dataJson = new Object(); // jSON Object 선언 
		dataJson.member_key = "<%=member_key%>";
		
		dataJson.cleaner_reg_no = ""; // 채번(MAX+1)
		dataJson.cleaner_reg_rev = 0;
		dataJson.cleaner_reg_date = $("#txt_cleaner_reg_date").val();
		dataJson.part_cd = $("#txt_part_cd").val();
		dataJson.part_cd_rev = $("#txt_part_cd_rev").val();
		dataJson.cleaner_usage = $("#txt_cleaner_usage").val();
		dataJson.ipgo_amt = ""; // 입고테이블에서 불러옴
		dataJson.usage_amt = usage_amt;
		dataJson.store_amt = ""; // 쿼리문에서 계산

		dataJson.write_dept = $("#txt_write_dept").val();
		dataJson.writor_main = $("#txt_writor_main").val();
		dataJson.writor_main_rev = $("#txt_writor_main_rev").val();
		dataJson.approval = "";
		dataJson.approval_date = write_date;
		dataJson.bigo = $("#txt_bigo").val();
		
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)   return;
		
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
	
	function pop_fn_PartStorage_View(obj) {
		var vPartGubunB = ""; // part_gubun 세척제 코드 정해지면 변경
		var vPartGubunM = ""; // part_gubun 세척제 코드 정해지면 변경
		var vPartGubunS = ""; // part_gubun 세척제 코드 정해지면 변경
		
		var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Tablet/M838/T838S050520.jsp"
							 + "?part_gubun_b=" + vPartGubunB
							 + "&part_gubun_m=" + vPartGubunM
							 + "&part_gubun_s=" + vPartGubunS ;
    	pop_fn_popUpScr_nd(modalContentUrl, obj.innerText + "(T838S050520)", '40%', '90%');
		return false;
	}

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
            	<input type="text" class="form-control" id="txt_cleaner_reg_date" style="width: 200px; float:left;" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>세척소독제명</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_part_nm" readonly style="width: 200px; float:left;"></input>
				<input type="hidden" class="form-control" id="txt_part_cd" readonly/>
				<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly/>
				<button type="button" onclick="pop_fn_PartStorage_View(this)" id="btn_SearchCust" class="btn btn-info" >
					세척소독제 검색
				</button>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>사용용도</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_cleaner_usage" style="width: 200px; float:left;" />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>사용량</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_usage_amt" style="width: 200px; float:left;" />
            	<p style="float:left;">( 재고량 :</p> 
            	<input type="text" class="form-control" id="txt_store_amt" value=0 readonly 
            		style="width: 100px; float:left;" ></input>
            	<p style="float:left;">)</p>
            	<input type="hidden" class="form-control" id="txt_ipgo_amt" value=0 readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>비고</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_bigo" style="width: 200px; float:left;"></input>
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
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>

    </table>
<!-- </form>     -->
</body>
</html>