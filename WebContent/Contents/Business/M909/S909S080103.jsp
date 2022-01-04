<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;
	Vector UserGroupVector = CommonData.getUserGroupData(member_key); 

	Vector deptCode =  null;
    Vector deptName =  null;
	Vector UserDeptVector = CommonData.getDeptCode(member_key);
	
	String[] strColumnHead = {"사용자ID", "개정번호", "사용자명", "휴대폰번호", "이메일주소", "직위", "그룹코드", //0~6
								"패스워드","위치", "부서코드", "delyn", // 7 ~10
								"적용시작일자", "적용종료일자", "create_user_id", "create_date",  //11 ~ 14
								"modify_user_id", "modify_reason", "modify_date"} ;	// 15 ~ 17
	
	String GV_USER_ID="", GV_REVISION_NO="";

	if(request.getParameter("user_id")== null)
		GV_USER_ID="";
	else
		GV_USER_ID = request.getParameter("user_id");
	
	if(request.getParameter("RevisionNo")== null)
		GV_REVISION_NO="";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");

	String param = GV_USER_ID + "|" + GV_REVISION_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "USER_ID", GV_USER_ID);
	jArray.put( "REVISION_NO", GV_REVISION_NO);
		
    TableModel = new DoyosaeTableModel("M909S080100E204", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
		
    // 데이터를 가져온다.
    Vector targetVector = (Vector)(TableModel.getVector().get(0));


    // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    try {
		revisionNoInt = Integer.parseInt( targetVector.get(1).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt;
		
%>
 
<jsp:include page="../../Common/linkcss_js.jsp" flush="false"/>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S080100E102 = {
			PID: "M909S080100E010",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S080100E010",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var docGubunCode = "";
    var JOB_GUBUN = "";
    
    //모든 공백 체크 정규식
	var empJ = /\s/g;
	//아이디 정규식
	var idJ = /^[a-z0-9]{4,12}$/; // a~z, 0~9로 시작하는 4~12자리 아이디를 만들 수 있다.
	// 비밀번호 정규식
	var pwJ = /^[A-Za-z0-9]{8,20}$/;  // A~Z, a~z, 0~9로 시작하는 8자리~20자리 비밀번호를 설정할 수 있다.
	// 이름 정규식
	var nameJ = /^[가-힣]{2,6}$/; // 가~힣 한글로 이뤄진 문자만으로 2~6자리 이름을 적어야 한다.
	// 이메일 검사 정규식
	var mailJ = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i; // 위와 비슷한데 특수문자가 가능하며 중앙아 @ 필수 그리고 뒤에 2~3글자가 필요하다
	// 휴대폰 번호 정규식
	var phoneJ = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/; /// - 생략하고 01?(3글자) 방식으로 나머지 적용해서 보면 된다.
	
	function SetRecvData(){
		DataPars(M909S080100E102, GV_RECV_DATA);
 		if(M909S080100E102.retnValue > 0)
 			alert('수정 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#txt_UserCode').val().length < 1) {
			alert("사용자코드를 입력하세요.");
			return;
		}
		if ($('#txt_UserName').val().length < 1) {
			alert("사용자명을 입력하세요.");
			return;
		}

   		var dataJson = new Object();
   		
  		dataJson.member_key = "<%=member_key%>";
		dataJson.UserCode = $('#txt_UserCode').val();
		dataJson.RevisionNo = $('#txt_RevisionNo').val();
		dataJson.UserName = $('#txt_UserName').val();
		dataJson.HpNo = $('#txt_HpNo').val();
		dataJson.Email = $('#txt_Email').val();
		dataJson.Jikwi = $('#txt_Jikwi').val();
		dataJson.hour_pay = $('#txt_hour_pay').val(); // 2019-11-28 진욱추가
		dataJson.UserGroupCode = $("#select_UserGroupCode option:selected").val();
		dataJson.UserDeptCode = $("#select_UserDeptCode option:selected").val();
		dataJson.PassWord = $('#txt_PassWord').val();
        dataJson.StartDate = $('#startDate').val();
        dataJson.user_id = "<%=loginID%>";
        dataJson.RevisionNo_Target = "<%=targetVector.get(1).toString() %>";
        
		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn){		
	        SendTojsp(JSON.stringify(dataJson), "M909S080100E010");
		}
	}
	
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         }
	     });		
	}
	
    
    $(document).ready(function () {
		
    	new SetSingleDate2("","#startDate",0);
    	
    	$('#startDate').val("<%=targetVector.get(12).toString()%>");

	    $("#select_DocGubunCode").on("change", function(){
	    	docGubunCode = $(this).val();
	    });
	    
	 	// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
    });

    function SetDocName_code(name, code){
		$('#txt_DocName').val(name);
		$('#txt_DocCode').val(code);
    }
    
	// 	비밀번호 유효성 검사
	// 	1-1 정규식 체크
	$("#txt_PassWord").blur(function(){
		
		var PassWord = $('#txt_PassWord').val();
		
		if(pwJ.test(PassWord)) {
			console.log('true');
			$("#pw_check").text("");
			$("#btn_Save").attr("disabled", false);
		} else if(PassWord == ""){
			console.log('false');
			$("#pw_check").text("비밀번호를 입력해주세요 :)");
			$("#pw_check").css('color', 'red');
			$("#btn_Save").attr("disabled", true);	
		} else{
			console.log('false');
			$("#pw_check").text("숫자 or 문자로만 숫자 8~20자리만 가능합니다 :) ");
			$("#pw_check").css('color','red');
			$("#btn_Save").attr("disabled", true);	
		}
	});

    </script>
