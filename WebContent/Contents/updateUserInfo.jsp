<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html>
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String login_name = session.getAttribute("login_name").toString();

	
	String GV_USER_ID="", GV_REVISION_NO="";

	if(request.getParameter("user_id") != null)
		GV_USER_ID = request.getParameter("user_id");
	
	if(request.getParameter("RevisionNo") != null)
		GV_REVISION_NO = request.getParameter("RevisionNo");

	JSONObject jArray = new JSONObject();
	jArray.put("user_id", loginID);
		
		
%>
 
	<!-- Theme style -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/css/adminlte.min.css">
	
	<!-- Daterange picker -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.css">
	<!-- summernote -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/summernote/summernote-bs4.css">
	
	<!-- Henesys Icon -->
	<link rel="shotcut icon" type="image/x-icon" href="<%=Config.this_SERVER_path%>/images/henesys.jpg"/>
	<!-- SweetAlert2 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.css">
	<!-- SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.js"></script>
	<!-- Customized SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/js/sweetalert.custom.js"></script>
	
 	<!-- DataTables -->
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/css/select.bootstrap4.min.css">
    
  	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css">
  	<!-- Henesys CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/css/henesys.css">
  	
 	<!-- jQuery -->
 	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.js"></script>
 	<!-- Canvas 공통함수 부분 -->
	<script src="<%=Config.this_SERVER_path%>/js/canvas.comm.func.js"></script>
  	
	<!-- DataTables -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables/jquery.dataTables.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/js/dataTables.select.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
	
	<!-- For DataTables Default Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/datatables.custom.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>
	
	<!-- daterangepicker -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/moment/moment.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.js"></script>
	
	<!-- Henedate -->
	<script src="<%=Config.this_SERVER_path%>/js/setdate.js"></script>
	
	<!-- User -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/user.js"></script>
       
<script>

    //모든 공백 체크 정규식
	var empJ = /\s/g;
	//아이디 정규식
	var idJ = /^[a-z0-9]{4,12}$/; // a~z, 0~9로 시작하는 4~12자리 아이디를 만들 수 있다.
	// 비밀번호 정규식
