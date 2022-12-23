<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%

String trNum = "";

if(request.getParameter("trNum") != null) {
	trNum = request.getParameter("trNum").toString();
}

%>
<script type="text/javascript">
    
	var dataJspPage = {};
	var order_table_RowCount = 0;
	var orderTable;  //주문정보 테이블
	var aaa;
	
	$(document).ready(function () {
		
		let productTable; //팝업 제품정보 테이블
		let productTableSelectedRow;
		
		$('#myModal3').modal('show');
		
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
		
		 initProductTable();
		
		 $('#productTable tbody').on('click', 'tr', function () {
	    		
			 console.log('<%=trNum%>');
			 
	    		if ( !$(this).hasClass('selected') ) {
	    			productTableSelectedRow = productTable.row( this ).data();
	    			console.log(productTableSelectedRow.productId);
	    			parent.$('#txt_ProductName' + '<%=trNum%>').val(productTableSelectedRow.productName);
	    			parent.$('#txt_ProductCode' + '<%=trNum%>').val(productTableSelectedRow.productId);
	    			
	    			$('#myModal3').modal('hide');
	            }
	    		
	    	});
		 
		 setTimeout(function(){
			 	$($.fn.dataTable.tables(true)).DataTable().columns.adjust();
		 }, 1000);
		
    });
	
	//주문정보 테이블 행 제거
	 function fn_minus_body() {
	    	
	        orderTable.row(order_table_RowCount - 1).remove().draw();

	        order_table_info = orderTable.page.info();
	        order_table_RowCount = order_table_info.recordsTotal;
	 }

	
</script>
 
 <div class="modal fade" id="myModal3" tabindex="-1" role="dialog"  aria-hidden="true">
    	<div class="modal-dialog modal-dialog-scrollable">
    		<div class="modal-content">
        		<div class="modal-header">
        			<h4 class="modal-title3"></h4>
          		</div>
          		<div class="modal-body">
          			<table class='table table-bordered nowrap table-hover' 
				   	id="productTable" style="width:100%">
					<thead>
						<tr>
					    	<th style = "display:none; width:0%;">제품코드</th>
					    	<th>제품명</th>
						</tr>
					</thead>
					<tbody id="productTableBody">		
					</tbody>
			</table>
        		</div>
		        <div class="modal-footer">
        			 <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
		        </div>
        	</div>
      	</div>
 </div>
