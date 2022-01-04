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
	
	String LOCATION_TYPE = "", orderbln = "";
	
	if(request.getParameter("location_type") != null)
		LOCATION_TYPE = request.getParameter("location_type");
	
	if(request.getParameter("orderbln") != null)
		orderbln = request.getParameter("orderbln");
	else orderbln = "false";
	
	// 주문내역
	String orderNo="", orderRevNo="", custName="", orderDate="", deliveryDate="", chulhaNote="";
	if(request.getParameter("orderNo") != null)
		orderNo = request.getParameter("orderNo");
	if(request.getParameter("orderRevNo") != null)
		orderRevNo = request.getParameter("orderRevNo");
	if(request.getParameter("custName") != null)
		custName = request.getParameter("custName");
	if(request.getParameter("orderDate") != null)
		orderDate = request.getParameter("orderDate");
	if(request.getParameter("deliveryDate") != null)
		deliveryDate = request.getParameter("deliveryDate");
	if(request.getParameter("chulhaNote") != null)
		chulhaNote = request.getParameter("chulhaNote");
	
	String initChulgoTypeCode = "PROD_CHULGO_TYPE001";
	Vector chulgoTypeCode = null;
    Vector chulgoTypeName = null;
    Vector chulgoTypeList = CommonData.getProdChulgoType();
%>

<section>
	<div class="row">
		<div class="col-md-6">
			<div class="table-responsive">
				<table class="table">
					<tr>
						<td>주문일자</td>
						<td>
							<input type="text" class="form-control" id="orderDate" 
								   readonly placeholder="Click here">
							<input type="hidden" class="form-control" id="orderNo">
							<input type="hidden" class="form-control" id="orderRevNo">
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
				        	<input type="text" class="form-control" id="orderNote" readonly>
						</td>
				   	</tr>
				   	<tr>
				       	<td>
				       		비고(출하)
				       	</td>
						<td>
				        	<input type="text" class="form-control" id="chulhaNote" placeholder="출하 시 기록할 사항을 입력해주세요" />
						</td>
						
				   	</tr>
				</table>
				</div>
			</div>
		<div class="col-md-6">
			<div class="row table-responsive">
				<br>
				<h3 style = "text-align: center;">출하제품 목록</h3>
				<br>
				
				<table class="table" id="orderDetail">
					<thead>
						<tr>
				            <th>제품명</th>
				            <th>제품코드</th>
				            <th>출하수량</th>
				            <th>비고</th>
				            <th style='width:0px; display: none;'>제품수정이력</th>
						</tr>
					</thead>
					<tbody id="orderDetailBody">
					</tbody>
				</table>
				
			</div>
		</div>
		
	</div>
</section>

<script src="<%=Config.this_SERVER_path%>/js/product/view.product.js"></script>

