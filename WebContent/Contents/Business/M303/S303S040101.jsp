<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="mes.frame.business.product.ProductPacking"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	ProductPacking prod = new ProductPacking();
%>

<div class="row">
<div class="col-lg-6">
	<table class="table" style="width:100%">
		<tr>
			<td>생산계획</td>
			<td>
				<div class="input-group">
				  <input type="text" class="form-control" id="selectedDate">
				  <div class="input-group-append">
				    <button type="button" onclick="pop_fn_ProdPlan_View($('#selectedDate').val())"
						  id="btn_SearchCust" class="btn btn-info">
						검색
					</button>
				  </div>
				</div>
	       	</td>
		<tr>
			<td>제품명</td>
			<td>
				<input type="text" class="form-control" id="prodName" readonly>
				<input type="hidden" class="form-control" id='prodCd'>
				<input type="hidden" class="form-control" id="prodRevNo">
	       	</td>
	    </tr>
		<tr>
			<td>
	        	제조년월일
			</td>
	        <td>
	        	<input type="text" data-date-format="yyyy-mm-dd" id="manufactureDate" 
	        		   class="form-control" readonly>
	        	<input type="hidden" class="form-control" id='prodPlanDate'>
				<input type="hidden" class="form-control" id="planRevNo">
				<input type="hidden" class="form-control" id="planType">
	        </td>
	    </tr>
		<tr>
			<td>
	        	유통기한
			</td>
	        <td>
	        	<input type="text" data-date-format="yyyy-mm-dd" id="expirationDate" 
	        	       class="form-control" readonly>
	        </td>
	    </tr>
		<tr>
			<td>
	        	규격
			</td>
	        <td>
		    	<input type="text" id="gugyuk" class="form-control" readonly>
	        </td>
	    </tr>
		<tr>
			<td>
	        	계획 생산량
			</td>
	        <td>
	        	<input type="number" id="planAmount" class="form-control" readonly>
	        </td>
	    </tr>
		<tr>
			<td>
	        	수율
			</td>
			<td>
            	<div class="input-group">
			      <input type="number" class="form-control" id="lossRate" min = "0" max = "100">
			      <div class="input-group-append">
			        <span class="input-group-text">%</span>
			      </div>
			    </div>
           	</td>
	    </tr>
		<tr>
	       	<td>
	       		비고
	       	</td>
			<td>
	        	<input type="text" id="note" class="form-control">
			</td>
	   	</tr>
	</table>	
</div>

<div class="col-lg-6">
	<table class="table" id="blendingTable" style="width:100%; float:right;">
		<thead>
			<tr>
	            <th>원료명</th>
	            <th>규격</th>
	            <th style="display:none; width:0px">배합율</th>
	            <th>계획배합량</th>
	            <th style="display:none; width:0px">원부재료 코드</th>
	            <th style="display:none; width:0px">원부재료 수정이력</th>
	            <th style="display:none; width:0px">배합정보 수정이력</th>
			</tr>
		</thead>
		<tbody id="blendingDetail">
		</tbody>
	</table>
</div>
</div>

