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
	    	var clInfo = new ChecklistInfo();
	    	var clList = await clInfo.getAll();
	    	
		    var customOpts = {
					data : clList,
					pageLength: 10,
					columns: [
						{ data: "checklistId", defaultContent: '' },
						{ data: "revisionNo", defaultContent: '' },
						{ data: "checklistName", defaultContent: '' },
						{ data: "imagePath", defaultContent: '' },
						{ data: "metaDataFilePath", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#checklistInfoTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    async function refreshMainTable() {
	    	var clInfo = new ChecklistInfo();
	    	var clList = await clInfo.getAll();
	    	
    		mainTable.clear().rows.add(clList).draw();
		}
	    
	    var initModal = function () {
	    	$('#checklist-id').prop('disabled', false);
	    	$('#checklist-id').val('');
	    	$('#checklist-name').val('');
	    	$('#image-path').val('');
	    	$('#metadata-file-path').val('');
	    };
	     
		initTable();
		
		// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#myModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#save').off().click(function() {
				var id = $('#checklist-id').val();
				var name = $('#checklist-name').val();
				var imagePath = $('#image-path').val();
				var metaDataFilePath = $('#metadata-file-path').val();
				
				if(id === '') {
					alert('선행요건 아이디를 입력해주세요');
					return false;
				}
				if(name === '') {
					alert('선행요건 명을 입력해주세요');
					return false;
				}
				if(imagePath === '') {
					alert('이미지 경로를 입력해주세요');
					return false;
				}
				if(metaDataFilePath === '') {
					alert('메타데이터 경로를 입력해주세요');
					return false;
				}
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/checklist-info",
		            data: {
		            	"type" : "insert",
		            	"id" : id, 
		            	"name" : name, 
		            	"imagePath" : imagePath, 
		            	"metaDataFilePath" : metaDataFilePath
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
				alert('수정할 선행요건을 선택해주세요.');
				return false;
			}
			
			$('#myModal').modal('show');
			$('.modal-title').text('수정');
			
			$('#checklist-id').val(row[0].checklistId);
			$('#checklist-name').val(row[0].checklistName);
			$('#image-path').val(row[0].imagePath);
			$('#metadata-file-path').val(row[0].metaDataFilePath);
			
			$('#checklist-id').prop('disabled', true);
			
			$('#save').off().click(function() {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/checklist-info",
		            data: { 
	            		"type" : "update",
	            		"id" : row[0].checklistId,
	            		"name" : $('#checklist-name').val(),
	            		"imagePath" : $('#image-path').val(),
	            		"metaDataFilePath" : $('#metadata-file-path').val(),
		           	},
		            success: function (deleteResult) {
		            	if(deleteResult == 'true') {
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
				alert('삭제할 제품을 선택해주세요.');
				return false;
			}
			
			if(confirm('삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/checklist-info",
		            data: { 
	            		"type" : "delete",
	            		"id" : row[0].checklistId 
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
    });
    
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	선행요건 관리
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
          		선행요건 목록
          	</h3>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="checklistInfoTable" style="width:100%">
				<thead>
					<tr>
					    <th>선행요건아이디</th>
					    <th>수정이력번호</th>
					    <th>선행요건명</th>
					    <th>이미지경로</th>
					    <th>메타데이터경로</th>
					</tr>
				</thead>
				<tbody id="checklistInfoTableBody">		
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
      	<label for="checklist-id">선행요건아이디</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="checklist-id">
		</div>
      	<label for="checklist-name">선행요건명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="checklist-name">
		</div>
      	<label for="image-path">이미지경로</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="image-path">
		</div>
      	<label for="metadata-file-path">메타데이터경로</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="metadata-file-path">
		</div>
      </div>
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>