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
	Vector VehicleRevNo = null;
	Vector VehicleVector = CommonData.getVehicleType();
	
%>

<script>
	
	$(document).ready(function () {
		
		$('#btn_Save').click(function() {
			insertVehicleInfo();
			
		});
		
		function insertVehicleInfo() {
			
			if($('#vehicle_cd').val() == '') {
	    		heneSwal.warning('차량코드를 입력하세요');
	    		return false;
	    	}
			
			if($('#vehicle_nm').val() == '') {
	    		heneSwal.warning('차량명을 입력하세요');
	    		return false;
	    	}
			
	   		var dataJson = new Object();
	  		
	   		dataJson.member_key = "<%=member_key%>";
			
			dataJson.vehicle_cd = $("#vehicle_cd").val();
			dataJson.vehicle_rev_no = 0;
			dataJson.vehicle_nm = $("#vehicle_nm").val();
			dataJson.vehicle_model = $("#vehicle_model").val();
			dataJson.vehicle_maker = $("#vehicle_maker").val();
			dataJson.vehicle_type = $("#vehicle_type option:selected").val();
			dataJson.vehicle_bigo = $("#vehicle_bigo").val();
			
			dataJson.user_id ="<%=loginID%>";
			
			var JSONparam = JSON.stringify(dataJson);
			var confirmed = confirm("등록하시겠습니까?"); 
				
			if(confirmed){
				
				SendTojsp(JSONparam, "M909S115100E121");
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
			        		heneSwal.success('차량정보가 등록 되었습니다');
			                $('#modalReport').modal('hide');
			                parent.fn_MainInfo_List();
			                parent.fn_DetailInfo_List();
			         	} else {
			         		heneSwal.error('차량정보 등록에 실패했습니다. 정보를 다시 확인해 주세요');
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
			<input type = "text" class ="form-control" id ="vehicle_cd" />
		</td>
	</tr>
	
	<tr>
		<td>
			차량명
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_nm" />
		</td>
	</tr>
	
	<tr>
		<td>
			차량모델
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_model" />
		</td>
	</tr>
	
	<tr>
		<td>
			차량 제조사
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_maker" />
		</td>
	</tr>
	
	<tr>
		<td>
			차량타입
		</td>
		<td></td>
		<td>
			<select class="form-control" id="vehicle_type">
				<option value = "승용차">승용차</option>
		    	<option value = "트럭">트럭</option>
		    	<option value = "기타">기타</option>
			</select>
		</td>
	</tr>
	
	<tr>
		<td>
			비고
		</td>
		<td></td>
		<td>
			<input type = "text" class ="form-control" id ="vehicle_bigo" />
		</td>
	</tr>
     
 </table>