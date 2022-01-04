<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
%>        
    <script type="text/javascript">
	
	function SaveOderInfo() {
		if ($('#txt_storage_no').val().length < 1) {
			alert("창고번호를 입력하세요.");
			return;
		}
		
		var WebSockData="";
   		var dataJson = new Object(); // jSON Object 선언 
   			dataJson.member_key = "<%=member_key%>";
			dataJson.storage_no = $('#txt_storage_no').val();
			dataJson.rake_no = $('#txt_rake_no').val();
			dataJson.plate_no = $('#txt_plate_no').val();
			dataJson.col_no = $('#txt_col_no').val();
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn){
				
// 				SendTojsp(urlencode(params),"M909S112100E101");
				SendTojsp(JSON.stringify(dataJson), "M909S112100E101"); // 보내는 데이터묶음 하나일때 => Object하나만
			}
	}
	
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('창고정보 등록에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else{
	        		heneSwal.error('창고정보 등록에 성공하였습니다.');
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
     
    $(document).ready(function () {

        $("#txt_StartDate").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });        

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
//        $('#txt_StartDate').datepicker('update', fromday);
        
    });

    </script>
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        <tr style="background-color: #fff; height: 40px">
            <td>창고번호</td>
            <td> </td>
            <td>
            	<input type="text" class="form-control" id="txt_storage_no" style="width: 200px; float:left"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>렉수/창고당</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_rake_no" style="width: 200px; float:left"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>선반수/렉당</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_plate_no" style="width: 200px; float:left"  />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>칸수/선반당</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_col_no" style="width: 200px; float:left"  />
           	</td>
        </tr>
        
        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>
    </table>
