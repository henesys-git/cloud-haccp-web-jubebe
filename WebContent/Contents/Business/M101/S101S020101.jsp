﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String GV_JSPPAGE = "", GV_NUM_GUBUN = "";
	
	if(request.getParameter("jspPage") != null)
		GV_JSPPAGE = request.getParameter("jspPage");

	if(request.getParameter("num_gubun") != null)
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	Vector orderTypeCode = null;
	Vector orderTypeName = null;
	Vector orderTypeList = CommonData.getOrderType();
%>

<script type="text/javascript">
    var detail_seq = 1;
	var vproduct_input_table;
    var vproduct_input_table_Row_index = -1;
	var vproduct_input_table_info;
    var vproduct_input_table_RowCount = 0;
    var checkval = true;
    var orderType = "";
    
    $(document).ready(function () {
    	
    	setTimeout(function(){
	    	detail_seq = 1;
	    	
	    	var customOpts = {
	   	   		paging : false,
	   	    	searching : false,
	   	    	ordering : false,
	   	    	keys : false,
	   	    	autoWidth : false,
	   	    	createdRow : "",
	   	    	columnDefs : [
					{ "className": "dt-head-center", "targets": "_all" },
					{ "width": "10%", "targets": 0 }
				]
	    	};
	    	
	    	vproduct_input_table = $('#product_input_table').DataTable(
	    		mergeOptions(henePopupTableOpts, customOpts)
	    	);
	    	
		    new SetSingleDate2("", "#dateOrder", 0);
		    new SetSingleDate2("", "#dateDelivery", 30);
	    	
		    // 처음 로딩 시 제품 선택하는 행 하나 추가된 상태로 로딩
		    //fn_plus_body();
		    
		    $("#btn_plus").click(function(){ 
		    	fn_plus_body();
		    }); 
		    
		    $("#btn_mius").click(function(){ 
		    	fn_minus_body(); 
		    }); 
		    
		    // textarea 줄바꿈 제한
		    $('#txt_bigo').keydown(function(){
		        var rows = $('#txt_bigo').val().split('\n').length;
		        var maxRows = 1;
		        if(rows > maxRows) {
		        	alert('줄바꿈은 불가능합니다');
		        	modifiedText = $('#txt_bigo').val().split("\n").slice(0, maxRows);
		            $('#txt_bigo').val(modifiedText.join("\n"));
		        }
		    });
		    
		    // textarea 글자수 제한
		    $('#txt_bigo').on('keyup', function() {
		    	if($(this).val().length > 10) {
		    		alert("글자수는 10자로 이내로 제한됩니다.");
		    		$(this).val($(this).val().substring(0, 10));
		    	}
		    });
		    
		    $('#txt_custname').click(function() {
		    	parent.pop_fn_CustName_View(1, 'CUSTOMER_GUBUN_BIG02');
		    });
	
		    $('#txt_ProductName').click(function() {
		    	select_product(this);
		    	parent.pop_fn_ProductName_View(1, '01');
		    });
		    
		 	// delete row on click minus button
		    $('#product_tbody').on('click', '.fa-minus', function () {
		    	vproduct_input_table
		    		       .row( $(this).parents('tr') )
				           .remove()
				           .draw();
		    });
		 	
    	}, 300);
    	
    	
    	
    });
    
    function select_product(obj) {
    	var tr = $(obj).parent().parent();
    	var trNum = $(tr).closest('tr').prevAll().length;
    	
    	vproduct_input_table_Row_index = vproduct_input_table.row(trNum).index();
    }
	
	function SetRecvData() {
		DataPars(M101S020100E101,GV_RECV_DATA);		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		var len = $("#product_tbody tr").length;
		
		if($("#txt_custname").val() == '') {
			heneSwal.warning("고객사를 검색하여 선택하세요");
			return false;
		}
		
        vproduct_input_table_info = vproduct_input_table.page.info();
        vproduct_input_table_RowCount = vproduct_input_table_info.recordsTotal; 
        
        if(vproduct_input_table_RowCount == 0) {
			heneSwal.warning("플러스 버튼을 눌러서 제품을 하나 이상 등록하세요");
			return false;
        }
        	
        var dataJsonHead = new Object();
		
		dataJsonHead.user_id 		= '<%=loginID%>';
		dataJsonHead.order_type 	= $('#order_type_1').val();
		dataJsonHead.order_date 	= $('#dateOrder').val();
		dataJsonHead.delivery_date 	= $('#dateDelivery').val();
		dataJsonHead.cust_cd 		= $('#txt_custcode').val();
		dataJsonHead.cust_rev 		= $('#txt_cust_rev').val();
		dataJsonHead.bigo 			= $('#txt_bigo').val();
        
		var jArray = new Array();
		
        for(var i = 0; i < vproduct_input_table_RowCount; i++) {
        	
    		var trInput = $($("#product_tbody tr")[i]).find(":input");
    		
    		if(trInput.eq(1).val() == '') { 
    			heneSwal.warning("제품을 검색하여 선택하세요");
    			return false;
    		}
    		if(trInput.eq(6).val() == '') {
    			
    			heneSwal.warning("주문할 수량을 입력하여 주세요");
    			return false;
    		}
    		
    		var dataJson = new Object();
    		
    		dataJson.prod_cd 		= trInput.eq(2).val();
    		dataJson.prod_rev 		= trInput.eq(3).val();
    		dataJson.unit_type 		= trInput.eq(5).val();	// ea, pack, box
    		dataJson.order_count 	= trInput.eq(6).val();
			dataJson.order_note 	= trInput.eq(7).val();
			
			jArray.push(dataJson);
        }
		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti); 
		
		var confirmVal = confirm("등록하시겠습니까?");
		
		if(confirmVal) {
			SendTojsp(JSONparam, "M101S020100E101");
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
	        		heneSwal.error("주문 등록을 실패했습니다, 다시 시도해주세요");
	        	} else {
	        		heneSwal.success("주문 등록을 완료했습니다");
		        	parent.fn_MainInfo_List(startDate, endDate, orderType);
		 	     	$('#modalReport').modal('hide'); 
	        	}
	        		
	        }
	     });
	}

    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    
    	if(typeof(popupWin) == "undefine") {
    		popupWin = window.returnValue;
    	}

    	return popupWin;
    }  
    
    // 고객사 검색창에서 클릭한 정보를 불러옴
    function SetCustName_code(name, code, rev) {
    	
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);
    }
    
	function checkValue(checkval){
    	
    	this.checkval = checkval;
    	
    	return checkval;
    }
    
 	// 제품 검색창에서 클릭한 정보를 불러옴
    function SetProductName_code(name, code, rev, gugyuk, safeStock, curStock) {
		console.log('row index:' + vproduct_input_table_Row_index);
 		
    	var trInput = $($("#product_tbody tr")[vproduct_input_table_Row_index]).find(":input");
		trInput.eq(1).val(name);	// 제품명
		trInput.eq(2).val(code);	// 제품코드
		trInput.eq(3).val(rev);		// 제품 수정이력번호
		trInput.eq(5).val(gugyuk);	// 규격
		
		for(var i = 0; i < vproduct_input_table_Row_index; i++) {
	   		
			var tr1 = $($("#product_tbody tr")[i]).find(":input");
		
			console.log(tr1.eq(1).val());
		
			if(tr1.eq(1).val() == name){
	   			alert('각각 다른 제품을 등록해 주세요.');
	   		
	   		trInput.eq(1).val('');
    		trInput.eq(2).val('');
    		trInput.eq(3).val('');
    		trInput.eq(5).val('');
	   	
    		checkval = false;
    
			checkValue(checkval);
	
			}
		
		}
		
		
    }
 	
    function fn_plus_body() {
    	vproduct_input_table.row.add([
    		" <input type='text' class='form-control' id='txt_detail_seq' readonly>",
    		" <input type='text' class='form-control' onclick=\"select_product(this); parent.pop_fn_ProductName_View(2,'01')\" id='txt_ProductName' readonly placeholder='Click here'>" +
    		" <input type='hidden' class='form-control' id='txt_Productcode' readonly>" +
    		" <input type='hidden' class='form-control' id='txt_prod_rev' readonly>" +
    		" <input type='hidden' id='txt_productSerialNo' class='form-control'>",
    		" <input type='text' id='txt_gugyuk' class='form-control' readonly>",
			/* " <select name='sel_box' id='txt_LOTNo"+vproduct_input_table_RowCount+"'>" +
			" 	<option value='single' selected>낱개</option>" +
			"	<option value='innerPacking'>내포장</option>" +
			"	<option value='outerPacking'>외포장</option>" +
			" </select>", */
			" <input type='text' class='form-control' id='txt_order_count"+vproduct_input_table_RowCount+"'>",
    		" <input type='text' class='form-control' id='txt_order_note'>" +
    		" <input type='hidden' id='txt_productSerialNoEnd' class='form-control'>",
    		" <button class='btn btn-info btn-sm' onclick = 'fn_minus_body();'>"+
			"	<i class='fas fa-minus'></i>" +
			" </button>"
        ]).draw();
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	    // 주문 품목 추가때마다 순번 매기기
        vproduct_input_table_info = vproduct_input_table.page.info();
        vproduct_input_table_RowCount = vproduct_input_table_info.recordsTotal;
        
		var trInput = $($("#product_tbody tr")[vproduct_input_table_RowCount - 1]).find(":input");
		trInput.eq(0).val(vproduct_input_table_RowCount);
    }
    
    function fn_minus_body() {
        vproduct_input_table
        .row(vproduct_input_table_RowCount - 1).remove().draw();

        vproduct_input_table_info = vproduct_input_table.page.info();
        vproduct_input_table_RowCount = vproduct_input_table_info.recordsTotal;
    }
