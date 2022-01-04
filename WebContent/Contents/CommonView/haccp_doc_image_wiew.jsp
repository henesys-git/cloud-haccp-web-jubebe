<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%

	String Fromdate="",Todate="",programId="", GV_PROCESS_STATUS="",programImage;

	if(request.getParameter("From")== null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To")== null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("sprogramId")== null)
		programId="";
	else
		programId = request.getParameter("sprogramId");
		
	programImage=	programId.replace(".jsp", "").replace("M", "S");
%>

 <div style="overflow-y:auto; width:100%; height:750px;">
    <canvas  id="HACCPFRM" width="1060px" height="1440px"  
    	style=" background: url('<%=Config.this_SERVER_path%>/images/HACCPFRM/<%=programImage%>.png');
    			background-repeat:no-repeat;background-size:contain;"> 
    </canvas>
 </div>

    