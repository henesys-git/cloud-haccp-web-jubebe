<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>

<%
// 	DoyosaeTableModel TableModel;
	String zhtml = "";
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String login_name = session.getAttribute("login_name").toString();
	String GV_NUM_GUBUN,GV_ACTION_PROCESS="",GV_ACTION_LEBEL="", GV_ORDERNO="", GV_PROCESSNAME=""
			,GV_ACTIONKEY,GV_MAINKEY="" ,GV_ORDER_DETAIL_SEQ="", GV_PROCESS_GUBUN="", GV_LOTNO="";

	if(request.getParameter("Action_process")== null)
		GV_ACTION_PROCESS="";
	else
		GV_ACTION_PROCESS = request.getParameter("Action_process");
	
	if(request.getParameter("Action_lebel")== null)
		GV_ACTION_LEBEL="";
	else
		GV_ACTION_LEBEL = request.getParameter("Action_lebel");	
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");

	if(request.getParameter("Lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("Lotno");
	
	if(request.getParameter("processname")== null)
		GV_PROCESSNAME="";
	else
		GV_PROCESSNAME = request.getParameter("processname");//한글업무명
	
	if(request.getParameter("OrderDetailSeq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailSeq");
	
	if(request.getParameter("mainKey")== null)
		GV_MAINKEY="";
	else
		GV_MAINKEY = request.getParameter("mainKey");
	
	if(request.getParameter("actionKey")== null)
		GV_ACTIONKEY="";
	else
		GV_ACTIONKEY = request.getParameter("actionKey");

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");

	if(request.getParameter("process_gubun")== null)
		GV_PROCESS_GUBUN="";
	else
		GV_PROCESS_GUBUN = request.getParameter("process_gubun");
	
// 	String param = GV_ORDER_NO + "|" + GV_CUST_CODE + "|"; 

%>

    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작 TBM_MENU
	var M000S100000E101 = {
			PID: "M000S100000E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
// 			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음 
			data: []
	};  
	
	var SQL_Param = {
			PID: "M000S100000E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    
    $(document).ready(function () {
        $("#confirm_DataTo").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });  


        var today = new Date();

        $('#confirm_DataTo').datepicker('update', today);
        
        $('#txt_class_id').val('<%=GV_ACTION_PROCESS%>'); 	//현재 JSP 파일명

        $('#txt_num_prefix').val("<%=GV_NUM_GUBUN%>"); 		//var num_gubun = "채번 prefix:ODR000000001;
        $('#txt_processgubun').val('<%=GV_ACTION_LEBEL%>');  //Regist등록, Review검토, Confirm승인 중 하나
        $('#txt_userid').val('<%=loginID%>');  				//담당자id
        $('#txt_username').val('<%=login_name%>');  		//담당자 명
        $('#txt_orderno').val('<%=GV_ORDERNO%>');  			//QUEUE용 주문번호
        $('#txt_processname').val('<%=GV_PROCESSNAME%>'); 	//한글업무명
        $('#txt_orderdetailseq').val('<%=GV_ORDER_DETAIL_SEQ%>');
        $('#txt_actionKey').val("<%=GV_ACTIONKEY%>"); 		//var actionKey = "";  //inpect_no = '" + vOrderNo + "'"; 있으면 mainKey와 같은 방식으로 정의
        $('#txt_mainKey').val("<%=GV_MAINKEY%>"); 			//var mainKey = "order_no = '" + vOrderNo + "'";
 	
    });
	

	function SetRecvData(){
//     	console.log("GV_RECV_DATA=" + GV_RECV_DATA);
		DataPars(M000S100000E101,GV_RECV_DATA);
	   	parent.fn_MainInfo_List();

	   	parent.DetailInfo_List.click();
		parent.$('#modalReport').hide();
	}
	
	function SaveApprovalInfo(IndGB) {  
		var user_id = $("#txt_userid").val().toString();
        var user_pw = $("#txt_password").val().toString();

		 $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/Approval_insert_pw_check.jsp", 
	         data:  "login_id=" + user_id + "&login_pw=" + user_pw,
	         beforeSend: function () {
//	         	 alert(bomdata);  Approval_insert.jsp
	         },
	         success: function (html) {
	        	 if(html>0){
	        		 var params = ""
	     	         	+ $('#txt_class_id').val() + "|"
	                	+ $('#txt_userid').val() + "|"
	                 	+ $('#txt_num_prefix').val() + "|"
	                 	+ $('#txt_processgubun').val() + "|"
	                 	+ $('#txt_processname').val() + "|" 
	                    + $('#txt_orderno').val() + "|"
	                    + $('#txt_orderdetailseq').val() + "|"
	                    + $('#txt_mainKey').val() + "|"
	             		+ $('#txt_actionKey').val() + "|"
	     				+ IndGB + "|"			//반려 , 검토/승인
	     	            + '<%=GV_PROCESS_GUBUN%>' + "|"  
	     	            + '<%=GV_LOTNO%>' + "|"
	     	            + '<%=member_key%>';			
	     	            
	     	         SendTojsp(urlencode(params), SQL_Param.PID);
	         	} else {
	         		alert("비밀번호가 틀립니다.");
	         		return false;
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });	
	}  
	

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
	        		parent.fn_MainInfo_List();
	        		 vOrderNo = "";  
	        		 vOrderDetailSeq = "";
	        		DetailInfo_List.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	} 
	
	
    
    </script>

	<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">        
        
        <tr style="height: 40px; vertical-align: middle">
            <td style="width: 25%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">처리프로세스</td>
            <td style="width: 75%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
				<input type="hidden" 	class="form-control"  id=txt_orderno 		style="width: 150px" readonly></input>
				<input type="hidden" 	class="form-control"  id=txt_orderdetailseq	style="width: 150px" readonly></input>
				<input type="hidden" 	class="form-control"  id=txt_mainKey 		style="width: 150px" readonly></input>
				<input type="hidden" 	class="form-control"  id=txt_actionKey 		style="width: 150px" readonly></input>
				<input type="hidden" 	class="form-control"  id=txt_num_prefix 		style="width: 150px" readonly></input>
				<input type="hidden" 	class="form-control"  id=txt_class_id 		style="width: 150px" readonly></input>
				<input type="text" 	class="form-control"  id=txt_processname 	 readonly></input>
           	</td>
        </tr>
        <tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">처리구분</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
            	<input type="text" class="form-control"  id="txt_processgubun" readonly style="width: 150px; border: solid 1px #cccccc;"/>
            </td>
        </tr>
		<tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">처리일자</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
            	<input type="text" data-date-format="yyyy-mm-dd" id="confirm_DataTo" class="form-control" style="width: 110px; border: solid 1px #cccccc;" />
            </td>
        </tr>
        <tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">처리담당자</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
				<input type="text" class="form-control" id="txt_userid" style="width: 150px" readonly></input>
				<input type="hidden" class="form-control" id="txt_username" style="width: 150px" readonly></input>
           	</td>
        </tr> 
         
        <tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">비밀번호</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
				<input type="password" class="form-control" id="txt_password" style="width: 150px"></input>
           	</td>
        </tr> 
        <tr style="height: 40px; vertical-align: middle">
            <td colspan="2" style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle" >
            <p>
            	<button id="btn_saVE"  class="btn btn-info" style="width: 100px;" onclick="SaveApprovalInfo(0);">확인</button>
            	<button id="btn_saVE"  class="btn btn-info" style="width: 100px; margin-left:10px;" onclick="SaveApprovalInfo(1);">반려</button>
                <button id="btn_Canc"  class="btn btn-info" style="width: 100px; margin-left:10px;" onclick="parent.$('#modalReport').hide();">취소</button>
            </p>
            </td>
        </tr>  
    </table>
