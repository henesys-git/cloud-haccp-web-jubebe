<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">

	var productStockJspPage = {};
    var dataLength;
    
	$(document).ready(function () {

		let mainTable;
		let subTable;
		let mainTableSelectedRow;
	    
	    async function initTable() {
	    	var productStorage = new ProductStorage();
	    	var stocks = await productStorage.getStockGroupByProductId();

	    	//TODO: 삭제?
	    	dataLength = stocks.length;
	    	
	    	var customOpts = {
					data : stocks,
					pageLength: 5,
					columns: [
						{ data: "productId", defaultContent: '' },
						{ data: "productName", defaultContent: '' },
						{ data: "ioAmt", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#mainTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    productStockJspPage.fillSubTable = async function (productId) {
	    	var productStorage = new ProductStorage();
	    	var stocks = await productStorage.getStockGroupByStockNo(productId);
			// 재고번호가 없는건 실제 재고 테이블에 없는 데이터이다.
	    	stocks = stocks.filter((obj) => {
	    		return obj.productStockNo != null;
	    	});
	    	
	    	if(subTable) {
	    		// redraw
	    		subTable.clear().rows.add(stocks).draw();
	    	} else {
	    		// initialize
			    var option = {
						data : stocks,
						pageLength: 10,
						columns: [
							{ data: "productStockNo", defaultContent: '' },
							{ data: "productId", defaultContent: '' },
							{ data: "productName", defaultContent: '' },
							{ data: "ioAmt", defaultContent: '' },
							{ data: "lotno", defaultContent: '' },
							{ data: "expirationDate", defaultContent: '' },
							{ data: "storageName", defaultContent: '' },
							{ data: "stockManage", defaultContent: '' },
							{ data: "history", defaultContent: '' }
				        ],
				        columnDefs : [
				   			{
					  			targets: [7],
					  			render: function(td, cellData, rowData, row, col){
			  						return `<button class='btn btn-success stock-btn'>재고입출고</button>`;
					  			}
					  		},
				   			{
					  			targets: [8],
					  			render: function(td, cellData, rowData, row, col){
			  						return `<button class='btn btn-success history-btn'>조회</button>`;
					  			}
					  		}
					    ]
				}
	    		
				subTable = $('#subTable').DataTable(
					mergeOptions(heneMainTableOpts, option)
				);
	    	}
	    };
	    
		initTable();
		
		async function refreshMainTable() {
			var productStorage = new ProductStorage();
	    	var stocks = await productStorage.getStockGroupByProductId();

			mainTable.clear().rows.add(stocks).draw();
			dataLength = newData.length;
			
    		if(subTable) {
	    		subTable.clear().draw();
	    	}
		}
    	
    	$('#mainTable tbody').on('click', 'tr', function () {
    		
    		if ( !$(this).hasClass('selected') ) {
    			mainTableSelectedRow = mainTable.row( this ).data();
    			productStockJspPage.fillSubTable(mainTableSelectedRow.productId);
            }
    	});
    	
    	// 수기 신규 입고
		$('#ipchulgoBtn').click(function() {
			var row = mainTable.rows( '.selected' ).data();
			
			if(row.length == 0) {
				alert('입출고 관리할 제품을 선택해주세요.');
				return false;
			}
			
			$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/mes/mes_product_stock_manage.jsp',
                data: {
                	productId: row[0].productId,
                	productName: row[0].productName,
                	ipgoOnly: "Y"
                },
                success: function (html) {
                    $("#modalWrapper").html(html);
                }
            });
		});
    	
    	
    	$('#subTableBody').off().on('click', 'button', function() {
    		if( $(this).hasClass("stock-btn") ) {
    			editCurrentStock(this);
    		}
    		
    		if( $(this).hasClass("history-btn") ) {
    			displayStockHistory(this);
    		}
    	});
    
    	// 기존 재고 수정
    	function editCurrentStock(that) {
    		var tr = $(that).parents('tr')[0];
			var row = subTable.rows(tr).data()[0];
    		
	    	$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/mes/mes_product_stock_manage.jsp',
                data: {
                	productStockNo: row.productStockNo,
                	productId: row.productId,
                	productName: row.productName,
                	ioAmt: row.ioAmt,
                	ipgoOnly: "N"
                },
                success: function (html) {
                    $("#modalWrapper").html(html);
                }
            });
    	}
    	
    	// 재고 이력 조회
    	function displayStockHistory(that) {
    		
    		var tr = $(that).parents('tr')[0];
			var row = subTable.rows(tr).data()[0];
    		
	    	$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/mes/mes_product_stock_history.jsp',
                data: {
                	productStockNo: row.productStockNo
                },
                success: function (html) {
                    $("#modalWrapper").html(html);
                }
            });
    	}
    });
</script>

<!-- Content Header (Page header) -->
<div class="content-header">
  	<div class="container-fluid">
    	<div class="row mb-2">
	      	<div class="col-sm-6">
	        	<h1 class="m-0 text-dark">
	        		완제품 관리
	        	</h1>
	      	</div>
	      	<div class="col-sm-6">
      			<div class="float-sm-right">
					<button type="button" class="btn btn-info" id="ipchulgoBtn">
						직접 입고 등록
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
          <div class="card-header row">
       		<div class="col-md-12">
	          	<h3 class="card-title">
	          		<i class="fas fa-edit" id="InfoContentTitle"></i>
	          		완제품 재고
	          	</h3> 
	        </div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="mainTable" style="width:100%">
				<thead>
					<tr>
					    <th>완제품아이디</th>
					    <th>완제품명</th>
					    <th>현재재고</th>
					</tr>
				</thead>
				<tbody id="mainTableBody">
				</tbody>
			</table>
          </div> 
           
         <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="subTable" style="width:100%">
				<thead>
					<tr>
					    <th>재고번호</th>
					    <th>완제품아이디</th>
					    <th>완제품명</th>
					    <th>재고</th>
					    <th>LOT번호</th>
					    <th>유통기한</th>
					    <th>저장창고</th>
					    <th>재고관리</th>
					    <th>이력</th>
					</tr>
				</thead>
				<tbody id="subTableBody">
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

<div id="modalWrapper"></div>