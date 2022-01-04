<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	DoyosaeTableModel TableModel;
	String[] strColumnHead = { "부서그룹","USER_ID","이름","비밀번호" }; 
	int[]   colOff 			= {1,	1	,3 ,4,5,6,7,8 ,9 ,1, 0, 1};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;

    String userID="login_id";
    String Loginid ="", Password="", login_name="";// request.getParameter("login_id"); login_name 
    
	if(request.getParameter("login_id")== null)
		Loginid="";
	else
		Loginid = request.getParameter("login_id");

	if(request.getParameter("login_name")== null)
		login_name="";
	else
		login_name = request.getParameter("login_name");
	
	if(request.getParameter("login_pw")== null)
		Password="";
	else
		Password = request.getParameter("login_pw");


	String param = Loginid + "|" + Password + "|" + request.getRemoteAddr() + "|";    		
    TableModel = new DoyosaeTableModel("M000S100000E104", strColumnHead, param);

    int zzhtml = TableModel.getRowCount();
    
// 	response.setContentType("text/html");
//     if(TableModel.getRowCount()>0){
//         session.setAttribute("login_id",Loginid);
//         session.setAttribute("login_name",login_name);  

//         response.sendRedirect("master/MasterMainPage.jsp"); 
// //         response.getWriter().print("ok");
//     }
//     else{    
//         response.sendRedirect("index.jsp");
//     }

%>
<%=zzhtml%>


