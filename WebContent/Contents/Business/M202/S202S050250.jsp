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

	String GV_PARTGUBUN_BIG = "";
	
	if( request.getParameter("partgubun_big") == null )
		GV_PARTGUBUN_BIG = "";
	else
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("Big_Gubun", GV_PARTGUBUN_BIG);
	
	StringBuffer result = new StringBuffer();
	
		TableModel = new DoyosaeTableModel("M000S010000E814", GV_PARTGUBUN_BIG + "|" + member_key);
		
		if(TableModel.getRowCount() == 0) {
		result.append("Empty_Value");
		result.append(",");
		result.append("중분류 없음");					
		} 
	
		for(int i = 0; i < TableModel.getRowCount(); i++) {
			result.append(TableModel.getValueAt(i, 0));
			result.append(",");
			result.append(TableModel.getValueAt(i, 1));
			
			if( i != TableModel.getRowCount() - 1 ) {
				result.append("|");					
			} 
		}

	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>