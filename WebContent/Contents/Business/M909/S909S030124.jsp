<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;


	String[] strColumnHead 	= {"코드구분"} ; 

	String GV_PAGE="", GV_CHECK_MID_NAME = "", GV_CHECK_SM_NAME="", GV_CHECK_BIG = "", GV_CHECK_MID = "";
	int RowCount=0;
	
	if(request.getParameter("Page")== null )
		GV_PAGE = "";
	else
		GV_PAGE = request.getParameter("Page");
	
	if(request.getParameter("Check_big")== null )
		GV_CHECK_BIG = "";
	else
		GV_CHECK_BIG = request.getParameter("Check_big");
	
	if(request.getParameter("Check_mid")== null )
		GV_CHECK_MID = "";
	else
		GV_CHECK_MID = request.getParameter("Check_mid");
	
	if(request.getParameter("Check_mid_name")== null )
		GV_CHECK_MID_NAME = "";
	else
		GV_CHECK_MID_NAME = request.getParameter("Check_mid_name");
	
	if(request.getParameter("Check_sm_name")== null )
		GV_CHECK_SM_NAME = "";
	else
		GV_CHECK_SM_NAME = request.getParameter("Check_sm_name");
	
	
	
	
	if(GV_PAGE.equals("S909S030111.jsp")) {
		JSONObject jArray = new JSONObject();
		jArray.put( "member_key", member_key);
		jArray.put( "check_big", GV_CHECK_BIG);
		jArray.put( "check_mid_name", GV_CHECK_MID_NAME);
	    TableModel = new DoyosaeTableModel("M909S030100E107", strColumnHead, jArray);	
	 	RowCount =TableModel.getRowCount();
	 	System.out.println("중분류 등록 중복");
	} else if(GV_PAGE.equals("S909S030121.jsp")) {
		JSONObject jArray = new JSONObject();
		jArray.put( "member_key", member_key);
		jArray.put( "check_big", GV_CHECK_BIG);
		jArray.put( "check_mid", GV_CHECK_MID);
		jArray.put( "check_sm_name", GV_CHECK_SM_NAME);
	    TableModel = new DoyosaeTableModel("M909S030100E108", strColumnHead, jArray);	
	 	RowCount =TableModel.getRowCount();
	 	System.out.println("소분류 등록 중복");
	}

%>


<%=RowCount%>

