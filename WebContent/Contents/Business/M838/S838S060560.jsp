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
	
	String GV_VHCL_NO4 = "", GV_VHCL_NO_REV4 = "", GV_START_DATE4 = "", GV_END_DATE4 = "";
	
	if( request.getParameter("vhcl_no") == null )
		GV_VHCL_NO4 = "";
	else
		GV_VHCL_NO4 = request.getParameter("vhcl_no");
	
	if( request.getParameter("vhcl_no_rev") == null )
		GV_VHCL_NO_REV4 = "";
	else
		GV_VHCL_NO_REV4 = request.getParameter("vhcl_no_rev");
	
	if( request.getParameter("start_date") == null )
		GV_START_DATE4 = "";
	else
		GV_START_DATE4 = request.getParameter("start_date");
	
	if( request.getParameter("end_date") == null )
		GV_END_DATE4 = "";
	else
		GV_END_DATE4 = request.getParameter("end_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "vhcl_no", GV_VHCL_NO4);
	jArray.put( "vhcl_no_rev", GV_VHCL_NO_REV4);
	jArray.put( "member_key", member_key);
	jArray.put( "start_date", GV_START_DATE4);
	jArray.put( "end_date", GV_END_DATE4);
	
	
	DBServletLink dbServletLink = new DBServletLink();
    dbServletLink.connectURL("M838S060500E184");
    
    Vector Strange_Info_Vector = dbServletLink.doQuery(jArray, false);
	
    StringBuffer result = new StringBuffer();
    
    if( Strange_Info_Vector.size() == 0 )
    {
    	result.append("N");
		//result.append("|");
    }
    else
    {
    	result.append("[");
    	for( int i = 0 ; i < Strange_Info_Vector.size() ; i++ )
    	{System.out.println("???????????????" + Strange_Info_Vector.get(i).toString() + "$$$$$$$$$$$$$$$$$");
    		result.append("[");
    		//result.append(((Vector)Strange_Info_Vector.get(i)).get(0).toString() + "," );
    		result.append(((Vector)Strange_Info_Vector.get(i)).get(1).toString() + "," );
    		result.append(((Vector)Strange_Info_Vector.get(i)).get(2).toString() + "," );
    		result.append(((Vector)Strange_Info_Vector.get(i)).get(3).toString() + "," );
    		result.append(((Vector)Strange_Info_Vector.get(i)).get(4).toString() + "," );
    		result.append(((Vector)Strange_Info_Vector.get(i)).get(5).toString() + "," );
    		result.append(((Vector)Strange_Info_Vector.get(i)).get(6).toString() + "" );
    		
    		if( i == Strange_Info_Vector.size() - 1 )
				result.append("]");
    		else
    			result.append("],");
    	}
    	result.append("]");
    }
    
	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>