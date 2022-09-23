<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<style>
	.being-red{
		color:red;
	}
	.being-black{
		color:black;
	}
</style>

<script type="text/javascript">
    
    var idCheckVal = 0;
    var pwdCheckVal = 0;
    
	$(document).ready(function () {
		
		let mainTable;
		
	    async function initTable() {
	    	var user = new HENESYS_API.User();
	    	var userList = await user.getUsers();
	    	
		    var customOpts = {
					data : userList,
					pageLength: 10,
					columns: [
						{ data: "userId", defaultContent: '' },
						{ data: "userName", defaultContent: '' },
						{ data: "authority", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#userTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
		    
		    //$("#authority option:eq(0)").attr("selected", "selected");
	    }
	    
	    async function refreshMainTable() {
	    	var user = new HENESYS_API.User();
	    	var userList = await user.getUsers();
	    	
    		mainTable.clear().rows.add(userList).draw();
		}
	    
	    var initModal = function () {
	    	$('#user-id').val('');
	    	$('#user-name').val('');
	    	$('#password').val('');
	    	$('#authority').val('');
	    	
	    	$('#user-id').prop('disabled', false);
	    	$('#id-check-msg').text('');
	    	$('#pwd-check-msg').text('');
	    };
	     
		initTable();
		//$("#authority option:eq(0)").attr("selected", "selected");

		function CV_checkIdPattern(str){
			var pattern1 = /[0-9]/; // 숫자
			var pattern2 = /[a-zA-Z]/; // 문자
			var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
			var pattern4 = /[ㄱ-ㅎㅏ-ㅣ가-힣]/g; // 한글
			var numtextyn = (pattern1.test(str) || pattern2.test(str));
			if(!numtextyn || pattern3.test(str) || pattern4.test(str) || str.length > 16) {
				//alert("아이디는 16자리 이하 영문자 또는 숫자로만 구성하여야 합니다.");
				return false;
			} else {
				return true;
			}
		}
		
		function CV_checkPasswordPattern(str) {
			var pattern1 = /[0-9]/; // 숫자
			var pattern2 = /[a-zA-Z]/; // 문자
			var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
			if(!pattern1.test(str) || !pattern2.test(str) || !pattern3.test(str) || str.length < 8) {
				$('#pwd-check-msg').text('비밀번호는 8자리 이상 문자, 숫자, 특수문자로 구성하여야 합니다.');
        		$('#pwd-check-msg').attr('class', 'input-group mb-3 being-red');
        		pwdCheckVal = 0;
				return false;
			} else {
				$('#pwd-check-msg').text('사용하실 수 있는 비밀번호 입니다.');
        		$('#pwd-check-msg').attr('class', 'input-group mb-3');
        		pwdCheckVal = 1;
				return true;
			}
		}
		
		//id에 입력시 중복체크 전까지 체크값 0으로 초기화
		$("#user-id").keyup(function(){
			idCheckVal = 0;
		})
		
		// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#insertModal').modal('show');
			
			$('#insert-btn').off().click(function() {
				var id = $('#user-id').val();
				var name = $('#user-name').val();
				var password = $('#password').val();
				var authority = $('#authority option:selected').val();
				
				if(id === '') {
					alert('사용자 아이디를 입력해주세요');
					return false;
				}
				
				if(!CV_checkIdPattern(id)){
					return false;
				}; // ID 유효성 검사 : 숫자와 문자로만 구성된 16자리 까지의 문자만 허용
				
				if(idCheckVal == 0) {
					alert('아이디 중복체크 완료가 필요합니다.');
					return false;
				}
				if(name === '') {
					alert('사용자 이름을 입력해주세요');
					return false;
				}
				if(password === '') {
					alert('비밀번호를 입력해주세요');
					return false;
				}
				
				if(pwdCheckVal == 0) {
					alert('올바른 형식의 비밀번호를 입력해 주세요.');
					return false;
				}
				
				if(authority === '') {
					alert('권한을 선택해주세요');
					return false;
				}
				
				console.log(id);
				console.log(name);
				console.log(password);
				console.log(authority);
				var check = confirm('등록하시겠습니까?');
				
				if(check){
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/user",
		            data: {
		            	"type" : "insert",
		            	"id" : id, 
		            	"name" : name,
		            	"password" : password,
		            	"authority" : authority
		            },
		            success: function (insertResult) {
		            	if(insertResult== 'true') {
		            		alert('등록되었습니다.');
		            		$('#insertModal').modal('hide');
		            		refreshMainTable();
		            	} else {
		            		alert('등록 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
				
				}
				
			});
			
			$('#overlap-btn').off().click(function() {
				var id = $('#user-id').val();
				
				if(id === '') {
					alert('사용자 아이디를 입력해주세요');
					return false;
				}
				
				$.ajax({
		            type: "GET",
		            url: "<%=Config.this_SERVER_path%>/user",
		            data: {
		            	"type" : "id-overlap",
		            	"id" : id
		            },
		            success: function (overlapResult) {
		            	console.log(overlapResult);
		            	console.log(overlapResult.userId);
		            	if(overlapResult.userId != null) {
		            		alert('이미 등록된 아이디입니다. 다른 아이디를 사용해주세요.');
		            		idCheckVal = 0;
		            		$('#id-check-msg').text('이미 등록된 아이디입니다.');
		            		$('#id-check-msg').attr('class', 'input-group mb-3 being-red');
		            	} else {
		            		if(CV_checkIdPattern($("#user-id").val()) != true) {
		            			alert("아이디는 16자리 이하 영문자 또는 숫자로만 구성하여야 합니다.");
		            			idCheckVal = 0;
		            			$('#id-check-msg').text('유효한 아이디를 입력해 주세요.');
		            			$('#id-check-msg').attr('class', 'input-group mb-3 being-red');
		            		}
		            		else {
		            			alert('사용하실 수 있는 아이디입니다.');
		            			idCheckVal = 1;
		            			$('#id-check-msg').text('');
		            			//$('#id-check-msg').text('아이디 중복체크 완료!');
		            			$('#id-check-msg').attr('class', 'input-group mb-3');
		            		}
		            	}
		            }
		        });
			});
			
			$("#password").keyup(function(){
				var pwd = $("#password").val();
				CV_checkPasswordPattern(pwd);
			});
		});

		// 수정
		$('#update').off().click(function() {
			initModal();
			
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('수정할 사용자를 선택해주세요.');
				return false;
			}
			
			$('#updateModal').modal('show');
			console.log(row[0].authority);
			$('#user-id-update').val(row[0].userId);
			$('#user-name-update').val(row[0].userName);
			$('#authority-update').val(row[0].authority);
			
			$('#update-btn').click(function() {
				
				var authority = $('#authority-update option:selected').val();
				
				if(authority === '') {
					alert('권한을 선택해주세요');
					return false;
				}
				
				var check = confirm('수정하시겠습니까?');
				
				if(check) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/user",
		            data: { 
	            		"type" : "updateAuthority",
	            		"id" : row[0].userId,
	            		"name" : $('#user-name-update').val(),
	            		"authority" : $('#authority-update').val()
	            	},
		            success: function (updateResult) {
		            	if(updateResult== 'true') {
		            		alert('수정되었습니다.');
		            		$('#updateModal').modal('hide');
		            		refreshMainTable();
		            	} else {
		            		alert('수정 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
				}
			});
		});
		
		// 삭제
		$('#delete').click(function() {
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('삭제할 사용자를 선택해주세요.');
				return false;
			}
			
			if(confirm('삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/user",
		            data: { 
	            		"type" : "delete",
	            		"id" : row[0].userId 
		           	},
		            success: function (deleteResult) {
		            	if(deleteResult== 'true') {
		            		alert('삭제되었습니다.');
		            		refreshMainTable();
		            	} else {
		            		alert('삭제 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
			}
			
		});
    });
    
	function fn_press_han(obj) {
		//if(event.keycode == 8 || event.keycode == 9 || event.keycode == 37
		 //  event.keycode == 39 || event.keycode == 46) {
			//return;
			obj.value = obj.value.replace(/[ㄱ-ㅎㅏ-ㅣ가-힣]/g, "");
		//}
	}
	
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	사용자 관리
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      	  <button type="button" class="btn btn-info" id="insert">
      	  	등록
      	  </button>
      	  <button type="button" class="btn btn-success" id="update">
      	  	수정
      	  </button>
      	  <button type="button" class="btn btn-danger" id="delete">
      	  	삭제
      	  </button>
      	</div>
      </div><!-- /.col -->
    </div><!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content-header -->

<!-- Main content -->
<div class="content">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">
        <div class="card card-primary card-outline">
          <div class="card-header">
          	<h3 class="card-title">
          		<i class="fas fa-edit"></i>
          		사용자 목록
          	</h3>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="userTable" style="width:100%">
				<thead>
					<tr>
					    <th>아이디</th>
					    <th>이름</th>
					    <th>권한</th>
					</tr>
				</thead>
				<tbody id="userTableBody">		
				</tbody>
			</table>
          </div> 
        </div>
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->

<!-- Modal -->  
<div class="modal fade" id="insertModal" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title">등록</h4>  
      </div>  
      <div class="modal-body">
      	<label for="basic-url">아이디</label>
		<div class="input-group">
		  <input type="text" class="form-control" id="user-id" onkeydown="fn_press_han(this);" style="ime-mode:disabled;">
		  	  <div class="input-group-append">
		  		<span class="input-group-button">
		  			<button type = "button" class="btn btn-primary" id = "overlap-btn">중복체크</button>
		  		</span>
		  	  </div>
		</div>
			<div class="input-group mb-3" id = "id-check-msg"></div>
      	<label for="basic-url">이름</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="user-name">
		</div>
      	<label for="basic-url">비밀번호</label>
		<div class="input-group mb-3">
		  <input type="password" class="form-control" id="password">
		</div>
			<div class="input-group mb-3" id = "pwd-check-msg"></div>
      	<label for="basic-url">권한</label>
		<div class="input-group mb-3">
		  <!-- <input type="text" class="form-control" id="authority"> -->
		  <select class = "form-control w-auto d-inline-block" id ="authority">
		  		<option value ="">선택</option>
		 		<option value ="관리자">관리자</option>
		 		<option value ="일반사용자">일반사용자</option>
		  </select>
		</div>
      </div>  
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="insert-btn">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>

<!-- Update Modal -->  
<div class="modal fade" id="updateModal" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title">수정</h4>  
      </div>  
      <div class="modal-body">
      	<label for="basic-url">아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="user-id-update" disabled>
		</div>
      	<label for="basic-url">이름</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="user-name-update">
		</div>
      	<label for="basic-url">권한</label>
		<div class="input-group mb-3">
		  <!-- <input type="text" class="form-control" id="authority-update"> -->
		  <select class = "form-control w-auto d-inline-block" id ="authority-update">
		  		<option value ="">선택</option>
		 		<option value ="관리자">관리자</option>
		 		<option value ="일반사용자">일반사용자</option>
		  </select>
		</div>
      </div>  
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="update-btn">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>