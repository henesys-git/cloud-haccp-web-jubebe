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
    Vector optCode =  null;
    Vector optName =  null;
    Vector codeGroupVector = CommonData.getCodeGroupDataAll(member_key);
    
	String[] strColumnHead = {"공통코드", "공통코드명", "개정번호", "비고"} ;
	
	String GV_CODE_GROUP="";

	if(request.getParameter("CodeGroupGubun") != null)
		GV_CODE_GROUP = request.getParameter("CodeGroupGubun");
%>
 
<script>
    var groupCodeGubun = "";
	
	function SaveOderInfo() {
		if ($('#txt_CodeGroupGubun').val().length < 1) {
			alert("구분코드를 입력하세요.");
			return;
		}
		
		var WebSockData="";
		var dataJson = new Object(); // jSON Object 선언 
			dataJson.CodeGroupGubun = $("#txt_CodeGroupGubun").val();
			dataJson.CodeGroupGubun_000 = $('#txt_CodeGroupGubun').val() + "000";
			dataJson.CodeName = $('#txt_CodeName').val();
			dataJson.RevisionNo = $('#txt_RevisionNo').val();
			dataJson.Bigo = $('#txt_Bigo').val();
			dataJson.StartDate = $('#txt_StartDate').val();
            dataJson.user_id = "<%=loginID%>";
            dataJson.member_key = "<%=member_key%>";
            
		var chekrtn = confirm("등록하시겠습니까?"); 
    		
    	if(chekrtn){
			SendTojsp(JSON.stringify(dataJson), "M909S140100E111");
    	}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         }
		});		
	}
    
    $(document).ready(function () {
		
		new SetSingleDate2("", "#txt_StartDate", 0);

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
	    $("#select_CodeGroupGubun").on("change", function(){
	    	groupCodeGubun = $(this).val();
	    });
    });

    function fn_CommonPopupModal(sUrl, name, w, h) {
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


	<table class="table table-hover">
		<tr>
            <td>공통코드그룹</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeGroupGubun">
           	</td>
        </tr>
		
        <tr>
            <td>공통코드명</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeName">
           	</td>
        </tr>
        
        <tr>
            <td>개정번호</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_RevisionNo" value="0" readonly>
           	</td>
        </tr>
        
        <tr>
            <td>적용시작일자</td>
            <td></td>
            <td>
            	<input type="date" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control">
           	</td>
        </tr>
        
        <tr>
            <td>비고</td>
            <td></td>
            <td>
				<input class="form-control" id="txt_Bigo">
			</td>
        </tr>
	</table>