<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
    Config.this_SERVER_path = request.getContextPath();
	
	//login.jsp에서 에러나서(아이디/비번틀려서) 다시 index.jsp로 온 경우, 구분변수
	String GV_INVALID_LOGIN = "";  

	if(request.getParameter("invalid_login") == null) {
		GV_INVALID_LOGIN = "";		
	} else {
		GV_INVALID_LOGIN = request.getParameter("invalid_login");		
	}
%>

<!DOCTYPE html>

<html>
<head id="Head1">
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Tell the browser to be responsive to screen width -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<title>SMART HACCP - 로그인</title>
	<!-- Henesys Icon -->
	<link rel="shotcut icon" type="image/x-icon" href="<%=Config.this_SERVER_path%>/images/henesys.jpg"/>
	<!-- Font Awesome -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/fontawesome-free/css/all.min.css">
	<!-- Ionicons -->
	<link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
	<!-- iCheck -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
	<!-- Theme style -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/css/adminlte.min.css">
	<!-- Google Font: Source Sans Pro -->
	<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
	<!-- SweetAlert2 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.css">
</head>

<body id="MainBody" class="hold-transition login-page">
	<div class="login-box">
	  	<div class="login-logo">
	    	<b>SMART HACCP</b> SYSTEM
	    	<!-- <img src="images/wonwoo_logo.jpg" alt="HACCP System" style = "width:360px;"> -->
	  	</div>
	  	<!-- /.login-logo -->
	  	<div class="card">
	    	<div class="card-body login-card-body">
	      		<p class="login-box-msg">SMART HACCP SYSTEM 로그인 합니다</p>
	
	      		<form id ="Loginfrm" name="Loginfrm" action="login.jsp" method="post">
	        		<div class="input-group mb-3">
						<input type="text" name="login_id" id="login_id" class="form-control" placeholder="아이디">
						<input type="hidden" name="login_id_enc" id="login_id_enc" class="w211" value="">
	          			<div class="input-group-append">
	            			<div class="input-group-text">
	              				<span class="fas fa-user"></span>
	            			</div>
	          			</div>
	        		</div>
			        <div class="input-group mb-3">
			          <input type="password" name="login_pw" id="login_pw" class="form-control" placeholder="비밀번호">
			          <input type="hidden" name="login_pw_enc" id="login_pw_enc" class="w211" value="">
			          <div class="input-group-append">
			            <div class="input-group-text">
			              <span class="fas fa-lock"></span>
			            </div>
			          </div>
			        </div>
	        		<div class="row">
	          			<div class="col-8">
	            			<div class="icheck-primary">
	              				<input type="checkbox" id="remember">
	              				<label for="remember">
	                       			로그인 정보 저장
	              				</label>
	            			</div>
	          			</div>
	          			<!-- /.col -->
	          			<div class="col-4">
				            <button type="button" name="btn_login" id="btn_login" class="btn btn-primary btn-block" onclick="doLogin()">
				            	로그인
				            </button>
	          			</div>
	          			<!-- /.col -->
	        		</div>
	        		
    				<input type="hidden" name="subdomain" id="subdomainId" value="">
				</form>
	    	</div>
	    	<!-- /.login-card-body -->
		</div>
	</div>
	<!-- /.login-box -->

	<!-- jQuery -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.min.js"></script>
	<!-- Bootstrap 4 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
	<!-- AdminLTE App -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/js/adminlte.min.js"></script>
	<!-- SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.js"></script>
	<!-- Customized SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/js/sweetalert.custom.js"></script>
	
	<script type="text/javascript">

		// sweetalert 객체 생성
		let heneSwal = new SweetAlert();
			
		$(document).ready(function () {
			
			// set subdomain
			var subdomain =  window.location.host.split('.')[1] ? window.location.host.split('.')[0] : false;
			
			// for dev env
			if( window.location.host.split(':')[0] === 'localhost' ) {
				subdomain = 'henesys';
			}
			
			console.log('subdomain:' + subdomain);
			$("#subdomainId").val(subdomain);
			
			//login.jsp에서 에러나서(아이디/비번틀려서) 다시 index.jsp로 온 경우
			if("<%=GV_INVALID_LOGIN%>".length > 0 && "<%=GV_INVALID_LOGIN%>" == "y") { 
				heneSwal.error("아이디 또는 비밀번호가 틀립니다.")
			}
			
			if("<%=GV_INVALID_LOGIN%>".length > 0 && "<%=GV_INVALID_LOGIN%>" == "yy") { 
				heneSwal.error("로그인을 먼저 하시고 접속해 주세요.")
			}
			
			$("#MainBody").keydown(function(key) { // 엔터키 누르면 로그인
				if (key.keyCode == 13) {
					doLogin()
				}
			});
		    
		    var userInputId = getCookie("userInputId");	// 저장된 쿠기값 가져오기
		    $("input[name='login_id']").val(userInputId); 
		    
			// 그 전에 ID를 저장해서 처음 페이지 로딩
			// 아이디 저장하기 체크되어있을 시 ID 저장하기를 체크 상태로 두기
		    if($("input[name='login_id']").val() != "") { 
		        $("#remember").attr("checked", true);
		    }
		     
		    $("#remember").change(function(){ // 체크박스에 변화가 발생시
		        if($("#remember").is(":checked")){ // ID 저장하기 체크했을 때,
		            var userInputId = $("input[name='login_id']").val();
		            setCookie("userInputId", userInputId, 30); // 30일 동안 쿠키 보관
		        } else { // ID 저장하기 체크 해제 시,
		            deleteCookie("userInputId");
		        }
		    });
		    
		    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
		    $("input[name='login_id']").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
		        if($("#remember").is(":checked")){ // ID 저장하기를 체크한 상태라면,
		            var userInputId = $("input[name='login_id']").val();
		            setCookie("userInputId", userInputId, 30); // 30일 동안 쿠키 보관
		        }
		    });
		    
		});
	
		function LoginInit() {
		    var getCookieValue = getLoginCookie();
		    if (getCookieValue.length > 0) {
		        document.Loginfrm.login_id.value = getCookieValue; //나중에 복원
		        document.Loginfrm.saveId.checked = true;
		    } else {
		        document.Loginfrm.saveId.checked = false;
		    }
		}
	
		//로그인시
		function doLogin() {
		    var _login_id = $("#login_id").val().toString();
		    var _login_pw = $("#login_pw").val().toString();
		
		    var str = $("#login_id").val();
		    var err = 0;
		
		    for (var i = 0; i < str.length; i++) {
		        var chk = str.substring(i, i + 1);
		        if (!chk.match(/[0-9]|[a-z]|[A-Z]/)) {
		            err = err + 1;
		        }
		    }
			
		    if (err > 0) {
		        ("숫자 및 영문만 입력가능합니다.");
		        $("#login_id").val("");
		        return false;
		    }
		
		    if (_login_id == null || _login_id.length == 0) {
		        heneSwal.warning("아이디를 입력하세요");
		        $("#login_id").focus();
		        return false;
		    } else if (_login_pw == null || _login_pw.length == 0) {
		        heneSwal.warning("비밀번호를 입력하세요");
		        $("#login_pw").focus();
		        return false;
		    }
		
		    //체크 박스에 선택이 되었을경우 ID 저장
		    var viewstate = "login_id";
		    var vlogin_id  = $("#login_id").val().toString();
		    var vpass_word = $("#login_pw").val().toString();
		    
		    //암호화
		    var vlogin_id_code = Encrypt(vlogin_id);
		    var vpass_word_code = Encrypt(vpass_word);
		    
		    var vlogin_id_enc = new Array();
		 	var vpass_word_enc = new Array();
		 	var vlogin_id_enc_string = '';
		 	var vpass_word_enc_string = '';
		 	
		 	for(i = 0; i < vlogin_id_code.length; i++) {
		 		vlogin_id_enc[i] = ('0000' + (vlogin_id_code.charCodeAt(i))).slice(-4);
		 		vlogin_id_enc_string += vlogin_id_enc[i];
		 	}
		 	
		 	for(i = 0; i < vpass_word_code.length; i++) {
		 		vpass_word_enc[i] = ('0000' + (vpass_word_code.charCodeAt(i))).slice(-4);
		  		vpass_word_enc_string += vpass_word_enc[i];
		 	}
		    
		    $("#login_id_enc").val(vlogin_id_enc_string);
		    $("#login_pw_enc").val(vpass_word_enc_string);
		
		    var loginform = $('#Loginfrm');
		    
		    loginform.submit();
		    
		    return true;
		}
	      
		function Encrypt(theText) {
		    output = new String;
		    Temp = new Array();
		    Temp2 = new Array();
		    TextSize = theText.length;
		    for (i = 0; i < TextSize; i++) {
		        rnd = Math.round(Math.random() * 122) + 68;
		        Temp[i] = theText.charCodeAt(i) + rnd;
		        Temp2[i] = rnd;
		    }
		    for (i = 0; i < TextSize; i++) {
		        output += String.fromCharCode(Temp[i], Temp2[i]);
		    }
		    return output;
		}
	
		function unEncrypt(theText) {
		    output = new String;
		    Temp = new Array();
		    Temp2 = new Array();
		    TextSize = theText.length;
		    for (i = 0; i < TextSize; i++) {
		        Temp[i] = theText.charCodeAt(i);
		        Temp2[i] = theText.charCodeAt(i + 1);
		    }
		    for (i = 0; i < TextSize; i = i+2) {
		        output += String.fromCharCode(Temp[i] - Temp2[i]);
		    }
		    return output;
		}
	      
		function urlencode(str) {
		    str = (str + '').toString();
		    return encodeURIComponent(str)
		        .replace(/!/g, '%21')
		        .replace(/'/g, '%27')
		        .replace(/\(/g, '%28')
		        .replace(/\)/g, '%29')
		        .replace(/\*/g, '%2A')
		        .replace(/%20/g, '+');
		}
		
		function setCookie(cookieName, value, exdays){
		    var exdate = new Date();
		    exdate.setDate(exdate.getDate() + exdays);
		    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
		    document.cookie = cookieName + "=" + cookieValue;
		}
		 
		function deleteCookie(cookieName){
		    var expireDate = new Date();
		    expireDate.setDate(expireDate.getDate() - 1);
		    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
		}
		 
		function getCookie(cookieName) {
		    cookieName = cookieName + '=';
		    var cookieData = document.cookie;
		    var start = cookieData.indexOf(cookieName);
		    var cookieValue = '';
		    if(start != -1){
		        start += cookieName.length;
		        var end = cookieData.indexOf(';', start);
		        if(end == -1)end = cookieData.length;
		        cookieValue = cookieData.substring(start, end);
		    }
		    return unescape(cookieValue);
		}
	</script>
</body>
</html>