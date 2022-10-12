<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	$(document).ready(function () {
    	
		let mainTable;
		
		async function getData() {
	    	
	        var fetchedData = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/notice",
			            data: "registerDatetime=all", 
			            success: function (result) {
			            	return result;
			            }
			        });
	    
	    	return fetchedData;
	    };
	    
	    async function initTable() {
	    	var data = await getData();
	    	
		    var customOpts = {
					data : data,
					pageLength: 10,
					columns: [
						{ data: "registerDatetime", defaultContent: '' },
						{ data: "noticeTitle", defaultContent: '' },
						{ data: "noticeContent", defaultContent: '' },
						{ data: "active", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#ccpDataTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    async function refreshMainTable() {
	    	var menu = new HENESYS_API.menu();
	    	var menuList = await menu.getMenus();
	    	
    		mainTable.clear().rows.add(menuList).draw();
		}
	    
	    var initModal = function () {
	    	$('#notice-title').val('');
	    	$('#notice-content').val('');
	    };
	    
	 	// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#myModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#save').off().click(function() {
				var title = $('#notice-title').val();
				var content = $('#notice-content').val();
				var registerDatetime = new HeneData().getDateTime();
				
				console.log(registerDatetime);
				
				if(title === '') {
					alert('제목을 입력해주세요');
					return false;
				}
				if(content === '') {
					alert('내용을 입력해주세요');
					return false;
				}
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/notice",
		            data: {
		            	"type" : "insert",
		            	"registerDatetime" : registerDatetime, 
		            	"noticeTitle" : title, 
		            	"noticeContent" : content,
		            	"active" : "N"
		            },
		            success: function (insertResult) {
		            	if(insertResult == 'true') {
		            		alert('등록되었습니다.');
		            		$('#myModal').modal('hide');
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
				alert('수정할 센서정보를 선택해주세요.');
				return false;
			}
			
			$('#myModal').modal('show');
			$('.modal-title').text('수정');
			
			$('#menu-id').val(row[0].menuId);
			$('#menu-name').val(row[0].menuName);
			$('#menu-level').val(row[0].menuLevel);
			$('#menu-path').val(row[0].path);
			$('#menu-parentId').val(row[0].parentMenuId);
			
			$('#menu-id').prop('disabled', true);
			
			$('#save').off().click(function() {
				
				var name = $('#menu-name').val();
				var level = $('#menu-level').val();
				var path = $('#menu-path').val();
				var parentId = $('#menu-parentId').val();
				
				if(name === '') {
					alert('메뉴명을 입력해주세요');
					return false;
				}
				if(level === '') {
					alert('메뉴 단계를 입력해주세요');
					return false;
				}
				if(path === '') {
					alert('메뉴 경로를 입력해주세요');
					return false;
				}
				if(parentId === '') {
					alert('상위 메뉴ID를 입력해주세요');
					return false;
				}
				
				var check = confirm('수정하시겠습니까?');
				
				if(check) {
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/notice",
		            data: { 
	            		"type" : "update",
	            		"id" : row[0].menuId,
	            		"name" : $('#menu-name').val(), 
	            		"level" : $('#menu-level').val(),
		            	"path" : $('#menu-path').val(), 
		            	"parentId" : $('#menu-parentId').val()
		           	},
		            success: function (updateResult) {
		            	console.log(updateResult);
		            	if(updateResult == 'true') {
		            		alert('수정되었습니다.');
		            		$('#myModal').modal('hide');
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
				alert('삭제할 센서정보를 선택해주세요.');
				return false;
			}
			
			if(confirm('삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/notice",
		            data: { 
	            		"type" : "delete",
	            		"id" : row[0].menuId 
		            },
		            success: function (deleteResult) {
		            	console.log(deleteResult);
		            	if(deleteResult == 'true') {
		            		alert('삭제되었습니다.');
		            		refreshMainTable();
		            	} else {
		            		alert('삭제 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
			}
			
		});
	    
		initTable();
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	공지사항 관리
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
          		<i class="fas fa-edit" id="InfoContentTitle"></i>
          		등록된 공지사항 목록
          	</h3>
          	<div class="card-tools">
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="ccpDataTable" style="width:100%">
				<thead>
					<tr>
					    <th>등록일자</th>
					    <th>제목</th>
					    <th>내용</th>
					    <th>활성화</th>
					</tr>
				</thead>
				<tbody id="ccpDataTableBody">		
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
<div class="modal fade" id="myModal" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title"></h4>  
      </div>  
      <div class="modal-body">
      	<label for="notice-title">제목</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="notice_title">
		</div>
      	<label for="notice-content">내용</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="notice_content">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>