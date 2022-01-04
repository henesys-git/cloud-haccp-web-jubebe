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

	String  GV_SELECT_CHECKGUBUN = "";	
	String  GV_SELECT_CHECKGUBUN_MID = "";	
	
	if(request.getParameter("select_CheckGubun")== null)
		GV_SELECT_CHECKGUBUN = "";
	else
		GV_SELECT_CHECKGUBUN = request.getParameter("select_CheckGubun");

	if(request.getParameter("select_CheckGubun_Mid")== null)
		GV_SELECT_CHECKGUBUN_MID = "";
	else
		GV_SELECT_CHECKGUBUN_MID = request.getParameter("select_CheckGubun_Mid");

	String param = GV_SELECT_CHECKGUBUN + "|" + GV_SELECT_CHECKGUBUN_MID +  "|";
	
	System.out.println("param 확인 : "+ param);
  	//소분류코드
	Vector check_gubunSmVector = CommonData.getChecklistGubun_Code_Sm(param,member_key);
  	
    Vector optCode =  null;
    Vector optName =  null;

%>
 
<script type="text/javascript"> 

    
    </script>
	<select class="form-control" id="select_CheckGubun_Sm" style="width: 200px; float: left;">
		<%optName =  (Vector)check_gubunSmVector.get(0);%>
		<%optCode =  (Vector)check_gubunSmVector.get(1);%>
		<!-- <option value=''>선택</option> -->
		<%for(int i=0; i<optCode.size();i++){ %>
			<option value='<%=optName.get(i).toString()%>'><%=optCode.get(i).toString()%></option>
			<%} %>
	</select>