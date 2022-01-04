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

	String cINDEX = "", vINDEX = "";
	
	if( request.getParameter("CINDEX") == null )
		cINDEX = "";
	else
		cINDEX = request.getParameter("CINDEX");
	
	if( request.getParameter("VINDEX") == null )
		vINDEX = "";
	else
		vINDEX = request.getParameter("VINDEX");
	
	int cindex = Integer.parseInt(cINDEX);
	int vindex = Integer.parseInt(vINDEX);
	
	vindex = cindex;
	
	StringBuffer result = new StringBuffer();
	result.append(vindex);
    
	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>