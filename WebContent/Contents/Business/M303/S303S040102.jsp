<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	String prod_plan_date = "", product_nm = "",
		   manufacturing_date = "", plan_amount = "",
		   expiration_date = "", loss_rate = "",
		   total_blending_amount = "", note = "", 
		   prod_cd = "", prod_rev_no = "", 
		   request_rev_no = "", plan_rev_no = "",
		   gugyuk = "";
	
	if(request.getParameter("prod_plan_date") != null)
		prod_plan_date = request.getParameter("prod_plan_date");
	
	if(request.getParameter("plan_rev_no") != null)
		plan_rev_no = request.getParameter("plan_rev_no");
	
	if(request.getParameter("product_nm") != null)
		product_nm = request.getParameter("product_nm");

	if(request.getParameter("gugyuk") != null)
		gugyuk = request.getParameter("gugyuk");
	
	if(request.getParameter("manufacturing_date") != null)
		manufacturing_date = request.getParameter("manufacturing_date");
	
	if(request.getParameter("plan_amount") != null)
		plan_amount = request.getParameter("plan_amount");
	
	if(request.getParameter("expiration_date") != null)
		expiration_date = request.getParameter("expiration_date");
	
	if(request.getParameter("loss_rate") != null)
		loss_rate = request.getParameter("loss_rate");
	
	if(request.getParameter("total_blending_amount") != null)
		total_blending_amount = request.getParameter("total_blending_amount");
	
	if(request.getParameter("note") != null)
		note = request.getParameter("note");
	
	if(request.getParameter("prod_cd") != null)
		prod_cd = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev_no") != null)
		prod_rev_no = request.getParameter("prod_rev_no");
	
	if(request.getParameter("request_rev_no") != null)
		request_rev_no = request.getParameter("request_rev_no");
%>

<div class="row">
<div class="col-lg-4">
	<table class="table" style="width: 115%">
		<tr>
			<td>생산계획</td>
			<td>
				<input type="text" class="form-control" id="date_to_select" readonly>
				<input type="hidden" class="form-control" id="request_rev_no">
	       	</td>
		<tr>
			<td>제품명</td>
			<td>
				<input type="text" class="form-control" id="product_nm" readonly>
				<input type="hidden" class="form-control" id='prod_cd'>
				<input type="hidden" class="form-control" id="prod_rev_no">
	       	</td>
	    </tr>
		<tr>
			<td>
	        	제조년월일
			</td>
	        <td>
	        	<input type="text" data-date-format="yyyy-mm-dd" id="manufacturing_date" class="form-control">
	        	<input type="hidden" class="form-control" id='prod_plan_date'>
				<input type="hidden" class="form-control" id="plan_rev_no">
	        </td>
	    </tr>
		<tr>
			<td>
	        	유통기한
			</td>
	        <td>
	        	<input type="text" data-date-format="yyyy-mm-dd" id="expiration_date" class="form-control" />
	        </td>
	    </tr>
	    <tr>
			<td>
	        	규격
			</td>
	        <td>
	        	<input type="text" id="gugyuk" class="form-control" id="gugyuk" readonly>
	        </td>
	    </tr>
		<tr>
			<td>
	        	계획 생산량
			</td>
	        <td>
	        	<input type="number" id="plan_amount" class="form-control" readonly>
	        </td>
	    </tr>
		<tr>
			<td>
	        	수율
			</td>
	        <td>
	        	<div class="input-group">
	        	<input type="number" id="loss_rate" class="form-control" min = "0" max = "100">
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

