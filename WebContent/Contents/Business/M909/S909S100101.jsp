<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;

	String[] strColumnHead = {"메뉴ID", "메뉴명", "메뉴레벨", "정렬순서", "삭제여부", "상위메뉴" };
	
	String param = "|";
%>
 
<script type="text/javascript">
// 웹소켓 통신을 위해서 필요한 변수들 ---시작
var M909S100100E101 = {
		PID: "M909S100100E101",  
		totalcnt: 0,
		retnValue: 999,
		colcnt: 0,
		colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
		data: []
};  

var SQL_Param = {
		PID: "M909S100100E101",
		excute: "queryProcess",
		stream: "N",
		param: + "|"
};
var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
// 웹소켓 통신을 위해서 필요한 변수들 ---끝	

   var docGubunCode = "";
   var JOB_GUBUN = "";

function SetRecvData(){
	DataPars(M909S100100E101, GV_RECV_DATA);
		if(M909S100100E101.retnValue > 0)
			alert('등록 되었습니다.');
  		
  		parent.fn_MainInfo_List();
		parent.$('#modalReport').hide();
}

function SaveOderInfo() {
	if ($('#txt_MenuId').val().length < 10) {
		alert("메뉴 ID를 정확히 입력하세요.\n메뉴 ID는 10자리입니다.");
		return;
	}
	
	if ($('#txt_MenuName').val().length < 1) {
		alert("메뉴명을 입력하세요.");
		return;
	}

	var WebSockData="";
  		var dataJson = new Object();
  			dataJson.member_key = "<%=member_key%>";
		dataJson.MenuId = $('#txt_MenuId').val();
		dataJson.MenuName = $('#txt_MenuName').val();
		dataJson.MenuLevel = $('#txt_MenuLevel').val();
		dataJson.OrderIndex = $('#txt_OrderIndex').val();
		dataJson.DelYn = $('#txt_DelYn').val();
		dataJson.UpMenu = $('#txt_UpMenu').val();
		dataJson.ProgramId = $('#txt_MenuId').val() + "0.jsp";
		dataJson.user_id = "<%=loginID%>";
	var chekrtn = confirm("등록하시겠습니까?"); 
		
	if(chekrtn){	
  			SendTojsp(JSON.stringify(dataJson), SQL_Param.PID);
  		}
}

function SendTojsp(bomdata, pid) {
    $.ajax({
         type: "POST",
         dataType: "json", // Ajax로 json타입으로 보낸다.
         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
         data:  "bomdata=" + bomdata + "&pid=" + pid,
         success: function (html) {
        	 if(html>-1){
        		heneSwal.success('그룹메뉴 정보 등록에 성공하였습니다.');
        	   	parent.fn_MainInfo_List();
                parent.$("#ReportNote").children().remove();
         		parent.$('#modalReport').hide();
         	}
        	 else{
        		heneSwal.error('그룹메뉴 정보 등록에 실패하였습니다.');
        	 }
         }
     });		
}

   	function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
       	var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
               + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
   		
   		if(typeof(popupWin)=="undefine") {
   			popupWin = window.returnValue;
   		}
		
   		return popupWin;
	}  
</script>

<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	<tr style="background-color: #fff; height: 40px">
    	<td style="font-weight:900;">메뉴ID</td>
        <td></td>
        <td>
        	<input type="text" class="form-control" id="txt_MenuId" style="width: 200px; float:left" />
        </td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">메뉴명</td>
		<td></td>
		<td>
        	<input type="text" class="form-control" id="txt_MenuName" style="width: 200px; float:left"  />
        </td>
	</tr>
      
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">메뉴레벨</td>
        <td></td>
        <td>
        	<input type="text" class="form-control" id="txt_MenuLevel" style="width: 200px; float:left" 
         		value="0" readonly />
        </td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
    	<td style="font-weight:900;">정렬순서</td>
        <td></td>
        <td>
        	<input type="text" class="form-control" id="txt_OrderIndex" style="width: 200px; float:left" 
          		value="0" readonly />
        </td>
	</tr>
      
	<tr style="background-color: #fff; height: 40px">
    	<td style="font-weight:900;">삭제여부</td>
        <td></td>
        <td>
          	<input type="text" class="form-control" id="txt_DelYn" style="width: 200px; float:left" 
          		value="N" readonly />
        </td>
	</tr>
      
	<tr style="background-color: #fff; height: 40px">
   		<td style="font-weight:900;">상위메뉴</td>
        <td></td>
        <td>
        	<input type="text" class="form-control" id="txt_UpMenu" style="width: 200px; float:left"  />
        </td>
	</tr>

    <!-- <tr style="height: 60px">
          <td colspan="4" align="center">
              <p>
              	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                  <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
              </p>
          </td>
	</tr> -->
</table>