<script>
    
    var orderTable;
    var chulhaTable;
	var rowIdx = 0;
	var chulhaTableInfo;
    var chulhaTableRowCount = 0;
	var jArray2 = new Array();
    var checkval = true;
    //var vTableS202S010250;
    //var TableS202S010250_RowCount;
    
    $(function () {
        
    	setTimeout(function() {
    	
   		// 값을 가져왔을때
       	var orderbln = <%=orderbln%>;
       	if(orderbln){
       		setOrderInfo('<%=orderNo%>', '<%=orderRevNo%>', '<%=custName%>', '<%=orderDate%>'
       					, '<%=deliveryDate%>', '<%=chulhaNote%>', '', ''); 
       	   	$('#orderDate').off();
       	   	$("#chulgo_type").attr("disabled", true);
       	 	$("#chulhaNote").attr("placeholder", "");
       	 	$("#chulhaNote").attr("disabled", true);
       	} 
    		
	    // 주문목록 상세 테이블 초기화
    	let customOpts = {
   	   		paging : false,
   	    	searching : false,
   	    	ordering : false,
   	    	keys : false,
   	    	autoWidth : false,
   	    	createdRow : "",
   	    	columnDefs : [
				{ "className": "dt-head-center", "targets": "_all" },
				{
					'targets': [4],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}
			]
    	};
    	
    	orderTable = $('#orderDetail').DataTable(
    		mergeOptions(henePopup2TableOpts, customOpts)
    	);
    	
    	 // 출하목록 상세 테이블 초기화
    	let customOpts2 = {
    			paging : false,
				scrollY : true,
				autoWidth : false,
				createdRow : "",
				select : false,
				columnDefs : [
					{ "className": "dt-head-center", "targets": "_all" },
					{
						'targets': [2,4,5],
						'createdCell': function (td) {
				  			$(td).attr('style', 'display: none;'); 
						}
					}
				]
       	};
    	
    	storageTable = $('#storageDetail').DataTable(
     		mergeOptions(henePopup2TableOpts, customOpts2)
     	); 
    	
    	},300);
    	
    	
    	// 출하목록 테이블 행 추가
    	$('#addProdBtn').click(function() {
    		chulhaTable.row.add([
	    		" <input type='text' class='form-control' readonly placeholder='Click here'>" +
	    		" <input type='hidden' class='form-control' id='prodDate'>" +	// 생산일자
	    		" <input type='hidden' class='form-control' id='seqNo'>" +	// 일련번호
	    		" <input type='hidden' class='form-control' id='prodCd'>" +	// 제품코드
	    		" <input type='hidden' class='form-control' id='prodRevNo'>",	// 제품 수정이력번호
				" <input type='text' class='form-control' id='chulhaCount'>",	// 품목별 출하 수량
	    		" <input type='text' class='form-control'>",	// 출하 품목별 비고
	    		" <button class='btn btn-info btn-sm btn-minus-prod'> " +
				" 	<i class='fas fa-minus'></i> " +
				" </button>"
	        ]).draw();
    	});
	    
    	// 주문목록 선택
	    $('#orderDate').click(function() {
	    	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/OrderInfoView.jsp"
						+ "?caller=2" + "&location_type=" + '<%=LOCATION_TYPE%>';
			var footer = "";
			var title = "주문정보 조회";
			
			var heneModal = new HenesysModal3(url, 'large', title, footer);
			heneModal.open_modal();
			
			//storageTable.clear();
	    });
	    
	    // update selected row index
	    $('#chulhaDetail').on( 'click', 'tr td:first-child', function () {
	    	viewProductStorage(2);
            rowIdx = chulhaTable.row(this).index();
        });
	    
	    $(document).on('click', '.btn-minus-prod', function() {
	    	chulhaTable
        		.row(chulhaTableRowCount - 1).remove().draw();

			chulhaTableInfo = chulhaTable.page.info();
			chulhaTableRowCount = chulhaTableInfo.recordsTotal;
	    });
	    
	    $('#addOrderInfoBtn').click(function() {

	    	if($("#orderDate").val() == '') {
				heneSwal.warning("주문을 선택해주세요");
				return false;
			}
	    	
	    	var tableLen1 = orderTable.data().length;
	    	var tableLen2 = storageTable.data().length;
	        
	        var dataJsonHead = new Object();
	        
			dataJsonHead.userId = '<%=loginID%>';
			dataJsonHead.orderNo = $('#orderNo').val();
			dataJsonHead.orderRevNo = $('#orderRevNo').val();
			dataJsonHead.chulgo_type = $('#chulgo_type').val();
			dataJsonHead.chulhaNote = $('#chulhaNote').val();
			dataJsonHead.custName = $('#custName').val();
			dataJsonHead.orderDate = $('#orderDate').val();
			dataJsonHead.deliveryDate = $('#deliveryDate').val();
			
			var jArray = new Array();
			var resultArr = new Array();

			for(var i = 0; i < tableLen1; i++){
				var value1 = $($('#orderDetail tbody tr')[i]).find('td').eq(1).text();
				var value2 = $($('#orderDetail tbody tr')[i]).find('td').eq(2).text();
				var value3 = $($('#orderDetail tbody tr')[i]).find('td').eq(3).text();
				var value4 = $($('#orderDetail tbody tr')[i]).find('td').eq(4).text();
				
				var dataJson = new Object();
				
				dataJson.chulhaNo = $('').val();
				dataJson.chulhaRevNo = $('').val();
				dataJson.prodCd = value1;
				dataJson.chulhaCount = value2;
				dataJson.note = value3;
				dataJson.prodRevNo = value4;
				
				jArray.push(dataJson);
				
				var dataJson2 = new Object();
				var dataJson3 = new Object();
				  
				dataJson2.prod_cd = value1 // 출하할 제품코드로 완제품 재고 정보 조회
				var jsonStr = JSON.stringify(dataJson2);
				
				var newArr = doAjax(jsonStr);
				resultArr = resultArr.concat(newArr);
			}
			
			console.log(resultArr);
			
		  	var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
	 		dataJsonMulti.param = jArray;
	 		//dataJsonMulti.param2 = resultArr;
	 		
	 		console.log(dataJsonMulti.paramHead);
	 		console.log(dataJsonMulti.param);
	 		//console.log(dataJsonMulti.param2);
	 		var checkyn = confirm('등록하시겠습니까?');
	 		
	 		if(checkyn){
	 			passOrderInfo(dataJsonMulti)
				$('#modalReport2').modal('hide');	
	 		}
	 		else {
	 			
	 		} 
	    });
	    
    });
    
    function checkValue(checkval){
    	
    	this.checkval = checkval;
    	
    	return checkval;
    }
    
    /* function getStorageValue(tableLen) {
		var jArray = new Array();
    	var resultArr = new Array();
		
		for(var i = 0; i < tableLen; i++){
			var value1 = $($('#orderDetail tbody tr')[i]).find('td').eq(1).text();
			var value2 = $($('#orderDetail tbody tr')[i]).find('td').eq(2).text();
			var value3 = $($('#orderDetail tbody tr')[i]).find('td').eq(3).text();
			var value4 = $($('#orderDetail tbody tr')[i]).find('td').eq(4).text();
			
			var dataJson = new Object();
			
			dataJson.chulhaNo = $('').val();
			dataJson.chulhaRevNo = $('').val();
			dataJson.prodCd = value1;
			dataJson.chulhaCount = value2;
			dataJson.note = value3;
			dataJson.prodRevNo = value4;
			
			jArray.push(dataJson);
			
			var dataJson2 = new Object();
			var dataJson3 = new Object();
			  
			dataJson2.prod_cd = value1 // 출하할 제품코드로 완제품 재고 정보 조회
			var jsonStr = JSON.stringify(dataJson2);
			
			var newArr = doAjax(jsonStr);
			resultArr = resultArr.concat(newArr);
		}
		
		return resultArr;
	} */
    
    function doAjax(jsonStr) {
		  var outerArr = new Array();
	
		  $.ajax({
		      type: "POST",
		      dataType: "json",
		      url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
		      data: {"prmtr" : jsonStr, "pid" : "M858S010100E214"},
		      async: false,
		      success: function (data) {
		        for(var j = 0; j < data.length; j++) {
		            var data1 = data[j];
		            var obj = new Object();
		            
		            obj.storage_prodDate = data1[0];
		            obj.storage_prodCd   = data1[1];
		            obj.storage_prodRevNo= data1[2];
		            obj.storage_postAmt  = data1[3];
		            obj.storage_seqNo    = data1[4];
		            obj.storage_minRank  = data1[5];
		            
		            outerArr.push(obj);
		        }
		      }
		    }); 
		
		  return outerArr;
    }
 	
 	// 주문 검색창에서 클릭한 주문정보를 불러옴
 	function setOrderInfo(orderNo, orderRevNo, custName,
						  orderDate, deliveryDate, orderNote, custCd, custRevNo) {
 		
 		var orderTableLength = parent.orderListTable.page.info().recordsTotal;
		
 		for(var i = 0; i < orderTableLength; i++) {
   	   		
   			var td1 = parent.$($("#orderListTableBody tr")[i]).find(":input").eq(0).val();
   			var td2 = parent.$($("#orderListTableBody tr")[i]).find(":input").eq(1).val();
   			
   			console.log(custName);
   			console.log(td1);
   			if(td1 == custName && td2 == orderDate){
   	   			alert('이미 해당 출하정보가 선택되어 있습니다.');
   	   		
   	   		$('#orderNo').val('');
   			$('#orderRevNo').val('');
   			$('#custName').val('');
   			$('#orderDate').val('');		
   			$('#deliveryDate').val('');
   			$('#orderNote').val('');
   	   	
	    	checkval = false;
	    
			checkValue(checkval);
			return false;
   			}
   			
   			
   		
   		}  
 		
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
 	
 	function passOrderInfo(obj) {
 		parent.getOrderInfo(obj);
 	}
 	
 	function getData(data) {
 		  return new Promise(function(resolve, reject) {
 		    
 		    resolve(data);
 		  });
 		}

 		// resolve()의 결과 값 data를 resolvedData로 받음
 		getData().then(function(resolvedData) {
 		  console.log(resolvedData); // 100
 		});
 	
</script>