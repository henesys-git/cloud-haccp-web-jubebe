<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">

	var chulhaJspPage = {};
    var dataLength;
    
	$(document).ready(function () {

		let mainTable;
		let subTable;
		let mainTableSelectedRow;
	    
	    async function initTable() {
	    	var chulhaInfo = new ChulhaInfo();
	    	var chulhaData = await chulhaInfo.getChulhaInfo();
	    	
	    	var customOpts = {
					data : chulhaData,
					pageLength: 10,
					columns: [
						{ data: "chulhaNo", defaultContent: '' },
						{ data: "chulhaDate", defaultContent: '' },
						{ data: "customerName", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#mainTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    chulhaJspPage.fillSubTable = async function (chulhaNo) {
	    	var chulhaInfo = new ChulhaInfo();
	    	var chulhaDetailData = await chulhaInfo.getChulhaInfoDetail(chulhaNo);
	    	
	    	if(subTable) {
	    		// redraw
	    		subTable.clear().rows.add(chulhaDetailData).draw();
	    	} else {
	    		// initialize
			    var option = {
						data : chulhaDetailData,
						pageLength: 10,
						columns: [
							{ data: "chulhaNo", defaultContent: '' },
							{ data: "productId", defaultContent: '' },
							{ data: "productName", defaultContent: '' },
							{ data: "chulhaCount", defaultContent: '' },
							{ data: "returnCount", defaultContent: '' },
							{ data: "returnType", defaultContent: '' }
				        ],
				        columnDefs : [
				   			{
					  			targets: [5],
					  			render: function(td, cellData, rowData, row, col) {
					  				if(rowData.returnType == '' || rowData.returnType == null) {
				  						return `<button class='btn btn-success return-btn'>반품</button>`;
					  				} else {
					  					return rowData.returnType;
					  				}
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
			
    		if(subTable) {
	    		subTable.clear().draw();
	    	}
		}
    	
    	$('#mainTable tbody').on('click', 'tr', function () {
    		
    		if ( !$(this).hasClass('selected') ) {
    			mainTableSelectedRow = mainTable.row( this ).data();
    			chulhaJspPage.fillSubTable(mainTableSelectedRow.chulhaNo);
            }
    	});
    	
    	// 출하 등록
		$('#ipchulgoBtn').click(function() {
			var row = mainTable.rows( '.selected' ).data();
			
			$.ajax({
                type: "POST",
                url: heneServerPath + '/Contents/mes/shipment_insert.jsp',
                success: function (html) {
                    $("#modalWrapper").html(html);
                }
            });
		});
    	
    	$('#subTableBody').off().on('click', 'button', function() {
    		if( $(this).hasClass("return-btn") ) {
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
	        		출하 관리
	        	</h1>
	      	</div>
	      	<div class="col-sm-6">
      			<div class="float-sm-right">
					<button type="button" class="btn btn-info" id="ipchulgoBtn">
						출하 등록
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
	          		출하 목록
	          	</h3> 
	        </div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="mainTable" style="width:100%">
				<thead>
					<tr>
					    <th>출하번호</th>
					    <th>출하날짜</th>
					    <th>고객명</th>
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
					    <th>출하번호</th>
					    <th>완제품아이디</th>
					    <th>완제품명</th>
					    <th>출하수량</th>
					    <th>반품수량</th>
					    <th>반품사유</th>
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