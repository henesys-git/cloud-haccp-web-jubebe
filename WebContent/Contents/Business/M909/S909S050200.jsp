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

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);

	String GV_SELECT_SULBIGUBUN = "";
	if (request.getParameter("select_SulbiGubun") == null)
		GV_SELECT_SULBIGUBUN = "";
	else
		GV_SELECT_SULBIGUBUN = request.getParameter("select_SulbiGubun");

	StringBuffer result;

	jArray.put("select_SulbiGubun", GV_SELECT_SULBIGUBUN);
	TableModel = new DoyosaeTableModel("M909S050100E994", jArray);
	result = new StringBuffer();
	result.append(TableModel.getValueAt(0, 0));
	
	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>


