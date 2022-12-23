<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="mes.frame.business.SCM.*" %>
<%@ page import="mes.frame.util.*" %>

<!-- 
원부재료 재고 관리
 -->
<%
	String rawmaterialStockNo = "";
	String rawmaterialId = "";
	String rawmaterialName = "";
	String ipgoOnly = "";
	
	if(request.getParameter("rawmaterialStockNo") != null) {
		rawmaterialStockNo = request.getParameter("rawmaterialStockNo");
	}

	if(request.getParameter("rawmaterialId") != null) {
		rawmaterialId = request.getParameter("rawmaterialId");
	}

	if(request.getParameter("rawmaterialName") != null) {
		rawmaterialName = request.getParameter("rawmaterialName");
	}

	if(request.getParameter("ipgoOnly") != null) {
		ipgoOnly = request.getParameter("ipgoOnly");
	}
%>

<!-- 메인 화면 -->
<div class='modify-prod-stock-wrapper'>
	
</div>

<!-- 메인 모달창 -->
<div class="modal fade" id="ipgoChulgoMainModal" 
	 tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	 aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="ipgoChulgoTitle"></h3>
      </div>
      <div class="modal-body">
        
        <div class="form-group row">
			<div class="col-sm-3">재고번호</div>
			<div class="col-sm-9" id="rawmaterialStockNo"></div>
		</div>
        <div class="form-group row">
			<div class="col-sm-3">원부재료명</div>
			<div class="col-sm-9" id="rawmaterialName"></div>
		</div>
		<div class="form-group row">
			<div class="col-sm-3" id="ipgoChulgoDateText">입고일자</div>
			<div class="col-sm-9">
				<input id="ipgoChulgoDate" data-date-format='yyyy-mm-dd' />
			</div>
		</div>
		<div class="form-group row">
			<div class="col-sm-3" id="ipgoChulgoText">입고수량</div>
			<div class="col-sm-9">
				<input id="ioAmt" type="number" />
			</div>
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

<!-- 입고/출고 선택 모달창 -->
<div class="modal fade" id="ipgoChulgoSelectModal" 
	 tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	 aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="exampleModalLabel">입출고 선택</h3>
      </div>
      <div class="modal-body">
        <button type="button" class="btn btn-primary" id="selectIpgo">
        	입고
        </button>
        <button type="button" class="btn btn-primary" id="selectChulgo">
        	출고
        </button>
      </div>
    </div>
  </div>
</div>

<script>
	
	$(document).ready(function () {
		
		$('#rawmaterialName').text('<%=rawmaterialName%>');
		let ipgoChulgo;
		
		$('#ipgoChulgoSelectModal').on('show.bs.modal', function () {
			
			$('#ipgoChulgoDate').datepicker("setDate", new Date());
			
			$('#selectIpgo').off().on('click', function() {
				ipgoChulgo = "ipgo";
				$('#rawmaterialStockNo').text('<%=rawmaterialStockNo%>');
				$('#ipgoChulgoTitle').text('원부재료 입고');
				$('#ipgoChulgoText').text('입고수량');
				$('#ipgoChulgoDateText').text('입고일자');
				$('#ipgoChulgoSelectModal').modal('hide');
				$('#ipgoChulgoMainModal').modal('show');
			});
			
			$('#selectChulgo').off().on('click', function() {
				ipgoChulgo = "chulgo";
				$('#rawmaterialStockNo').text('<%=rawmaterialStockNo%>');
				$('#ipgoChulgoTitle').text('원부재료 출고');
				$('#ipgoChulgoText').text('출고수량');
				$('#ipgoChulgoDateText').text('출고일자');
				$('#ipgoChulgoSelectModal').modal('hide');
				$('#ipgoChulgoMainModal').modal('show');
			});
		});
		
		if('<%=ipgoOnly%>' == 'Y') {
			ipgoChulgo = "ipgo";
			$('#ipgoChulgoDate').datepicker("setDate", new Date());
			$('#rawmaterialStockNo').text('자동 생성');
			$('#ipgoChulgoTitle').text('원부재료 입고');
			$('#ipgoChulgoText').text('입고수량');
			$('#ipgoChulgoDateText').text('입고일자');
			$('#ipgoChulgoMainModal').modal('show');
		} else {
			$('#ipgoChulgoSelectModal').modal('show');
		}
		
		$('#saveBtn0').click(async function() {
			// 예외처리
			if(!validate()) {
				return false;
			}
			
			let obj = {};
			obj.rawmaterialId = "<%=rawmaterialId%>";
			obj.ioDatetime = $('#ipgoChulgoDate').val()
							+ " " 
							+ new HeneDate().getTime();
			obj.rawmaterialStockNo = "<%=rawmaterialStockNo%>";
			
			if(ipgoChulgo == 'chulgo') {
				obj.ioAmt = Number( $('#ioAmt').val() ) * -1;
			} else if(ipgoChulgo == 'ipgo') {
				obj.ioAmt = Number( $('#ioAmt').val() );
			}
			
			var rawmaterialStorage = new RawmaterialStorage();
			var result = await rawmaterialStorage.ipgoChulgo(obj);
			
			if(result) {
				alert('원부재료 입출고 완료되었습니다.');
				$('#ipgoChulgoMainModal').modal('hide');
				rawmaterialStockJspPage.fillSubTable("<%=rawmaterialId%>");
			} else {
				alert('원부재료 입출고 실패, 관리자에게 문의해주세요.');
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