<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="org.json.simple.parser.*"%>
<%
	String[] rTurnValue;
	DBServletLink dbServletLink = new DBServletLink();
	
	String GV_PID = "", GV_PARM = "";
	
	if(request.getParameter("pid") != null) {
		GV_PID = request.getParameter("pid");		
	}
	
	if(request.getParameter("prmtr") != null) {
		GV_PARM = request.getParameter("prmtr");
	}
	
	try{
		dbServletLink = new DBServletLink();
		dbServletLink.connectURL(GV_PID);
		
		// String형태의 JSON 데이터를 JSONObject 형태로 변환한다.
		JSONObject jObj = new JSONObject();
		if(GV_PARM != "") {
			JSONParser parser = new JSONParser();
			jObj = (JSONObject)parser.parse(GV_PARM);
		}
		
		// DB의 SELECT 결과값을 Vector로 가져온다
		Vector dataFromDb = dbServletLink.doQuery(jObj, false);
		
		// Vector to Json
		String data = dataFromDb.toString();

		VectorToJson vj = new VectorToJson();
		String jsonStr = vj.vectorToJson(dataFromDb);
		
		response.setContentType("application/json");
	    response.setHeader("Cache-Control", "no-store");
	    response.getWriter().print(jsonStr);
	} catch(Exception e){
		System.out.println(e);
	}
%>