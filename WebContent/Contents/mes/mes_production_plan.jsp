<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	var dataJspPage = {};
	var order_table_info;
	var order_table_RowCount = 0;
	var orderTable;  //주문정보 테이블
	
	$(document).ready(function () {
		
		let date = new SetSingleDate2("", "#plan_date", 0);
		let date2 = new SetSingleDate2("", "#plan_date2", 0);
		
		let mainTable; //메인테이블
		let mainTableSelectedRow;
		let orderTableSelectedRow;
		
	    async function initTable() {
	    	var plans = new ProductionPlan();
	    	var plansList = await plans.getProductionPlans();
		    var customOpts = {
					data : plansList,
					pageLength: 10,
					columns: [
						{ data: "planNo", defaultContent: '' },
						{ data: "planDate", defaultContent: '' },
						{ data: "customerCode", defaultContent: '' },
						{ data: "customerName", defaultContent: '' },
						{ data: "productId", defaultContent: '' },
						{ data: "productName", defaultContent: '' },
						{ data: "planCount", defaultContent: '' }
			        ],
			        columnDefs : [
			        	{
					  			targets: [0,2,4],
					  			createdCell:  function (td) {
				          			$(td).attr('style', 'width:0px; display: none;'); 
				       			}
				  		}
				    ]
			}
					
			mainTable = $('#planTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    async function refreshMainTable() {
	    	var plans = new ProductionPlan();
	    	var plansList = await plans.getProductionPlans();
	    	
    		mainTable.clear().rows.add(plansList).draw();
    		
		}
	    
	    var initModal = function () {
	    	$('#order_no').val('');
	    	$('#product_id').val('');
	    	$('#customer_code').val('');
	    	$('#plan_count').val('');
	    	
	    	//orderTable.clear().draw();
	    	//orderTable.columns.adjust().draw();
	    };
	    
	    var initModal2 = function () {
	    	$('#plan_date2').val('');
	    	$('#product_id2').val('');
	    	$('#customer_code2').val('');
	    	$('#plan_count2').val('');
	    };
	     
	    var initModal4 = function () {
	    	$('#instruction_date').val('');
	    	$('#product_name4').val('');
	    	$('#customer_code4').val('');
	    	$('#product_id4').val('');
	    	$('#plan_no4').val('');
	    	$('#instruction_count').val('');
	    };
	    
		initTable();
		
		
		// 등록
		$('#insert').click(function() {
			initModal();
			
			
			
			$('#myModal').modal('show');
			$('.modal-title').text('생산계획등록');
			
			$('#save').off().click(function() {
				var planDate = $('#plan_date').val();
				var orderNo = $('#order_no').val();
				var productId = $('#product_id').val();
				var customerCode = $('#customer_code').val();
				var planCount = $('#plan_count').val();
				
				var jArray = new Array();
				
				if(planDate === '') {
					alert('계획일자를 선택해주세요');
					return false;
				}
				if(orderNo === '') {
					alert('주문 정보를 선택해주세요');
					return false;
				}
				
				var check = confirm('생산계획을 등록하시겠습니까?');
				
				if(check) {
					
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/mes-productionPlan",
		            data: {
		            	"type" : "insert",
		            	"planDate" : planDate,
		            	"orderNo" : orderNo,
		            	"customerCode" : customerCode,
		            	"productId" : productId,
		            	"planCount" : planCount
		            	
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
				
				}
				
			});
		});

		// 수정
		$('#update').click(function() {
			initModal2();
			
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('수정할 제품을 선택해주세요.');
				return false;
			}
			
			$('#myModal2').modal('show');
			$('.modal-title2').text('생산계획수정');
			
			$('#plan_date2').val(row[0].planDate);
			$('#product_id2').val(row[0].productId);
			$('#customer_code2').val(row[0].customerCode);
			$('#product_name2').val(row[0].productName);
			$('#plan_count2').val(row[0].planCount);
			$('#plan_no').val(row[0].planNo);
			
			
			
			$('#save2').off().click(function() {
				
				var planNo = $('#plan_no').val();
				var planDate = $('#plan_date2').val();
				var productId = $('#product_id2').val();
				var planCount = $('#plan_count2').val();
				
				var check = confirm('생산계획을 수정하시겠습니까?');
				
				if(check) {
					
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/mes-productionPlan",
		            data: {
		            	"type" : "update",
		            	"planDate" : planDate,
		            	"productId" : productId,
		            	"planCount" : planCount,
		            	"planNo" : planNo
		            	
		            },
		            success: function (updateResult) {
		            	if(updateResult == 'true') {
		            		alert('수정되었습니다.');
		            		$('#myModal2').modal('hide');
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
				alert('삭제할 생산계획정보를 선택해주세요.');
				return false;
			}
			
			if(confirm('생산계획을 삭제하시겠습니까?')) {
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/mes-productionPlan",
		            data: { 
		            		"type" : "delete",
		            		"id" : row[0].planNo 
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
		
		// 생산지시등록
		$('#instruction').click(function() {
			
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('생산지시를 등록할 항목을 선택해주세요.');
				return false;
			}
			
			initModal4();
			
			$('#myModal4').modal('show');
			$('.modal-title4').text('생산지시등록');
			
			$('#product_name4').val(row[0].productName);
			$('#product_id4').val(row[0].productId);
			$('#plan_no4').val(row[0].planNo);
			$('#instruction_count').val(row[0].planCount);
			
			$('#save4').off().click(function() {
				var instructionDate = $('#instruction_date').val();
				var productId = $('#product_id4').val();
				var planNo = $('#plan_no4').val();
				var instructionCount = $('#instruction_count').val();
				
				var jArray = new Array();
				
				if(instructionDate === '') {
					alert('지시일자를 선택해주세요');
					return false;
				}
				
				
				var check = confirm('생산지시를 등록하시겠습니까?');
				
				if(check) {
					
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/mes-productionPlan",
		            data: {
		            	"type" : "instruction_insert",
		            	"instructionDate" : instructionDate,
		            	"planNo" : planNo,
		            	"productId" : productId,
		            	"instructionCount" : instructionCount
		            	
		            },
		            success: function (insertResult) {
		            	if(insertResult == 'true') {
		            		alert('생산지시 정보가 등록되었습니다.');
		            		$('#myModal4').modal('hide');
		            		refreshMainTable();
		            	} else {
		            		alert('등록 실패했습니다, 관리자에게 문의해주세요.');
		            	}
		            }
		        });
				
				}
				
			});
		});
		
		
		$('#order_no').click(function() {
			
			$('#myModal3').modal('show');
			$('.modal-title3').text('주문 정보 조회');
			
			initOrderTable();
			
			$('#orderTable tbody').on('click', 'tr', function () {
	    		
				if ( !$(this).hasClass('selected') ) {
	    			orderTableSelectedRow = orderTable.row( this ).data();
	    			
	    			$('#order_no').val(orderTableSelectedRow.orderNo);
	    			$('#product_name').val(orderTableSelectedRow.productName);
	    			$('#product_id').val(orderTableSelectedRow.productId);
	    			$('#customer_code').val(orderTableSelectedRow.customerCode);
	    			$('#plan_count').val(orderTableSelectedRow.orderCount);
	    			
	    			$('#myModal3').modal('hide');
	            }
				
				
	    		
	    	});
			
		});
		
		
		// 주문정보 테이블 초기화
		 async function initOrderTable() {
		    	var orders = new Order();
		    	var ordersList = await orders.getOrderInfos();
		    	console.log(ordersList);
			    var customOpts = {
						data : ordersList,
						pageLength: 10,
						columns: [
							{ data: "orderNo", defaultContent: '' },
							{ data: "customerCode", defaultContent: '' },
							{ data: "customerName", defaultContent: '' },
							{ data: "productId", defaultContent: '' },
							{ data: "productName", defaultContent: '' },
							{ data: "orderCount", defaultContent: '' }
				        ],
				        columnDefs : [
				        	{
					  			targets: [0,1,3],
					  			'createdCell' : function(td, cellData, rowData, rowinx, col) {
									$(td).attr('style', 'display:none;');
								}
					  		}
					    ]
				}
						
			    orderTable = $('#orderTable').DataTable(
					mergeOptions(heneMainTableOpts, customOpts)
				);
		 }
		
		 setTimeout(function(){
		 	$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
		 }, 1000);
    });
	
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark">
        	생산계획 관리
        </h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      	  <button type="button" class="btn btn-info" id="insert">
      	  	생산계획등록
      	  </button>
      	  <button type="button" class="btn btn-success" id="update">
      	  	생산계획수정
      	  </button>
      	  <button type="button" class="btn btn-danger" id="delete">
      	  	생산계획삭제
      	  </button>
      	   <button type="button" class="btn btn-warning" id="instruction">
      	  	생산지시등록
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
          		생산계획 목록
          	</h3>
          </div>
          <div class="card-body" id="MainInfo_List_contents">
          	<table class='table table-bordered nowrap table-hover' 
				   id="planTable" style="width:100%">
				<thead>
					<tr>
						<th style="display:none; width:0px;">생산계획번호</th>
					    <th>생산계획일자</th>
					    <th style="display:none; width:0px;">고객사코드</th>
					    <th>고객사명</th>
					    <th style="display:none; width:0px;">제품아이디</th>
					    <th>제품명</th>
					    <th>계획수량</th>
					</tr>
				</thead>
				<tbody id="planTableBody">		
				</tbody>
			</table>
          </div>
          <!-- 
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
            -->
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
      	<label for="basic-url">생산계획일자</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="plan_date" readonly>
		</div>
		<label for="basic-url">주문번호</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="order_no" readonly>
		  <input type="hidden" class="form-control" id="customer_code">
		</div>
		<label for="basic-url">제품명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="product_name" readonly>
		  <input type="hidden" class="form-control" id="product_id">
		</div>
		<label for="basic-url">생산계획량</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="plan_count">
		</div>
      </div> 
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>

<!-- Modal -->  
<div class="modal fade" id="myModal2" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title2"></h4>  
      </div>  
      <div class="modal-body">
      	<label for="basic-url">생산계획일자</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="plan_date2" readonly>
		</div>
		<label for="basic-url">제품명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="product_name2" readonly>
		  <input type="hidden" class="form-control" id="customer_code2">
		  <input type="hidden" class="form-control" id="product_id2">
		  <input type="hidden" class="form-control" id="plan_no">
		</div>
		<label for="basic-url">생산계획량</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="plan_count2">
		</div>
      </div> 
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save2">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
      
  </div>  
</div>


<div class="modal fade" id="myModal3" tabindex="-1" role="dialog"  aria-hidden="true">
    	<div class="modal-dialog modal-dialog-scrollable">
    		<div class="modal-content">
        		<div class="modal-header">
        			<h4 class="modal-title3"></h4>
          		</div>
          		<div class="modal-body">
          			<table class='table table-bordered nowrap table-hover' 
				   	id="orderTable" style="width:100%">
					<thead>
						<tr>
					    	<th style = "display:none; width:0%;">주문번호</th>
					    	<th style = "display:none; width:0%;">고객사코드</th>
					    	<th>고객사명</th>
					    	<th style = "display:none; width:0%;">제품아이디</th>
					    	<th>제품명</th>
					    	<th>주문수량</th>
						</tr>
					</thead>
					<tbody id="orderTableBody">		
					</tbody>
			</table>
        		</div>
		        <div class="modal-footer">
        			 <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
		        </div>
        	</div>
      	</div>
 </div>

 <!-- Modal -->  
<div class="modal fade" id="myModal4" role="dialog">  
  <div class="modal-dialog">
    
    <!-- Modal content-->  
    <div class="modal-content">  
      <div class="modal-header">
        <h4 class="modal-title4"></h4>  
      </div>  
      <div class="modal-body">
      	<label for="basic-url">생산지시일자</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="instruction_date" readonly>
		</div>
		<label for="basic-url">제품명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="product_name4" readonly>
		  <input type="hidden" class="form-control" id="product_id4">
		  <input type="hidden" class="form-control" id="plan_no4">
		</div>
		<label for="basic-url">생산지시량</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="instruction_count">
		</div>
      </div> 
      <div class="modal-footer">  
        <button type="button" class="btn btn-primary" id="save4">저장</button>  
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
      </div>  
    </div>  
  </div>  
</div>