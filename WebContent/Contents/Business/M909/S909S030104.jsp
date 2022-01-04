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

	// 시도 정보
	String  GV_SELECT_CHECKGUBUN = "";	
	if(request.getParameter("select_CheckGubun")== null)
		GV_SELECT_CHECKGUBUN = "";
	else
		GV_SELECT_CHECKGUBUN = request.getParameter("select_CheckGubun");

	String param = GV_SELECT_CHECKGUBUN + "|";
	
	System.out.println(param);
  	//중분류코드
	Vector check_gubunMidVector = CommonData.getChecklistGubun_Code_Mid(param,member_key);
    Vector optCode =  null;
    Vector optName =  null;

%>
 
<script type="text/javascript"> 
	$(document).ready(function () {
		fn_Select_CheckGubun_Mid();
	});
	
    function fn_Select_CheckGubun_Mid() {
    	
    	var select_checkGubun = $("#select_CheckGubun option:selected").val().trim();
    	
    	if($("#select_CheckGubun_Mid option:selected").val()==undefined) {var select_checkGubun_mid="";}
    	else {var select_checkGubun_mid = $("#select_CheckGubun_Mid option:selected").val().trim();}
    	
    	$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030105.jsp",
            data: "select_CheckGubun="+ select_checkGubun + "&select_CheckGubun_Mid="+ select_checkGubun_mid,
            beforeSend: function () {
                $("#select_CheckGubun_Sm_td").children().remove();
            },
            success: function (html) {
                $("#select_CheckGubun_Sm_td").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
    	});
    }
    
    </script>
    
	<select class="form-control" id="select_CheckGubun_Mid" style="width: 200px; float: left;" onchange="fn_Select_CheckGubun_Mid()">
		<%optName =  (Vector)check_gubunMidVector.get(0);%>
		<%optCode =  (Vector)check_gubunMidVector.get(1);%>
		<!-- <option value=''>선택</option> -->
		<%for(int i=0; i<optCode.size();i++){ %>
			<option value='<%=optName.get(i).toString()%>'><%=optCode.get(i).toString()%></option>
			<%} %>
	</select>