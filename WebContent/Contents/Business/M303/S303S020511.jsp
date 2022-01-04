<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
	라벨 출력 
	S303S020511.jsp
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
%>

<div class="col">
<!-- Horizontal Form -->
	<div class="card card-info">
		<div class="card-header">
			<h3 class="card-title">라벨 정보</h3>
        </div>
        <!-- /.card-header -->
        <!-- form start -->
		<form class="form-horizontal">
			<div class="card-body">
				<div class="form-group row">
             		<label for="printDate" class="col-sm-4 col-form-label">출력 날짜</label>
					<div class="col-sm-8">
						<input type="date" class="form-control" id="printDate" readonly>
					</div>
				</div>
				<div class="form-group row">
             		<label for="prodName" class="col-sm-4 col-form-label">제품명</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="prodName" readonly placeholder="클릭해주세요">
					</div>
				</div>
				<div class="form-group row">
             		<label for="prodName" class="col-sm-4 col-form-label">라벨 표시 번호</label>
					<div class="col-sm-8">
						<input type="number" class="form-control" id="sideNumber" placeholder="선반 라벨 참조 숫자 입력">
					</div>
				</div>
				<div class="form-group row">
             		<label for="prodCode" class="col-sm-4 col-form-label">제품코드</label>
					<div class="col-sm-8">
						<input type="text" class="form-control" id="prodCode" readonly placeholder="제품 선택 시 자동 기입">
						<input type="hidden" class="form-control" id="prodRevNo">
					</div>
				</div>
			</div>
			<!-- /.card-body -->
		</form>
        <!-- form end -->
    </div>
    <!-- /.card -->
</div>
<!-- /.col -->


<script type="text/javascript">
	
    $(document).ready(function () {
    	
	    new SetSingleDate2("", "#printDate", 0);
	    
	    // 제조년월일 기준으로 유통기한 날짜 변경
	    $('#manufactureDate').change(function() {
	    	var date = adjustExpDate($('#manufactureDate').val(), vExpirationDate);
	    	$('#expirationDate').val(date);
	    });
	    
		// 제품명 input tag 클릭 시 제품 검색 팝업 생성
	    $('#prodName').click(function() {
	    	parent.pop_fn_ProductName_View(2,'01')
	    });
    });
	
 	
 	// 제품 검색 후 클릭한 데이터를 가져옴
    function SetProductName_code(prodName, prodCode, prodRevNo, 
    							 prodGyugyuk, safeStock, curStock) {
    	
    	$('#prodName').val(prodName);
    	$('#prodCode').val(prodCode);
    	$('#prodRevNo').val(prodRevNo);
    }
    
    var printStart = function() {
    	var prodName = $('#prodName').val();
    	var sideNumber = $('#sideNumber').val();
    	var prodNameWithNum = prodName.concat(sideNumber);
    	
		$.ajax({
			url: 'PrintBarcodeServlet',
			data : {
				printDate : $('#printDate').val(),
				prodName : prodNameWithNum,
				prodCode : $('#prodCode').val()
			},
			success: function(returnText) {
				heneSwal.success(returnText);
			},
			error: function() {
				heneSwal.error('출력 실패했습니다, 다시 시도해주세요');
			}
		})
	}
</script>