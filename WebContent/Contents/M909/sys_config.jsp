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
    Vector optCode =  null;
    Vector optName =  null;
    
    SysConfig sys_config = new SysConfig();
    
	String[] strColumnHead = {"", "", "", "", "",""} ;
	String param = sys_config.sys_config_key + "|";
	
    TableModel = new DoyosaeTableModel("M000S100000E204", strColumnHead, param);
%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M000S100000E201 = {
			PID: "M000S100000E201", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M000S100000E201",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var groupCodeGubun = "";
	
	
	
	function SaveOderInfo() {
		var WebSockData="";
     	var params = ""
	            + $('#server').val() + "|"
	            + $('#barcode').val() + "|"
	            + $('#camera').val() + "|"
	            + $('#humidity').val() + "|"
	            + $('#pressure').val() + "|"
	            + $('#temprature').val() + "|"
               ;

		SendTojsp(urlencode(params),SQL_Param.PID)
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
	        	 alert("저장 완료");
	        	 if(html>-1){
	        		parent.fn_MainInfo_List();
// 	        	   	parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
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
        
        $('#txt_StartDate').datepicker('update', fromday);
        
	    $("#select_CodeGroupGubun").on("change", function(){
	    	groupCodeGubun = $(this).val();
	    });
    });


    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetDocName_code(name, code){
		$('#txt_DocName').val(name);
		$('#txt_DocCode').val(code);
    }
    

    </script>
</head>
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">

     <tr>
      <td style="width:20%; text-align:right; ">sub server IP</td>
      <td style="width:30%; text-align: left"><input type="text" id="server" class="regular-checkbox" value="<%=TableModel.getValueAt(0,0).toString()%>" /></td>
      <td style="width:50%"></td>
    </tr>

    <tr>
      <td style="width:20%; text-align:right; ">barcode print IP</td>
      <td><input type="text" id="barcode" class="regular-checkbox" value="<%=TableModel.getValueAt(0,1).toString()%>"/></td>
      <td style="width:50%"></td>
    </tr>

    <tr>
      <td style="width:20%; text-align:right; ">vision camera IP</td>
      <td><input type="text" id="camera" class="regular-checkbox" value="<%=TableModel.getValueAt(0,2).toString()%>"/></td>
      <td style="width:50%"></td>
    </tr>

    <tr>
      <td style="width:20%; text-align:right; ">humidity gage IP</td>
      <td><input type="text" id="humidity" class="regular-checkbox" value="<%=TableModel.getValueAt(0,3).toString()%>"/></td>
      <td style="width:50%"></td>
    </tr>

    <tr>
      <td style="width:20%; text-align:right; ">pressure gage IP</td>
      <td><input type="text" id="pressure" class="regular-checkbox" value="<%=TableModel.getValueAt(0,4).toString()%>"/></td>
      <td style="width:50%"></td>
    </tr>
  
    <tr>
      <td style="width:20%; text-align:right; ">temprature gage IP</td>
      <td><input type="text" id="temprature" class="regular-checkbox" value="<%=TableModel.getValueAt(0,5).toString()%>"/></td>
      <td style="width:50%"></td>
    </tr>
                

        <tr style="height:60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo()">저장</button>
                </p>
            </td>
        </tr>
    </table>
<!-- </form>     -->
</body>
</html>