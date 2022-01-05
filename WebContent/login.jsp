<%@page import="mes.service.LoginService"%>
<%@page import="mes.frame.database.JDBCConnectionPool"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="mes.service.BiznoSubdomainPairService" %>
<%@ page import="mes.service.LoginService" %>
<%@ page import="mes.dao.BiznoSubdomainPairDao" %>
<%@ page import="mes.dao.BiznoSubdomainPairDaoImpl" %>
<%@ page import="mes.dao.UserDaoImpl" %>
<%@ page import="mes.model.User" %>
<%@ page import="org.json.simple.*" %>

<%
    String Loginid = "", 
    	   Password = "", 
    	   login_name = "", 
    	   member_key = "",
    	   subdomain = "",
    	   login_date = "";	
    
	if(request.getParameter("subdomain") != null)
		subdomain = request.getParameter("subdomain");

	if(request.getParameter("login_id_enc") != null)
		Loginid = request.getParameter("login_id_enc");

	if(request.getParameter("login_name") != null)
		login_name = request.getParameter("login_name");
	
	if(request.getParameter("login_pw_enc") != null)
		Password = request.getParameter("login_pw_enc");
	
	if(request.getParameter("member_key") != null)
		member_key = request.getParameter("member_key");
	
	// 서브도메인 별 biz no 조회
	BiznoSubdomainPairDao dao = new BiznoSubdomainPairDaoImpl();
	BiznoSubdomainPairService bspService = new BiznoSubdomainPairService(dao);
	String bizNo = bspService.getBizno(subdomain);
	System.out.println("biz no : " + bizNo);
	
	// 아이디 복호화
	int Loginid_char_length = Loginid.length() / 4;
	String Loginid_decr = "";
	
    for(int i = 0; i < Loginid_char_length; i++) {
    	String Loginid_char = Loginid.substring(i*4, i*4+4);
    	int Loginid_ASCII = Integer.parseInt(Loginid_char);
    	Loginid_decr += (char)Loginid_ASCII;
    }
    
    String Loginid_output = "";
    
    int[] Loginid_Temp = new int[1000];
    int[] Loginid_Temp2 = new int[1000];
    
    for (int i = 0; i < Loginid_decr.length()-1; i++) {
    	Loginid_Temp[i] = (int)Loginid_decr.charAt(i);
    	Loginid_Temp2[i] = (int)Loginid_decr.charAt(i+1);
    }
    
    for (int i = 0; i < Loginid_decr.length(); i = i + 2) {
    	int temp = Loginid_Temp[i] - Loginid_Temp2[i];
    	Loginid_output += (char)temp;
    }
	
	// 패스워드 복호화
	int Password_char_length = Password.length() / 4;
	String Password_decr = "";
	
    for(int i = 0; i < Password_char_length; i++) {
    	String Password_char = Password.substring(i * 4, i * 4+4);
    	int Password_ASCII = Integer.parseInt(Password_char);
    	Password_decr += (char)Password_ASCII;
    }
    
    String Password_output = "";
    int[] Password_Temp = new int[1000];
    int[] Password_Temp2 = new int[1000];
    
    for (int i = 0; i < Password_decr.length()-1; i++) {
    	Password_Temp[i] = (int)Password_decr.charAt(i);
    	Password_Temp2[i] = (int)Password_decr.charAt(i+1);
    }
    
    for (int i = 0; i < Password_decr.length(); i = i+2) {
    	int temp = Password_Temp[i] - Password_Temp2[i];
    	Password_output += (char)temp;
    }

    LoginService loginService = new LoginService(new UserDaoImpl());
	User user = loginService.checkPassword(bizNo, Loginid_output, Password_output);
	
	response.setContentType("text/html");
	
    if(user.getUserId() != null) {
    	session.setAttribute("login_id", Loginid_output);
        session.setAttribute("login_name", user.getUserName());
        session.setAttribute("bizNo", bizNo);
        
		response.sendRedirect("MasterMainPage.jsp");
    } else {
    	response.sendRedirect("index.jsp" + "?invalid_login=y"); 
    }
%>