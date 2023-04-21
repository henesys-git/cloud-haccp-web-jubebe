<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%

String trNum = "";

if(request.getParameter("trNum") != null) {
	trNum = request.getParameter("trNum").toString();
}

%>
<head>
    <script src="https://unpkg.com/xlsx@0.11.18/dist/xlsx.full.min.js"></script>
    <meta charset="UTF-8">
</head>

<script type="text/javascript">
    
	//var dataJspPage = {};
	var order_table_RowCount = 0;
	var orderTable;  //주문정보 테이블
	var aaa;
	var orderDate;
	var rowObj;
	var order_data = new Object();
	var js_data = new Object();
	
	$(document).ready(function () {
		
	$('#myModal4').modal('show');	
	
	
	// excel file read
	$('#btn1').click(function() {
		
		const fObj = document.getElementById("selfile");
        if(fObj.value === '') {
            alert('파일을 선택해주세요');
        } else {
            const selectedFile = fObj.files[0];
            var reader = new FileReader();
 
            reader.onload = function(evt) {
            	console.log(evt);
            	console.log(evt.target.readyState);
                if(evt.target.readyState == FileReader.DONE) {
                	
                	$("#order_list tr").remove();
                	
                    var data = evt.target.result;
                    data = new Uint8Array(data);
 					console.log(data);
                    // call 'xlsx' to read the file
                    var workbook = XLSX.read(data, {type: 'array'});
                	console.log(workbook);
                	console.log(workbook.Sheets['order']);
                	
                	if(workbook.Sheets['order'] == 'undefined' || workbook.Sheets['order'] == 'null') {
                		alert('첨부한 엑셀 파일 내에 주문정보 시트가 존재하는지 확인해 주세요.');
                		return false;
                	}
                	
                    var toHtml = XLSX.utils.sheet_to_html(workbook.Sheets['order']);
                    console.log(toHtml);
                    
                    rowObj = XLSX.utils.sheet_to_json(workbook.Sheets['order']);
                    document.getElementById('order_list').innerHTML = toHtml;
                //	console.log(JSON.stringify(rowObj));
                	console.log("toHtml #### : ");
                	console.log(toHtml);
                	console.log("rowObj #### : ");
                	console.log(rowObj);
                	console.log("length : " + Object(rowObj).length);
                    order_data = JSON.stringify(rowObj);
                }
            };
            reader.readAsArrayBuffer(selectedFile);
        }
		
	  });
	
	//save to db
	$('#btn_Save').click(async function() {
		
		async function getOrderExcelProdcd(prodNm) {
			let orders = $.ajax({
		        type: "GET",
		        url: heneServerPath + "/mes-order?id=getProdCd" + "&prodNm=" + prodNm,
		        success: function (result) {
		        	return result;
		        }
			});
		    
			return orders;
		};
		
		async function getOrderExcelCustcd(custNm) {
			let orders2 = $.ajax({
		        type: "GET",
		        url: heneServerPath + "/mes-order?id=getCustCd" + "&custNm=" + custNm,
		        success: function (result) {
		        	return result;
		        }
			});
		    
			return orders2;
		};
		
        js_data = JSON.parse(order_data);
		
		console.log(js_data);
		console.log(Object(rowObj).length);
		
		var orderDetails = new Order();
		
		//return false;
		
		var jArray = new Array();
		var today = new Date();
		var todayYear =  today.getFullYear();
		var todayMonth =  today.getMonth() + 1;
		var todayDay =  today.getDate();
		
		if(todayMonth < 10) {
			todayMonth = "0" + todayMonth;
		}
		if(todayDay < 10) {
			todayDay = "0" + todayDay;
		}
		
		orderDate = todayYear + "-" + todayMonth + "-" + todayDay; 
		
		if(Object(rowObj).length <= 0) {
			alert('엑셀파일 내의 데이터가 제대로 입력되어 있는지 확인해 주세요.');
			return false;
		}
		
        for(var i = 0; i < Object(rowObj).length; i++) {
        	
        	//var  j = 0;
        	
        	//j += 1;
        	
        	if(js_data[i].거래처 == '' || js_data[i].거래처 == null) {
        		alert('거래처가 입력되지 않은 항목이 있습니다.');
        		return false;
        	}
        	
        	if(js_data[i].품명 == '' || js_data[i].품명 == null) {
        		alert('품명이 입력되지 않은 항목이 있습니다.');
        		return false;
        	}
        	
        	if(js_data[i].주문량 == '' || js_data[i].주문량 == null) {
        		alert('주문량이 입력되지 않은 항목이 있습니다.');
        		return false;
        	}
        	
			var dataJson = new Object();
			var dataJson2 = new Object();
			
			//var prod_cd = getOrderExcelProdcd(js_data[i].품명).then(response => {console.log(response);});
			//var cust_cd = getOrderExcelCustcd(js_data[i].거래처).then(response => {console.log(response);});
			
			var prod_cd2 = await getOrderExcelProdcd(js_data[i].품명);
			var cust_cd2 = await getOrderExcelCustcd(js_data[i].거래처);
			
			
    		dataJson.cust_cd 				= cust_cd2.customerId;
    		dataJson.prod_cd 				= prod_cd2.productId;
    		dataJson.cust_name 				= js_data[i].거래처;
    		dataJson.order_detail_seq 		= 0;
    		dataJson.order_count 			= js_data[i].주문량;
    		dataJson.order_date	 			= orderDate;
    		
    		jArray.push(dataJson);
			dataJson2 = new Object();
			
			j = 0;
        }

     	var dataJsonMulti = new Object();
		dataJsonMulti.param = jArray;
		var JSONparam = JSON.stringify(dataJsonMulti);
		console.log(JSONparam);
		var confirmVal = confirm("등록하시겠습니까?"); 
		
		if(confirmVal) {
			
			$.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/mes-order",
	            data: {
	            	"type" : "excelInsert",
	            	"orderData" : JSONparam,
	            	"orderDate" : orderDate
	            },
	            success: function (insertResult) {
	            	if(insertResult == 'true') {
	            		alert('등록되었습니다.');
	            		$('#myModal4').modal('hide');
	            		orderJSPPage.refreshMainTable();
	            	} else {
	            		alert('등록 실패했습니다, 관리자에게 문의해주세요.');
	            	}
	            }
	        });
			
			console.log("send data complete");
			
			
		}
		
		
	  });
	
    });

	
</script>
 
 <div class="modal fade" id="myModal4" tabindex="-1" role="dialog"  aria-hidden="true">
    	<div class="modal-dialog modal-dialog-scrollable">
    		<div class="modal-content">
        		<div class="modal-header">
        			<h4 class="modal-title3">주문정보 엑셀등록</h4>
          		</div>
          		<div class="modal-body">
          			<div style="width:30%; float : left;">
						<input type="file" id="selfile" accept=".xlsx, .txt">
					<br>
					
				</div>
				<table class='table table-bordered nowrap table-hover' id="order_list" style="width: 100%">
 				<tbody id="order_list_body">
 				</tbody>
				</table>
		<div id="UserList_pager" class="text-center"></div>
        		</div>
		        <div class="modal-footer">
		        	 <button id="btn1" class="btn btn-info" value="Get Excel Data">내용가져오기</button>
					 <button id="btn_Save"  class="btn btn-info" >저장</button>
        			 <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>  
		        </div>
        	</div>
      	</div>
 </div>
