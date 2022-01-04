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
	
	String orderNo = "", orderType = "", orderDate = "", 
		   orderRevNo = "", custName = "", custCode = "", 
		   custRevNo = "", deliveryDate = "", note = "";
	
	if(request.getParameter("orderNo") != null)
		orderNo = request.getParameter("orderNo");
	
	if(request.getParameter("orderRevNo") != null)
		orderRevNo = request.getParameter("orderRevNo");

	if(request.getParameter("orderType") != null)
		orderType = request.getParameter("orderType");

	if(request.getParameter("orderDate") != null)
		orderDate = request.getParameter("orderDate");

	if(request.getParameter("custName") != null)
		custName = request.getParameter("custName");

	if(request.getParameter("custCode") != null)
		custCode = request.getParameter("custCode");

	if(request.getParameter("custRevNo") != null)
		custRevNo = request.getParameter("custRevNo");

	if(request.getParameter("deliveryDate") != null)
		deliveryDate = request.getParameter("deliveryDate");

	if(request.getParameter("note") != null)
		note = request.getParameter("note");
	
	Vector orderTypeCode = null;
	Vector orderTypeName = null;
	Vector orderTypeList = CommonData.getOrderType();
%>

<div class="table-responsive">
	<table class="table">
		<tr>
			<td>
				주문 구분
			</td>
			<td>
				<select class="form-control" id="order_type_1">
		        	<% orderTypeCode = (Vector) orderTypeList.get(1);%>
		            <% orderTypeName = (Vector) orderTypeList.get(2);%>
		            <% for(int i = 0; i < orderTypeName.size(); i++) { %>
						<option value='<%=orderTypeCode.get(i).toString()%>' 
								<%=orderType.equals(orderTypeName.get(i).toString()) ? "selected" : "" %>>
							<%=orderTypeName.get(i).toString()%>
						</option>
					<%} %>
				</select>
	       	</td>
	    </tr>
	    
		<tr>
			<td>
				고객사
			</td>
			<td>
				<input type="text" class="form-control" id="custName">
				<input type="hidden" class="form-control" id='custCode'>
				<input type="hidden" class="form-control" id="custRevNo">
	       	</td>
	    </tr>
	
		<tr>
			<td>
	        	주문일자
			</td>
	        <td>
	        	<input type="text" data-date-format="yyyy-mm-dd" id="orderDate" class="form-control" readonly>
	        </td>
	    </tr>
		<tr>
			<td>
	        	요청 납품일자
			</td>
	        <td>
	        	<input type="text" data-date-format="yyyy-mm-dd" id="deliveryDate" class="form-control" readonly>
	        </td>
	    </tr>
		<tr>
	       	<td>
	       		비고
	       	</td>
			<td>
	        	<input type="text" class="form-control" id="note">
			</td>
	   	</tr>
	</table>
</div>

<div class="table-responsive">
	<table class="table" id="product_input_table">
		<thead>
			<tr>
	            <th>제품명</th>
	            <th>단위</th>
	            <th>수량</th>
	            <th>비고</th>
	            <th>
	            	<button id="btn_plus" class="btn btn-info btn-sm">
	            		<i class="fas fa-plus"></i>
	            	</button>
				</th>
			</tr>
		</thead>
		<tbody id="product_tbody">
		</tbody>
	</table>
</div>

