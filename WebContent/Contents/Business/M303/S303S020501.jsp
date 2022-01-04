<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 선반 입고 -->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
%>

<div class="col" id="first" style="display:none;">
<!-- Horizontal Form -->
	<div class="card card-info">
		<form class="form-horizontal" id="barcodeForm">
			<div class="card-body">
				<div class="form-group row">
             		<label for="barcode" class="col-sm-4 col-form-label">바코드</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="barcode" readonly name="barcode">
					</div>
				</div>
				<div class="form-group row">
             		<label for="manufacturing_date" class="col-sm-4 col-form-label">제조년월일</label>
					<div class="col-sm-8">
						<input type="date" class="form-control" id="manufacturing_date" readonly name="manufacturing_date">
					</div>
				</div>
				<div class="form-group row">
             		<label for="prod_name" class="col-sm-4 col-form-label">제품명</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="prod_name" readonly name="prod_name">
					</div>
				</div>
				<div class="form-group row">
             		<label for="prod_cd" class="col-sm-4 col-form-label">제품코드</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="prod_cd" readonly name="prod_cd">
					</div>
				</div>
				<div class="form-group row">
             		<label for="prod_count_on_shelf" class="col-sm-4 col-form-label">제품수량</label>
					<div class="col-sm-4">
						<input type="text" class="form-control input-lg" id="prod_count_on_shelf" name="prod_count_on_shelf" value=0>
					</div>
					<div class="col-sm-4">
						<button type="button" class="btn-lg btn-primary w-100" id="default">초기화</button>
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-4"></div>
					<div class="col-sm-8">
						<div>
							<button type="button" class="btn-lg btn-primary btn-block" id="shelfPlus">선반</button>
						</div>
						<div class="btn-group d-flex mt-2" role="group">
							<button type="button" class="btn-lg btn-primary w-50" id="trayPlus">
								<i class="fas fa-plus"></i>
							</button>
							<button type="button" class="btn-lg btn-secondary disabled w-100" aria-disabled="true">
								쟁반
							</button>
							<button type="button" class="btn-lg btn-danger w-50" id="trayMinus">
								<i class="fas fa-minus"></i>
							</button>
						</div>
						<div class="btn-group d-flex mt-2" role="group">
							<button type="button" class="btn-lg btn-primary w-50" id="piecePlus">
								<i class="fas fa-plus"></i>
							</button>
							<button type="button" class="btn-lg btn-secondary disabled w-100" aria-disabled="true">
								낱개
							</button>
							<button type="button" class="btn-lg btn-danger w-50" id="pieceMinus">
								<i class="fas fa-minus"></i>
							</button>
						</div>
					</div>
				</div>
				<div class="form-group row">
             		<label for="note" class="col-sm-4 col-form-label">비고</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="note" name="note">
					</div>
				</div>
			</div>
			<!-- /.card-body -->
			
			<input type="hidden" id="request_rev_no" name="request_rev_no">
			<input type="hidden" id="prod_plan_date" name="prod_plan_date">
			<input type="hidden" id="plan_rev_no" name="plan_rev_no">
			<input type="hidden" id="prod_rev_no" name="prod_rev_no">
		</form>
        <!-- form end -->
    </div>
    <!-- /.card -->
</div>
<!-- /.col -->

<div id="second">
	바코드를 스캔해주세요
	<input id="hidden_barcode">
</div>

