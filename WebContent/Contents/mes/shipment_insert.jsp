<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<!-- 
출하 등록
 -->

<!-- 메인 모달창 -->
<div class="modal fade" id="ipgoChulgoMainModal" 
	 tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	 aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="chulhaInsertTitle">출하 등록</h3>
      </div>
      <div class="modal-body">
		<div class="form-group row">
			<div class="col-sm-3">출하일자</div>
			<div class="col-sm-5">
				<input id="chulhaDate" data-date-format='yyyy-mm-dd' />
			</div>
			<div class="col-sm-4">
				<button class="btn btn-primary" id="selectOrder">
					출하할 주문 선택
				</button>
			</div>
		</div>
        <div class="form-group row">
			<div class="col-sm-3">받을 고객명</div>
			<div class="col-sm-9" id="customerName"></div>
		</div>
        <div class="form-group row">
			<div class="col-sm-3">받을 고객아이디</div>
			<div class="col-sm-9" id="customerCode"></div>
		</div>
		<div class="form-group row">
			<table class='table table-bordered nowrap table-hover' 
				   id="chulhaInsertTable" style="width:100%">
				<thead>
					<tr>
					    <th>완제품코드</th>
					    <th>완제품명</th>
					    <th>출하수량</th>
					</tr>
				</thead>
				<tbody id="chulhaInsertTableBody">
				</tbody>
			</table>
		</div>
		<div style="float: right;">
			<button class="btn btn-primary" id="saveBtn0">
				저장
			</button>
			<button class="btn" id="closeBtn0">
				닫기
			</button>
		</div>
      </div>
    </div>
  </div>
</div>

<!-- 주문 선택 모달창 -->
<div class="modal fade" id="orderSelectModal" 
	 tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	 aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="exampleModalLabel">주문 목록</h3>
      </div>
      <div class="modal-body">
        <div class="form-group row">
	        <table class='table table-bordered nowrap table-hover' 
					   id="orderSelectTable" style="width:100%">
				<thead>
					<tr>
					    <th>주문번호</th>
					    <th>고객명</th>
					    <th>주문일자</th>
					</tr>
				</thead>
				<tbody id="orderSelectTableBody">
				</tbody>
			</table>
		</div>
		<div style="float: right;">
			<button class="btn" id="closeBtn1">
				닫기
			</button>
		</div>
      </div>
    </div>
  </div>
</div>

<script>

	$(document).ready(function () {
		
		let chulhaInsertTable;
		let orderSelectTable;
		
		$('#chulhaDate').datepicker("setDate", new Date());
		$('#ipgoChulgoMainModal').modal('show');
		
		var fillChulhaInsertTable = async function (orderInfo) {
			let order = new Order();
	    	var orders = await order.getOrderDetailsNoChulhaYet(orderInfo.orderNo);
			
			$('#customerCode').text(orderInfo.customerCode);
			$('#customerName').text(orderInfo.customerName);

			if(chulhaInsertTable) {
	    		// redraw
	    		chulhaInsertTable.clear().rows.add(orders).draw();
	    	} else {
	    		// initialize
			    var option = {
						data : orders,
						pageLength: 5,
						columns: [
							{ data: "productId", defaultContent: '' },
							{ data: "productName", defaultContent: '' },
							{ data: "orderCount", defaultContent: '' },
							{ data: "orderNo", defaultContent: '' },
							{ data: "orderDetailNo", defaultContent: '' }
				        ],
				        columnDefs: [
				        	{
				                targets: [3, 4],
				                visible: false,
				            },
				        ]
				}
	    		
			    chulhaInsertTable = $('#chulhaInsertTable').DataTable(
					mergeOptions(heneMainTableOpts, option)
				);
	    	}
	    };
		
		$('#selectOrder').click(async function() {
			let order = new Order();
	    	var orders = await order.getOrdersNoChulhaYet();
	    	
	    	$('#orderSelectModal').on('show.bs.modal', function () {
			    var option = {
					data : orders,
					pageLength: 10,
					columns: [
						{ data: "orderNo", defaultContent: '' },
						{ data: "customerName", defaultContent: '' },
						{ data: "orderDate", defaultContent: '' }
			        ]
				}
	    		
			    setTimeout(function() { 
				    orderSelectTable = $('#orderSelectTable').DataTable(
						mergeOptions(heneMainTableOpts, option)
					);
				}, 500);
	    	});
	    	
	    	$('#orderSelectModal').modal('show');
		
			$('#orderSelectTable tbody').on('click', 'tr', function () {
	    		if ( !$(this).hasClass('selected') ) {
	    			var row = orderSelectTable.row( this ).data();
					fillChulhaInsertTable(row);
			    	$('#orderSelectModal').modal('hide');;
	            }
	    	});
			
			$('#closeBtn1').click(function() {
				$('#orderSelectModal').modal('hide');
			})
		})
		
		$('#closeBtn0').click(function() {
			$('#ipgoChulgoMainModal').modal('hide');
		})
		
		$('#saveBtn0').click(async function() {
			var chulhaInfo = new ChulhaInfo();
			var chulhaNo = chulhaInfo.generateChulhaNo();
			let obj = {};
			obj.chulhaNo = chulhaNo;
			obj.chulhaDate = $('#chulhaDate').val();
			obj.customerCode = $('#customerCode').text();
			obj.detail = [];
			
			let rows = chulhaInsertTable.rows().data();

			for(let i=0; i<rows.length; i++) {
				let innerObj = {};
				innerObj.chulhaNo = chulhaNo;
				innerObj.productId = rows[i].productId;
				innerObj.chulhaCount = rows[i].orderCount;
				innerObj.orderNo = rows[i].orderNo;
				innerObj.orderDetailNo = rows[i].orderDetailNo;
				obj.detail.push(innerObj);
			}
			
			var result = await chulhaInfo.chulha(obj);
			console.log(result);
			
			if(result == "success") {
				alert('출하 등록 완료되었습니다.');
				$('#ipgoChulgoMainModal').modal('hide');
				chulhaJspPage.refreshMainTable();
			} else if(result == "fail") {
				alert('출하 등록 실패, 관리자에게 문의해주세요.\n');
			} else {
				alert('출하 등록 실패\n' + result);
			}
		});
		
	});	// document.ready
</script>