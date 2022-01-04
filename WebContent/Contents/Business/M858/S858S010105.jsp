﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
//출하삭제(used in wonwoo)

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_CHULHA_NO = "", GV_CHULHA_REV_NO = "",
		   GV_CHULHA_DATE = "", GV_DRIVER = "", GV_DRIVER_ID = "", 
		   GV_VEHICLE_CD = "", GV_VEHICLE_REV_NO = "", GV_VEHICLE_NM = "", 
		   GV_LOCATION_TYPE = "", GV_LOCATION_TYPE_NM = "";
	
	
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
	
	if(request.getParameter("driver") == null)
		GV_DRIVER = "";
	else
		GV_DRIVER = request.getParameter("driver");
	
	if(request.getParameter("driver_id") == null)
		GV_DRIVER_ID = "";
	else
		GV_DRIVER_ID = request.getParameter("driver_id");
	
	if(request.getParameter("location_type") == null)
		GV_LOCATION_TYPE = "";
	else
		GV_LOCATION_TYPE = request.getParameter("location_type");
	
	if(request.getParameter("location_type_nm") == null)
		GV_LOCATION_TYPE_NM = "";
	else
		GV_LOCATION_TYPE_NM = request.getParameter("location_type_nm");
	
	if(request.getParameter("vehicle_rev_no") == null)
		GV_VEHICLE_REV_NO = "";
	else
		GV_VEHICLE_REV_NO = request.getParameter("vehicle_rev_no");
	
	
		// 배송차량 목록
		String initVehicleTypeCode = "";
		Vector vehicleTypeCode = null;
	    Vector vehicleTypeName = null;
	    Vector vehicleTypeList = CommonData.getVehicleType();
	    
	 	// 배송지역 목록
	    String initVehicleLocationCode = "";
		Vector vehicleLocationCode = null;
	    Vector vehicleLocationName = null;
	    Vector vehicleLocationList = CommonData.getDeliverLocation();

	    JSONObject jArray = new JSONObject();
		jArray.put("chulha_no", GV_CHULHA_NO);
		jArray.put("chulha_date", GV_CHULHA_DATE);
		jArray.put("location_type", GV_LOCATION_TYPE);
		jArray.put("location_nm", GV_LOCATION_TYPE_NM);
	    
	    DoyosaeTableModel table = new DoyosaeTableModel("M858S010100E224", jArray); //가맹점별 출하량 상세정보 조회
	    DoyosaeTableModel table2 = new DoyosaeTableModel("M858S010100E234", jArray); //가맹점 상세정보 조회
	    DoyosaeTableModel table3 = new DoyosaeTableModel("M858S010100E264", jArray); //P박스 출고량 조회
		
	    VectorToJson vtj = new VectorToJson();
	    
	    String data1 = vtj.vectorToJson(table.getVector());
	    String data2 = vtj.vectorToJson(table2.getVector());
	    String data3 = vtj.vectorToJson(table3.getVector());
%>


