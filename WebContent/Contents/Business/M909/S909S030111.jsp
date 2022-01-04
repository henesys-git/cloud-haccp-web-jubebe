<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
    
	String GV_CHECK_CODE="", GV_CHECK_NAME="";
	
	if(request.getParameter("check_code")== null)
		GV_CHECK_CODE="";
	else
		GV_CHECK_CODE = request.getParameter("check_code");
	
	if(request.getParameter("check_name")== null)
		GV_CHECK_NAME="";
	else
		GV_CHECK_NAME = request.getParameter("check_name");
	
	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());	
	String JSPpage = jspPageName.GetJSP_FileName();
	
	
%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S030100E111 = {
			PID: "M909S030100E111",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S030100E111",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var groupCodeGubun = "";
	
	
	function SaveOderInfo() {

		var WebSockData="";
		
		if ($('#txt_mid_Code_Name').val().length < 1) {
			alert("중분류 명을 입력하세요.");
			return;
		}
		
   		var dataJson = new Object(); // jSON Object 선언 
   		
   			dataJson.member_key = "<%=member_key%>";
            dataJson.Check_big = "<%=GV_CHECK_CODE %>";
            dataJson.Check_big_name = "<%=GV_CHECK_NAME %>";
            dataJson.Check_mid_name = $('#txt_mid_Code_Name').val();

            
            $.ajax({
     	         type: "POST",
     	         url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030124.jsp", 
     	         data:  "Page=<%=JSPpage%>"+"&Check_mid_name=" + $('#txt_mid_Code_Name').val() + "&Check_big=" + "<%=GV_CHECK_CODE %>",	         
     	         success: function (html) {
     	        	 if(html > 0) {
     	        		 	alert("이미 등록되어 있습니다.");
     	        		 	return;
     	        		 } else {
     	        			var chekrtn = confirm("등록하시겠습니까?"); 
     	        			
     	        			if(chekrtn){
								SendTojsp(JSON.stringify(dataJson),SQL_Param.PID);	
     	        			}
     	        		 }          	        		      			 
     	         }
     	     });    
            
//             SendTojsp(JSON.stringify(dataJson), SQL_Param.PID);
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
	        		 heneSwal.success('등록에 성공하였습니다.');
	        		/* parent.$("#insert").trigger('click'); */
	        		parent.$('#modalReport2').modal('hide');
	         		
	         	}
	         },
	         error: function (xhr, option, error) {
	        	 heneSwal.error('등록에 실패하였습니다. 다시 시도해 주세요.');
	         }
	     });	 
	    
	}
	
    
    $(document).ready(function () {

		$("#txt_StartDate1").datepicker({
			format: 'yyyy-mm-dd',
			autoclose: true,
			language: 'ko'
		});  			
		$("#dateDelevery1").datepicker({
			format: 'yyyy-mm-dd',
			autoclose: true,
			language: 'ko'
		});  

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
        $('#txt_StartDate1').datepicker('update', fromday);
        
    });


   

    </script>
</head>
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">

        <tr style="background-color: #fff; height: 40px">
            <td>대분류 명</td>
            <td> </td>
            <td >
            <input type="hidden" class="form-control" id="txt_Big_Code_Cd" style="width: 200px; float:left" readonly />
            <input type="text" class="form-control" id="txt_Big_Code_Name" value="<%=GV_CHECK_NAME %>" style="width: 200px; float:left" readonly="readonly" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>중분류 명</td>
            <td> </td>
            <td >
            <input type="text" class="form-control" id="txt_mid_Code_Name" style="width: 200px; float:left"  />
           	</td>
        </tr>
        
        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save2"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc2"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport2').modal('hide'); ">취소</button>
                </p>
            </td>
        </tr>
    </table>
<!-- </form>     -->
</body>
</html>