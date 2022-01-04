<%@page import="java.io.FileReader"%>
<%@page import="org.json.simple.parser.JSONParser"%>
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
	
	
	Vector VehicleCode = null;
	Vector VehicleName = null;
	Vector VehicleVector = CommonData.getVehicleType();
	
%>

<script>
	
	$(document).ready(function () {
		
		var vehicle_cd2 = $('#vehicle_cd option:selected').val();
	   	
	   	var dataJson2 = new Object();
	   	dataJson2.vehicle_cd = vehicle_cd2;
	   	var jsonStr2 = JSON.stringify(dataJson2);
		
		
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
			data: {"prmtr" : jsonStr2, "pid" : "M909S115100E154"},
	        success: function (data) {
			
	        $("#vehicle_cd").val(data[0][0]).prop("selected", true); //차량코드
	        $("#vehicle_rev_no").val(data[0][1]); //차량수정이력
	        $("#vehicle_nm").val(data[0][2]); 	  //차량명
	        $("#vehicle_model").val(data[0][3]);  //차량모델
	        $("#vehicle_maker").val(data[0][4]);  //차량제조사
	        $("#vehicle_type").val(data[0][5]);   //차량타입
	        $("#vehicle_bigo").val(data[0][6]);   //차량제조사
	        
	        }
	      });
		
		
		
		$('#vehicle_cd').on('change', function(){
		   	var vehicle_cd = $(this).val();
		   	
		   	var dataJson = new Object();
		   	dataJson.vehicle_cd = vehicle_cd;
		   	var jsonStr = JSON.stringify(dataJson);
		   	
		   	$.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
				data: {"prmtr" : jsonStr, "pid" : "M909S115100E154"},
		        success: function (data) {
				
		        $("#vehicle_cd").val(data[0][0]).prop("selected", true); //차량코드
		        $("#vehicle_rev_no").val(data[0][1]); //차량수정이력
		        $("#vehicle_nm").val(data[0][2]); 	  //차량명
		        $("#vehicle_model").val(data[0][3]);  //차량모델
		        $("#vehicle_maker").val(data[0][4]);  //차량제조사
		        $("#vehicle_type").val(data[0][5]);   //차량타입
		        $("#vehicle_bigo").val(data[0][6]);   //차량제조사
		        
		        }
		      });
		   	
		   	
		   	});
		
		
		$("#vehicle_type").attr('disabled', true);
		
		$('#btnUpdate').click(function() {
			deleteVehicleInfo();
			
		});
		
		function deleteVehicleInfo() {
			
	   		var dataJson = new Object();
	  		
	   		dataJson.member_key = "<%=member_key%>";
			
	   		dataJson.vehicle_cd = $("#vehicle_cd").val();
			dataJson.vehicle_rev_no = $("#vehicle_rev_no").val();
			
			var JSONparam = JSON.stringify(dataJson);
			var confirmed = confirm("삭제하시겠습니까?"); 
				
			if(confirmed){
				
				SendTojsp(JSONparam, "M909S115100E123");
			} else {
				return false;
			}
			
			function SendTojsp(bomdata, pid){
				$.ajax({
			         type: "POST",
			         dataType: "json",
			         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			         data:  {"bomdata" : bomdata, "pid" : pid},
			         success: function (html) {
			        	 if(html > -1) {
			        		heneSwal.success('차량정보가 삭제 되었습니다');
			                $('#modalReport').modal('hide');
			                parent.fn_MainInfo_List();
			                parent.fn_DetailInfo_List();
			         	} else {
			         		heneSwal.error('차량정보 삭제에 실패했습니다. 정보를 다시 확인해 주세요');
			         	}
			         }
				});
			}
		}
	    
	 	
	});

</script>
   
<table class="table table-hover">
	<tr>
		<td>
			차량코드
		</td>
		<td></td>
		<td>
			<select class="form-control" id="vehicle_cd">
		    	<% VehicleCode = (Vector)VehicleVector.get(0);%>
		    	<% VehicleName = (Vector)VehicleVector.get(1);%>
		        <% for(int i=0; i<VehicleName.size();i++){ %>
					<option value='<%=VehicleCode.get(i).toString()%>'>
						<%=VehicleCode.get(i).toString()%>
					</option>
				<% } %>
			</select>
			<input type = "hidden" class ="form-control" id ="vehicle_rev_no" readonly />
		</td>
	</tr>
	
	<tr>
		<td>
			차량명
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_nm" readonly />
		</td>
	</tr>
	
	<tr>
		<td>
			차량모델
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_model" readonly />
		</td>
	</tr>
	
	<tr>
		<td>
			차량 제조사
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_maker" readonly/>
		</td>
	</tr>
	
	<tr>
		<td>
			차량타입
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_type" readonly/>
		</td>
	</tr>
	
	<tr>
		<td>
			비고
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_bigo" readonly />
		</td>
	</tr>
     
 </table>