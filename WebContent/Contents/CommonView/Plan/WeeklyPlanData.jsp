<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String start = "", end = "", prodCd = "";
	
	if(request.getParameter("start") != null) {
		start = request.getParameter("start");
		start = start.substring(0, 10);
	}
	
	if(request.getParameter("end") != null) {
		end = request.getParameter("end");
		end = end.substring(0, 10);
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("start", start);
	jArray.put("end", end);
	
    DoyosaeTableModel vector = new DoyosaeTableModel("M303S020100E104", jArray);
	int row = vector.getRowCount();
	
    List<Map<String, String>> listOfMaps = new ArrayList<Map<String, String>>();
	
    for(int i = 0; i < row; i++) {
    	Map<String, String> hm = new HashMap<String, String>();
    	
    	hm.put("start", vector.getStrValueAt(i, 0));
    	hm.put("planRevNo", vector.getStrValueAt(i, 1));
    	hm.put("title", vector.getStrValueAt(i, 2));
    	
    	String value = vector.getStrValueAt(i, 3);
    	
    	value = value.replace(",", "<br>")
    				 .replace("[", "")
    				 .replace("]", "");
    	
    	hm.put("description", value);
    	
    	listOfMaps.add(hm);
    }
    
	JSONArray list = new JSONArray();
	
    for(Map<String, String> data : listOfMaps) {
        JSONObject obj = new JSONObject(data);
        list.add(obj);
    }
    
    response.setContentType("application/json");
    response.setHeader("Cache-Control", "no-store");
    response.getWriter().print(list);
%>