</script>

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
						<option value='<%=orderTypeCode.get(i).toString()%>'>
							<%=orderTypeName.get(i).toString()%>
						</option>
					<%} %>
				</select>
	       	</td>
	    </tr>
	    
		<tr>
			<td>고객사</td>
			<td>
				<input type="text" class="form-control" id="txt_custname" 
					   readonly placeholder="Click here" />
				<input type="hidden" class="form-control" id='txt_custcode' />
				<input type="hidden" class="form-control" id="txt_cust_rev" />
	       	</td>
	    </tr>
	
		<tr>
			<td>
	        	주문일자
			</td>
	        <td>
	        	<input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control" readonly/>
	        </td>
	    </tr>
		<tr>
			<td>
	        	요청 납품일자
			</td>
	        <td>
	        	<input type="text" data-date-format="yyyy-mm-dd" id="dateDelivery" class="form-control" readonly/>
	        </td>
	    </tr>
		<tr>
	       	<td>
	       		비고
	       	</td>
			<td>
	        	<input type="text" class="form-control" id="txt_bigo" />
			</td>
	   	</tr>
	</table>
</div>

<div class="row table-responsive">
	<table class="table" id="product_input_table">
		<thead>
			<tr>
	            <th>#</th>
	            <th>제품명</th>
	            <th>단위</th>
	            <th>수량</th>
	            <th>비고</th>
	            <th>
	            	<button id="btn_plus" class="btn btn-info btn-sm">
	            		<i class="fas fa-plus"></i>
	            	</button>
	            	<!-- <button id="btn_mius" class="btn btn-info btn-sm">
						<i class="fas fa-minus"></i>
					</button> -->
				</th>
			</tr>
		</thead>
		<tbody id="product_tbody">
		</tbody>
	</table>
</div>