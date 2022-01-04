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
	
	if(request.getParameter("prodCd") != null) {
		prodCd = request.getParameter("prodCd");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("start", start);
	jArray.put("end", end);
	jArray.put("prodCd", prodCd);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M858S010300E114", jArray);
	int row = TableModel.getRowCount();

    List<Map<String, String>> listOfMaps = new ArrayList<Map<String, String>>();
	
    for(int i = 0; i < row; i++) {
    	Map<String, String> hm = new HashMap<String, String>();    	
    	
    	hm.put("title", TableModel.getStrValueAt(i, 3));
    	hm.put("start", TableModel.getStrValueAt(i, 0));
    	
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