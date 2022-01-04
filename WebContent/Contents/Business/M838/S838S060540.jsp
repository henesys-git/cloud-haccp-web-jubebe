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

	String GV_VHCL_NO2 = "", GV_VHCL_NO_REV2 = "", GV_SERVICE_DATE2 = "";
	
	if( request.getParameter("vhcl_no") == null )
		GV_VHCL_NO2 = "";
	else
		GV_VHCL_NO2 = request.getParameter("vhcl_no");
	
	if( request.getParameter("vhcl_no_rev") == null )
		GV_VHCL_NO_REV2 = "";
	else
		GV_VHCL_NO_REV2 = request.getParameter("vhcl_no_rev");
	
	if( request.getParameter("service_date") == null )
		GV_SERVICE_DATE2 = "";
	else
		GV_SERVICE_DATE2 = request.getParameter("service_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "vhcl_no", GV_VHCL_NO2);
	jArray.put( "vhcl_no_rev", GV_VHCL_NO_REV2);
	jArray.put( "service_date", GV_SERVICE_DATE2);
	jArray.put( "member_key", member_key);
	
	
	DBServletLink dbServletLink = new DBServletLink();
    dbServletLink.connectURL("M838S060500E154");
    
    Vector Driver_Vector = dbServletLink.doQuery(jArray, false);
	
    StringBuffer result = new StringBuffer();
    
    if( Driver_Vector.size() == 0 )
    {
    	result.append("N");
    	result.append("|");
    }
    else
    {
    	result.append(((Vector)Driver_Vector.get(0)).get(0).toString());
    	result.append("|");
    }
    
	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>