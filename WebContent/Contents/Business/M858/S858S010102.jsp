﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_ORDER_DATE = "", GV_DELIVERY_DATE = "",
		   GV_CHULHA_NOTE = "", GV_ORDER_NOTE = "",
		   GV_CUST_NM = "", GV_ORDER_NO = "", GV_ORDER_REV_NO = "",
		   GV_CHULHA_NO = "", GV_CHULHA_REV_NO = "";
		
	if(request.getParameter("order_date") != null)
		GV_ORDER_DATE = request.getParameter("order_date");
	
	if(request.getParameter("delivery_date") != null)
		GV_DELIVERY_DATE = request.getParameter("delivery_date");
	
	if(request.getParameter("chulha_note") != null)
		GV_CHULHA_NOTE = request.getParameter("chulha_note");
	
	if(request.getParameter("order_note") != null)
		GV_ORDER_NOTE = request.getParameter("order_note");
	
	if(request.getParameter("cust_nm") != null)
		GV_CUST_NM = request.getParameter("cust_nm");
	
	if(request.getParameter("order_no") != null)
		GV_ORDER_NO = request.getParameter("order_no");
	
	if(request.getParameter("order_rev_no") != null)
		GV_ORDER_REV_NO = request.getParameter("order_rev_no");
	
	if(request.getParameter("chulha_no") != null)
		GV_CHULHA_NO = request.getParameter("chulha_no");
	
	if(request.getParameter("chulha_rev_no") != null)
		GV_CHULHA_REV_NO = request.getParameter("chulha_rev_no");
	
	String initChulgoTypeCode = "PROD_CHULGO_TYPE001";
	Vector chulgoTypeCode = null;
    Vector chulgoTypeName = null;
    Vector chulgoTypeList = CommonData.getProdChulgoType();
%>

<script src="<%=Config.this_SERVER_path%>/js/product/view.product.js"></script>

