<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String selectedDate = "" , planRevNo = "";
	
	if(request.getParameter("selectedDate") != null) {
		selectedDate = request.getParameter("selectedDate");
	}

	if(request.getParameter("planRevNo") != null) {
		planRevNo = request.getParameter("planRevNo");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("selectedDate", selectedDate);
	jArray.put("planRevNo", planRevNo);
	
    DoyosaeTableModel vector = new DoyosaeTableModel("M303S020100E124", jArray);
	int row = vector.getRowCount();
	
	Map<String, List<Object>> hm 
	= new HashMap<String, List<Object>>();
	
    List<Object> t1Arr = new ArrayList<Object>();
    List<Object> t2Arr = new ArrayList<Object>();

    Vector inner = vector.getVector();
	Vector temp = new Vector();
	
    for(int i = 0; i < row; i++) {
    	String tableType = vector.getStrValueAt(i, 0);
    	
    	switch(tableType) {
    		case "t1":
    			temp = (Vector) inner.get(i);
    			// delete index 0~2
    			temp.remove(0);	// t1
    			temp.remove(0); // 생산계획날짜
    			temp.remove(0);	// 계획수정번호
    			
    			t1Arr.add(temp);
    			break;
    		case "t2":
    			temp = (Vector) inner.get(i);
    			// delete index 0~2
    			temp.remove(0);	// t1
    			temp.remove(0); // 생산계획날짜
    			temp.remove(0);	// 계획수정번호
    			
    			t2Arr.add(temp);
    			break;
    	}
    }

    hm.put("t1", t1Arr);
    hm.put("t2", t2Arr);
    
	JSONObject jo = new JSONObject(hm);
	
    response.setContentType("application/json");
    response.setHeader("Cache-Control", "no-store");
    response.getWriter().print(jo);
%>