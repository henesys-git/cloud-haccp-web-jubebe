<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%  	

	DoyosaeTableModel TableModel;
	String member_key = session.getAttribute("member_key").toString();

	String GV_CUST_CD = "";
	
	if( request.getParameter("cust_cd") == null )
		GV_CUST_CD = "";
	else
		GV_CUST_CD = request.getParameter("cust_cd");
	
	System.out.println("??????????????????????????" + GV_CUST_CD + "??????????????????????????");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("cust_cd", GV_CUST_CD);
	
	StringBuffer result = new StringBuffer();
	
	DBServletLink dbServletLink = new DBServletLink();
    dbServletLink.connectURL("M838S060700E995");
    
    Vector Part_Address_Vector = dbServletLink.doQuery(jArray, false);
    
    System.out.println("$$$$$$$$$$$$$$$$$$$" + Part_Address_Vector.toString() + "$$$$$$$$$$$$$$$$$$$$$$");
    
    result.append(((Vector)(Part_Address_Vector.get(0))).get(0).toString());
    result.append("|");
    result.append(((Vector)(Part_Address_Vector.get(0))).get(1).toString());
    result.append("|");
    result.append(((Vector)(Part_Address_Vector.get(0))).get(2).toString());
    result.append("|");
    
	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>