<script>
    var orderTable;
    var chulhaTable;
    var chulhaTable_Row_index = -1;
	var chulhaTable_info;
    var chulhaTable_RowCount = 0;
	
    var rowIdx = 0;
    
    $(document).ready(function () {
    	
    	setTimeout(function(){
    	
    	$('#orderDate').val('<%=GV_ORDER_DATE%>');
    	$('#custName').val('<%=GV_CUST_NM%>');
    	$('#deliveryDate').val('<%=GV_DELIVERY_DATE%>');
    	$('#orderNote').val('<%=GV_ORDER_NOTE%>');
    	$('#chulhaNote').val('<%=GV_CHULHA_NOTE%>');
    	$('#chulhaNo').val('<%=GV_CHULHA_NO%>');
    	$('#chulhaRevNo').val('<%=GV_CHULHA_REV_NO%>');
    	$('#orderNo').val('<%=GV_ORDER_NO%>');
    	$('#orderRevNo').val('<%=GV_ORDER_REV_NO%>');
    	
    	$('#orderDate').attr('disabled', true);
    	$('#custName').attr('disabled', true);
    	$('#deliveryDate').attr('disabled', true);
    	$('#orderNote').attr('disabled', true);
    	
    	// 주문목록 상세 테이블 초기화
    	let customOpts = {
   	   		paging : false,
   	    	searching : false,
   	    	ordering : false,
   	    	keys : false,
   	    	autoWidth : false,
   	    	createdRow : "",
   	    	columnDefs : [
				{ "className": "dt-head-center", "targets": "_all" }
			]
    	};
    	
    	orderTable = $('#orderDetail').DataTable(
    		mergeOptions(henePopupTableOpts, customOpts)
    	);
    	
    	// 출하목록 상세 테이블 초기화
    	let customOpts2 = {
    			paging : false,
				scrollY : true,
				autoWidth : false,
				createdRow : "",
				select : false,
				columnDefs : [
					{ "className": "dt-head-center", "targets": "_all" }
				]
       	};
    	
    	chulhaTable = $('#chulhaDetail').DataTable(
     		mergeOptions(henePopupTableOpts, customOpts2)
     	);
    	
    	
    	// 출하목록 테이블 행 추가
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body();
	    });

    	// 주문목록 선택
	    $('#orderDate').click(function() {
	    	parent.pop_fn_OrderInfor_View(1, '01');
	    });	    
	    
	    // update selected row index
	    chulhaTable.on( 'click', 'tr td:first-child', function () {
            rowIdx = chulhaTable.row(this).index();
        });
	    
	    /* // delete row on click minus button
	    $('#chulhaDetail tbody').on('click', '.fa-minus', function () {
	    	chulhaTable
	    		       .row( $(this).parents('tr') )
			           .remove()
			           .draw();
	    }); */
	    
	 	// 주문 상세정보를 불러온다.
		let jsonObj = new Object();
		
		jsonObj.orderNo 	= <%=GV_ORDER_NO%>;
		jsonObj.orderRevNo  = <%=GV_ORDER_REV_NO%>;
		
		let jsonStr = JSON.stringify(jsonObj);
		
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			data: {"prmtr" : jsonStr, "pid" : "M858S010100E124"},
	        success: function (data) {
				orderTable.clear().rows.add(data).draw();
	        }	
	    });
		
		// 출하 상세정보를 불러온다.
		let jsonObj2 = new Object();
		
		jsonObj2.chulhaNo 	= <%=GV_CHULHA_NO%>;
		jsonObj2.chulhaRevNo  = <%=GV_CHULHA_REV_NO%>;
		
		let jsonStr2 = JSON.stringify(jsonObj2);
		
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			data: {"prmtr" : jsonStr2, "pid" : "M858S010100E134"},
	        success: function (data) {
	        	initRows(chulhaTable, data);
	        }
	    });
    	}, 200);  
    });
    
	function SaveOderInfo() {
		
		if($("#orderDate").val() == '') {
			heneSwal.warning("주문을 선택해주세요");
			return false;
		}
		
		var tableLen = chulhaTable.data().length;
		
        if ( ! chulhaTable.data().any() ) {
			heneSwal.warning("플러스 버튼을 눌러서 제품을 하나 이상 등록하세요");
			return false
        }
        
        var dataJsonHead = new Object();
		
		dataJsonHead.userId = '<%=loginID%>';
		dataJsonHead.orderNo = $('#orderNo').val();
		dataJsonHead.orderRevNo = $('#orderRevNo').val();
			
		dataJsonHead.chulgo_type = $('#chulgo_type').val();
		dataJsonHead.chulhaNo = $('#chulhaNo').val();
		dataJsonHead.chulhaRevNo = $('#chulhaRevNo').val();
		dataJsonHead.chulhaNote = $('#chulhaNote').val();
        
		var jArray = new Array();
		
        for(var i = 0; i < tableLen; i++) {
        	
    		var trInput = $($("#chulhaDetailBody tr")[i]).find(":input");
    		
    		if(trInput.eq(0).val() == '') { 
    			heneSwal.warning("제품을 검색하여 선택하세요");
    			return false;
    		}
    		if(trInput.eq(5).val() == '') {
    			heneSwal.warning("주문할 수량을 입력하여 주세요");
    			return false;
    		}
    		
    		var dataJson = new Object();
    		
    		dataJson.chulhaNo = $('').val();
    		dataJson.chulhaRevNo = $('').val();
    		dataJson.prodDate = trInput.eq(1).val();
    		dataJson.seqNo 	= trInput.eq(2).val();
			dataJson.prodCd = trInput.eq(3).val();
			dataJson.prodRevNo = trInput.eq(4).val();
			dataJson.ChulhaCount = trInput.eq(5).val();
			dataJson.orgChulhaCount = trInput.eq(6).val();
			dataJson.note = trInput.eq(7).val();
			
			console.log(dataJson.orgChulhaCount);
			console.log(dataJson.ChulhaCount);
			
			jArray.push(dataJson);
        }
		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti); 
		
		var confirmVal = confirm("수정하시겠습니까?");
		
		if(confirmVal) {
			SendTojsp(JSONparam, "M858S010100E102");
		}
	}
    
	function SendTojsp(bomdata, pid){		
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : bomdata, "pid" : pid},
	        success: function (rcvData) {
	        	if(rcvData > -1) {
	        		heneSwal.success("출하 수정을 완료했습니다");
		 	     	$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	        	} else {
	        		heneSwal.error("출하 수정에 실패했습니다, 다시 시도해주세요");
	        	}
	        },
	        error: function(rcvData) {
        		heneSwal.error("출하 수정에 실패했습니다, 다시 시도해주세요");
	        }
	    });
	}
	
 	// 제품 검색창에서 클릭한 정보를 불러옴
    function SetProductName_code(prodName, prodCode, prodRevNo,
    							 prodDate, seqNo) {
		
 		console.log('제품 정보 입력 관련, 현재 행 인덱스는 : ' + rowIdx);
 		
    	var trInput = $($("#chulhaDetailBody tr")[rowIdx]).find(":input");
		
    	trInput.eq(0).val(prodName);	// 제품명
		trInput.eq(1).val(prodDate);	// 생산일자
		trInput.eq(2).val(seqNo);		// 일련번호
		trInput.eq(3).val(prodCode);	// 제품코드
		trInput.eq(4).val(prodRevNo);	// 제품 수정이력번호
    }
 	
 	// 필요한가? (20210108 최현수)
 	// 주문 검색창에서 클릭한 주문정보를 불러옴
 	function setOrderInfo(orderNo, orderRevNo, custName,
						  orderDate, deliveryDate, orderNote, custCd, custRevNo) {
 		
 		// 주문 메인 정보
		$('#orderNo').val(orderNo);				// 주문번호
		$('#orderRevNo').val(orderRevNo);		// 주문수정이력
		$('#custName').val(custName);			// 고객사명
		$('#orderDate').val(orderDate);			// 주문날짜
		$('#deliveryDate').val(deliveryDate);	// 납기일자
		$('#orderNote').val(orderNote);			// 비고
 		
		// 주문 상세 정보
		let jsonObj = new Object();
		
		jsonObj.orderNo = orderNo;
		jsonObj.orderRevNo = orderRevNo;
		
		let jsonStr = JSON.stringify(jsonObj);
		
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			data: {"prmtr" : jsonStr, "pid" : "M858S010100E124"},
	        success: function (data) {
				orderTable.clear().rows.add(data).draw();
	        }	
	    });
 	}
 	
    function fn_plus_body() {
    	
    	chulhaTable.row.add([
    		" <input type='text' class='form-control' onclick=\"viewProductStorage(1);\" readonly placeholder='Click here' />" +
    		" <input type='hidden' class='form-control' id='prodDate' />" +					// 생산일자
    		" <input type='hidden' class='form-control' id='seqNo' />" +					// 일련번호
    		" <input type='hidden' class='form-control' id='prodCd' />" +					// 제품코드
    		" <input type='hidden' class='form-control' id='prodRevNo' />",					// 제품 수정이력번호
			" <input type='text' class='form-control' id='chulhaCount' />" +				// 품목별 수정 출하 수량
			" <input type='hidden' class='form-control' value='0' id='orgChulhaCount' />",	// 품목별 기존 출하 수량
    		" <input type='text' class='form-control' />",									// 출하 품목별 비고
    		" <button class='btn btn-info btn-sm' id='btn-minus' onclick='fn_minus_body();'> " +
			" 	<i class='fas fa-minus'></i> " +
			" </button>"
        ]).draw();
    	
    }
    
    //출하 상세정보 row data 불러오는 함수
	function initRows(chulhaTable, data) {
    	
		var len = data.length;
		
		for(i = 0; i < len; i++) {
	    	chulhaTable.row.add([
	    		" <input type='text' class='form-control' value='" + data[i][0] + "' onclick=\"viewProductStorage(1);\" readonly placeholder='Click here' />" +
	    		" <input type='hidden' class='form-control' value='" + data[i][1] + "' id='prodDate' />" +		// 생산일자
	    		" <input type='hidden' class='form-control' value='" + data[i][2] + "' id='seqNo' />" +			// 일련번호
	    		" <input type='hidden' class='form-control' value='" + data[i][3] + "' id='prodCd' />" +		// 제품코드
	    		" <input type='hidden' class='form-control' value='" + data[i][4] + "'id='prodRevNo' />",		// 제품 수정이력번호
				" <input type='text' class='form-control' value='" + data[i][5] + "' id='chulhaCount' />" +		// 품목별 수정 출하 수량
				" <input type='hidden' class='form-control' value='" + data[i][5] + "' id='orgChulhaCount' />",	// 품목별 기존 출하 수량
	    		" <input type='text' class='form-control' value='" + data[i][6] + "' />",						// 출하 품목별 비고
	    		" <button class='btn btn-info btn-sm' id='btn-minus' onclick='fn_minus_body();'> " +
				" 	<i class='fas fa-minus'></i> " +
				" </button>"
	        ]).draw();
	  	}
    }
    
	function fn_minus_body() {
    	
		chulhaTable
        .row(chulhaTable_RowCount - 1).remove().draw();

		chulhaTable_info = chulhaTable.page.info();
		chulhaTable_RowCount = chulhaTable_info.recordsTotal;
    }
    
