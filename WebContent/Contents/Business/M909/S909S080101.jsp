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
	
	/* String initialPassword = ProjectConstants.INITIAL_PASSWORD; */
%>

<script>
	
	$(document).ready(function () {
				
		$('#btn_Save').click(function() {
			insertNewUser();
		});
		
		function insertNewUser() {
			
			if ($('#userId').val().length < 1) {
				heneSwal.warning("아이디를 입력해주세요");
				return false;
			}
			
			if ($('#password').val().length < 1) {
				heneSwal.warning("비밀번호를 입력해주세요");
				return false;
			}
			
			if ($('#name').val().length < 1 || $('#name').val().trim() == "") {
				heneSwal.warning("이름을 입력해주세요");
				return false;
			}

	   		var dataJson = new Object();
	  		
	   		dataJson.member_key = "<%=member_key%>";
			dataJson.userId = $('#userId').val();
			dataJson.name = $('#name').val();
			dataJson.tel = $('#tel').val();
			dataJson.email = $('#email').val();
			dataJson.userGroupCode = $("#select_UserGroupCode option:selected").val();
			dataJson.userDeptCode = $("#select_UserDeptCode option:selected").val();
			dataJson.password = $("#password").val();
		    dataJson.createUserId = "<%=loginID%>";
			    
			var confirmed = confirm("등록하시겠습니까?"); 
				
			if(confirmed){
				$.ajax({
			         type: "POST",
			         dataType: "json",
			         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			         data: "bomdata=" + JSON.stringify(dataJson) + 
			         	   "&pid=" + "M909S080100E101",
			         success: function (html) {
			        	 if(html > -1) {
			        	   	parent.fn_MainInfo_List();
			                $('#modalReport').modal('hide');
			                heneSwal.success('사용자 정보가 등록 되었습니다. <br> 사용자 프로그램 권한 관리에서 프로그램 권한을 추가하셔야 등록하신 사용자로 이용이 가능해집니다.');
			         	} else {
			         		heneSwal.warning('사용자 정보 등록에 실패했습니다.');
			         	}
			         }
				});
			}
		}
	    
	 	// 아이디 유효성 검사(1 = 중복 / 0 != 중복)
		$("#userId").blur(function() {
			// 정규식 : a~z, 0~9로 시작하는 4~12자리 아이디를 만들 수 있다.
			var idJ = /^[a-z0-9]{4,12}$/;
			
			var userId = $('#userId').val().trim();
			
			$.ajax({
				url : "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S080104.jsp",
				type : 'POST',
		        data: "user_id=" + userId,
				success : function(data) {
					if (data >= 1) {
							// 1 : 아이디가 중복되는 문구
							$("#id_check").text("사용 중인 아이디입니다");
							$("#id_check").css("color", "red");
							$("#btn_Save").attr("disabled", true);
					} else {
						if(idJ.test(userId)) {
							// 0 : 아이디 길이 / 문자열 검사
							$("#id_check").text("");
							$("#btn_Save").attr("disabled", false);
						} else if(userId == "") {
							$('#id_check').text("아이디를 입력해주세요");
							$('#id_check').css('color', 'red');
							$("#btn_Save").attr("disabled", true);				
						} else {
							$('#id_check').text("아이디는 소문자와 숫자 4~12자리만 가능합니다");
							$('#id_check').css('color', 'red');
							$("#btn_Save").attr("disabled", true);
						}
						
					}
				}
			});
		});
	 	
//	 	비밀번호 유효성 검사
//	 	1-1 정규식 체크
		$("#password").keyup(function(){
			
			var pwJ = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$~`!@#$%\^&*()-+=])[A-Za-z\d$~`!@#$%\^&*()-+=]{8,20}$/; // A~Z, a~z, 0~9, 특수문자로 시작하는 8자리~20자리 비밀번호를 설정할 수 있다.
			var PassWord = $('#password').val();
			
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
   
<table class="table table-hover">
     <tr>
        <td style = "width:22%;">
			<label for="userId">아이디</label>
		</td>
        <td>
        	<input type="text" class="form-control" id="userId" name="userId">
			<div class="check_font" id="id_check"></div>
    	</td>
    </tr>
     
	<tr>
		<td>
			<label for="password">비밀번호</label>
		</td>
		<td>
         	<input type="password" class="form-control" id="password" name="password">
         		   <div class="check_font" id="pw_check_new"></div>
		</td>
     </tr>

     <tr>
        <td>
			<label for="name">이름</label>
		</td>
        <td>
         	<input type="text" class="form-control" id="name" name="name">
		</td>
     </tr>
     
	<tr>
		<td>
			<label for="tel">휴대전화</label>
		</td>
		<td>
			<input type="tel" id="tel" name="tel" class="form-control" 
				   placeholder="010-1234-5678" pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}" required>
        </td>
	</tr>
	<tr>
		<td>
			그룹코드
		</td>
		<td>
			<select class="form-control" id="select_UserGroupCode">
				<% optCode = (Vector)UserGroupVector.get(0);%>
				<% optName = (Vector)UserGroupVector.get(1);%>
				<% for(int i=0; i<optName.size();i++){ %>
					<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
				<% } %>
			</select>
		</td>
	</tr>
     
	<tr>
		<td>
			부서
		</td>
        <td>
			<select class="form-control" id="select_UserDeptCode">
		    	<% deptCode = (Vector)UserDeptVector.get(0);%>
		    	<% deptName = (Vector)UserDeptVector.get(1);%>
		        <% for(int i=0; i<deptName.size();i++){ %>
					<option value='<%=deptCode.get(i).toString()%>'>
						<%=deptName.get(i).toString()%>
					</option>
				<% } %>
			</select>
		</td>
	</tr>
 </table>