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
	
	String GV_CHULHA_NO = "", GV_CHULHA_REV_NO = "",
			   GV_CHULHA_DATE = "", GV_DRIVER_ID = "", 
			   GV_VEHICLE_CD = "", GV_VEHICLE_REV_NO = "", GV_VEHICLE_NM = "", 
			   GV_LOCATION_TYPE = "", LOCATION_TYPE_NM = "", 
			   GV_ORDER_NO = "", GV_ORDER_REV_NO = "",
			   GV_CHULHA_NOTE = "", GV_CUST_NM = "",
			   GV_ORDER_DATE = "", GV_DELIVERY_DATE = "";
		
		
		if(request.getParameter("chulha_no") == null)
			GV_CHULHA_NO = "";
		else
			GV_CHULHA_NO = request.getParameter("chulha_no");
		
		if(request.getParameter("chulha_rev_no") == null)
			GV_CHULHA_REV_NO = "";
		else
			GV_CHULHA_REV_NO = request.getParameter("chulha_rev_no");
		
		if(request.getParameter("chulha_date") == null)
			GV_CHULHA_DATE = "";
		else
			GV_CHULHA_DATE = request.getParameter("chulha_date");
		
		if(request.getParameter("vehicle_cd") == null)
			GV_VEHICLE_CD = "";
		else
			GV_VEHICLE_CD = request.getParameter("vehicle_cd");
		
		if(request.getParameter("driver_id") == null)
			GV_DRIVER_ID = "";
		else
			GV_DRIVER_ID = request.getParameter("driver_id");
		
		if(request.getParameter("location_type") == null)
			GV_LOCATION_TYPE = "";
		else
			GV_LOCATION_TYPE = request.getParameter("location_type");
		
		if(request.getParameter("location_type_nm") == null)
			LOCATION_TYPE_NM = "";
		else
			LOCATION_TYPE_NM = request.getParameter("location_type_nm");
		
		if(request.getParameter("vehicle_rev_no") == null)
			GV_VEHICLE_REV_NO = "";
		else
			GV_VEHICLE_REV_NO = request.getParameter("vehicle_rev_no");
		
		if(request.getParameter("order_no") == null)
			GV_ORDER_NO = "";
		else
			GV_ORDER_NO = request.getParameter("order_no");
		
		if(request.getParameter("order_rev_no") == null)
			GV_ORDER_REV_NO = "";
		else
			GV_ORDER_REV_NO = request.getParameter("order_rev_no");
		
		if(request.getParameter("chulha_note") == null)
			GV_CHULHA_NOTE = "";
		else
			GV_CHULHA_NOTE = request.getParameter("chulha_note");
		
		if(request.getParameter("cust_nm") == null)
			GV_CUST_NM = "";
		else
			GV_CUST_NM = request.getParameter("cust_nm");
		
		if(request.getParameter("order_date") == null)
			GV_ORDER_DATE = "";
		else
			GV_ORDER_DATE = request.getParameter("order_date");
		
		if(request.getParameter("delivery_date") == null)
			GV_DELIVERY_DATE = "";
		else
			GV_DELIVERY_DATE = request.getParameter("delivery_date");
		
	
	
	// 배송차량 목록
	String initVehicleTypeCode = "";
	Vector vehicleTypeCode = null;
    Vector vehicleTypeName = null;
    Vector vehicleTypeList = CommonData.getVehicleType();
    
    // 배송기사 목록
    String initVehicleDriverCode = "";
	Vector vehicleDriverCode = null;
    Vector vehicleDriverName = null;
    Vector vehicleDriverList = CommonData.getVehicleDriver();
    
 	// 배송지역 목록
    String initVehicleLocationCode = "";
	Vector vehicleLocationCode = null;
    Vector vehicleLocationName = null;
    Vector vehicleLocationList = CommonData.getDeliverLocation();
    
    
    JSONObject jArray = new JSONObject();
	jArray.put("chulha_no", GV_CHULHA_NO);
	jArray.put("location_type", GV_LOCATION_TYPE);
	jArray.put("location_nm", LOCATION_TYPE_NM);
	jArray.put("chulha_date", GV_CHULHA_DATE);
    
    DoyosaeTableModel table = new DoyosaeTableModel("M858S010100E224", jArray); //가맹점별 출하량 상세정보 조회
    DoyosaeTableModel table2 = new DoyosaeTableModel("M858S010100E234", jArray); //가맹점 상세정보 조회
    DoyosaeTableModel table3 = new DoyosaeTableModel("M858S010100E264", jArray); //p박스 출고량 조회
	
    VectorToJson vtj = new VectorToJson();
    
    String data1 = vtj.vectorToJson(table.getVector());
    String data2 = vtj.vectorToJson(table2.getVector());
    String data3 = vtj.vectorToJson(table3.getVector());
    