</script>
	
<section>
	<div class="row">
		<div class="col-md-6">
			<div class="table-responsive">
				<table class="table">
					<tr>
						<td>주문일자</td>
						<td>
							<input type="text" class="form-control" id="orderDate" 
								   readonly placeholder="Click here" />
							<input type="hidden" class="form-control" id="orderNo" />
							<input type="hidden" class="form-control" id="orderRevNo" />
				       	</td>
				    </tr>
						
					<tr>
						<td>
				        	고객사명
						</td>
				        <td>
				        	<input type="text" id="custName" class="form-control" readonly/>
				        </td>
				    </tr>
					<tr>
						<td>
				        	납기일자
						</td>
				        <td>
				        	<input type="text" data-date-format="yyyy-mm-dd" 
				        			 id="deliveryDate" class="form-control" readonly/>
				        </td>
				    </tr>
				    <tr>
						<td>
							출고 타입
						</td>
					  	<td>
							<select class="form-control" id="chulgo_type">
					        	<% chulgoTypeCode = (Vector) chulgoTypeList.get(1);%>
					            <% chulgoTypeName = (Vector) chulgoTypeList.get(2);%>
					            <% for(int i = 0; i < chulgoTypeName.size(); i++) { %>
									<option value='<%=chulgoTypeCode.get(i).toString()%>' 
										<%=initChulgoTypeCode.equals(chulgoTypeCode.get(i).toString()) ? "selected" : "" %>>
										<%=chulgoTypeName.get(i).toString()%>
									</option>
								<%} %>
							</select>
						</td>
				  	</tr>
					<tr>
				       	<td>
				       		비고(주문)
				       	</td>
						<td>
				        	<input type="text" class="form-control" id="orderNote" readonly />
						</td>
				   	</tr>
				   	<tr>
				       	<td>
				       		비고(출하)
				       	</td>
						<td>
				        	<input type="text" class="form-control" id="chulhaNote" placeholder="출하 시 기록할 사항을 입력해주세요" />
				        	<input type="hidden" class="form-control" id="chulhaNo" />
				        	<input type="hidden" class="form-control" id="chulhaRevNo" />
						</td>
				   	</tr>
				</table>
			</div>
		</div>
		<div class="col-md-6">
			<div class="row table-responsive">
				<table class="table" id="orderDetail">
					<thead>
						<tr>
				            <th>제품명</th>
				            <th>제품코드</th>
				            <th>주문수량</th>
				            <th>주문상세비고</th>
						</tr>
					</thead>
					<tbody id="orderDetailBody">
					</tbody>
				</table>
			</div>
			<div class="row table-responsive">
				<table class="table" id="chulhaDetail">
					<thead>
						<tr>
				            <th>제품명</th>
				            <th>출하수량</th>
				            <th>출하상세비고</th>
				            <th>
				            	<button id="btn_plus" class="btn btn-info btn-sm">
				            		<i class="fas fa-plus"></i>
				            	</button>
								<input type="hidden" class="form-control" id="prodDate" />
								<input type="hidden" class="form-control" id="seqNo" />
								<input type="hidden" class="form-control" id="prodCd" />
								<input type="hidden" class="form-control" id="prodRevNo" />
							</th>
						</tr>
					</thead>
					<tbody id="chulhaDetailBody">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</section>