</head>
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
   		<!--
        <tr style="background-color: #fff; height: 40px">
            <td style="width: 25%; font-weight: 900; font-size:14px; text-align:left">주문 고객사</td>
            <td style="width: 2%; font-weight: 900; font-size:14px; text-align:left"> </td>
            <td style="width: 73%; font-weight: 900; font-size:14px; text-align:left">
				<input type="text" class="form-control" id="txt_CustName" style="width: 150px; float:left"  />
				<input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" />
				<label style="float:left">&nbsp;</label>
				<button type="button" onclick="parent.pop_fn_CustName_View(1,'O')" id="btn_SearchCust" class="btn btn-info" style="float:left">
				    고객사검색</button> 
           	</td>
        </tr>
        -->
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">사용자ID</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_UserCode" style="width: 200px; float:left" 
            		value="<%=targetVector.get(0).toString()%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">패스워드</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_PassWord" style="width: 200px; float:left" 
            		value="<%=targetVector.get(7).toString()%>" />
            		<div class="check_font" id="pw_check"></div>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">사용자명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_UserName" style="width: 200px; float:left" 
            		value="<%=targetVector.get(2).toString()%>" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">휴대폰번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_HpNo" style="width: 200px; float:left" 
            		value="<%=targetVector.get(3).toString()%>" />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">이메일주소</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Email" style="width: 200px; float:left" 
            		value="<%=targetVector.get(4).toString()%>" />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">직위</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_Jikwi" style="width: 200px; float:left" 
            		value="<%=targetVector.get(5).toString()%>" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">시급</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_hour_pay" style="width: 200px; float:left" 
            		value="<%=targetVector.get(10).toString()%>" numberOnly />
           	</td>
        </tr>

        <tr style="height: 40px">
            <td style="font-weight:900;">그룹코드</td>
            <td></td>
            <td >
				<select class="form-control" id="select_UserGroupCode" style="width: 200px">
	            	<%	optCode =  (Vector)UserGroupVector.get(0);%>
	                <%	optName =  (Vector)UserGroupVector.get(1);%>
	                <%for(int i=0; i<optName.size();i++){ %>
						<option value='<%=optCode.get(i).toString()%>' 
							<%=targetVector.get(6).toString().equals(optCode.get(i).toString()) ? "selected" : "" %> > 
							<%=optName.get(i).toString()%>	
						</option>
					<%} %>
				</select>
            </td>
        </tr>
        
        <tr style="height: 40px">
            <td style="font-weight:900;">부서</td>
            <td></td>
            <td >
				<select class="form-control" id="select_UserDeptCode" style="width: 200px">
	            	<%	deptCode =  (Vector)UserDeptVector.get(0);%>
	                <%	deptName =  (Vector)UserDeptVector.get(1);%>
	                <%for(int i=0; i<deptName.size();i++){ %>
	                	<option value='<%=deptCode.get(i).toString()%>' 
							<%=targetVector.get(9).toString().equals(deptCode.get(i).toString()) ? "selected" : "" %> > 
							<%=deptName.get(i).toString()%>	
						</option>
					<%} %>
				</select>
            </td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" style="width: 200px; float:left" 
            		value="<%=revisionNumberStr%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">적용시작일자</td>
            <td> </td>
            <td >
            	<input type="text" data-date-format="yyyy-mm-dd" id="startDate" class="form-control"
                	style="width: 220px; border: solid 1px #cccccc;"/>
            		
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
</html> --%>








<%@page import="java.io.FileReader"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

    Vector optCode = null;
    Vector optName = null;
	Vector UserGroupVector = CommonData.getUserGroupData(member_key);
	
	Vector deptCode = null;
    Vector deptName = null;
	Vector UserDeptVector = CommonData.getDeptCode(member_key);
	
	String GV_USER_ID = "", GV_REVISION_NO = "";

	if(request.getParameter("user_id") != null)
		GV_USER_ID = request.getParameter("user_id");
	
	if(request.getParameter("RevisionNo") != null)
		GV_REVISION_NO = request.getParameter("RevisionNo");

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("USER_ID", GV_USER_ID);
	jArray.put("REVISION_NO", GV_REVISION_NO);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S080100E204", jArray);
		
    Vector user = (Vector)(TableModel.getVector().get(0));
%>

<script>
	
	$(document).ready(function () {
		
		$('#btnDelete').click(function() {
			deleteUser();
		});
		
		function deleteUser() {

	   		var dataJson = new Object();
	  		
	   		dataJson.member_key = "<%=member_key%>";
			dataJson.userId = "<%=GV_USER_ID%>";
			dataJson.RevisionNo_Target = "<%=GV_REVISION_NO%>";
			
			var confirmed = confirm("삭제하시겠습니까?"); 
				
			if(confirmed) {
				$.ajax({
			         type: "POST",
			         dataType: "json",
			         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			         data: "bomdata=" + JSON.stringify(dataJson) + "&pid=M909S080100E103",
			         success: function (rcvData) {
			        	 if(rcvData > -1) {
			                $('#modalReport').modal('hide');
			        	   	parent.fn_MainInfo_List();
			        	   	heneSwal.success("사용자 정보 삭제가 완료되었습니다.");
			         	} else {
			        	   	heneSwal.error("사용자 정보 삭제에 실패했습니다.");
			         	}
			         }
				});
			}
		}
	});
	
</script>
   
<table class="table table-hover">
	<tr>
        <td>
			<label for="userId">아이디</label>
		</td>
        <td></td>
        <td>
        	<input type="text" class="form-control" id="userId" name="userId" 
        		   readonly value="<%=user.get(0).toString()%>">
		</td>
	</tr>

     <tr>
        <td>
			<label for="name">이름</label>
		</td>
        <td></td>
        <td>
         	<input type="text" class="form-control" id="name" name="name" readonly value="<%=user.get(2).toString()%>">
		</td>
	</tr>
</table>