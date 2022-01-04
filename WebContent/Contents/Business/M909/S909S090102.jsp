<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>

<%
	String member_key = session.getAttribute("member_key").toString();
// 	DoyosaeTableModel TableModel;
	String zhtml = "";
	String GV_GROUP_CD="", GV_USER_ID="", GV_MENU_ID="", GV_MENU_NM=""
		,GV_AUTHO_INSERT="", GV_AUTHO_UPDATE="", GV_AUTHO_DELETE="", GV_AUTHO_SELECT="", GV_AUTHO_MENU="";

	if(request.getParameter("group_cd")== null)
		GV_GROUP_CD="";
	else
		GV_GROUP_CD = request.getParameter("group_cd");
	
	if(request.getParameter("user_id")== null)
		GV_USER_ID="";
	else
		GV_USER_ID = request.getParameter("user_id");	
	
	if(request.getParameter("menu_id")== null)
		GV_MENU_ID="";
	else
		GV_MENU_ID = request.getParameter("menu_id");

	if(request.getParameter("menu_nm")== null)
		GV_MENU_NM="";
	else
		GV_MENU_NM = request.getParameter("menu_nm");
	
	if(request.getParameter("autho_insert")== null)
		GV_AUTHO_INSERT="";
	else
		GV_AUTHO_INSERT = request.getParameter("autho_insert");
	
	if(request.getParameter("autho_update")== null)
		GV_AUTHO_UPDATE="";
	else
		GV_AUTHO_UPDATE = request.getParameter("autho_update");
	
	if(request.getParameter("autho_delete")== null)
		GV_AUTHO_DELETE="";
	else
		GV_AUTHO_DELETE = request.getParameter("autho_delete");

	if(request.getParameter("autho_select")== null)
		GV_AUTHO_SELECT="";
	else
		GV_AUTHO_SELECT = request.getParameter("autho_select");

	if(request.getParameter("autho_menu")== null)
		GV_AUTHO_MENU="";
	else
		GV_AUTHO_MENU = request.getParameter("autho_menu");
%>

    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작 TBM_MENU
	var M000S100000E101 = {
			PID: "M909S090100E112",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
// 			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음 
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S090100E112",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    $(document).ready(function () {
        $('#txt_group_cd').val('<%=GV_GROUP_CD%>');
        $('#txt_user_id').val("<%=GV_USER_ID%>");
        $('#txt_menu_id').val('<%=GV_MENU_ID%>');
        $('#txt_menu_nm').val('<%=GV_MENU_NM%>');
        if('<%=GV_AUTHO_INSERT%>'=='1') $('#txt_autho_insert').prop("checked",true);
        else $('#txt_autho_insert').prop("checked",false);
        if('<%=GV_AUTHO_UPDATE%>'=='1') $('#txt_autho_update').prop("checked",true);
        else $('#txt_autho_update').prop("checked",false);
        if('<%=GV_AUTHO_DELETE%>'=='1') $('#txt_autho_delete').prop("checked",true);
        else $('#txt_autho_delete').prop("checked",false);
        if('<%=GV_AUTHO_SELECT%>'=='1') $('#txt_autho_select').prop("checked",true);
        else $('#txt_autho_select').prop("checked",false);
        if('<%=GV_AUTHO_MENU%>'=='1') $('#txt_autho_menu').prop("checked",true);
        else $('#txt_autho_menu').prop("checked",false);  
        
        validateCheckbox();
    });
    
    function validateCheckbox(obj) {
    	if($(obj).prop("checked")) {
    		$("#txt_autho_menu").prop("checked",true);
    	}
    	if($("#txt_autho_menu").prop("checked")==false) {
    		$("#txt_autho_insert").prop("checked",false);
    		$("#txt_autho_update").prop("checked",false);
    		$("#txt_autho_delete").prop("checked",false);
    		$("#txt_autho_select").prop("checked",false);
    	}
    }
	
	function SaveProgramUpdate() {
     	var params = '<%=Config.HEADTOKEN %>'
     				+ $('#txt_group_cd').val()		+ "|"	//group_cd
					+ $('#txt_user_id').val() 		+ "|"	//user_id
					+ $('#txt_menu_id').val() 		+ "|" ;	//menu_id
		if($('#txt_autho_menu').prop("checked")) params += '1' + "|" ;	//autho_menu
		else params += '0' + "|" ;	//autho_menu
		if($('#txt_autho_insert').prop("checked")) params += '1' + "|" ;	//autho_menu
		else params += '0' + "|" ;	//autho_menu
		if($('#txt_autho_update').prop("checked")) params += '1' + "|" ;	//autho_menu
		else params += '0' + "|" ;	//autho_menu
		if($('#txt_autho_delete').prop("checked")) params += '1' + "|" ;	//autho_menu
		else params += '0' + "|" ;	//autho_menu
		if($('#txt_autho_select').prop("checked")) params += '1' + "|" ;	//autho_menu
		else params += '0' + "|" ;	//autho_menu
		
		params += '<%=member_key%>' + "|" ;	//autho_menu
		params += '<%=Config.DATATOKEN %>' ;
   	 	SendTojsp_nd(params, SQL_Param.PID)   	    
	}  
	

	function SendTojsp_nd(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
	        		parent.fn_MyInfo_List();
	                parent.$("#ReportNote_nd").children().remove();
	         		parent.$('#modalReport_nd').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	} 
    
    </script>

	<table class="table " style="width: 100%; margin: 0 auto; align:left">        
        
        <tr style="height: 40px; vertical-align: middle">
            <td style="width: 25%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">메뉴ID</td>
            <td style="width: 75%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
				<input type="hidden" 	class="form-control"  id="txt_group_cd" readonly style="width: 200px;"></input>
				<input type="hidden" 	class="form-control"  id="txt_user_id" readonly style="width: 200px;"></input>
				<input type="text" 	class="form-control"  id="txt_menu_id" readonly style="width: 200px;"></input>
           	</td>
        </tr>
        <tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">메뉴명</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
            	<input type="text" class="form-control"  id="txt_menu_nm" readonly style="width: 200px;"></input>
            </td>
        </tr>
        <tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">메뉴권한</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
				<input type="checkbox" id="txt_autho_menu" onclick="validateCheckbox(this)"></input>
           	</td>
        </tr>
		<tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">입력권한</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
            	<input type="checkbox" id="txt_autho_insert" onclick="validateCheckbox(this)"></input>
            </td>
        </tr>
        <tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">수정권한</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
				<input type="checkbox" id="txt_autho_update" onclick="validateCheckbox(this)"></input>
           	</td>
        </tr>
        <tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">삭제권한</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
				<input type="checkbox" id="txt_autho_delete" onclick="validateCheckbox(this)"></input>
           	</td>
        </tr> 
        <tr style="height: 40px; vertical-align: middle">
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">조회권한</td>
            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle" >
				<input type="checkbox" id="txt_autho_select" onclick="validateCheckbox(this)"></input>
           	</td>
        </tr>
        <tr style="height: 40px; vertical-align: middle">
            <td colspan="2" style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle" >
            <p>
            	<button id="btn_saVE"  class="btn btn-info" style="width: 100px;" onclick="SaveProgramUpdate();">확인</button>
                <button id="btn_Canc"  class="btn btn-info" style="width: 100px; margin-left:10px;" onclick="parent.$('#modalReport_nd').hide();">취소</button>
            </p>
            </td>
        </tr>  
    </table>