%>
<style>
table{
postion : relative;
padding:0; border-spacing:0px; border:0; border-collapse:collapse;
}

th, td {
padding:0px;
}


.table{
position: relative;
overflow-x : hidden;
margin: 0;
padding : 0;

}
</style>


  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <div class="stepwizard">
          <div class="stepwizard-row setup-panel">
            <div class="stepwizard-step">
              <a href="#step-1" type="button" class="btn btn-primary btn-circle start-class">1</a>
              <p>배송차량</p>
            </div>
            <div class="stepwizard-step">
              <a href="#step-2" type="button" class="btn btn-default btn-circle" disabled="disabled">2</a>
              <p>주문</p>
            </div>
            <div class="stepwizard-step">
              <a href="#step-3" type="button" class="btn btn-default btn-circle end-class" disabled="disabled">3</a>
              <p>완료</p>
            </div>
          </div>
        </div>
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      </div>
      <div class="modal-body">
        <div class="container">
            <div class="row setup-content" id="step-1">
              <div class="col-md-12">
                <div class="row">
                	<div class="col-md-6">
	                  <h3>1. 배송자 정보를 선택해 주세요</h3>
                	</div>
                	<div class="col-md-6">
	                  <button class="btn btn-primary skipBtn pull-right" type="button">
	                  	배송 차량 관리를 안합니다
	                  </button>
                	</div>
                </div>
                
                <div class="form-group">
                   <label class="control-label">배송 기사</label>
                 	<select required="required" class="form-control" id="vehicleDriver">
			        	<% vehicleDriverCode = (Vector) vehicleDriverList.get(0);%>
			            <% vehicleDriverName = (Vector) vehicleDriverList.get(1);%>
			            <% for(int i = 0; i < vehicleDriverName.size(); i++) { %>
							<option value='<%=vehicleDriverCode.get(i).toString()%>' 
								<%=initVehicleDriverCode.equals(vehicleDriverCode.get(i).toString()) ? "selected" : "" %>>
								<%=vehicleDriverName.get(i).toString()%>
							</option>
						<%} %>
					</select>
                 </div>
                
                 <div class="form-group">
					<label class="control-label">배송 차량</label>
                 	<select required="required" class="form-control" id="vehicleCd">
			        	<% vehicleTypeCode = (Vector) vehicleTypeList.get(0);%>
			            <% vehicleTypeName = (Vector) vehicleTypeList.get(1);%>
			            <% for(int i = 0; i < vehicleTypeName.size(); i++) { %>
							<option value='<%=vehicleTypeCode.get(i).toString()%>' 
								<%=initVehicleTypeCode.equals(vehicleTypeCode.get(i).toString()) ? "selected" : "" %>>
								<%=vehicleTypeName.get(i).toString()%>
							</option>
						<%} %>
					</select>
                 </div>
                 
                 <div class="form-group">
                   <label class="control-label">배송 지역</label>
                 	<select required="required" class="form-control" id="vehicleLocation">
			        	<% vehicleLocationCode = (Vector) vehicleLocationList.get(1);%>
			            <% vehicleLocationName = (Vector) vehicleLocationList.get(2);%>
			            <% for(int i = 0; i < vehicleLocationName.size(); i++) { %>
							<option value='<%=vehicleLocationCode.get(i).toString()%>' 
								<%=initVehicleLocationCode.equals(vehicleLocationCode.get(i).toString()) ? "selected" : "" %>>
								<%=vehicleLocationName.get(i).toString()%>
							</option>
						<%} %>
					</select>
                 </div>
                 <div class="form-group">
                   <label class="control-label">P박스</label>
                   <input id="vehicleNote" required="required" class="form-control" placeholder="P박스 개수를 입력해주세요" type="number">
                 </div>
              </div>
            </div>
            <div class="row setup-content" id="step-2">
            	<h3>2. 주문 목록</h3>
            	
            	<div class="row table-responsive" >
					<table class="table" id="orderListTable" style="width:900px;">
						<thead>
					    	<tr>
					            <th>고객사</th>
					            <th>주문일자</th>
					            <th>요청 납품일자</th>
					            <th>비고</th>
					            <th>
					            	<button class="btn btn-info btn-sm" id="addChulhaBtn" type="button">
					            		<i class="fas fa-plus"></i>
					            	</button>
								</th>
							</tr>
					  	</thead>
					  	<tbody id="orderListTableBody">
					  	</tbody>
				  	</table>
				</div>
            </div>
            <div class="row setup-content" id="step-3">
              <div>
                  <h3>3. 수정</h3>
                  <div class="center">
	                  <button class="btn btn-success btn-lg pull-right" id="saveChulhaBtn" type="submit">출하 수정</button>
                  </div>
              </div>
            </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary prevBtn btn-lg pull-left disabled-control" type="button">뒤로</button>
        <button class="btn btn-primary nextBtn btn-lg pull-right" type="button">다음</button>
        <button type="button" class="btn btn-primary btn-lg" data-dismiss="modal">닫기</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->


