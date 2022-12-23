<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<script type="text/javascript">

	var rawmaterialStockJspPage = {};
    var dataLength;
    
	$(document).ready(function () {

		let mainTable;
		let subTable;
		let mainTableSelectedRow;
	    
	    async function initTable() {
	    	var rawmaterialStorage = new RawmaterialStorage();
	    	var stocks = await rawmaterialStorage.getStockGroupByRawmaterialId();

	    	//TODO: 삭제?
	    	dataLength = stocks.length;
	    	
	    	var customOpts = {
					data : stocks,
					pageLength: 10,
					columns: [
						{ data: "rawmaterialId", defaultContent: '' },
						{ data: "rawmaterialName", defaultContent: '' },
						{ data: "ioAmt", defaultContent: '' }
			        ]
			}
					
			mainTable = $('#mainTable').DataTable(
				mergeOptions(heneMainTableOpts, customOpts)
			);
	    }
	    
	    rawmaterialStockJspPage.fillSubTable = async function (rawmaterialId) {
	    	var rawmaterialStorage = new RawmaterialStorage();
	    	var stocks = await rawmaterialStorage.getStockGroupByStockNo(rawmaterialId);
	    	
	    	if(subTable) {
	    		// redraw
	    		subTable.clear().rows.add(stocks).draw();
	    	} else {
	    		// initialize
			    var option = {
						data : stocks,
						pageLength: 10,
						columns: [
							{ data: "rawmaterialStockNo", defaultContent: '' },
							{ data: "rawmaterialId", defaultContent: '' },
							{ data: "rawmaterialName", defaultContent: '' },
							{ data: "ioAmt", defaultContent: '' },
							{ data: "storageName", defaultContent: '' },
							{ data: "stockManage", defaultContent: '' },
							{ data: "history", defaultContent: '' }
				        ],
				        columnDefs : [
				   			{
					  			targets: [5],
					  			render: function(td, cellData, rowData, row, col){
			  						return `<button class='btn btn-success stock-btn'>재고입출고</button>`;
					  			}
					  		},
				   			{
					  			targets: [6],
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
			var rawmaterialStorage = new RawmaterialStorage();
	    	var stocks = await rawmaterialStorage.getStockGroupByRawmaterialId();

			mainTable.clear().rows.add(stocks).draw();
			dataLength = newData.length;
			
    		if(subTable) {
	    		subTable.clear().draw();
	    	}
		}
    	
    	$('#mainTable tbody').on('click', 'tr', function () {
    		
    		if ( !$(this).hasClass('selected') ) {
    			mainTableSelectedRow = mainTable.row( this ).data();
    			rawmaterialStockJspPage.fillSubTable(mainTableSelectedRow.rawmaterialId);
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
                url: heneServerPath + '/Contents/mes/mes_rawmaterial_stock_manage.jsp',
                data: {
                	rawmaterialId: row[0].rawmaterialId,
                	rawmaterialName: row[0].rawmaterialName,
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
                url: heneServerPath + '/Contents/mes/mes_rawmaterial_stock_manage.jsp',
                data: {
                	rawmaterialStockNo: row.rawmaterialStockNo,
                	rawmaterialId: row.rawmaterialId,
                	rawmaterialName: row.rawmaterialName,
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
                url: heneServerPath + '/Contents/mes/mes_rawmaterial_stock_history.jsp',
                data: {
                	rawmaterialStockNo: row.rawmaterialStockNo
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
	        		원부재료 관리
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
	          		원부재료 재고
	          	</h3> 
	        </div>
          </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' 
				   id="mainTable" style="width:100%">
				<thead>
					<tr>
					    <th>원부재료아이디</th>
					    <th>원부재료명</th>
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
					    <th>원부재료아이디</th>
					    <th>원부재료명</th>
					    <th>재고</th>
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