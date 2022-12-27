<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<!-- 
출하 등록
 -->

<!-- 메인 모달창 -->
<div class="modal fade" id="ipgoChulgoMainModal" 
	 tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	 aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="chulhaInsertTitle">출하 등록</h3>
      </div>
      <div class="modal-body">
        <div style="float: right;">
			<button class="btn btn-primary" id="selectOrder">
				출하할 주문 선택
			</button>
		</div>
		<div class="form-group row">
			<div class="col-sm-3" id="ipgoChulgoDateText">출하일자</div>
			<div class="col-sm-9">
				<input id="ipgoChulgoDate" data-date-format='yyyy-mm-dd' />
			</div>
		</div>
        <div class="form-group row">
			<div class="col-sm-3">받을 고객명</div>
			<div class="col-sm-9" id="customerName"></div>
		</div>
        <div class="form-group row">
			<div class="col-sm-3">받을 고객아이디</div>
			<div class="col-sm-9" id="customerId"></div>
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

<!-- 주문/비주문 선택 모달창 -->
<div class="modal fade" id="ipgoChulgoSelectModal" 
	 tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	 aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="exampleModalLabel">입출고 선택</h3>
      </div>
      <div class="modal-body">
        <button type="button" class="btn btn-primary" id="chulhaFromOrder">
        	주문출하
        </button>
        <button type="button" class="btn btn-primary" id="chulhaFromNonOrder">
        	비주문출하
        </button>lll
      </div>
    </div>
  </div>
</div>

<script>

	var chulhaInsertJspPage = {};
	
	$(document).ready(function () {
		
		let chulhaInsertTable;
		
		$('#ipgoChulgoDate').datepicker("setDate", new Date());
		
		$('#productStockNo').text('');
		$('#ipgoChulgoText').text('입고수량');
		$('#ipgoChulgoDateText').text('입고일자');
		$('#ipgoChulgoMainModal').modal('show');
		
		chulhaJspPage.fillSubTable = async function () {
	    	var orders = {} // get seleced order info
	    	
	    	if(chulhaInsertTable) {
	    		// redraw
	    		chulhaInsertTable.clear().rows.add(orders).draw();
	    	} else {
	    		// initialize
			    var option = {
						data : orders,
						pageLength: 10,
						columns: [
							{ data: "productId", defaultContent: '' },
							{ data: "productName", defaultContent: '' },
							{ data: "chulhaCount", defaultContent: '' }
				        ]
				}
	    		
			    chulhaInsertTable = $('#subTable').DataTable(
					mergeOptions(heneMainTableOpts, option)
				);
	    	}
	    };
		
		$('#saveBtn0').click(async function() {
			// 예외처리
			if(!validate()) {
				return false;
			}
			
			let obj = {};
			obj.productId = "";
			obj.ioDatetime = $('#ipgoChulgoDate').val()
							+ " " 
							+ new HeneDate().getTime();
			obj.productStockNo = "";
			
			if(ipgoChulgo == 'chulgo') {
				obj.ioAmt = Number( $('#ioAmt').val() ) * -1;
			} else if(ipgoChulgo == 'ipgo') {
				obj.ioAmt = Number( $('#ioAmt').val() );
			}
			
			var productStorage = new ProductStorage();
			var result = await productStorage.ipgoChulgo(obj);
			
			if(result) {
				alert('완제품 입출고 완료되었습니다.');
				$('#ipgoChulgoMainModal').modal('hide');
				chulhaInsertJspPage.fillSubTable("");
			} else {
				alert('완제품 입출고 실패, 관리자에게 문의해주세요.');
			}
		});
		
		$('#closeBtn0').click(function() {
			$('#ipgoChulgoMainModal').modal('hide');
		})
		
		function validateIpgoAmt() {
			
			var ioAmt = $('#ioAmt').val();

			if(ioAmt == "") {
				alert('입고 수량 입력 필수');
				return false;
			}
			
			if(Number(ioAmt) <= 0) {
				alert('0이상 입력 필요');
				return false;
			}
			
			return true;
		}
		
		function validateChulgoAmt() {
			
			var ioAmt = $('#ioAmt').val();
			
			if(ioAmt == "") {
				alert('출고 수량 입력 필수');
				return false;
			}
			
			if(Number(ioAmt) <= 0) {
				alert('0 이상 입력 필요');
				return false;
			}
			
			if( 1 < Number(ioAmt) ) {
				alert('현재 재고보다 출고량이 많습니다.');
				return false;
			}
			
			return true;
		}
		
		function validate() {
			var result;
			
			if(ipgoChulgo == 'ipgo') {
				result = validateIpgoAmt();
			};

			if(ipgoChulgo == 'chulgo') {
				result = validateChulgoAmt();
			};
			
			return result;
		}
		
	});	// document.ready
</script>