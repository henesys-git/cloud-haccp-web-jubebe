<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
// System.out.println(loginID);
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
// 	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);		
// 	makeMenu MainMenu = new makeMenu(loginID, sHeadmenuID);
	
// 	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
	if(request.getRemoteAddr().equals("210.181.138.62"))
		System.out.println("로그인 한 사람==시흥 해내시스==" + request.getRemoteAddr());
	else
		System.out.println("로그인 한 사람==그외지역==" + request.getRemoteAddr());

// 	String authoProgram = MainMenu.getAuthorityOfProgram();
	
%>
    <script type="text/javascript">    	
       var MenuTitle;
        $(document).ready(function () {

			fn_SubMain("<%=Config.this_SERVER_path%>/Contents/<%=sHeadmenuID%>/<%=sProgramId%>", "<%=sHeadmenuID%>",
					"<%=sHeadmenuName%>","<%=sProgramId%>","<%=sMenuTitle%>");
        });

    </script>
	         