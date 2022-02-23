<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
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
	    };
	     
		initTable();
		
		// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#insertModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#insert-btn').off().click(function() {
				var id = $('#user-id').val();
				var name = $('#user-name').val();
				var password = $('#password').val();
				var authority = $('#authority').val();
				
				if(id === '') {
					alert('사용자 아이디를 입력해주세요');
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
				if(authority === '') {
					alert('권한을 선택해주세요');
					return false;
				}
				
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
			});
		});

		// 수정
		$('#update').click(function() {
			initModal();
			
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('수정할 사용자를 선택해주세요.');
				return false;
			}
			
			$('#updateModal').modal('show');
			
			$('#user-id-update').val(row[0].userId);
			$('#user-name-update').val(row[0].userName);
			$('#authority-update').val(row[0].authority);
			
			$('#update-btn').click(function() {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/user",
		            data: { 
	            		"type" : "updateAuthority",
	            		"id" : row[0].userId,
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
        <h4 class="modal-title">수정</h4>  
      </div>  
      <div class="modal-body">
      	<label for="basic-url">아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="user-id">
		</div>
      	<label for="basic-url">이름</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="user-name">
		</div>
      	<label for="basic-url">비밀번호</label>
		<div class="input-group mb-3">
		  <input type="password" class="form-control" id="password">
		</div>
      	<label for="basic-url">권한</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="authority">
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
        <h4 class="modal-title"></h4>  
      </div>  
      <div class="modal-body">
      	<label for="basic-url">아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="user-id-update" disabled>
		</div>
      	<label for="basic-url">이름</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="user-name-update" disabled>
		</div>
      	<label for="basic-url">권한</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="authority-update">
		</div>
      </div>  
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="update-btn">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>