<script type="text/javascript">

    $(document).ready(function () {
		var applyLossRate = function() {
			let lossRate = $('#lossRate').val();
			
			$("#blendingDetail td:nth-child(4) input").each(function(){
				let $row = $(this).closest("tr");
			    let $tds = $row.find("td");
				let blendAmt = $tds[2].innerText;
				let planAmt = $('#planAmount').val();
				
				let orgBlendAmt = blendAmt * planAmt;
		        let newBlendAmt = orgBlendAmt * (((100 - lossRate) / 100) + 1);
		        newBlendAmt = newBlendAmt.toFixed(2);
		        $(this).val(newBlendAmt);
		    })
		}
		
    	new SetSingleDate2("", "#manufactureDate", 0);
	    new SetSingleDate2("", "#selectedDate", 0);
	    new SetSingleDate2("", "#expirationDate", 0);
	    
	    // 제조년월일 기준으로 유통기한 날짜 변경
	    $('#manufactureDate').change(function() {
	    	var date = adjustExpDate($('#manufactureDate').val(), vExpirationDate);
	    	$('#expirationDate').val(date);
	    });
	    
	    // 수율 변경 시 배합량 변경
	    $('#lossRate').change(function() {
	    	
	    	if($(this).val() > 100 || $(this).val() < 0){
	    		heneSwal.warning("수율은 0 이상 100 이하 숫자만 가능합니다");
	    		$(this).val(0);
	    		$("#btn_Save").attr("disabled", true);
	    		return true;
	    	}
	    	$("#btn_Save").attr("disabled", false);
			applyLossRate();
	    });
	    
	 	// 원부재료 배합량을 위한 기준값(투입량)을 가져옴
	    var getTotalQuantityForProduction = function() {
	    	
	    };
    });
    
	function SaveOderInfo() {
		
		if($("#lossRate").val() == '') {
			heneSwal.warning("수율을 입력해주세요");
			return false;
		}

		//배합량 입력 안된 곳 있으면 예외 처리하는 코드 넣어야됨 (needtocheck)
        var dataJsonHead = new Object();
		
		dataJsonHead.user_id = '<%=loginID%>';
		dataJsonHead.dateManufacture = $('#manufactureDate').val();	//제조년월일
		dataJsonHead.planRevNo = $('#planRevNo').val();				//생산작업요청서 수정이력
		dataJsonHead.prodPlanDate = $('#prodPlanDate').val();		//생산계획일자
		dataJsonHead.planRevNo = $('#planRevNo').val();				//계획 수정이력번호
		dataJsonHead.prodCd = $('#prodCd').val();					//완제품코드
		dataJsonHead.prodRevNo = $('#prodRevNo').val();				//완제품수정이력번호
		dataJsonHead.dateExpiration = $('#expirationDate').val();	//유통기한
		dataJsonHead.lossRate = $('#lossRate').val();				//수율
		dataJsonHead.bigo = $('#note').val();						//비고
		dataJsonHead.planType = $('#planType').val();				//계획구분
        
		var jArray = new Array();
		
		// 완제품별 배합 row 개수
		var trNum = $('#blendingDetail tr').length;
		
        for(var i=0; i<trNum; i++) {
        	
    		var trInput = $($("#blendingDetail tr")[i]).find(":input");
    		
    		if(trInput.eq(3).val() == '') {
    			heneSwal.warning("배합량을 입력해주세요");
    			return false;
    		}
    		
    		var dataJson = new Object();
    		
    		//dataJson.ttlBlendAmt = $('#ttlBlendAmt' + i).val();
    		dataJson.ttlBlendAmt = trInput.eq(0).val(); // 배합량
    		dataJson.partCd = $('#blendingDetail tr:nth-child('+(i+1)+') td:nth-child(5)').text();		// 원부재료 코드
    		dataJson.partRevNo = $('#blendingDetail tr:nth-child('+(i+1)+') td:nth-child(6)').text();	// 원부재료 수정이력번호
    		dataJson.bomRevNo = $('#blendingDetail tr:nth-child('+(i+1)+') td:nth-child(7)').text();	// 배합정보수정이력
			
			jArray.push(dataJson);
        }
		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti); 

		if(confirm("등록하시겠습니까?")) {
			insertIntoDb(JSONparam, "M303S040100E101");
		}
	}
    
	function insertIntoDb(param, pid) {
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : param, "pid" : pid },
	        success: function (rcvData) {
	        	if(rcvData > -1) {
					heneSwal.success('작업지시 등록 완료되었습니다');
		    	    $('#modalReport').modal('hide'); 
					parent.fn_MainInfo_List(startDate, endDate);
	        	} else {
					heneSwal.error('작업지시 등록 실패했습니다, 다시 시도해주세요');
	        	}
			}
	    });
	}
    
    function pop_fn_ProdPlan_View(date) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/ViewPlanDaily.jsp"
    			   + "?selectedDate=" + date;
    	
		var footer = "";
		var title = "생산계획 조회";

		var heneModal = new HenesysModal2(url, 'xlarge', title , footer);
		heneModal.open_modal();
    }
    
	function setValues (prodPlanDate, planType, prodName, planAmount,
			 		    planRevNo, prodCd, prodRevNo, 
			 		    expirationDate, gugyuk) {
    	
		console.log("생산계획일자:" + prodPlanDate);
		console.log("계획구분:" + planType);
		console.log("완제품명:" + prodName);
		console.log("계획 생산량:" + planAmount);
		console.log("계획 수정이력:" + planRevNo);
		console.log("완제품 코드:" + prodCd);
		console.log("완제품 수정이력:" + prodRevNo);
		console.log("유통기한:" + expirationDate);
		console.log("규격:" + gugyuk);
		
    	var initExpDate = adjustExpDate($('#manufactureDate').val(), expirationDate);
    	
    	$('#prodPlanDate').val(prodPlanDate);
    	$('#prodName').val(prodName);
    	$('#planAmount').val(planAmount);
    	$('#planRevNo').val(planRevNo);
    	$('#prodCd').val(prodCd);
    	$('#prodRevNo').val(prodRevNo);
    	$('#expirationDate').val(initExpDate);
    	$('#gugyuk').val(gugyuk);
    	$('#planType').val(planType);
    	
    	var dataToAjax = {
    					"prodCd": prodCd,
    					"prodRevNo": prodRevNo,
    					"selectedDate": prodPlanDate
    				  };
    	
    	dataToAjax = JSON.stringify(dataToAjax);
    	
    	$.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
	         data: {"prmtr" : dataToAjax, "pid" : 'M303S040100E184'},
	         beforeSend: function () {
	         	 console.log('parameter: ' + dataToAjax);
	         	 console.log('sending ajax');
	         },
	         success: function (data) {
	        	 console.log('ajax success');
	        	 console.log('rcv data: ' + data);
	        	 setBlendingSubTable(data);
	         },
	         error: function (request, status, error) {
	             console.log("error:" + request.responseText);
	         }
	    });
    }

	function setBlendingSubTable(data) {
		
		let planAmount = $('#planAmount').val();
				
    	let blendingTable = $('#blendingTable').DataTable({
    		data: data,
    		createdRow: "",
    		select: false,
    		columnDefs: [
    			{
	    			"targets": [2,4,5,6],
	    			"createdCell":  function (td) {
	          			$(td).attr('style', 'display:none;');
	       			}
	    		},
    			{
	    		    "targets": 3,
	    		    "data": "download_link",
	    		    "render": function (data, type, row, meta) {
						let blendAmt = row[2];
	    		    	let blendAmtApplied = blendAmt * planAmount;

	    		    	return '<input type="password" class="form-control"' +
	    		      		  	'readonly id="ttlBlendAmt'+meta.row+'" value="'+blendAmtApplied+'">';
	    		    }
	    		}
	    		/* {
	    			"targets": 2,
	    			"className": "dt-body-right"
	    		} */
    		],
    		paging: false,
    		lengthMenu: false,
    		searching: false,
    		info: false,
    		destroy: true  // reinitialize 에러 발생 해결. 
    	});
	}
</script>