<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html>
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String login_name = session.getAttribute("login_name").toString();

    Vector optCode =  null;
    Vector optRevNo =  null;
    Vector optName =  null;
	Vector UserVector = CommonData.getUserID(member_key); 
	
	String GV_USER_ID="", GV_REVISION_NO="";

	if(request.getParameter("user_id") != null)
		GV_USER_ID = request.getParameter("user_id");
	
	if(request.getParameter("RevisionNo") != null)
		GV_REVISION_NO = request.getParameter("RevisionNo");

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("user_id", loginID);
		
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S080100E404", jArray);
	
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(TableModel.getVector());
	
    //Vector targetVector = (Vector)(TableModel.getVector().get(0));
%>
 
	<!-- Theme style -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/css/adminlte.min.css">
	
	<!-- Daterange picker -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.css">
	<!-- summernote -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/summernote/summernote-bs4.css">
	
	<!-- Henesys Icon -->
	<link rel="shotcut icon" type="image/x-icon" href="<%=Config.this_SERVER_path%>/images/henesys.jpg"/>
	<!-- SweetAlert2 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.css">
	<!-- SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.js"></script>
	<!-- Customized SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/js/sweetalert.custom.js"></script>
	
 	<!-- DataTables -->
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/css/select.bootstrap4.min.css">
    
  	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/css/select2.min.css">
  	<!-- Henesys CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/css/henesys.css">
  	
 	<!-- jQuery -->
 	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.js"></script>
 	<!-- Canvas 공통함수 부분 -->
	<script src="<%=Config.this_SERVER_path%>/js/canvas.comm.func.js"></script>
  	
	<!-- DataTables -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables/jquery.dataTables.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/js/dataTables.select.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
	
	<!-- For DataTables Default Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/datatables.custom.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.7/js/select2.min.js"></script>
	
	<!-- daterangepicker -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/moment/moment.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.js"></script>
	
	<!-- Henedate -->
	<script src="<%=Config.this_SERVER_path%>/js/setdate.js"></script> 
       
<script>
	
	// sweetalert 객체 생성
	let heneSwal = new SweetAlert();		
			
	function SaveOderInfo() {
		var data = <%=data%>;
		
		var kakao_user1 = $('#kakao_user1 option:selected').val();
		var kakao_user2 = $('#kakao_user2 option:selected').val();
		var kakao_user3 = $('#kakao_user3 option:selected').val();
		
		var kakao_rev_no1 = $('#kakao_user1 option:selected').attr('value2');
		var kakao_rev_no2 = $('#kakao_user2 option:selected').attr('value2');
		var kakao_rev_no3 = $('#kakao_user3 option:selected').attr('value2');
		
		if(kakao_user1 == ''){
			
			heneSwal.warning("수신자1의 정보는 필수입니다. 선택해주세요.");
			return;
			
		}
		
		if(kakao_user2 == '' && kakao_user3 != ''){
			
			heneSwal.warning("수신자2의 정보를 먼저 선택해주세요.");
			return;
			
		}
		
		if ((kakao_user1 == kakao_user2 || kakao_user1 == kakao_user3 || kakao_user2 == kakao_user3)  
				&& (kakao_user2 != '' || kakao_user3 != '') ) 
		{
			heneSwal.warning("같은 사용자를 중복하여 선택할 수 없습니다.");
			return;
		}

   		var dataJson = new Object();
   		var jArray = new Array();
   		
   		var dataJson2 = new Object();
   		var dataJson3 = new Object();
   		var dataJson4 = new Object();
		
   		var params = new Object();   		
   		//var value1 = document.getElementById("kakao_user" +(i));
   		//var kakao_user 	 = value1.options[value1.selectedIndex].value;
   		//var kakao_rev_no = value1.options[value1.selectedIndex].value2;
   		
   		dataJson2.kakao_user_id = kakao_user1;
   		dataJson2.user_rev_no   = kakao_rev_no1;
   		dataJson2.order_index   = "1";
   		
   		jArray.push(dataJson2);
   		
   		
   		if(kakao_user2 != ''){
   		
   			dataJson3.kakao_user_id = kakao_user2;
   	   		dataJson3.user_rev_no   = kakao_rev_no2;
   	   		dataJson3.order_index   = "2";
   	   	
   	 		jArray.push(dataJson3);
   	 	
   		}
   		
   		
   		if(kakao_user3 != ''){
   	   		
   	   		dataJson4.kakao_user_id = kakao_user3;
   	   	   	dataJson4.user_rev_no   = kakao_rev_no3;
   	   	   	dataJson4.order_index   = "3";
   	   	   	
   	   	 	jArray.push(dataJson4);
   	   	 	
   	   	}

   		
   		params.param = jArray;
   		
   		dataJson.params = params;
   		dataJson.member_key = "<%=member_key%>";
	    dataJson.user_id = "<%=loginID%>";
	    
	    console.log(dataJson);
		var chekrtn = confirm("현재 정보로 알람 사용자를 수정하시겠습니까?"); 
		
		if(chekrtn){		
	        SendTojsp(JSON.stringify(dataJson), "M909S080100E030");
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html> 0){
	                parent.$("#ReportNote").children().remove();
	                heneSwal.successTimer('정보가 수정 되었습니다.');
	                
	                setTimeout(function(){window.close();}, 500);
	         	}
	        	 else{
	        		 heneSwal.error('정보 수정에 실패하였습니다. 다시 시도해주세요.');
	        	 }
	         },
	         error: function (xhr, option, error) {
	        	 heneSwal.error('정보 수정에 실패하였습니다. 다시 시도해주세요.');
	         }
	     });		
	}
	
    
    $(document).ready(function () {
		
    	var data = <%=data%>;
    	
    	$("#kakao_user2").prepend("<option value = '' value2 = ''>사용자 없음</option>");
    	$("#kakao_user3").prepend("<option value = '' value2 = ''>사용자 없음</option>");
    	
    	$("#kakao_user1 > option:eq(0)").prop("selected",true);
    	$("#kakao_user2 > option:eq(0)").prop("selected",true);
    	$("#kakao_user3 > option:eq(0)").prop("selected",true);
    	
    	$("#kakao_user1").val(data[0][0]).prop("selected", true);
    	$("#kakao_user2").val(data[1][0]).prop("selected", true);
    	$("#kakao_user3").val(data[2][0]).prop("selected", true);
    	
	 	
    });
    </script>
