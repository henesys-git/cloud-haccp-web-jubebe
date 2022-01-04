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

	String GV_CODE_CD = "" , GV_CODE_VALUE="" , GV_PART_CD="" , GV_SERIAL_NUM="" ,GV_PAGE="";
	int RowCount=0;
	
	if(request.getParameter("Page")== null )
		GV_PAGE = "";
	else
		GV_PAGE = request.getParameter("Page");
	
	if(request.getParameter("CodeGroupGubun")== null )
		GV_CODE_CD = "";
	else
		GV_CODE_CD = request.getParameter("CodeGroupGubun");
	
	if(request.getParameter("CodeValue")== null )
		GV_CODE_VALUE = "";
	else
		GV_CODE_VALUE = request.getParameter("CodeValue");
	
	if(request.getParameter("Part_cd")== null )
		GV_PART_CD = "";
	else
		GV_PART_CD = request.getParameter("Part_cd");
	
	if(request.getParameter("Serial_num")== null )
		GV_SERIAL_NUM = "";
	else
		GV_SERIAL_NUM = request.getParameter("Serial_num");
	
	
	
	if(GV_PAGE.equals("S909S110201.jsp")) {
// 		String param =  GV_CODE_CD + "|"  + GV_CODE_VALUE + "|";
		JSONObject jArray = new JSONObject();
		jArray.put( "member_key", member_key);
		jArray.put( "CODE_CD", GV_CODE_CD);
		jArray.put( "CODE_VALUE", GV_CODE_VALUE);
	    TableModel = new DoyosaeTableModel("M909S110100E107", strColumnHead, jArray);	
	 	RowCount =TableModel.getRowCount();
	 	System.out.println("코드등록 중복");
	} else if(GV_PAGE.equals("S909S110101.jsp")) {
// 		String param =  GV_PART_CD + "|"  + GV_SERIAL_NUM + "|";
		JSONObject jArray = new JSONObject();
		jArray.put( "member_key", member_key);
		jArray.put( "PART_CD", GV_PART_CD);
		jArray.put( "SERIAL_NUM", GV_SERIAL_NUM);
	    TableModel = new DoyosaeTableModel("M909S110100E108", strColumnHead, jArray);	
	 	RowCount =TableModel.getRowCount();
	 	System.out.println("원자재 등록 중복");
	}

%>


<%=RowCount%>

