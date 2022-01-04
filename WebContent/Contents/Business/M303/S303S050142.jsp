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
생산개수 //외부서버 공정완료 개수 갱신 처리(tbi_production_work_result)
 */

 	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
 
	SysConfig sys_config = new SysConfig();

	String rTurnValue="";
	DBServletLink dbServletLink =  new DBServletLink();
	
	String GV_ORDER_NO="", GV_LOTNO="",GV_RESULT_CNT="" ;
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");    
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");  
	
	if(request.getParameter("result_cnt")== null)
		GV_RESULT_CNT="";
	else
		GV_RESULT_CNT = request.getParameter("result_cnt"); 
	
	String GV_PARM  = Config.HEADTOKEN 
					+ GV_ORDER_NO 	+ "|" 
					+ GV_LOTNO 	  	+ "|" 
					+ GV_RESULT_CNT + "|" 
					+ sys_config.sub_server_ip + "|" // 보조서버 ip
					+ member_key 	+ "|" 
	 				+ Config.DATATOKEN ;
	if(GV_ORDER_NO.equals("") || GV_LOTNO.equals("")) {
		rTurnValue="주문번호 또는 Lot번호가 없습니다!!!";
	} else {
		// 내부서버(클라우드) 공정완료 제품개수 업데이트(tbi_production_work_result)
		dbServletLink.connectURL("M303S050100E142"); 
		dbServletLink.queryProcessForjsp(GV_PARM, false);
		
		// 외부서버(보조서버) 공정완료 제품개수 업데이트(tbi_production_work_result)
		dbServletLink.connectURL("M303S050100E152"); 
		dbServletLink.queryProcessForjsp(GV_PARM, false);
		
		rTurnValue="공정완료 제품개수 업데이트 완료!!!";
	}

	response.setContentType("text/html");
	response.setHeader("Cache-Control", "no-store");
	response.getWriter().print(rTurnValue);
	
%>

