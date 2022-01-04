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
실시간 생산현황 변동체크 (S707S010115.jsp)
*/	
// 	String loginID = session.getAttribute("login_id").toString();
// 	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;

	String member_key = "";
	
	if(request.getParameter("member_key") == null)
		member_key = "";
	else
		member_key = request.getParameter("member_key");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);

	TableModel = new DoyosaeTableModel("M707S010100E115", jArray);
	int RowCount =TableModel.getRowCount();
	
	makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS707S010115";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink; 
%>

<%=makeGridData.getDataArry()%>
