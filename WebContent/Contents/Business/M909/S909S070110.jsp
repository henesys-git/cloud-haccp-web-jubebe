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

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_CUST_CD = "";	
	
	if(request.getParameter("Cust_cd") == null)
		GV_CUST_CD = "";
	else
		GV_CUST_CD = request.getParameter("Cust_cd");
	
	// 고객사 코드
	String cust_cd = GV_CUST_CD.substring(0, 3) + "-"+ GV_CUST_CD.substring(3,5) + "-"+ GV_CUST_CD.substring(5,10); 

	JSONObject jArray = new JSONObject();	
	jArray.put("cust_cd", cust_cd);
	jArray.put("member_key", member_key);
    TableModel = new DoyosaeTableModel("M909S070100E214", jArray);
    
    int code_cnt = Integer.parseInt(TableModel.getValueAt(0,0).toString().trim());
	String code_val = "";
	
    if(code_cnt < 1) {
    	code_val = cust_cd;
	} else {
		code_val = cust_cd + "_" + code_cnt;
	}
%>

<input type="text" class="form-control" id="txt_CustCode" 
	   style="width:200px; float:left" value="<%=code_val%>" readonly />