<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<% 
String productName = "";

if(request.getParameter("productName") != null) {
	productName = request.getParameter("productName").toString();
}

%>

<!-- 
출하 등록
 -->
 
<!-- 메인 모달창 -->
<!--
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
 -->
<!-- 반품 선택 모달창 -->
<div class="modal fade" id="orderSelectModal" 
	 tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	 aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="exampleModalLabel">반품</h3>
      </div>
      <div class="modal-body">
        <div class="form-group row">
	        
      	<label for="basic-url">제품명</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="product-name">
		</div>
      	<label for="basic-url">반품수량</label>
		<div class="input-group mb-3">
		  <input type="text" class="form-control" id="return-count">
      </div>  	
			
		</div>
		<div style="float: right;">
			<button class="btn" id="closeBtn1">
				닫기
			</button>
			<button type="button" class="btn btn-primary" id="update-btn">저장</button>  
		</div>
      </div>
    </div>
  </div>
</div>

<script>

	$(document).ready(function () {
		
		let chulhaInsertTable;
		let orderSelectTable;
		
		//$('#chulhaDate').datepicker("setDate", new Date());
		//$('#ipgoChulgoMainModal').modal('show');
		
		$('#orderSelectModal').modal('show');
		
		$('#product-name').val('<%=productName%>');
		
		
		$('#closeBtn1').click(function() {
			$('orderSelectModal').modal('hide');
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
			console.log(obj);
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