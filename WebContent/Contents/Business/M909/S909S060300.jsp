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

	String MID_GUBUN = "";
	
	if( request.getParameter("Mid_Gubun") == null )
		MID_GUBUN = "";
	else
		MID_GUBUN = request.getParameter("Mid_Gubun");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("Mid_Gubun", MID_GUBUN);
	
	DBServletLink dbServletLink = new DBServletLink();
    dbServletLink.connectURL("M909S060100E999");
    
    Vector Max_Product_Code_Vector = dbServletLink.doQuery(jArray, false);
	
	String result = ((Vector)Max_Product_Code_Vector.get(0)).get(0).toString();

	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>


