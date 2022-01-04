<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
생산시작 //외부서버 생산시작처리(tbi_production_work_result)
 */

// 	String loginID = session.getAttribute("login_id").toString();
	String rTurnValue="";
	DBServletLink dbServletLink =  new DBServletLink();
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_ORDER_NO="", GV_LOTNO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");    
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");   
	
	String GV_PARM  = GV_ORDER_NO + "|" 
					+ GV_LOTNO 	  + "|" 
					+ member_key+ "|" 
					+ Config.DATATOKEN  ;
	
    if(GV_ORDER_NO.equals("") || GV_LOTNO.equals("")){
    	rTurnValue="주문번호 또는 Lot번호가 없습니다!!!";
    }
    else{
    	dbServletLink.connectURL("M303S050100E131");
    	dbServletLink.queryProcessForjsp(GV_PARM, false);
    	rTurnValue="생산을 시작했습니다!!!";
    }
    
    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-store");
    response.getWriter().print(rTurnValue);
    
%>
