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
                  <h3>3. 등록</h3>
                  <div class="center">
	                  <button class="btn btn-success btn-lg pull-right" id="saveChulhaBtn" type="submit">출하 등록</button>
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
	
	function getOrderInfo(obj) {
		/* 순서 중요 (key값이 더해지기 전에 화면에 먼저 보여준다) */
		displayReceivedOrder(obj, keyInContainer);

		orderListObj[keyInContainer] = obj;
		keyInContainer = parseInt(keyInContainer) + 1;
		keyInContainer = keyInContainer.toString();
		console.log("getOrderInfo");
		console.log(keyInContainer);
		console.log(obj);
	}
	
	function displayReceivedOrder(obj, idx) {
		orderListTable.row.add([
    		" <input type='text' class='form-control' required='required' readonly>",
			" <input type='text' class='form-control' required='required' readonly>",
    		" <input type='text' class='form-control' required='required' readonly>",
    		" <input type='text' class='form-control' readonly>",
    		" <button class='btn btn-info btn-sm btn-minus' onclick='fn_minus_body(this);'>" +
			"   <i class='fas fa-minus'></i>" +
			" </button>"
        ]).draw();
		console.log("displayReceivedOrder");
		console.log(obj);
		console.log(idx);
		
		var tr = $($("#orderListTableBody tr")[idx]).find(":input");
		tr.eq(0).val(obj.paramHead.custName);
		tr.eq(1).val(obj.paramHead.orderDate);
		tr.eq(2).val(obj.paramHead.deliveryDate);
		tr.eq(3).val(obj.paramHead.chulhaNote);
	}
	
	$(document).ready(function () {
		
		/* skip이 true이면, 다음 step으로 건너뛰기 가능 */
		var skip = false;
		/* 차량 혹은 배송기사 관리 여부 */
		var manageVehicle = true;
		
		var orderListTableInfo;
	   	var orderRowCount = 0;
		
	   	setTimeout(function() {
	   	
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
	    	console.log(keyInContainer);
	    	keyInContainer = parseInt(keyInContainer) - 1;
			keyInContainer = keyInContainer.toString();
			console.log("minus button");
			console.log(keyInContainer);
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
				vehicle.vehicleNote = $('#vehicleNote').val();	// 원우푸드 프로젝트에서는 P박스 관리용 데이터
				obj.vehicle = vehicle;
			}
			console.log(vehicle.vehicleLocationNm);
			
			const today = new Date();
			
			const year = today.getFullYear();
			const month = today.getMonth() + 1;
			const date = today.getDate();
			
			var toDate = year +'-'+ month +'-'+ date;
			console.log(year +'-'+ month +'-'+ date);
			
			var chulObj = new Object();
			
			chulObj.chulha_date = toDate;
			
			var chulhaYn = doAjaxDate(JSON.stringify(chulObj));
			
			for(var i = 0; i < chulhaYn.length; i++) {
				
				var chulhaVehicleCd = chulhaYn[i].chulha_vehicle_cd;
				console.log(chulhaYn[i].chulha_vehicle_cd);
				
				if(chulhaVehicleCd == vehicle.vehicleCd) {
					heneSwal.warning('이미 오늘 날짜로 해당 지역의 출하정보가 등록되어 있습니다. \n 출하정보 수정을 이용하세요.');
					return false;
				}
			}
			
			var jsonObj = JSON.stringify(obj);
			
			
			console.log(obj.vehicle);
			console.log(obj.orders);
			console.log(jsonObj);
			var check = confirm('등록하시겠습니까?')
			
			if(check){
			
			$.ajax({
		        type: "POST",
		        dataType: "json",
		        timeout : 7000,
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {"bomdata" : jsonObj, "pid" : "M858S010100E101"},
		        success: function (rcvData) {
		        	if(rcvData > -1) {
		        		heneSwal.success("출하 등록을 완료했습니다");
		        		parent.fn_MainInfo_List(startDate, endDate);
			 	     	$('#chulhaModal').modal('hide');
		        	} else {
		        		heneSwal.error("출하 등록 실패했습니다, 재고 정보를 다시 확인하고 시도해주세요");
		        	}
		        },
		        error: function(rcvData) {
	        		heneSwal.error("출하 등록 실패했습니다, 재고 정보를 다시 확인하고 다시 시도해주세요");
		        }
		    });
			
			}
			
			else{
				
			}
		});
		
		$('#chulhaModal').on('hidden', function() {
		    $(this).removeData('modal');
		});
		
	});
	
	function doAjaxDate(jsonStr) {
		  var outerArr = new Array();
	
		  $.ajax({
		      type: "POST",
		      dataType: "json",
		      url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
		      data: {"prmtr" : jsonStr, "pid" : "M858S010100E274"},
		      async: false,
		      success: function (data) {
		        for(var j = 0; j < data.length; j++) {
		            var data1 = data[j];
		            var obj = new Object();
		            
		            obj.chulha_vehicle_cd = data1[0];
		            
		            outerArr.push(obj);
		        }
		      }
		    }); 
		
		  return outerArr;
  }
	
	function fn_minus_body(obj) {
		var trNum = $(obj).closest('tr').prevAll().length;
		
		orderListTable.row(trNum).remove().draw();
		
		keyInContainer = parseInt(keyInContainer) - 1;
		keyInContainer = keyInContainer.toString();
    }
	
	
</script>