//	var pwJ = /^[A-Za-z0-9]{8,20}$/;  // A~Z, a~z, 0~9로 시작하는 8자리~20자리 비밀번호를 설정할 수 있다.
	var pwJ = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$~`!@#$%\^&*()-+=])[A-Za-z\d$~`!@#$%\^&*()-+=]{8,20}$/; // A~Z, a~z, 0~9, 특수문자로 시작하는 8자리~20자리 비밀번호를 설정할 수 있다.
	// /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!~%^*#?&-_=])[A-Za-z\d$@$!~%^*#?&-_=]{8,20}$/ --> 이건 왜 안되지?
			
	// 이름 정규식
	var nameJ = /^[가-힣]{2,6}$/; // 가~힣 한글로 이뤄진 문자만으로 2~6자리 이름을 적어야 한다.
	// 이메일 검사 정규식
	var mailJ = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i; // 위와 비슷한데 특수문자가 가능하며 중앙아 @ 필수 그리고 뒤에 2~3글자가 필요하다
	// 휴대폰 번호 정규식
	var phoneJ = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/; /// - 생략하고 01?(3글자) 방식으로 나머지 적용해서 보면 된다.
	
	// sweetalert 객체 생성
	let heneSwal = new SweetAlert();		
			
	function SaveOderInfo() {
		if ($('#txt_PassWord_Old').val().length < 1) {
			alert("기존 패스워드를 입력하세요.");
			return;
		}
		if ($('#txt_PassWord_New').val().length < 1) {
			alert("새 패스워드를 입력하세요.");
			return;
		}

   		var dataJson = new Object(); // jSON Object 선언 
			dataJson.UserName = $('#txt_UserName').val();
			dataJson.HpNo = $('#txt_HpNo').val();
			dataJson.Email = $('#txt_Email').val();
			dataJson.PassWord_Old = $('#txt_PassWord_Old').val();
			dataJson.PassWord_New = $('#txt_PassWord_New').val();
	        dataJson.user_id = "<%=loginID%>";
		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn){		
	        SendTojsp(JSON.stringify(dataJson), "M909S080100E020");
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html> 0){
	                parent.$("#ReportNote").children().remove();
	                heneSwal.successTimer('개인정보가 수정 되었습니다.');
	                
	                setTimeout(function(){window.close();}, 250);
	         	}
	        	 else{
	        		 heneSwal.error('개인정보 수정에 실패하였습니다. 다시 시도해주세요.');
	        	 }
	         },
	         error: function (xhr, option, error) {
	        	 heneSwal.error('개인정보 수정에 실패하였습니다. 다시 시도해주세요.');
	         }
	     });		
	}
	
	var users;
    
    $(document).ready(function () {
    	
    	async function initData() {
    		var user = new HENESYS_API.User();
	    	var userList = await user.getSelectedUsers('<%=loginID%>');
	    	console.log(userList);
	    	users = userList;
	    	console.log(users);
    	}
    	console.log(users);
    	
	    $("#select_DocGubunCode").on("change", function(){
	    	docGubunCode = $(this).val();
	    });
	    
	 	// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
//	 	비밀번호 유효성 검사
//	 	1-1 정규식 체크
		$("#txt_PassWord_New").keyup(function(){
			var PassWord = $('#txt_PassWord_New').val();
			if(pwJ.test(PassWord)) {
				$("#pw_check_new").text("비밀번호 사용이 가능합니다.");
				$("#pw_check_new").css('color', 'green');
				$("#btn_Save").attr("disabled", false);
			}else if(PassWord == ""){
				$("#pw_check_new").text("비밀번호를 입력해주세요 :)");
				$("#pw_check_new").css('color', 'red');
				$("#btn_Save").attr("disabled", true);	
			}
			else{
				$("#pw_check_new").text("영문자, 숫자, 특수문자로 조합된 8~20자리만 가능합니다 :) ");
				$("#pw_check_new").css('color','red');
				$("#btn_Save").attr("disabled", true);	
			}
		});
	 	
    });
    </script>
</head>

<section class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<div class="card card-info">
                    <div class="card-header"> 
                     <h3 class="card-title">개인정보 수정</h3>
                    </div> <!-- card-header -->
                    <div class="card-body">
   
   <table class="table table-hover">
        
        <tr>
            <td style = "width:25%;">아이디</td>
            <td><input type="text" class="form-control" id="txt_UserCode" value="" readonly>
           	</td>
        </tr>
        
        <tr>
            <td>이름</td>
            <td><input type="text" class="form-control" id="txt_UserName" value="" readonly>
           	</td>
        </tr>
        
        <tr>
            <td>기존 패스워드</td>
            <td><input type="password" class="form-control" id="txt_PassWord_Old">
            		<div class="check_font" id="pw_check_old"></div>
           	</td>
        </tr>
        
        <tr>
            <td>새 패스워드</td>
            <td ><input type="password" class="form-control" id="txt_PassWord_New">
            		<div class="check_font" id="pw_check_new"></div>
           	</td>
        </tr>
        
        <!-- <tr>
            <td>휴대폰번호</td>
            <td><input type="text" class="form-control" id="txt_HpNo" value="" autocomplete="off"/>
           	</td>
        </tr>
        
        <tr>
            <td>이메일주소</td>
            <td><input type="text" class="form-control" id="txt_Email" value="" autocomplete="off"/>
           	</td>
        </tr>
 -->
      		<tr>
          		<td colspan = 2>
              		<p style = "margin: 0 40%;">
	              		<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>
	                    <button id="btn_Canc" class="btn btn-info" onclick="window.close();">취소</button>
              		</p>
          		</td>
      		</tr>
  		</table>
 					</div> <!-- card-body  -->
				</div> <!-- card card-info -->
			</div> <!-- col-md-6 -->
		</div> <!-- row -->
	</div> <!-- container-fluid -->
</section> <!-- content -->