<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%  	
/* 
공정대분류코드를 Refresh하는 모듈
 */
 	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	String GV_PROCESS_GUBUN="";
	if(request.getParameter("Process_gubun")== null)
		GV_PROCESS_GUBUN="";
	else
		GV_PROCESS_GUBUN = request.getParameter("Process_gubun");
	
		
	
	
	TableModel = new DoyosaeTableModel("M000S010000E044",GV_PROCESS_GUBUN+"|"+member_key+"|");
	
	StringBuffer result = new StringBuffer();
	
	
	 for(int i=0; i<TableModel.getRowCount(); i++) {
		  
			result.append(TableModel.getValueAt(i, 0));
			result.append(",");
			result.append(TableModel.getValueAt(i, 1));
			if(i!=TableModel.getRowCount()-1) {
				result.append("|");					
			} 
	
		
	} 
	
	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>