<script type="text/javascript">
	
    var t;	// datatable
    var rowIdx;	// tbody 클릭한 행의 인덱스 값
    var checkval = true;
    var orderType = "";
    
    $(document).ready(function () {
    	
    	setTimeout(function(){
	    	// set initial values
	    	new SetSingleDate2('<%=orderDate%>', "#orderDate", 0);
		    new SetSingleDate2('<%=deliveryDate%>', "#deliveryDate", 0);
	    	$('#custName').val('<%=custName%>');
	    	$('#custCode').val('<%=custCode%>');
	    	$('#custRevNo').val('<%=custRevNo%>');
	    	$('#note').val('<%=note%>');
	    	
	    	var customOpts = {
	   	   		paging : false,
	   	    	searching : false,
	   	    	ordering : false,
	   	    	keys : false,
	   	    	autoWidth : false,
	   	    	createdRow : "",
	   	    	columnDefs : [
					{ "className": "dt-head-center", "targets": "_all" },
					{ "width": "10%", "targets": 4 },
				]
	    	};
	    	
	    	t = $('#product_input_table').DataTable(
	    		mergeOptions(henePopupTableOpts, customOpts)
	    	);
	    	
	    	initRows(t, subRowsData);
	    	
		    $("#btn_plus").click(function(){ 
		    	addRow(t);
		    });
		    
		 	// update row index when select first column
		    t.on( 'click', 'tr td:first-child', function () {
	            rowIdx = t.row(this).index();
	        });
		    
		    // delete row on click minus button
		    $('#product_input_table tbody').on('click', '#btn_minus', function () {
		    	t
	  		     .row( $(this).parents('tr') )
	             .remove()
	             .draw();
		    });
		    
		    $('#custName').click(function() {
		    	parent.pop_fn_CustName_View(1, 'CUSTOMER_GUBUN_BIG01');
		    });
	   
    	}, 300);
    });
    
    function select_product(obj) {
    	var tr = $(obj).parent().parent();
    	var trNum = $(tr).closest('tr').prevAll().length;
    }
	
	function SetRecvData() {
		DataPars(M101S020100E101,GV_RECV_DATA);		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function updateOrderInfo() {
		var len = t.rows().count();
		
		if($("#custName").val() == '') {
			heneSwal.warning("고객사를 검색하여 선택하세요");
			return false;
		}
		
        if(len == 0) {
			heneSwal.warning("플러스 버튼을 눌러서 제품을 하나 이상 등록하세요");
			return false;
        }
        	
        var dataJsonHead = new Object();
		
		dataJsonHead.user_id 		= '<%=loginID%>';
		dataJsonHead.order_no 		= '<%=orderNo%>';
		dataJsonHead.order_rev_no 	= '<%=orderRevNo%>';
		dataJsonHead.order_type 	= $('#order_type_1').val();
		dataJsonHead.order_date 	= $('#orderDate').val();
		dataJsonHead.delivery_date 	= $('#deliveryDate').val();
		dataJsonHead.cust_cd 		= $('#custCode').val();
		dataJsonHead.cust_rev 		= $('#custRevNo').val();
		dataJsonHead.bigo 			= $('#note').val();
        
		var jArray = new Array();
		
        for(var i = 0; i < len; i++) {
    		var trInput = $($("#product_tbody tr")[i]).find(":input");
    		
    		if(trInput.eq(2).val() == '') { 
    			heneSwal.warning("제품을 검색하여 선택하세요");
    			return false;
    		}
    		if(trInput.eq(4).val() == '') {
    			heneSwal.warning("주문할 수량을 입력하여 주세요");
    			return false;
    		}
    		
    		var dataJson = new Object();
    		
    		dataJson.prod_cd 		= trInput.eq(0).val();
    		dataJson.prod_rev 		= trInput.eq(1).val();
    		dataJson.unit_type 		= trInput.eq(3).val();	// ea, pack, box
    		dataJson.order_count 	= trInput.eq(4).val();
			dataJson.order_note 	= trInput.eq(5).val();
			
			jArray.push(dataJson);
        }
		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti); 
		
		var confirmVal = confirm("수정 하시겠습니까?");
		
		if(confirmVal) {
			SendTojsp(JSONparam, "M101S020100E102");
		}
	}
    
	function SendTojsp(bomdata, pid){		
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : bomdata, "pid" : pid},
	        success: function (rcvData) {
	        	console.log('rcvData:'+rcvData);
	        	if(rcvData < 0) {
	        		heneSwal.error("주문 정보 수정 실패했습니다, 다시 시도해주세요");
	        	} else {
	        		heneSwal.success("주문 정보 수정을 완료했습니다");
		        	parent.fn_MainInfo_List(startDate, endDate, orderType);
		        	$("#tab1").children().remove();
		 	     	$('#modalReport').modal('hide'); 
	        	}
	        		
	        }
	     });
	}
    
    // 고객사 검색창에서 클릭한 정보를 불러옴
    function SetCustName_code(name, code, rev) {
		$('#custName').val(name);
		$('#custCode').val(code);
		$('#custRevNo').val(rev);
    }
    
	function checkValue(checkval){
    	
    	this.checkval = checkval;
    	
    	return checkval;
    }
    
    
 	// 제품 검색창에서 클릭한 정보를 불러옴
    function SetProductName_code(name, code, rev, gyugyuk, safeStock, curStock) {
 		var trInput = $($("#product_tbody tr")[rowIdx]).find(":input");
 		
 		console.log("trInput");
 		console.log(trInput);
 		
		trInput.eq(0).val(code);	// 제품코드
		trInput.eq(1).val(rev);		// 제품 수정이력번호
		trInput.eq(2).val(name);	// 제품명
		trInput.eq(4).val("");		// 수량
		trInput.eq(5).val("");		// 비고
		
		for(var i = 0; i < rowIdx; i++) {
	   		
			var tr1 = $($("#product_tbody tr")[i]).find(":input");
		
			console.log(tr1.eq(0).val());
		
			if(tr1.eq(2).val() == name){
	   			alert('각각 다른 제품을 등록해 주세요.');
	   		
	   		trInput.eq(0).val('');
    		trInput.eq(1).val('');
    		trInput.eq(2).val('');
    		trInput.eq(4).val('');
    		trInput.eq(5).val('');
    		
	   	
    		checkval = false;
    
			checkValue(checkval);
	
			}
		
		}
		
		
    }
 	
    function addRow(table) {
    	var rowLen = t.rows().count() + 1;
    	
   		table.row.add([
       		" <input type='hidden' class='form-control' id='prodCode' />" +
       		" <input type='hidden' class='form-control' id='prodRevNo' />" +
       		" <input type='text' class='form-control' id='prodName' onclick=\"parent.pop_fn_ProductName_View(2,'01')\" readonly />",
   			" <select name='sel_box' class='form-control' id='selBox"+rowLen+"'>" +
   			" 	<option value='EA' selected>EA</option>" +
   			"	<option value='Pack'>Pack</option>" +
   			"	<option value='Box'>Box</option>" +
   			" </select>",
   			" <input type='text' class='form-control' id='orderCount"+rowLen+"' />",
       		" <input type='text' class='form-control' id='orderNote' />",
       		" <button id='btn_minus' class='btn btn-info btn-sm'>" +
			" 	<i class='fas fa-minus'></i>" +
			" </button>"
        ]).draw();
    }
    
    function initRows(table, initData) {
    	console.log(initData);
    	var len = initData.length;
    	var counter = 1;
    	
    	for(i = 0; i < len; i++) {
    		table.row.add([
        		" <input type='hidden' class='form-control' id='prodCode' value='" + initData[i][0] + "' />" +
        		" <input type='hidden' class='form-control' id='prodRevNo' value='" + initData[i][1] + "' />" +
        		" <input type='text' class='form-control' id='prodName' onclick=\"parent.pop_fn_ProductName_View(2,'01')\" readonly value='" + initData[i][2] + "' />",
    			" <select name='sel_box' class='form-control' id='selBox"+counter+"'>" +
    			" 	<option value='EA' selected>EA</option>" +
    			"	<option value='Pack'>Pack</option>" +
    			"	<option value='Box'>Box</option>" +
    			" </select>",
    			" <input type='text' class='form-control' id='orderCount"+counter+"' value='" + initData[i][4] + "' />",
        		" <input type='text' class='form-control' id='orderNote' value='" + initData[i][5] + "' />",
        		" <button id='btn_minus' class='btn btn-info btn-sm'>" +
				" 	<i class='fas fa-minus'></i>" +
				" </button>"
            ]).draw();
    		
    		counter++;
    	}
    }
</script>