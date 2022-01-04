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
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);

	String[] strColumnHead = {"메뉴ID", "메뉴명", "메뉴레벨", "정렬순서", "삭제여부", "상위메뉴" };
	
	String GV_MENU_ID="", JOB_GUBUN="";

	if(request.getParameter("DocNo") == null)
		GV_MENU_ID="";
	else
		GV_MENU_ID = request.getParameter("DocNo");
	
	if(request.getParameter("job_gubun") == null)
		JOB_GUBUN = "";
	else
		JOB_GUBUN = request.getParameter("job_gubun");	
	
	String param = GV_MENU_ID + "|";
%>
 
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S100100E111 = {
			PID: "M909S100100E111",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S100100E111",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var docGubunCode = "";
    var JOB_GUBUN = "";
	
	/* function SetRecvData(){
		DataPars(M909S100100E111,GV_RECV_DATA);

		if(M909S100100E111.retnValue > 0)
 			alert('등록 되었습니다.');
   		
   		parent.fn_DetailInfo_List();
 		parent.$('#modalReport').hide();
	} */
	
	function SaveOderInfo() {
		if ($('#txt_ProgramId').val().length < 11) {
			alert("프로그램ID를 정확히 입력해 주세요.\n ex)M123S123456");
			return;
		}
		if ($('#txt_MenuId').val().length < 1) {
			alert("메뉴ID를 입력하세요.");
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
			dataJson.ProgramId = $('#txt_ProgramId').val() + ".jsp";
			dataJson.user_id = "<%=loginID%>";
			
			if (JOB_GUBUN == "open") {
				params += "|" + <%=GV_MENU_ID%> + "|";
			}
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn) {	
			SendTojsp(JSON.stringify(dataJson), SQL_Param.PID);
		}
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  "bomdata=" + bomdata + "&pid=" + pid,
	        success: function (html) {
	        	if(html > -1) {
	        		heneSwal.success('소메뉴정보 등록에 성공하였습니다.');	        	
	        	   	parent.fn_DetailInfo_List();
	        	   	$('#modalReport').modal('hide');
	         	}
	        	else{
	        		heneSwal.error('소메뉴정보 등록에 실패하였습니다.');
	        	}
	        }
		});		
	}
    
    $(document).ready(function () {
	    <%-- JOB_GUBUN = "<%=JOB_GUBUN%>"; --%>
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

<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	<tr style="background-color: #fff; height: 40px">
    	<td>프로그램ID</td>
        <td></td>
        <td>
         	<input type="text" class="form-control" id="txt_ProgramId" style="width: 200px; float:left"  />
        </td>
	</tr>
     
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
        	<input type="text" class="form-control" id="txt_MenuName" style="width: 200px; float:left" />
        </td>
    </tr>
     
    <tr style="background-color: #fff; height: 40px">
    	<td style="font-weight:900;">메뉴레벨</td>
        <td></td>
        <td>
        	<input type="text" class="form-control" id="txt_MenuLevel" style="width: 200px; float:left" 
         		value="2" readonly />
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
         	<input type="text" class="form-control" id="txt_UpMenu" style="width: 200px; float:left" />
       	</td>
    </tr>
</table>