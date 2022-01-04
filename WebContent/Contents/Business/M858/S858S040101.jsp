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
%>

<style>
	th.width70px{
		width:100px !important;
	}
	
	.discard_amount{
		width:100px !important;
	}
	
	#discard_note{
		width:112px !important;
	}
	
	table#discardDetail{
		table-layout:fixed;
	}
	
	table#discardDetailBody{
		table-layout:fixed;
	}
	#type_select{
	width : 80px ! important;
	}
</style>

<script src="<%=Config.this_SERVER_path%>/js/product/view.product.js"></script>

<script>
    var chulhaTable;
    var discardTable;
	var rowIdx = 0;
    
    $(document).ready(function () {
    	
    	setTimeout(function() {
    		
    		// 출하 목록 상세 테이블 초기화
    		let customOpts = {
					retrieve : true,
		   	   		paging : false,
		   	    	searching : false,
		   	    	ordering : false,
		   	    	keys : false,
		   	    	select : false,
		   	    	autoWidth : false,
		   	    	//data : data,
		   	    	createdRow : "",
		   	    	columnDefs : [
						{ 
							"className": "dt-body-center dt-head-center", 
							"targets": "_all"
						},
						{ 
							"targets": [0,1,3,5,6,8,9],
						  	"createdCell": function (td) {
								$(td).attr('style', 'display:none;');
						  	}
						},
						{
							"data": null,
							"targets": 11,
							"render": function(data, type, row) {
								return " <button class='btn btn-info btn-sm btn-plus'> " +
								  	   " 	<i class='fas fa-plus'></i> " +
								       " </button>";
							}
						}
					]
		    	};
		    	
		    	chulhaTable = $('#chulhaDetail').DataTable(
		    		mergeOptions(henePopupTableOpts, customOpts)
		    	);
    		
	    	// 반품 목록 상세 테이블 초기화
	    	let customOpts2 = {
	    			paging : false,
					scrollY : true,
					autoWidth : false,
					createdRow : "",
					select : false,
					columnDefs : [
						{
							"className": "dt-head-center", 
						 	"targets": "_all" 
						},
						{ 
							"targets": [0,1,3,5,6,8,9],
						  	"createdCell": function (td) {
								$(td).attr('style', 'display:none;');
						  	}
						},
						{
							"targets": [7, 10],
							"className": 'width70px'
						},
						{
							"data": null,
							"targets": 13,
							"render": function(data, type, row) {
								return " <button class='btn btn-info btn-sm btn-minus'> " +
								  	   " 	<i class='fas fa-minus'></i> " +
								       " </button>";
							}
						},
						{
							"targets": [13],
							"createdCell": function(td) {
								$(td).attr('style', 'text-align:center;');
							}
						}
					]
	       	};
	    	
	    	discardTable = $('#discardDetail').DataTable(
	     		mergeOptions(henePopupTableOpts, customOpts2)
	     	);
	    		    	
	    	// 출하된 상품 중 하나 선택 후 반품 리스트에 추가
	    	$('#chulhaDetail tbody').on('click', '.btn-plus', function() {
	            var data = chulhaTable.row($(this).parents('tr')).data();
				console.log(data);
				var discard_input = "<input class='discard_amount' type='number' min='1' max='9999'>";
				var discard_note = "<input id='discard_note' type='text'>";
				var type_select = "<select id='type_select' class='form-control'>"
						       	+ "	<option value='return' selected>반품</option>"
		  				        + "	<option value='discard'>폐기</option>"
				                + "</select>";
				
	            data.pop(); // 출하 비고 제거
                data.push(discard_input);
				data.push(type_select);
				data.push(discard_note);

				discardTable.row.add(data).draw();
				chulhaTable.row($(this).parents('tr')).remove().draw();
	        });

	    	setTimeout(function(){discardTable.columns.adjust().draw();},200);
	    	
	    	// 출하 목록 선택
		    $('#chulha_date').click(function() {
		    	viewProductChulhaList('%', 2);
		    });
	    	
		    // delete row on click minus button
		    $('#discardDetail tbody').on('click', '.btn-minus', function () {
		    	//var data = discardTable.row($(this).parents('tr')).data();
		    	
		    	var dataArray = new Array();
		    	
		    	//var data0 = discardTable.row($(this).parents('tr').find('td:eq(0)').text()).data();
		    	var data0 = discardTable.row($(this).parents('tr')).data()[0];
		    	var data1 = discardTable.row($(this).parents('tr')).data()[1];
		    	var data2 = discardTable.row($(this).parents('tr')).data()[2];
		    	var data3 = discardTable.row($(this).parents('tr')).data()[3];
		    	var data4 = discardTable.row($(this).parents('tr')).data()[4];
		    	var data5 = discardTable.row($(this).parents('tr')).data()[5];
		    	var data6 = discardTable.row($(this).parents('tr')).data()[6];
		    	var data7 = discardTable.row($(this).parents('tr')).data()[7];
		    	var data8 = discardTable.row($(this).parents('tr')).data()[8];
		    	var data9 = discardTable.row($(this).parents('tr')).data()[9];
		    	var data10 = "";
		    	

		    	dataArray[0] = data0;
		    	dataArray[1] = data1;
		    	dataArray[2] = data2;
		    	dataArray[3] = data3;
		    	dataArray[4] = data4;
		    	dataArray[5] = data5;
		    	dataArray[6] = data6;
		    	dataArray[7] = data7;
		    	dataArray[8] = data8;
		    	dataArray[9] = data9;
		    	dataArray[10] = data10;
		    	
		    	discardTable.row( $(this).parents('tr') ).remove().draw();
		    	
		    	chulhaTable.row.add(dataArray).draw();
		    });
		
		    
    	}, 300);
    });
    
    // 반품 등록 전 반품 개수의 유효성을 검증
    function validateDiscardAmount(obj) {
    	var len = Object.keys(obj).length;
    	var returnVal = true;
    	
    	console.log(obj[0]);
    	
    	for(var i = 0; i < len; i++) {
    		var chulhaCnt = obj[i][7];
    		var discardCnt = obj[i][10];

    		if(parseInt(chulhaCnt, 10) < parseInt(discardCnt, 10) || parseInt(discardCnt, 10) <= 0) {
    			returnVal = false;
    		} else {
    			returnVal = true;
    		}
    	}
    	return returnVal;
    }
    
    $('#insertBtn').click(function() {
		var tableLen = discardTable.data().length;
		
        if ( ! discardTable.data().any() ) {
			heneSwal.warning("제품을 하나 이상 등록하세요");
			return false;
        }
        
		var outerObj = new Object();
		
        for(var i = 0; i < tableLen; i++) {
			var tr = discardTable.row(i).node();
			var rowArr = new Array();

			$(tr).find('td').each(function() {
				var val = '';
				var insideTd = $(this).children();
				
				if(insideTd.length > 0 && !insideTd.hasClass('btn')) {
					// td 안에 input, select 태그의 값은 저장하고, button 태그의 값은 무시
					val = $(this).find('input, select').val();
				} else if(insideTd.length <= 0) {
					val = $(this).text();
				}
				
				rowArr.push(val);
			});
			
			outerObj[i] = rowArr;
        }

        var validation = validateDiscardAmount(outerObj);
        if(!validation) {
        	heneSwal.error('반품 수량은 1보다 작거나 출하수량보다 클 수 없습니다');
        	return false;
        }
        
        var objLen = Object.keys(outerObj).length;
        outerObj.length = objLen;
        
		var JSONparam = JSON.stringify(outerObj); 
		console.log(JSONparam);
		var confirmVal = confirm("등록하시겠습니까?");
		
		if(confirmVal) {
			sendToServer(JSONparam, "M858S040100E101");
		}
	});
    
	function sendToServer(param, pid){
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : param, "pid" : pid},
	        success: function (rcvData) {
	        	if(rcvData > -1) {
	        		heneSwal.success("반품 등록을 완료했습니다");
		 	     	$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	        	} else {
	        		heneSwal.error("반품 등록에 실패했습니다, 다시 시도해주세요");
	        	}
	        },
	        error: function(rcvData) {
        		heneSwal.error("반품 등록에 실패했습니다, 다시 시도해주세요");
	        }
	    });
	}
 	
 	// 출하 검색창에서 클릭한 출하 정보를 불러옴
 	function getChulhaMainInfo(chulha_no, chulha_rev_no, chulha_date,
			 				   order_no, order_rev_no, note) {
 		
 		// 출하 메인 정보
		$('#chulha_no').val(chulha_no);
		$('#chulha_rev_no').val(chulha_rev_no);
		$('#chulha_date').val(chulha_date);
		$('#order_no').val(order_no);
		$('#order_rev_no').val(order_rev_no);
		$('#note').val(note);
 		
		//$('#chulhaDetail > tbody:last').empty();
		
		
		// 출하 상세 정보
		let jsonObj = new Object();
		jsonObj.chulha_no = chulha_no;
		jsonObj.chulha_rev_no = chulha_rev_no;
		jsonObj.order_no = order_no;
		jsonObj.order_rev_no = order_rev_no;
		let jsonStr = JSON.stringify(jsonObj);
		
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			data: {"prmtr" : jsonStr, "pid" : "M858S040100E124"},
	        success: function (data) {
				
	        	chulhaTable.clear().rows.add(data).draw();
	        	discardTable.rows( $('#discardDetail > tbody > tr') ).remove().draw();
	        	$("#note").attr("readonly", false);
				heneSwal.successTimer("반품할 제품을 추가해 주세요");
	        }
	    });
 	}
