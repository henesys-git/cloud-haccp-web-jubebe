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
	    	var data = await getData();
    		mainTable.clear().rows.add(data).draw();
		}
	    
	    var initModal = function () {
	    	$('#notice-title').val('');
	    	$('#notice-content').val('');
	    };
	    
	    var ifActiveNoticeNotExist = function (table) {
	    	var rows = table.rows().data();
			
			for(let i=0; i<rows.length; i++) {
				var active = rows[i].active;
				if(active == 'Y') {
					return false;
				}
			}
	    	
	    	return true;
	    }
	    
	 	// 조회
		$('#display').click(function() {
			if(ifActiveNoticeNotExist(mainTable)) {
				alert('활성화 된 공지사항이 없습니다.');
				return false;
			}
			
			window.open("/Contents/notice_display.jsp", 
	 				'_blank', 
	 				"top=5, left=0, width=1910, height=1070," + 
	 				"fullscreen=yes, toolbars=no, status=no," + 
	 				"scrollbars=no, resizable=yes, titlebar=no, location=no");
		});
	    
	 	// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#myModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#save').off().click(function() {
				var title = $('#notice_title').val();
				var content = $('#notice_content').val();
				var registerDatetime = new HeneDate().getDateTime();
				
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
		            	"active" : "Y"
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
			
			var row = mainTable.rows( '.selected' ).data()[0];
			console.log(row);
			
			if(row === undefined) {
				alert('수정할 공지사항을 선택해주세요.');
				return false;
			}
			
			$('#myModal').modal('show');
			$('.modal-title').text('수정');
			
			$('#notice_title').val(row.noticeTitle);
			$('#notice_content').val(row.noticeContent);
			
			$('#save').off().click(function() {
				
				var title = $('#notice_title').val();
				var content = $('#notice_content').val();
				
				if(title === '') {
					alert('제목을 입력해주세요');
					return false;
				}
				if(content === '') {
					alert('내용을 입력해주세요');
					return false;
				}
				
				if(!confirm('수정하시겠습니까?')) {
					return false;
				}
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/notice",
		            data: {
		            	"type" : "update",
		            	"registerDatetime" : row.registerDatetime, 
		            	"noticeTitle" : title, 
		            	"noticeContent" : content,
		            	"active" : row.active
		            },
		            success: function (updateResult) {
		            	if(updateResult == 'true') {
		            		alert('수정되었습니다.');
		            		$('#myModal').modal('hide');
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
				alert('삭제할 공지사항을 선택해주세요.');
				return false;
			}
			
			if(confirm('삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/notice",
		            data: { 
	            		"type" : "delete",
	            		"registerDatetime" : row[0].registerDatetime
		            },
		            success: function (deleteResult) {
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
      	  <button type="button" class="btn" id="display">
      	  	조회
      	  </button>
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
		  <textarea class="form-control" id="notice_content"></textarea>
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>