<script>
    var orderTable;
    var chulhaTable;
	var rowIdx = 0;
	var data1 = <%=data1%>;
	var data2 = <%=data2%>;
	var data3 = <%=data3%>;
	
    $(document).ready(function () {
    	
    	setTimeout(function(){
    	
    	console.log(data3[0][0]);
    	
    	$("#location_nm").val('<%=GV_LOCATION_TYPE%>').prop("selected", true); 
	    $("#vehicle_cd").val('<%=GV_VEHICLE_CD%>').prop("selected", true); 
    		
    	$('#chulha_date').val('<%=GV_CHULHA_DATE%>');
    	$('#chulha_no').val('<%=GV_CHULHA_NO%>');
    	$('#chulha_rev_no').val('<%=GV_CHULHA_REV_NO%>');
    	$('#driver_nm').val('<%=GV_DRIVER%>');
    	
    	$('#orderDate').attr('disabled', true);
    	$('#custName').attr('disabled', true);
    	$('#deliveryDate').attr('disabled', true);
    	$('#orderNote').attr('disabled', true);
    	$('#chulhaNote').attr('disabled', true);
    	$('#location_nm').attr('disabled', true);
    	$('#vehicle_cd').attr('disabled', true);
		
		// 출하 상세정보를 불러온다.
		let jsonObj3 = new Object();
		var outerArr = new Array();
		
		for(var k = 0; k < data2.length; k++){
			
			jsonObj3.chulha_no 	= '<%=GV_CHULHA_NO%>';
			jsonObj3.location_type 	= '<%=GV_LOCATION_TYPE%>';
			jsonObj3.order_no 	= data2[k][0];
			jsonObj3.order_rev_no 	=  data2[k][1];
			
			let jsonStr3 = JSON.stringify(jsonObj3);
			
			$.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
				data: {"prmtr" : jsonStr3, "pid" : "M858S010100E244"},
				async: false,
		        success: function (data) {
		        
		        var obj = new Object();
		        	
		        outerArr.push(obj);
		        generate_table(data);
		        
		        }	
		    });	
		}
		
      }, 300);
    	
    	
    });
    
	function SaveChulhaInfo() {
        
		var orderInfo = data2.length;
		
        var dataJsonHead = new Object();
		
		dataJsonHead.chulha_no = '<%=GV_CHULHA_NO%>';
		dataJsonHead.chulha_rev_no = '<%=GV_CHULHA_REV_NO%>';
		dataJsonHead.chulha_date= '<%=GV_CHULHA_DATE%>';
		dataJsonHead.location_type= '<%=GV_LOCATION_TYPE%>';
		dataJsonHead.location_type_nm =  '<%=GV_LOCATION_TYPE_NM%>';
		dataJsonHead.vehicle_cd= '<%=GV_VEHICLE_CD%>';
		dataJsonHead.vehicle_rev_no= '<%=GV_VEHICLE_REV_NO%>';
		dataJsonHead.vehicle_driver= '<%=GV_DRIVER_ID%>';
		dataJsonHead.pBoxCount= parseInt(data3[0][0]);
		
        
	
		
		var jArray = new Array();
		var resultArr = new Array();
		
        for(var i = 0; i < orderInfo; i++) {
        	
        	var orderNo = data2[i][0];
        	var orderRevNo = data2[i][1];
        	
    		
    		var dataJson = new Object();
    		
    		dataJson.order_no = orderNo;
			dataJson.order_rev_no = orderRevNo;
			
			
			jArray.push(dataJson);
			
			var dataJson2 = new Object();
			var dataJson3 = new Object();
			
			dataJson2.chulha_no = '<%=GV_CHULHA_NO%>';
			dataJson2.location_type 	= '<%=GV_LOCATION_TYPE%>';
			dataJson2.order_no = orderNo // 주문번호로 출하 삭제할 정보 조회
			var jsonStr = JSON.stringify(dataJson2);
			
			var newArr = doAjax(jsonStr);
			resultArr = resultArr.concat(newArr);
			
        }
		
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
 		dataJsonMulti.param = jArray;
 		dataJsonMulti.param2 = resultArr;

		var JSONparam = JSON.stringify(dataJsonMulti); 
		
		var confirmVal = confirm("해당 출하번호의 정보들을 모두 삭제하시겠습니까?");
		
		if(confirmVal) {
			SendTojsp(JSONparam, "M858S010100E103");
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
	        		heneSwal.success("출하정보 삭제를 완료했습니다");
		 	     	$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	        	} else {
	        		heneSwal.error("출하정보 삭제에 실패했습니다, 다시 시도해주세요");
	        	}
	        },
	        error: function(rcvData) {
        		heneSwal.error("출하정보 삭제에 실패했습니다, 다시 시도해주세요");
	        }
	    });
	}
    	
	   // 조회용 table load
      function generate_table(data){
    	
    	var setTable = document.getElementById('setTable');
    	
    	for(var e = 0; e < 1; e++){
    		
    		var table = document.createElement('table');
        	var tableHead = document.createElement('thead');
        	var tableBody = document.createElement('tbody');
    		let thnm = ['가맹점명','완제품명','생산일자','출하수량',];
        	
    		var label = document.createElement('label');
    		var labelText = document.createTextNode(data2[e][2]);
    		
        	
        	for(var i = 0; i <1; i++){
        		var row = document.createElement('tr');
        		
        		
            	for(var j = 0; j < 4; j++){
            	
            	var cell = document.createElement('th');
            	if(j == 2){
                cell.style = "'width:0px; display: none;'"	
                }	
            	
                var cellText = document.createTextNode(thnm[j]);
                
            	cell.appendChild(cellText);
            
            	row.appendChild(cell);
            	
            	}
            	//label.appendChild(labelText);
            	//tableHead.appendChild(label);
            	tableHead.appendChild(row);
            	
            	}
        	
        	
        	for(var i = 0; i < data.length; i++){
        	let arr = data[i];
        	var row2 = document.createElement('tr');
        	
        	for(var j = 0; j < 4; j++){
        	let arr2 = arr[j]
        	var cell2 = document.createElement('td');
        	
        	var input = document.createElement('input');	
        	
      		
        	cell2.appendChild(input);
        	row2.appendChild(cell2);
        	
        	input.value = arr2;
        	input.readOnly = true;
        	input.type = "text";
        	input.disabled = true;
        	
        	}
        	
        	tableBody.appendChild(row2);
        	
        	}
        	
        	
        	table.appendChild(tableHead);
        	table.appendChild(tableBody);
        	
        	setTable.appendChild(table);
        	table.setAttribute("border", "2");
        	table.setAttribute("class", "table");
    		table.setAttribute("id", "table" + e);
    		
    	}
    	
    }
      
    function doAjax(jsonStr) {
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
    
</script>
	

<form id = "formTest" >
	<table class="table" id="bom_table">
		<tr>
		    <td>
		    	출하일자 &nbsp;
				<input type="text" data-date-format="yyyy-mm-dd" id="chulha_date" class="form-control" style = "width:100%;" readonly>
			</td>
			<td>
		    	출하번호 &nbsp;
				<input type="text" id="chulha_no" class="form-control" style = "width:100%;" readonly>
			</td>
			<td>
		    	배송지역 &nbsp;
				<select required="required" class="form-control" id="location_nm" readonly>
			        	<% vehicleLocationCode = (Vector) vehicleLocationList.get(1);%>
			            <% vehicleLocationName = (Vector) vehicleLocationList.get(2);%>
			            <% for(int i = 0; i < vehicleLocationName.size(); i++) { %>
							<option value='<%=vehicleLocationCode.get(i).toString()%>' 
								<%=initVehicleLocationCode.equals(vehicleLocationCode.get(i).toString()) ? "selected" : "" %>>
								<%=vehicleLocationName.get(i).toString()%>
							</option>
						<%} %>
					</select>
			</td>
			<td>
		    	배송차량 &nbsp;
				<select required="required" class="form-control" id="vehicle_cd" readonly>
			        	<% vehicleTypeCode = (Vector) vehicleTypeList.get(0);%>
			            <% vehicleTypeName = (Vector) vehicleTypeList.get(1);%>
			            <% for(int i = 0; i < vehicleTypeName.size(); i++) { %>
							<option value='<%=vehicleTypeCode.get(i).toString()%>' 
								<%=initVehicleTypeCode.equals(vehicleTypeCode.get(i).toString()) ? "selected" : "" %>>
								<%=vehicleTypeName.get(i).toString()%>
							</option>
						<%} %>
					</select>
			</td>
			<td>
		    	배송기사 &nbsp;
				<input type="text" id="driver_nm" class="form-control" style = "width:100%;" readonly>
						
			</td>
		</tr>
	</table>
</form>
<br>
<h3 style='text-align : center;'>출하 내역</h3>
<br>
<div id ="setTable"></div>
