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
             		<label for="start_date_freeze" class="col-sm-4 col-form-label">입고 날짜</label>
					<div class="col-sm-8">
						<input type="date" class="form-control" id="start_date_freeze" readonly name="start_date_freeze">
					</div>
				</div>
				<div class="form-group row">
             		<label for="start_time_freeze" class="col-sm-4 col-form-label">입고 시간</label>
					<div class="col-sm-8">
						<input type="time" class="form-control" id="start_time_freeze" name="start_time_freeze">
					</div>
				</div>
				<div class="form-group row">
             		<label for="prod_count_on_shelf" class="col-sm-4 col-form-label">제품수량</label>
					<div class="col-sm-8">
						<input type="text" class="form-control input-lg" id="prod_count_on_shelf" name="prod_count_on_shelf" readonly>
					</div>
				</div>
				<div class="form-group row">
             		<label for="prodTemperature" class="col-sm-4 col-form-label">제품 품온</label>
					<div class="col-sm-8 input-group">
						<input type="number" class="form-control" id="prodTemperature" 
							   name="prodTemperature" placeholder="제품 품온을 입력해 주세요">
						<div class="input-group-append">
					    	<span class="input-group-text">℃</span>
					    </div>
					</div>
				</div>
				<div class="form-group row">
             		<label for="note" class="col-sm-4 col-form-label">비고</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="note" name="note" readonly>
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
	<input type="text" id="hidden_barcode" autofocus>
</div>

<script>
	
    $(document).ready(function () {
    	$('#prodTemperature').focus();
    	
    	// disable click
    	$('#manufacturing_date, #start_date_freeze, #start_time_freeze')
    										.css('pointer-events', 'none');
    	
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
    				pid : 'M303S020500E124'
    			},
    			success: function(data) {
    				if(data.length > 0) {
    					// 필요한 값들을 설정
    					$('#manufacturing_date').val(data[0][0]);
    					$('#prod_name').val(data[0][4]);
    					$('#prod_cd').val(data[0][5]);
    					$('#prod_count_on_shelf').val(data[0][8]);
    					new SetSingleDate2(data[0][9], "#start_date_freeze", 0);
    					$('#start_time_freeze').val(data[0][10]);
    					$('#note').val(data[0][12]);
    					
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
	       			obj.barcode = barcode;
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
    });
	
    var ajaxTakeOutShelf = function() {
    	var formData = getFormDataJson('#barcodeForm');
    	console.log(formData);
    	$.ajax({
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
			data : {
				bomdata : JSON.stringify(formData),
				pid : 'M303S020500E112'
			},
			success: function(returnVal) {
				if(returnVal < 1) {
					heneSwal.error('에러 발생, 다시 시도해주세요');
				} else {
					$('#modalReport').modal('hide');
					parent.fn_MainInfo_List();
					heneSwal.success('선반 출고 완료 되었습니다');
				}
			},
			error: function() {
				heneSwal.error('에러 발생, 다시 시도해주세요');
			}
		});
    }
</script>