<script>
	/* 출하 등록될 주문 목록 */
	var orderListTable;
	/* 최종적으로 서버로 보내서 db에 저장하기 위한 객체 */
	var orderListObj = new Object();
	/* 위 객체의 키 값(0,1,... 숫자) */
	var keyInContainer = "0";
	//var keyInContainer = parseInt(Object.keys(orderListObj).length) ;
	
	var data1 = <%=data1%>;
	var data2 = <%=data2%>;
	var data3 = <%=data3%>;
	
	function getOrderInfo(obj) {
		/* 순서 중요 (key값이 더해지기 전에 화면에 먼저 보여준다) */
		displayReceivedOrder(obj, keyInContainer);

		orderListObj[keyInContainer] = obj;
		keyInContainer = parseInt(keyInContainer) + 1;
		keyInContainer = keyInContainer.toString();
		
		console.log(keyInContainer);
	}
	
	function displayReceivedOrder(obj, idx) {
		orderListTable.row.add([
    		"<input type='text' class='form-control' required='required' readonly>",
			"<input type='text' class='form-control' required='required' readonly>",
    		"<input type='text' class='form-control' required='required' readonly>",
    		"<input type='text' class='form-control' readonly>",
    		"<button class='btn btn-info btn-sm btn-minus' onclick='fn_minus_body(this);'>" +
			"  <i class='fas fa-minus'></i>" +
			"</button>"
        ]).draw();
		
		var tr = $($("#orderListTableBody tr")[parseInt(idx)]).find(":input");
		tr.eq(0).val(obj.paramHead.custName);
		tr.eq(1).val(obj.paramHead.orderDate);
		tr.eq(2).val(obj.paramHead.deliveryDate);
		tr.eq(3).val(obj.paramHead.chulhaNote);
	}
	
	//페이지 최초 주문정보 display 해주는 함수
	function initdisplayReceivedOrder(){
		
			for(var i = 0; i<data2.length; i++){
			orderListTable.row.add([
	    		" <input type='text' class='form-control' required='required' readonly>",
				" <input type='text' class='form-control' required='required' readonly>",
	    		" <input type='text' class='form-control' required='required' readonly>",
	    		" <input type='text' class='form-control' readonly>",
	    		" <button class='btn btn-info btn-sm btn-minus' onclick='fn_minus_body(this);'>" +
				"   <i class='fas fa-minus'></i>" +
				" </button>"
	        ]).draw();
			
			var tr = $($("#orderListTableBody tr")[i]).find(":input");
			tr.eq(0).val(data2[i][2]);
			tr.eq(1).val(data2[i][5]);
			tr.eq(2).val(data2[i][6]);
			tr.eq(3).val(data2[i][7]);	
		}
		
		
	}
	
	$(document).ready(function () {
		
		/* skip이 true이면, 다음 step으로 건너뛰기 가능 */
		var skip = false;
		/* 차량 혹은 배송기사 관리 여부 */
		var manageVehicle = true;
		
		var orderListTableInfo;
	   	var orderRowCount = 0;
		
	   	setTimeout(function() {
	   	
	   	$('#vehicleNote').val(parseInt(data3[0][0]));	
	   		
	   	$('#vehicleDriver').attr('disabled', true);
	   	$('#vehicleLocation').attr('disabled', true);
	   	$('#vehicleCd').attr('disabled', true);
	   	
		$("#vehicleDriver").val('<%=GV_DRIVER_ID%>').prop("selected", true); 
	   	$("#vehicleLocation").val('<%=GV_LOCATION_TYPE%>').prop("selected", true); 
	    $("#vehicleCd").val('<%=GV_VEHICLE_CD%>').prop("selected", true);
	    console.log('=============================');	
	   	console.log('<%=LOCATION_TYPE_NM%>');	
	   	var customOpts = {
	   	   		paging : false,
	   	    	searching : false,
	   	    	ordering : false,
	   	    	keys : false,
	   	    	autoWidth : false,
	   	    	createdRow : "",
	   	    	columnDefs : [
					{ "className": "dt-head-center", "targets": "_all" },
					{ "width": "30%", "targets": 0 }
				]
	    	};
	    	
	   	orderListTable = $('#orderListTable').DataTable(
   			mergeOptions(henePopupTableOpts, customOpts)
	   	);
	   	
	  	initdisplayReceivedOrder(); //출하 된 주문목록 display
	  	
		var dataJsonHead = new Object();
		var jArray = new Array();
		
		var resultArr2 = new Object();
		var resultArr3 = new Array();
		
		var dataJson2 = new Object();
		var jArray3 = new Array();
		
	  	for(var i = 0; i<data2.length; i++){
	  		var dataJsonMulti = new Object();
	  		
	  		let jsonObj = new Object();
			
			jsonObj.orderNo = data2[i][0];
			jsonObj.orderRevNo = data2[i][1];
			
			let jsonStr = JSON.stringify(jsonObj);
			
			var newArr2 = doAjax(jsonStr); //orderInfo
			var newArr3 = doAjax2(jsonStr); // chulhaInfo
						
			resultArr2.aa = newArr2;
			resultArr3[i] = newArr3;
			
		    console.log("resultArr2:================");
	  		console.log(resultArr2);
	  		console.log(resultArr2[i]);
	  		
	  		
	  		console.log("resultArr3:================");
	  		console.log(resultArr3);
	  		console.log(resultArr3[i]);
	  		
	  		dataJsonMulti.paramHead = resultArr2.aa
	  		//dataJsonMulti.paramHead = resultArr2[i];
	  		dataJsonMulti.param = resultArr3[i];
	  		console.log(dataJsonMulti.paramHead);
	  		console.log(dataJsonMulti.param);
	 		//dataJsonMulti.param = resultArr3[i];
	 		console.log("dataJsonMulti:================")
	 		console.log(dataJsonMulti);
	 		
	 		orderListObj[i] = dataJsonMulti;
	 			  		
	  	}
	  	
	  	keyInContainer = parseInt(Object.keys(orderListObj).length);
	   	console.log(orderListObj);
	   	console.log(Object.keys(orderListObj).length);
	   	console.log(keyInContainer);
	   	
		},300);
	   	
	   	//배송기사 선택시 배송정보에 등록되어 있는 대로 배송지역, 차량 정보 변경 
	   	$('#vehicleDriver').on('change', function(){
	   	var driver_id = $(this).val();
	   	
	   	var dataJson = new Object();
	   	dataJson.driver_id = driver_id;
	   	var jsonStr = JSON.stringify(dataJson);
	   	
	   	$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			data: {"prmtr" : jsonStr, "pid" : "M858S010100E204"},
	        success: function (data) {
			
		        $("#vehicleLocation").val(data[0][4]).prop("selected", true); //배송지역
		        $("#vehicleCd").val(data[0][6]).prop("selected", true); //차량종류
	        }
	      });
	   	
	   	
	   	});
	   		   	
	   	$('#vehicleCd').attr('disabled', true);
	   	$('#vehicleLocation').attr('disabled', true);
	   	
	   	$('#addChulhaBtn').on('click', function () {
	   		
	   		var location_type = $("#vehicleLocation option:selected").val();
	   		
	   		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010104.jsp"
	   				+ "?location_type=" + location_type;
			var footer = '<button id="addOrderInfoBtn" class="btn btn-info">등록</button>';
			var title = "주문별 출하정보";
			var heneModal = new HenesysModal2(url, 'xlarge', title, footer);
			heneModal.open_modal();
	   	});
	   	
	   	/*
	   	$(document).on('click', '.btn-minus', function () {
	    	orderListTable
	   		       .row( $(this).parents('tr') )
		           .remove()
		           .draw();
	    	
	    	keyInContainer = parseInt(keyInContainer) - 1;
			keyInContainer = keyInContainer.toString();
	    });
	   	*/
	   	
		var navListItems = $('div.setup-panel div a'),
	    allWells = $('.setup-content'),
	    allNextBtn = $('.nextBtn'),
		allPrevBtn = $('.prevBtn');
		
		allWells.hide();
		
		navListItems.click(function (e) {
			e.preventDefault();
			var $target = $($(this).attr('href')),
			    $item = $(this);
			
			if ( !$item.hasClass('disabled') ) {
			    navListItems.removeClass('btn-primary').addClass('btn-default');
			    $item.removeClass('btn-default').addClass('btn-primary');
			    allWells.hide();
			    $target.show();
			    $target.find('input:eq(0)').focus();
			}
		});
	  
		allPrevBtn.click(function(){
		    var setupwizard = $('.stepwizard-row');
		    var sel = setupwizard.find('.btn-primary');
		    var to_sel = sel.parent().prev().find('.btn-circle');
		    to_sel.trigger('click');
		  
		    /* DISABLING AND ENABLING PREV AND NEXT
		       BUTTONS BASED ON CURRENT PAGE
		    */
		    if(to_sel.hasClass('start-class')) {
		       $('.prevBtn').addClass('disabled-control');
		       $('.nextBtn').removeClass('disabled-control');
		    } else if(to_sel.hasClass('end-class')) {
		       $('.nextBtn').addClass('disabled-control');
		       $('.prevBtn').removeClass('disabled-control');
		    } else {
		       $('.nextBtn').removeClass('disabled-control');
		       $('.prevBtn').removeClass('disabled-control');
		    }
		});
	
		$('.nextBtn').click(function() {
		    var setupwizard = $('.stepwizard-row');
		    var sel = setupwizard.find('.btn-primary');
		    var to_sel = sel.parent().next().find('.btn-circle');
		    var err = 0;

		    var step = get_current_page_id();
		
		    /* CHECKING IF ALL INPUTS AND TEXTAREA IN THE CURRENT 
		       PAGE ARE FILLED. IF NOT : ADD ERROR CLASS ON INPUT 
		       AND INCREMENT ERROR COUNTER */
		    $('#' + step + ' input, textarea').each(function(){
		        if($(this).prop('required') && $(this).val() == '') {   
		             if(!$(this).hasClass('is-invalid'))
		                 $(this).addClass('is-invalid')
		
		            err++;
		        } else {
		             if($(this).hasClass('is-invalid'))
		                 $(this).removeClass('is-invalid')
		        }
		    });
	
			/* IF ERROR COUNTER == 0 ( ie. NO ERRORS FOUND )
			       => PROCEED TO NEXT STEP 
			*/
			if(err == 0) {
			    to_sel.trigger('click');
			
			    if(to_sel.hasClass('start-class')) {
			       $('.prevBtn').addClass('disabled-control');
			       $('.nextBtn').removeClass('disabled-control');
			    } else if(to_sel.hasClass('end-class')) {
			        $('.nextBtn').addClass('disabled-control');
			        $('.prevBtn').removeClass('disabled-control');
			    } else {
			        $('.nextBtn').removeClass('disabled-control');
			        $('.prevBtn').removeClass('disabled-control');
			    }
			}
		});
		
		$('.skipBtn').click(function() {
		    var setupwizard = $('.stepwizard-row');
		    var sel = setupwizard.find('.btn-primary');
		    var to_sel = sel.parent().next().find('.btn-circle');
		    var err = 0;
		    
		    var step = get_current_page_id();
		
		    to_sel.trigger('click');
		
		    if(to_sel.hasClass('start-class')) {
		       $('.prevBtn').addClass('disabled-control');
		       $('.nextBtn').removeClass('disabled-control');
		    } else if(to_sel.hasClass('end-class')) {
		        $('.nextBtn').addClass('disabled-control');
		        $('.prevBtn').removeClass('disabled-control');
		    } else {
		        $('.nextBtn').removeClass('disabled-control');
		        $('.prevBtn').removeClass('disabled-control');
		    }
		});
		
		/* SHOW AND HIDE ERROR CLASS AS USER TYPES */
		$(document).on('input', 'input, textarea', function(){
		   if($(this).val() == '') {
		        if(!$(this).hasClass('is-invalid'))
		           $(this).addClass('is-invalid');
		   }  else {
		       if($(this).hasClass('is-invalid'))
		           $(this).removeClass('is-invalid')
		   }
		});
	
		/* FUNCTION WHICH RETURNS THE ID OF CURRENT VISIBLE PAGE */
		function get_current_page_id() {
			return $(".setup-content:visible").attr('id');
		}
		
		/* 
			첫 화면에서 step 1에 click 이벤트  실행. 
			실행되면 btn-default 클래스가 생겨서 명시적으로 제거 
		*/
		$('div.setup-panel div a.btn-primary').trigger('click');
		$('.stepwizard-step:first-child').children("a").removeClass('btn-default');
		
		$('#saveChulhaBtn').click(function() {
			
			var obj = new Object();
			
			/* 주문 관련 정보 추가 */
			obj.orders = orderListObj;
			
			console.log(obj.orders[0]);
			
			if(obj.orders[0] == undefined){
			
			heneSwal.warning('출하하는 주문정보를 1개 이상 등록해 주세요');
			
			return false;
			
			} 
			
			/* 차량 관련 정보 추가 */
			if(manageVehicle == true) {
				var vehicle = new Object();
				
				vehicle.vehicleLocation = $('#vehicleLocation').val();
				vehicle.vehicleLocationNm = $('#vehicleLocation option:selected').text().trim();
				vehicle.vehicleCd = $('#vehicleCd').val();
				vehicle.vehicleDriver = $('#vehicleDriver').val();
				vehicle.vehicleNote = $('#vehicleNote').val();	// 원우푸드 프로젝트에서는 P박스 관리용 데이터(수정될 p박스 출고량)
				vehicle.beforeVehicleNote = parseInt(data3[0][0]);	// 기존 P박스 출고량
				obj.vehicle = vehicle;
			}
			
			//출하수정시 insert전 delete하기 위해 필요한 출하 정보 추가
			var chulha = new Object();
			
			chulha.chulhaNo = '<%=GV_CHULHA_NO%>';
			chulha.chulhaRevNo = '<%=GV_CHULHA_REV_NO%>';
			chulha.chulhaDate = '<%=GV_CHULHA_DATE%>';
			
			obj.deleteInfo1 = chulha;
			
			//출하수정시 insert전 delete하기 위해 필요한 주문, 출하량 정보 추가
			var orderInfo = data2.length;
			
			var jArray = new Array();
			var resultArr = new Array();
			
			for(var i = 0; i < orderInfo; i++) {
			
				var orderNo = data2[i][0];
		        var orderRevNo = data2[i][1];
		        
		        var dataJson_order = new Object();
		        
		        dataJson_order.order_no = orderNo;
		        dataJson_order.order_rev_no = orderRevNo;
		        
		        jArray.push(dataJson_order);
		        
		        var dataJson_order2 = new Object();
		        
		        dataJson_order2.chulha_no 		= '<%=GV_CHULHA_NO%>';
				dataJson_order2.location_type 	= '<%=GV_LOCATION_TYPE%>';
				dataJson_order2.order_no 		= orderNo // 주문번호로 출하 삭제할 정보 조회
				
				var jsonStr = JSON.stringify(dataJson_order2);
				
				var newArr = doAjax3(jsonStr);
				resultArr = resultArr.concat(newArr);
			
			}
			
			var params = new Object();
			
			params.param  = jArray;
			params.param2 = resultArr;
			
			
			obj.deleteInfo2 = params;
			
			
			var jsonObj5 = JSON.stringify(obj);
			
			console.log("======obj.vehicle : 차량 정보=======");
			console.log(obj.vehicle); //차량 정보
			console.log("======obj.orders : delete 후 insert될 주문/출하정보 =======");
			console.log(obj.orders); //delete 후 insert될 주문/출하정보
			console.log("======obj.deleteInfo1 : delete 후 insert될 출하정보 =======");
			console.log(obj.deleteInfo1); //delete 후 insert될 출하정보
			console.log("======obj.deleteInfo2 : delete 후 insert될 주문/출하량 정보 =======");
			console.log(obj.deleteInfo2); //delete 후 insert될 주문/출하량 정보
			
			/* console.log("======obj.chulha : delete할때 필요한 출하정보 =======");
			console.log(obj.chulha); //delete할때 필요한 출하정보
			console.log("======obj.param : delete할때 필요한 주문정보 =======");
			console.log(obj.param); //delete할때 필요한 주문정보
			console.log("======obj.param2 : delete할때 필요한 가맹점별 출하량정보 =======");
			console.log(obj.param2); //delete할때 필요한 가맹점별 출하량정보 */
			console.log("======jsonObj : 최종적으로 넘어갈 정보 ======="); 
			console.log(jsonObj5);
			var check = confirm('수정하시겠습니까?')
			
			if(check){
			
			$.ajax({
		        type: "POST",
		        dataType: "json",
		        timeout : 7000,
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {"bomdata" : jsonObj5, "pid" : "M858S010100E102"},
		        success: function (rcvData) {
		        	if(rcvData > -1) {
		        		heneSwal.success("출하 수정을 완료했습니다");
		        		parent.fn_MainInfo_List(startDate, endDate);
			 	     	$('#chulhaModal').modal('hide');
		        	} else {
		        		heneSwal.error("출하 수정에 실패했습니다, 재고 정보를 확인하고 다시 시도해주세요");
		        	}
		        },
		        error: function(rcvData) {
	        		heneSwal.error("출하 수정에 실패했습니다, 재고정보를 확인하고 다시 시도해주세요");
		        }
		    });
			
			}
			
			else{
				
			}
		});
		
		//// 0630 서승헌
		// 주문목록에서 tr 클릭하면 해당 데이터 목록 보여주기
		$('#orderListTable tbody').on('click','td', function(){
			
			let flag = true;
			
			if($(this).children("button").hasClass("btn-minus")) flag = false;
			
			if(flag){
				
				var orderListInfo = new Object();
				var clickCustNm = $(this).closest("tr").children("td").eq(0).children('input').val();
				
				for(x in orderListObj){
					var xCustNm = orderListObj[x].paramHead.custName;
					
					if(clickCustNm == xCustNm){
						orderListInfo = orderListObj[x]; 
					}
				}
				
				var jsonStr = JSON.stringify(orderListInfo.paramHead);
				jsonStr = jsonStr.replace(/,/gi, "&");
				jsonStr = jsonStr.replace(/\"/gi, "");
				jsonStr = jsonStr.replace(/:/gi, "=");
				jsonStr = jsonStr.slice(1,-1);
				
				var location_type = $("#vehicleLocation option:selected").val();
		   		
		   		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010104.jsp"
		   				+ "?location_type=" + location_type
		   				+ "&orderbln=true" 
		   				+ "&"+jsonStr;
				var footer = '<button class="btn btn-info" data-dismiss="modal">닫기</button>';
				var title = "출하정보";
				var heneModal = new HenesysModal2(url, 'xlarge', title, footer);
				heneModal.open_modal();
			}
		});
		
		$('#orderListTable tbody tr').each(function(){
			alert($(this).hasClass("selected"));
		});
		
		function doAjax(jsonStr) {
			
			var outerArr = new Array();
			var outerObj = new Object();
			  $.ajax({
			      type: "POST",
			      dataType: "json",
			      url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			      data: {"prmtr" : jsonStr, "pid" : "M858S010100E254"},
			      //async: false,
			      success: function (data) {
			        for(var j = 0; j < data.length; j++) {
			            var ajaxData = data[j];
			            var obj = new Object();
			            
			           /*  obj.orderNo 		 = ajaxData[0];
			            obj.orderRevNo   	 = ajaxData[1];
			            obj.custName  		 = ajaxData[2];
			            obj.orderDate    	 = ajaxData[3];
			            obj.deliveryDate  	 = ajaxData[4];
			            obj.chulhaNote 		 = ajaxData[5];
			            
			            outerArr.push(obj); */
			            
			            outerObj.orderNo 		 = ajaxData[0];
			            outerObj.orderRevNo   	 = ajaxData[1];
			            outerObj.custName  		 = ajaxData[2];
			            outerObj.orderDate    	 = ajaxData[3];
			            outerObj.deliveryDate  	 = ajaxData[4];
			            outerObj.chulhaNote 	 = ajaxData[5];
			        }
			      }
			    }); 
			
			  //return outerArr;
			  return outerObj;
	    }
		
		
		function doAjax2(jsonStr) {
			
			var outerArr = new Array();
		
			  $.ajax({
			      type: "POST",
			      dataType: "json",
			      url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			      data: {"prmtr" : jsonStr, "pid" : "M858S010100E124"},
			      //async: false,
			      success: function (data) {
			        for(var j = 0; j < data.length; j++) {
			            var ajaxData2 = data[j];
			            var obj = new Object();
			            
			            obj.prodNm 		 	 = ajaxData2[0];
			            obj.prodCd 		 	 = ajaxData2[1];
			            obj.chulhaCount  	 = ajaxData2[2];
			            obj.note    	 	 = ajaxData2[3];
			            obj.prodRevNo   	 = ajaxData2[4];
			            
			            outerArr.push(obj);
			        }
			      }
			    }); 
			
			  return outerArr;
	    }
		
		
		function doAjax3(jsonStr) {
			  var outerArr = new Array();
		
			  $.ajax({
			      type: "POST",
			      dataType: "json",
			      url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			      data: {"prmtr" : jsonStr, "pid" : "M858S010100E224"},
			      async: false,
			      success: function (data) {
			        for(var j = 0; j < data.length; j++) {
			            var data3 = data[j];
			            var obj = new Object();
						obj.prod_date		 = data3[2];			            
			            obj.chulhaCount 	 = data3[3];
			            obj.prodCd   		 = data3[4];
			            obj.prodRevNo		 = data3[5];
			            obj.seqNo  		 	 = data3[6];
			            
			            outerArr.push(obj);
			        }
			      }
			    }); 
			
			  return outerArr;
	    }
		
	});
	
	function fn_minus_body(obj) {
		var trNum = $(obj).closest('tr').prevAll().length;
		
		orderListTable.row(trNum).remove().draw();
		
		keyInContainer = parseInt(keyInContainer) - 1;
		keyInContainer = keyInContainer.toString();
    }
	
	
</script>