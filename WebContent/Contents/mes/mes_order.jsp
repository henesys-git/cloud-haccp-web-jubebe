<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">
    
	var dataJspPage = {};
	var orderJSPPage = {};
	var order_table_info;
	var order_table_RowCount = 0;
	var orderTable;  //주문정보 테이블
	
	$(document).ready(function () {
		
		let date = new SetSingleDate2("", "#order_date", 0);
		let mainTable; //메인테이블
		let subTable;  //서브테이블
		let customerTable; //팝업 고객사정보 테이블
		let mainTableSelectedRow;
		let customerTableSelectedRow;
		
	    async function initTable() {
	    	var orders = new Order();
	    	var ordersList = await orders.getOrders();
	    	console.log(ordersList);
		    var customOpts = {
					data : ordersList,
					pageLength: 10,
					columns: [
						{ data: "orderNo", defaultContent: '' },
						{ data: "orderDate", defaultContent: '' },
						{ data: "customerCode", defaultContent: '' },
						{ data: "customerName", defaultContent: '' }
			        ],
			        columnDefs : [
			        	{
					  			targets: [2],
					  			createdCell:  function (td) {
				          			$(td).attr('style', 'width:0px; display: none;'); 
				       			}
				  		}
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
							{ data: "productName", defaultContent: '' },
							{ data: "orderCount", defaultContent: '' },
							{ data: "chulhaYn", defaultContent: '' }
				        ],
				        columnDefs : [
				        	{
					  			targets: [0],
					  			createdCell:  function (td) {
				          			$(td).attr('style', 'width:0px; display: none;'); 
				       			}
				  			},
				        	{
					  			targets: [3],
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
	    	
	    	orderTable.clear().draw();
	    	orderTable.columns.adjust().draw();
	    };
	     
		initTable();
		initOrderTable();
		initCustomerTable();
		
		// 등록
		$('#insert').click(function() {
			initModal();
			
			
			
			$('#myModal').modal('show');
			$('.modal-title').text('주문정보등록');
			
			$('#save').off().click(function() {
				var orderDate = $('#order_date').val();
				var custCode = $('#customer_code').val();
				
				var jArray = new Array();
				
				if(orderDate === '') {
					alert('주문일자를 선택해주세요');
					return false;
				}
				if(custCode === '') {
					alert('고객사 정보를 선택해주세요');
					return false;
				}
				
				order_table_info = orderTable.page.info();
			    order_table_RowCount = order_table_info.recordsTotal;
				console.log(order_table_RowCount);
				
				for(var i = 0; i < order_table_RowCount; i++) {
		        	
		    		var trInput = $($("#order_input_table_tbody tr")[i]).find(":input");
		    		
		    		console.log(trInput.eq(0).val());
		    		console.log(trInput.eq(1).val());
		    		console.log(trInput.eq(2).val());
		    		console.log(trInput.eq(3).val());
		    		
		    		if(trInput.eq(2).val() == '') { 
		    			heneSwal.warning("제품을 검색하여 선택하세요");
		    			return false;
		    		}
		    		if(trInput.eq(3).val() == '') {
		    			
		    			heneSwal.warning("주문할 수량을 입력하여 주세요");
		    			return false;
		    		}
		    		
		    		var dataJson = new Object();
		    		
		    		dataJson.product_id 	= trInput.eq(2).val();
		    		dataJson.order_count 	= trInput.eq(3).val();
					
					jArray.push(dataJson);
		        }
				
				var dataJsonMulti = new Object();
				dataJsonMulti.param = jArray;
				
				console.log(orderDate);
				console.log(custCode);
				console.log(dataJsonMulti);
				
				var JSONparam = JSON.stringify(dataJsonMulti);
				
				var check = confirm('주문정보를 등록하시겠습니까?');
				
				if(check) {
					
				$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/mes-order",
		            data: {
		            	"type" : "insert",
		            	"orderDate" : orderDate, 
		            	"custCode" : custCode,
		            	"orderData" : JSONparam
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
		
		// 주문정보 엑셀등록
		$('#excel').click(function() {
			
			console.log('excel pop up');
			
			$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/mes/mes_order_popup_excel.jsp',
                data: {
                },
                success: function (html) {
                    $("#modalWrapper2").html(html);
                }
            });
			
		});
		
		
		$('#orderTable tbody').on('click', 'tr', function () {
    		
    		if ( !$(this).hasClass('selected') ) {
    			mainTableSelectedRow = mainTable.row( this ).data();
    			dataJspPage.fillSubTable();
            }
    		
    	});
		
		$('#customer_name').click(function() {
			
			$('#myModal2').modal('show');
			$('.modal-title2').text('고객사 정보 조회');
			
			$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
			
			$('#customerTable tbody').on('click', 'tr', function () {
	    		
				if ( !$(this).hasClass('selected') ) {
	    			customerTableSelectedRow = customerTable.row( this ).data();
	    			
	    			$('#customer_name').val(customerTableSelectedRow.customerName);
	    			$('#customer_code').val(customerTableSelectedRow.customerId);
	    			
	    			$('#myModal2').modal('hide');
	            }
				
				
	    		
	    	});
			
		});
		
		
		// 고객사 팝업 테이블 초기화
		 async function initCustomerTable() {
		    	var customers = new Customer();
		    	var customersList = await customers.getCustomers();
		    	
			    var customOpts = {
						data : customersList,
						pageLength: 10,
						columns: [
							{ data: "customerId", defaultContent: '' },
							{ data: "customerName", defaultContent: '' }
				        ],
				        columnDefs : [
				        	{
					  			targets: [0],
					  			'createdCell' : function(td, cellData, rowData, rowinx, col) {
									$(td).attr('style', 'display:none;');
								}
					  		}
					    ]
				}
						
			    customerTable = $('#customerTable').DataTable(
					mergeOptions(heneMainTableOpts, customOpts)
				);
		 }
		
		 $("#btn_plus").click(function(){ 
		    	fn_plus_body();
		 }); 	
		
		 $("#btn_mius").click(function(){ 
		    	fn_minus_body(); 
		 }); 
		 
		 
		// 하단 주문정보 추가 팝업 테이블 초기화
		 async function initOrderTable() {
		    	
			 var customOpts = {
			   	   		paging : false,
			   	    	searching : false,
			   	    	ordering : false,
			   	    	keys : false,
			   	    	autoWidth : false,
			   	    	createdRow : "",
			   	    	columnDefs : [
							{ "className": "dt-head-center", "targets": "_all" },
							{ "width": "10%", "targets": 0 }
						]
			    	};
						
				orderTable = $('#order_input_table').DataTable(
					mergeOptions(heneMainTableOpts, customOpts)
				);
				
		 }
		
		//주문정보 테이블 행 추가
		 function fn_plus_body() {
			
				// 주문 품목 추가때마다 순번 매기기
		        order_table_info = orderTable.page.info();
		        order_table_RowCount = order_table_info.recordsTotal;	
				
		        console.log(order_table_RowCount);
		        
		    	orderTable.row.add([
		    		" <input type='text' class='form-control' id='txt_detail_seq'readonly />",
		    		" <input type='text' class='form-control prodAdd' id='txt_ProductName"+order_table_RowCount+"' readonly placeholder='Click here' onclick='prodAdd(this);'/>"+
		    		" <input type='hidden' class='form-control' id='txt_ProductCode"+order_table_RowCount+"'/>",
		    		//" <input type='text' class='form-control' id='txt_Productcode' readonly />",
					" <input type='number' class='form-control' id='txt_order_count"+order_table_RowCount+"' min='1' max='9999'/>",
		    		"<button class='btn btn-info btn-sm' onclick = 'fn_minus_body();'>"+
					"<i class='fas fa-minus'></i>" +
					"</button>"
		        ]).draw();
		    	
			    // 숫자만
			    $("input:text[numberOnly]").on("keyup", function() {
			        $(this).val($(this).val().replace(/[^0-9]/g,""));
			    });
			    
			    // 주문 품목 추가때마다 순번 매기기
		        order_table_info = orderTable.page.info();
		        order_table_RowCount = order_table_info.recordsTotal;
		        
				var trInput = $($("#order_input_table_tbody tr")[order_table_RowCount - 1]).find(":input");
				trInput.eq(0).val(order_table_RowCount);
		 }
		
		// 제품정보 팝업 테이블 초기화
		 async function initProductTable() {
		    	var products = new Product();
		    	var productsList = await products.getProducts();
		    	
			    var customOpts = {
						data : productsList,
						pageLength: 10,
						columns: [
							{ data: "productId", defaultContent: '' },
							{ data: "productName", defaultContent: '' }
				        ],
				        columnDefs : [
				        	{
					  			targets: [0],
					  			'createdCell' : function(td, cellData, rowData, rowinx, col) {
									$(td).attr('style', 'display:none;');
								}
					  		}
					    ]
				}
						
			    productTable = $('#productTable').DataTable(
					mergeOptions(heneMainTableOpts, customOpts)
				);
		 }
		
		//주문정보 테이블 제품명 클릭시
		 $('input[name=prodAdd]').on("click", function() {
				
			 	var trNum = $(this).closest('tr').prevAll().length;
			 	console.log(trNum);
			 
				$('#myModal3').modal('show');
				$('.modal-title3').text('제품 정보 조회');
				
				initProductTable();
				
				
				$('#productTable tbody').on('click', 'tr', function () {
		    		
					if ( !$(this).hasClass('selected') ) {
		    			productTableSelectedRow = productTable.row( this ).data();
		    			
		    			$('#txt_ProductName' + trNum).val(productTableSelectedRow.productName);
		    			$('#txt_ProductCode' + trNum).val(prodcutTableSelectedRow.productId);
		    			
		    			$('#myModal3').modal('hide');
		            }
					
		    	});
				
			});
		
		 setTimeout(function(){
		 	$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
		 }, 3000);
    });
	
	//주문정보 테이블 행 제거
	 function fn_minus_body() {
	    	
	        orderTable.row(order_table_RowCount - 1).remove().draw();

	        order_table_info = orderTable.page.info();
	        order_table_RowCount = order_table_info.recordsTotal;
	 }
	
	//제품명 input 클릭시
	 function prodAdd(obj) {
			
			var trNum = $(obj).closest('tr').prevAll().length;
		 	console.log(trNum);
		 
		 	$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/mes/mes_order_popup.jsp',
                data: {
                	trNum: trNum,
                },
                success: function (html) {
                    $("#modalWrapper").html(html);
                }
            });
			
		}
	
	
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
      	  <button type="button" class="btn btn-warning" id="excel">
      	  	주문정보엑셀등록
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
					    <th style = 'display:none; width:0px;'>고객사</th>
					    <th>고객사명</th>
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
						<th style = 'display:none; width:0px;'>제품아이디</th>
					    <th>제품명</th>
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
				<tbody id="order_input_table_tbody">
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


<div class="modal fade" id="myModal2" tabindex="-1" role="dialog"  aria-hidden="true">
    	<div class="modal-dialog modal-dialog-scrollable">
    		<div class="modal-content">
        		<div class="modal-header">
        			<h4 class="modal-title2"></h4>
          		</div>
          		<div class="modal-body">
          			<table class='table table-bordered nowrap table-hover' 
				   	id="customerTable" style="width:100%">
					<thead>
						<tr>
					    	<th style = "display:none; width:0%;">고객사코드</th>
					    	<th>고객사명</th>
						</tr>
					</thead>
					<tbody id="customerTableBody">		
					</tbody>
			</table>
        		</div>
		        <div class="modal-footer">
        			 <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
		        </div>
        	</div>
      	</div>
 </div>
 
<div id = "modalWrapper"></div>

<div id = "modalWrapper2"></div>