<script>
	
	var shelf_row;
	var shelf_column;
	var tray_prod_count;
	var maxShelfCount = shelf_row * shelf_column * tray_prod_count;
	
	$('#hidden_barcode').focus();
	
    $(document).ready(function () {
    	
    	new SetSingleDate2("", "#manufacturing_date", 0);
    	$('#manufacturing_date').css('pointer-events', 'none'); // disable click
		
    	// 바코드를 한번 읽으면 더 이상 실행 안되도록 하기 위한 변수
    	// 스캔 실패시엔 다시 true로 변경해준다
   		let barcode_modal_open = true;
		
   		// 바코드값으로 서버 측 정보를 제대로 읽으면 메인 화면을 보여준다
    	var showMainScreen = function() {
    		$('#second').toggle();
    		$('#first').toggle();
        	$('#btn_Save').toggle();
    	}
    	
   		var ajaxGetDataFromDb = function(param, cb) {
        	$.ajax({
    			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
    			data : {
    				prmtr : param,
    				pid : 'M303S020500E114'
    			},
    			success: function(data) {
    				if(data.length > 0) {
    					// 필요한 값들을 설정
    					$('#request_rev_no').val(data[0][1]);
    					$('#prod_plan_date').val(data[0][2]);
    					$('#plan_rev_no').val(data[0][3]);
    					$('#prod_rev_no').val(data[0][5]);
    					$('#prod_name').val(data[0][6]);
    					shelf_row = data[0][7];
    					shelf_column = data[0][8];
    					tray_prod_count = data[0][9];
    					
    					heneSwal.successTimer('바코드 스캔 완료');
    					cb(true);
    				} else {
    					heneSwal.errorTimer('에러 발생, 다시 시도해주세요');
						cb(false);
    				}
    			},
    			error: function() {
    				heneSwal.errorTimer('에러 발생, 다시 시도해주세요');
    				cb(false);
    			}
    		});
        }
    	
    	var readBarcode = function() {
    		$("#hidden_barcode").keyup(function() {
	    		if(this.value.length >= 21 && barcode_modal_open) {
	    			barcode_modal_open = false;
	    			
	    			// set main modal values
	    			var barcode = $('#hidden_barcode').val();
	        		var prod_cd = barcode.substring(0, 4);
	        		$('#hidden_barcode').val('');
	        		
	        		$('#barcode').val(barcode);
	        		$('#prod_cd').val(prod_cd);
	        		
	       			var obj = new Object();
	       			obj.manufacturing_date = $('#manufacturing_date').val();
	       			obj.prod_cd = $('#prod_cd').val();
	       			obj = JSON.stringify(obj);
	       			
	       			ajaxGetDataFromDb(obj, function(success) {
	       				if(success) {
	       					showMainScreen();
	       				} else {
	       					barcode_modal_open = true;
	       				}
	       			});
	    		}
	    	});
    	}
    	
    	readBarcode();
    	
    	// 선반 꽉 찼을 때 수량 계산
    	var shelf_full = false;	// 한번만 클릭할 수 있도록
    	$('#shelfPlus').click(function() {
    		if(!shelf_full) {
	    		var count = shelf_row * shelf_column * tray_prod_count;
	    		$('#prod_count_on_shelf').val(count);
    			shelf_full = true;
    		}
    	});
    	
    	// 쟁반 기준 개수 추가
    	$('#trayPlus').click(function() {
    		var curCount = $('#prod_count_on_shelf').val();
   			var count = tray_prod_count;
       		var addedCount = parseInt(curCount) + parseInt(count);
       		
       		if(addedCount <= maxShelfCount) {
	       		$('#prod_count_on_shelf').val(addedCount);
       		}
    	});

    	// 쟁반 기준 개수 차감
    	$('#trayMinus').click(function() {
    		var curCount = $('#prod_count_on_shelf').val();
    		var count = tray_prod_count;
    		var subtractedCount = parseInt(curCount) - parseInt(count);
    		
    		if(subtractedCount > -1) {
				$('#prod_count_on_shelf').val(subtractedCount);
				shelf_full = false;
    		}
    	});
    	
    	// 낱개 기준 개수 추가
    	$('#piecePlus').click(function() {
    		var curCount = $('#prod_count_on_shelf').val();
   			var addedCount = parseInt(curCount) + 1;
   			
   			if(addedCount <= maxShelfCount) {
	       		$('#prod_count_on_shelf').val(addedCount);
       		}
    	});
    	
    	// 낱개 기준 개수 차감
    	$('#pieceMinus').click(function() {
    		var curCount = $('#prod_count_on_shelf').val();
    		var subtractedCount = parseInt(curCount) - 1;

    		if(subtractedCount > -1) {
				$('#prod_count_on_shelf').val(subtractedCount);
				shelf_full = false;
    		}
    	});
    	
    	// 개수 0으로 초기화
    	$('#default').click(function() {
    		$('#prod_count_on_shelf').val(0);
    		shelf_full = false;
    		console.log("개수 초기화됨");
			console.log("shelf full?" + shelf_full);
    	});
    });
	
    var ajaxInsertShelf = function() {
    	var countOnShelf = $('#prod_count_on_shelf').val();
    	if(countOnShelf <= 0) {
    		heneSwal.error('수량을 확인해주세요');
    		return false;
    	}
    	
    	var formData = getFormDataJson('#barcodeForm');
    	console.log(formData);
    	$.ajax({
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
			data : {
				bomdata : JSON.stringify(formData),
				pid : 'M303S020500E101'
			},
			success: function(returnVal) {
				if(returnVal < 1) {
					heneSwal.error('에러 발생, 다시 시도해주세요');
				} else {
					$('#modalReport').modal('hide');
					parent.fn_MainInfo_List();
					heneSwal.success('선반 입고 완료 되었습니다');
				}
			},
			error: function() {
				heneSwal.error('에러 발생, 다시 시도해주세요');
			}
		});
    }
</script>