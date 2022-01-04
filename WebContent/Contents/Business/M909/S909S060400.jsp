<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%  	
	String member_key = session.getAttribute("member_key").toString();

	String GV_PRODGUBUN_BIG = "", GV_PRODGUBUN_MID = "";
	
	if( request.getParameter("prodgubun_big") != null ) {
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");
	}
	
	if( request.getParameter("prodgubun_mid") != null ) {
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("Big_Gubun", GV_PRODGUBUN_BIG);
	jArray.put("Mid_Gubun", GV_PRODGUBUN_MID);
	
	StringBuffer result = new StringBuffer();
	
	if( CommonData.getProductNameSize(jArray) ) { // 비어 있으면
		result.append("Empty_Value");
		result.append(",");
		result.append("제품명을 등록해 주세요.");
	} else {
		DoyosaeTableModel TableModel = new DoyosaeTableModel("M000S010000E924", GV_PRODGUBUN_BIG + "|" + GV_PRODGUBUN_MID + "|" + member_key);
		
		for(int i = 0; i < TableModel.getRowCount(); i++) {
			result.append(TableModel.getValueAt(i, 0));
			result.append(",");
			result.append(TableModel.getValueAt(i, 1));
			
			if( i != TableModel.getRowCount() - 1 ) {
				result.append("|");
			}
		}
	}
	
	System.out.println(result);

	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(result.toString());
%>