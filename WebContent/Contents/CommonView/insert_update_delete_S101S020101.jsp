<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String[] rTurnValue;
	DBServletLink dbServletLink =  new DBServletLink();
	
	String GV_PID="", GV_PARM="";

	
	if(request.getParameter("pid")== null)
		GV_PID="";
	else
		GV_PID = request.getParameter("pid");	
	
	if(request.getParameter("bomdata")== null)
		GV_PARM="";
	else
		GV_PARM = request.getParameter("bomdata");

	
	
	dbServletLink.connectURL(GV_PID);

	// rTurnValue [Length \t Head \t responseInt \t columnCount \t Data]
	rTurnValue = dbServletLink.queryProcessForjsp(GV_PARM, false).split("\t");
	
    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-store");
    response.getWriter().print(rTurnValue[4].trim());
%>
