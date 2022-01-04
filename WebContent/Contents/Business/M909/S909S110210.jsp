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
	String  GV_PART_GUBUN = "";	
	
	if(request.getParameter("part_gubun")== null)
		GV_PART_GUBUN = "";
	else
		GV_PART_GUBUN = request.getParameter("part_gubun");

	JSONObject jArray = new JSONObject();	
	jArray.put( "part_gubun", GV_PART_GUBUN);
	jArray.put( "member_key", member_key);
    TableModel = new DoyosaeTableModel("M909S110100E204", jArray);
    
    int code_temp = Integer.parseInt(TableModel.getValueAt(0,0).toString().trim());
    String code_val = "";
    if(code_temp < 10) code_val = "0"+ String.valueOf(code_temp);
    else code_val = String.valueOf(code_temp);
/*	String code_val = "";
    if(code_temp > 100){
    	code_val = String.valueOf(code_temp);
    	if(code_val.length() == 3) { code_val = "0"+ code_val;}
    } else { code_val = String.valueOf(code_temp); } */
%>
 
<script type="text/javascript"> 
</script>

<input type="text" 
	   class="form-control" 
	   id="txt_CodeValue" 
	   style="width: 200px; float:left" 
	   value="<%=code_val%>" 
	   readonly>
</input>
