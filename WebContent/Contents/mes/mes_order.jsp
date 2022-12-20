<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	var dataJspPage = {};
    
	$(document).ready(function () {
		
		let date = new SetSingleDate2("", "#order_date", 0);
		let mainTable;
		let subTable;
		let mainTableSelectedRow;
		
	    async function initTable() {
	    	var orders = new Order();
	    	var ordersList = await orders.getOrders();
	    	
		    var customOpts = {
					data : ordersList,
					pageLength: 10,
					columns: [
						{ data: "orderNo", defaultContent: '' },
						{ data: "orderDate", defaultContent: '' },
						{ data: "customerCode", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#orderTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    dataJspPage.fillSubTable = async function () {
	    	var orderDetails = new Order();
	    	var order = await orderDetails.getOrderDetails(mainTableSelectedRow.orderNo);
	    	
	    	if(subTable) {
	    		// redraw
	    		subTable.clear().rows.add(order).draw();
	    	} else {
	    		// initialize
			    var option = {
						data : order,
						pageLength: 10,
						columns: [
							{ data: "productId", defaultContent: '' },
							{ data: "orderCount", defaultContent: '' },
							{ data: "chulhaYn", defaultContent: '' }
				        ],
				        columnDefs : [
				        	{
					  			targets: [2],
					  			render: function(td, cellData, rowData, row, col){
					  				console.log(cellData);
					  				if (rowData.chulhaYn == 'Y') {
					  					return '출하완료';
					  				}
					  				else {
					  					return '출하미완료';
					  				}
					  			}
					  		}
					    ],
					    stateSave : true
				}
	    		
				subTable = $('#orderTableDetail').DataTable(
					mergeOptions(heneMainTableOpts, option)
				);
	    	}
	    };
	    
	    async function refreshMainTable() {
	    	var orders = new Order();
	    	var ordersList = await orders.getOrders();
	    	
    		mainTable.clear().rows.add(ordersList).draw();
    		
    		if(subTable) {
	    		subTable.clear().draw();
	    	}
		}
	    
	    var initModal = function () {
	    	$('#product-id').prop('disabled', false);
	    	$('#product-id').val('');
	    	$('#product-name').val('');
	    };
	     
		initTable();
		
		// 등록
		$('#insert').click(function() {
			initModal();
			
			$('#myModal').modal('show');
			$('.modal-title').text('등록');
			
			$('#save').off().click(function() {
				var id = $('#product-id').val();
				var name = $('#product-name').val();
				
				if(id === '') {
					alert('제품아이디를 입력해주세요');
					return false;
				}
				if(name === '') {
					alert('제품명을 입력해주세요');
					return false;
				}
				
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/mes-order",
		            data: {
		            	"type" : "insert",
		            	"id" : id, 
		            	"name" : name 
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
				alert('수정할 제품을 선택해주세요.');
				return false;
			}
			
			$('#myModal').modal('show');
			$('.modal-title').text('수정');
			
			$('#product-id').val(row[0].productId);
			$('#product-name').val(row[0].productName);
			
			$('#product-id').prop('disabled', true);
			
			$('#save').off().click(function() {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/product",
		            data: { 
	            		"type" : "update",
	            		"id" : row[0].productId,
	            		"name" : $('#product-name').val()
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
				alert('삭제할 주문정보를 선택해주세요.');
				return false;
			}
			
			if(confirm('삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/mes-order",
		            data: { 
		            		"type" : "delete",
		            		"id" : row[0].orderNo 
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
		
		
		$('#orderTable tbody').on('click', 'tr', function () {
    		
    		if ( !$(this).hasClass('selected') ) {
    			mainTableSelectedRow = mainTable.row( this ).data();
    			dataJspPage.fillSubTable();
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
        	주문정보 관리
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      	  <button type="button" class="btn btn-info" id="insert">
      	  	주문정보등록
      	  </button>
      	  <button type="button" class="btn btn-success" id="update">
      	  	주문정보수정
      	  </button>
      	  <button type="button" class="btn btn-danger" id="delete">
      	  	주문정보삭제
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
          		주문정보 목록
          	</h3>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="orderTable" style="width:100%">
				<thead>
					<tr>
					    <th>주문번호</th>
					    <th>주문일자</th>
					    <th>고객사</th>
					</tr>
				</thead>
				<tbody id="orderTableBody">		
				</tbody>
			</table>
          </div>
          
           <div class="card-body" id="SubInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="orderTableDetail" style="width:100%">
				<thead>
					<tr>
					    <th>제품아이디</th>
					    <th>주문수량</th>
					    <th>출하여부</th>
					</tr>
				</thead>
				<tbody id="orderTableDetailBody">		
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
      	<label for="basic-url">주문일자</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="order_date">
		</div>
      	<label for="basic-url">고객사명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="customer_name" readonly>
		  <input type="hidden" class="form-control" id="customer_code">
		</div>
		
		<div class="row table-responsive">
			<table class="table" id="order_input_table">
				<thead>
					<tr>
	            		<th>#</th>
	            		<th>제품명</th>
	            		<th>수량</th>
	            		<th>
	            			<button id="btn_plus" class="btn btn-info btn-sm">
	            				<i class="fas fa-plus"></i>
	            			</button>
	            			<!-- <button id="btn_mius" class="btn btn-info btn-sm">
						<i class="fas fa-minus"></i>
					</button> -->
				</th>
			</tr>
		</thead>
		<tbody id="order_tbody">
		</tbody>
	</table>
</div>
		
      </div> 
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>