</script>
	
<section>
	<div class="row">
		<div class="col-md-4">
			<div class="table-responsive">
				<table class="table">
					<tr>
						<td>출하일자</td>
						<td>
							<input type="text" class="form-control" id="chulha_date" 
								   readonly placeholder="클릭">
				       	</td>
				    </tr>
						
					<tr>
						<td>
				        	출하번호
						</td>
				        <td>
				        	<input type="text" id="chulha_no" class="form-control" readonly>
				        	<input type="hidden" id="chulha_rev_no" class="form-control">
				        </td>
				    </tr>
					<tr>
						<td>
				        	주문번호
						</td>
				        <td>
				        	<input type="text" id="order_no" class="form-control" readonly>
				        	<input type="hidden" class="form-control" id="order_rev_no">
				        </td>
				    </tr>
				   	<tr>
				       	<td>
				       		비고
				       	</td>
						<td>
				        	<input type="text" class="form-control" id="note" readonly>
						</td>
				   	</tr>
				</table>
			</div>
		</div>
		<div class="col-md-8">
			<div class="row table-responsive">
				<table class="table cell-border" id="chulhaDetail">
					<thead>
						<tr>
				            <th style="display:none; width:0px">출하번호</th>
				            <th style="display:none; width:0px">출하 수정이력번호</th>
				            <th>생산날짜</th>
				            <th style="display:none; width:0px">재고일련번호</th>
				            <th>제품명</th>
				            <th style="display:none; width:0px">제품코드</th>
				            <th style="display:none; width:0px">제품 수정이력번호</th>
				            <th>출하수량(ea)</th>
				            <th style="display:none; width:0px">주문번호</th>
				            <th style="display:none; width:0px">주문 수정이력번호</th>
				            <th>비고</th>
				            <th></th>
						</tr>
					</thead>
					<tbody id="chulhaDetailBody">
					</tbody>
				</table>
			</div>
			<div class="row table-responsive">
				<table class="table cell-border" id="discardDetail">
					<thead>
						<tr>
				            <th style="display:none; width:0px">출하번호</th>
				            <th style="display:none; width:0px">출하 수정이력번호</th>
				            <th>생산날짜</th>
				            <th style="display:none; width:0px">재고일련번호</th>
				            <th>제품명</th>
				            <th style="display:none; width:0px">제품코드</th>
				            <th style="display:none; width:0px">제품 수정이력번호</th>
				            <th>출하수량(ea)</th>
				            <th style="display:none; width:0px">주문번호</th>
				            <th style="display:none; width:0px">주문 수정이력번호</th>
				            <th>반품수량(ea)</th>
				            <th>분류</th>
				            <th>비고</th>
				            <th></th>
						</tr>
					</thead>
					<tbody id="discardDetailBody">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</section>