</head>

<section class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<div class="card card-info">
                    <div class="card-header"> 
                     <h3 class="card-title">카카오톡 알람 수신자 정보 수정</h3>
                    </div> <!-- card-header -->
                    <div class="card-body">
   
   <table class="table table-hover">
        
        <tr>
            <td>수신자 1</td>
            <td>
            	<select class="form-control" id="kakao_user1">
	                   <% optCode = (Vector)UserVector.get(0);%>
	                   <% optRevNo = (Vector)UserVector.get(1);%>
	                   <% optName = (Vector)UserVector.get(2);%>
	                   <%for(int i=0; i<optName.size();i++) { %>
							<option value='<%=optCode.get(i).toString()%>' 
							value2 = '<%=optRevNo.get(i).toString()%>'>
							<%=optName.get(i).toString()%>
							</option>
							<%} %>
				</select>
           	</td>
        </tr>
        
        <tr>
            <td>수신자 2</td>
            <td>
            	<select class="form-control" id="kakao_user2">
	                   <% optCode = (Vector)UserVector.get(0);%>
	                   <% optRevNo = (Vector)UserVector.get(1);%>
	                   <% optName = (Vector)UserVector.get(2);%>
	                   <%for(int i=0; i<optName.size();i++) { %>
							<option value='<%=optCode.get(i).toString()%>'
							value2 = '<%=optRevNo.get(i).toString()%>'>
							<%=optName.get(i).toString()%>
							</option>
							<%} %>
				</select>
           	</td>
        </tr>
        
        <tr>
            <td>수신자 3</td>
            <td>
            	<select class="form-control" id="kakao_user3">
	                   <% optCode = (Vector)UserVector.get(0);%>
	                   <% optRevNo = (Vector)UserVector.get(1);%>
	                   <% optName = (Vector)UserVector.get(2);%>
	                   <%for(int i=0; i<optName.size();i++) { %>
							<option value='<%=optCode.get(i).toString()%>'
							value2 = '<%=optRevNo.get(i).toString()%>'>
							<%=optName.get(i).toString()%>
							</option>
							<%} %>
				</select>
           	</td>
        </tr>
        <tr>
          	<td colspan = 2>
              		<p style = "margin: 0 40%;">
	              		<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>
	                    <button id="btn_Canc" class="btn btn-info" onclick="window.close();">취소</button>
              		</p>
          		</td>
      		</tr>
  		</table>
 					</div> <!-- card-body  -->
				</div> <!-- card card-info -->
			</div> <!-- col-md-6 -->
		</div> <!-- row -->
	</div> <!-- container-fluid -->
</section> <!-- content -->