<div class="col-lg-8">
	<table class="table" id="blendingTable" style="width:90%; float:right;">
		<thead>
			<tr>
	            <th>원료명</th>
	            <th>규격</th>
	            <th style="display:none; width:0px">배합기준량</th>
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
    	
    	var loss_rate = parseFloat('<%=loss_rate%>');
    	console.log(loss_rate);
    	var fx_loss_rate = loss_rate.toFixed(0);
    	console.log(fx_loss_rate);
    	
    	
    	var applyLossRate = function() {
			let lossRate = $('#loss_rate').val();
			
			console.log(lossRate);
			
			$("#blendingDetail td:nth-child(4) input").each(function(){
				let $row = $(this).closest("tr");
			    let $tds = $row.find("td");
				//let ratio = $tds[2].innerText;
				let blendAmt = $tds[2].innerText;
				let planAmt = $('#plan_amount').val();
				
				let orgBlendAmt = blendAmt * planAmt;
		        let newBlendAmt = orgBlendAmt * (((100 - lossRate) / 100) + 1);
		        newBlendAmt = newBlendAmt.toFixed(2);
		        $(this).val(newBlendAmt);
		    })
		}
    	
    	new SetSingleDate2("", "#manufacturing_date", 0);
	    new SetSingleDate2("", "#expiration_date", 0);
	    
	    $('#date_to_select').attr('disabled', true);
	    
	    $('#date_to_select').val('<%=prod_plan_date%>');
	    $('#prod_plan_date').val('<%=prod_plan_date%>');
	    $('#product_nm').val('<%=product_nm%>');
	    $('#manufacturing_date').val('<%=manufacturing_date%>');
	    $('#expiration_date').val('<%=expiration_date%>');
	    $('#plan_amount').val('<%=plan_amount%>');
	   <%--  $('#loss_rate').val('<%=loss_rate%>'); --%>
	    $('#loss_rate').val(fx_loss_rate);
	    $('#note').val('<%=note%>');
	    $('#request_rev_no').val('<%=request_rev_no%>');
	    $('#prod_cd').val('<%=prod_cd%>');
	    $('#plan_rev_no').val('<%=plan_rev_no%>');
	    $('#prod_rev_no').val('<%=prod_rev_no%>');
	    $('#gugyuk').val('<%=gugyuk%>');
	    
	    var dataToAjax = {
				"manufacturing_date": '<%=manufacturing_date%>',
				"request_rev_no": '<%=request_rev_no%>',
				"prod_plan_date": '<%=prod_plan_date%>',
				"plan_rev_no": '<%=plan_rev_no%>',
				"prod_cd": '<%=prod_cd%>',
				"prod_rev_no": <%=prod_rev_no%>,
			  };
		
		dataToAjax = JSON.stringify(dataToAjax);

		$.ajax({
    		 type: "POST",
    		 dataType: "json",
    		 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
     		 data: {"prmtr" : dataToAjax, "pid" : 'M303S040100E194'},
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
    });
	
	function SaveOderInfo() {
		if($("#loss_rate").val() == '') { 
			heneSwal.warning("수율을 입력해주세요");
			return false;
		}
		
		//배합량 입력 안된 곳 있으면 예외 처리하는 코드 넣어야됨, needtocheck
        
        var dataJsonHead = new Object();
		
		dataJsonHead.user_id 			= '<%=loginID%>';
		dataJsonHead.manufacturing_date = $('#manufacturing_date').val();		//제조년월일
		dataJsonHead.request_rev_no 	= $('#request_rev_no').val();		//지시서 수정이력번호
		dataJsonHead.prod_plan_date 	= $('#prod_plan_date').val();		//생산계획일자
		dataJsonHead.plan_rev_no 		= $('#plan_rev_no').val();			//계획 수정이력번호
		dataJsonHead.prod_cd 			= $('#prod_cd').val();				//완제품코드
		dataJsonHead.prod_rev_no		= $('#prod_rev_no').val();			//완제품수정이력번호
		dataJsonHead.expiration_date 	= $('#expiration_date').val();		//유통기한
		dataJsonHead.loss_rate 			= $('#loss_rate').val();			//수율
		dataJsonHead.note 				= $('#note').val();					//비고
        
		var jArray = new Array();
		
		// 완제품별 배합 row 개수
		var trNum = $('#blendingDetail tr').length;
		
        for(var i = 0; i < trNum; i++) {
        	
    		var trInput = $($("#blendingDetail tr")[i]).find(":input");
    		
    		if(trInput.eq(3).val() == '') { 
    			heneSwal.warning("배합량을 입력해주세요");
    			return false;
    		}
    		
    		var dataJson = new Object();
    		
    		//dataJson.blending_amount_plan = $('#blending_amount_plan' + i).val();	// 배합량
    		dataJson.blending_amount_plan = trInput.eq(0).val();
    		dataJson.part_cd = $('#blendingDetail tr:nth-child('+(i+1)+') td:nth-child(5)').text();	// 원부재료 코드
    		dataJson.part_rev_no = $('#blendingDetail tr:nth-child('+(i+1)+') td:nth-child(6)').text();	// 원부재료 수정이력번호
    		dataJson.bom_rev_no = $('#blendingDetail tr:nth-child('+(i+1)+') td:nth-child(7)').text();	// 배합정보 수정이력번호
			
			jArray.push(dataJson);
        }
		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti); 

		var confirmVal = confirm("수정하시겠습니까?"); 
		
		if(confirmVal) {
			updateRqstInfo(JSONparam, "M303S040100E102");
		}
	}
    
	function updateRqstInfo(param, pid) {
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : param, "pid" : pid },
	        success: function (rcvData) {
	        	if(rcvData > -1) {
					heneSwal.success('작업지시 수정이 완료되었습니다');
		    	    $('#modalReport').modal('hide'); 
					parent.fn_MainInfo_List(startDate, endDate);
	        	} else {
					heneSwal.error('작업지시 수정에 실패했습니다, 다시 시도해주세요');
	        	}
			}
	    });
	}
    
	function setBlendingSubTable(data) {
		
		var planAmount = $('#plan_amount').val();
		var loss_rate = $('#loss_rate').val();
		
    	var blendingTable = $('#blendingTable').DataTable({
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
	    		    "targets": [3],
	    		    "data": "download_link",
	    		    "render": function ( data, type, row, meta ) {
	    		    	let blendAmt = row[3];
	    		    	let blendAmtApplied = blendAmt * planAmount;
	    		    	let blendAmtApplied_Loss  = blendAmtApplied * (((100 - loss_rate) / 100) + 1);
	    		    	
		    		    return '<input type="password" class="form-control"' + 
		    		    			  'value="'+blendAmtApplied_Loss+'" id="blending_amount_plan'+meta.row+'">';
	    		    }
	    		}/* ,
	    		{
	    			"targets": [2],
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