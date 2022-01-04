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
	
	String driver_id = "", driver_nm = "",
		   location_gubun2 = "", vehicle_cd = "";
	
	if(request.getParameter("driver_id") != null)
		driver_id = request.getParameter("driver_id");
	
	if(request.getParameter("driver_nm") != null)
		driver_nm = request.getParameter("driver_nm");
	
	if(request.getParameter("location_gubun2") != null)
		location_gubun2 = request.getParameter("location_gubun2");
	
	if(request.getParameter("vehicle_cd") != null)
		vehicle_cd = request.getParameter("vehicle_cd");
	
	
    Vector DriverCode = null;
    Vector DriverName = null;
	Vector DriverVector = CommonData.getVehicleDriver();
	
	Vector LocationCode = null;
	Vector LocationName = null;
	Vector LocationVector = CommonData.getDeliverLocation();
	
	Vector VehicleCode = null;
	Vector VehicleName = null;
	Vector VehicleVector = CommonData.getVehicleType();
	
%>

<script>
	
	$(document).ready(function () {
		
		console.log('<%=location_gubun2%>');
		console.log('<%=(Vector)LocationVector.get(1)%>');
		console.log('<%=(Vector)LocationVector.get(0)%>');
		
		$("#select_Driver").attr('disabled', true);
		
		$("#select_Driver").val('<%=driver_id%>').prop("selected", true);
		$("#select_Location2").val('<%=location_gubun2%>').prop("selected", true);
		$("#select_Vehicle").val('<%=vehicle_cd%>').prop("selected", true);
		
		$('#btnUpdate').click(function() {
			UpdateDriverInfo();
			
		});
		
		function UpdateDriverInfo() {
			
	   		var dataJson = new Object();
	  		
	   		dataJson.member_key = "<%=member_key%>";
			
			dataJson.driver_id   = $("#select_Driver option:selected").val();
			dataJson.location_cd = $("#select_Location2 option:selected").val();
			dataJson.vehicle_cd = $("#select_Vehicle option:selected").val();
			dataJson.user_id ="<%=loginID%>";
			
			console.log(dataJson.location_cd);
			console.log(dataJson.vehicle_cd);
			
			var JSONparam = JSON.stringify(dataJson);
			var confirmed = confirm("수정하시겠습니까?"); 
				
			if(confirmed){
				
				SendTojsp(JSONparam, "M909S115100E102");
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
			        		heneSwal.success('배송기사 정보가 수정 되었습니다');
			                $('#modalReport').modal('hide');
			                parent.fn_MainInfo_List();
			                parent.fn_DetailInfo_List();
			         	} else {
			         		heneSwal.error('배송기사 정보 수정에 실패했습니다. 정보를 다시 확인해 주세요');
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
			배송기사명
		</td>
        <td></td>
        <td>
        	<select class="form-control" id="select_Driver">
				<% DriverCode = (Vector)DriverVector.get(0);%>
				<% DriverName = (Vector)DriverVector.get(1);%>
				<% for(int i=0; i<DriverName.size();i++){ %>
					<option value='<%=DriverCode.get(i).toString()%>'>
					<%=DriverName.get(i).toString()%>
					</option>
				<% } %>
			</select>
    	</td>
    </tr>

	<tr>
		<td>
			배송지역
		</td>
		<td></td>
		<td>
			<select class="form-control" id="select_Location2">
				<% LocationCode = (Vector)LocationVector.get(1);%>
				<% LocationName = (Vector)LocationVector.get(2);%>
				<% for(int i=0; i<LocationName.size();i++){ %>
					<option value='<%=LocationCode.get(i).toString()%>'>
					<%=LocationName.get(i).toString()%>
					</option>
				<% } %>
			</select>
		</td>
	</tr>
     
	<tr>
		<td>
			차랑명
		</td>
        <td></td>
        <td>
			<select class="form-control" id="select_Vehicle">
		    	<% VehicleCode = (Vector)VehicleVector.get(0);%>
		    	<% VehicleName = (Vector)VehicleVector.get(1);%>
		        <% for(int i=0; i<VehicleName.size();i++){ %>
					<option value='<%=VehicleCode.get(i).toString()%>'>
						<%=VehicleName.get(i).toString()%>
					</option>
				<% } %>
			</select>
		</td>
	</tr>
 </table>