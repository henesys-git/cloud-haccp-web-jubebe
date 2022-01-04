<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);

	String[] strColumnHead = {
							  "parent_menu_id", "메뉴ID", 
							  "메뉴명", "메뉴레벨", 
							  "program_id", "정렬순서", 
							  "updatedate", "update_user", 
							  "삭제여부" 
							 };
	
	String GV_PROGRAM_ID="", JOB_GUBUN="";

	if(request.getParameter("program_id")== null)
		GV_PROGRAM_ID="";
	else
		GV_PROGRAM_ID = request.getParameter("program_id");
	
	if(request.getParameter("job_gubun")== null)
		JOB_GUBUN = "";
	else
		JOB_GUBUN = request.getParameter("job_gubun");	
	
	String param = GV_PROGRAM_ID + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "PROGRAM_ID", GV_PROGRAM_ID);
		
    TableModel = new DoyosaeTableModel("M909S100100E214", strColumnHead, jArray);
    int ColCount = TableModel.getColumnCount();
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
    String JSPpage = jspPageName.GetJSP_FileName();
    Vector targetMenuVector = (Vector)(TableModel.getVector().get(0));		
%>

<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S100100E112 = {
			PID: "M909S100100E112",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S100100E112",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var docGubunCode = "";
    var JOB_GUBUN = "";
	
	function SetRecvData(){
		DataPars(M909S100100E112,GV_RECV_DATA);
 		if(M909S100100E112.retnValue > 0)
 			alert('수정 되었습니다.');
   		
   		parent.fn_DetailInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#txt_ProgramId').val().length < 11) {
			alert("프로그램ID를 정확히 입력해 주세요.\n ex)M123S123456");
			return;
		}
		if ($('#txt_MenuName').val().length < 1) {
			alert("메뉴명을 입력하세요.");
			return;
		}
		
		var WebSockData="";
   		var dataJson = new Object(); // jSON Object 선언 
   			dataJson.member_key = "<%=member_key%>";
			dataJson.MenuId = $('#txt_MenuId').val();
			dataJson.MenuName = $('#txt_MenuName').val();
			dataJson.MenuLevel = $('#txt_MenuLevel').val();
			dataJson.OrderIndex = $('#txt_OrderIndex').val();
			dataJson.DelYn = $('#txt_DelYn').val();
			dataJson.UpMenu = $('#txt_UpMenu').val();
			dataJson.ProgramId = $('#txt_ProgramId').val();
			dataJson.user_id = "<%=loginID%>";
			
			if (JOB_GUBUN == "open") {
				params += "|" + <%=JOB_GUBUN%> + "|";
			}
		var chekrtn = confirm("수정하시겠습니까?"); 
			
		if(chekrtn){
			SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
		}
	}
 
	function SendTojsp(bomdata, pid) {
	    $.ajax({
			type: "POST",
	        dataType: "json", // Ajax로 json타입으로 보낸다.
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  "bomdata=" + bomdata + "&pid=" + pid,
	        success: function (html) {
	        	if(html > -1) {
	        		heneSwal.success('소메뉴 정보 수정에 성공하였습니다.');
	        		parent.fn_DetailInfo_List();
	        		$('#modalReport').modal('hide');
	         	}
	        	else{
	        		heneSwal.error('소메뉴 정보 수정에 실패하였습니다.');
	        	}
	        }
		});
	}
    
    $(document).ready(function () {
	    JOB_GUBUN = "<%=JOB_GUBUN%>";
    });

    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin) == "undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }
    
    function SetDocName_code(name, code){
		$('#txt_DocName').val(name);
		$('#txt_DocCode').val(code);
    }
</script>
	
<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	<tr style="background-color: #fff; height: 40px">
	    <td style="font-weight:900;">메뉴ID</td>
	    <td></td>
	    <td>
	    	<input type="text" class="form-control" id="txt_MenuId" style="width: 200px; float:left" 
	    		value="<%=targetMenuVector.get(1).toString() %>" readonly />
	   	</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
	    <td style="font-weight:900;">메뉴명</td>
	    <td></td>
	    <td>
	    	<input type="text" class="form-control" id="txt_MenuName" style="width: 200px; float:left"  
	    		   value="<%=targetMenuVector.get(2).toString() %>" />
	   	</td>
	</tr>

	<tr>
       	<td style="font-weight:900;">프로그램ID</td>
        <td></td>
		<td>
			<input type="text" class="form-control" id="txt_ProgramId" style="width: 200px; float:left" 
           		   value="<%=targetMenuVector.get(4).toString() %>" readonly />
    	</td>
	</tr>
       
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">메뉴레벨</td>
		<td></td>
        <td>
        	<input type="text" class="form-control" id="txt_MenuLevel" style="width: 200px; float:left" 
           		   value="<%=targetMenuVector.get(3).toString() %>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
        <td style="font-weight:900;">정렬순서</td>
        <td></td>
        <td>
        	<input type="text" class="form-control" id="txt_OrderIndex" style="width: 200px; float:left" 
           		   value="<%=targetMenuVector.get(5).toString() %>" readonly />
    	</td>
	</tr>
       
	<tr style="background-color: #fff; height: 40px">
	    <td style="font-weight:900;">삭제여부</td>
		<td></td>
		<td>
	    	<input type="text" class="form-control" id="txt_DelYn" style="width: 200px; float:left" 
	           	   value="<%=targetMenuVector.get(8).toString() %>" readonly />
		</td>
	</tr>
       
	<tr style="background-color: #fff; height: 40px">
        <td style="font-weight:900;">상위메뉴</td>
        <td></td>
		<td>
        	<input type="text" class="form-control" id="txt_UpMenu" style="width: 200px; float:left"  
           		value="<%=targetMenuVector.get(0).toString() %>" />
    	</td>
	</tr>
</table>