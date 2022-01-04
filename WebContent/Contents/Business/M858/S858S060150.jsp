<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
바코드 출력
 */

// 	String loginID = session.getAttribute("login_id").toString();
// 	String member_key = session.getAttribute("member_key").toString();

// 	SysConfig sys_config = new SysConfig();
	
	String rTurnValue="";
/* 	BarcodePrint BCPrint = new BarcodePrint(); */
	
	String GV_PROD_CD="",GV_BARCODE_PRINT_IP;

	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");  
	
	//2019-03-11 추가
	if(request.getParameter("barcode_print_ip")== null)
		GV_BARCODE_PRINT_IP="";
	else
		GV_BARCODE_PRINT_IP = request.getParameter("barcode_print_ip");  	
	
    if(GV_PROD_CD.equals("")){
    	rTurnValue="제품번호가 없습니다";
    }
    else{
/* 		rTurnValue = BCPrint.DoBarcodePrint(GV_PROD_CD, GV_BARCODE_PRINT_IP);*/    }
    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-store");
    response.getWriter().print(rTurnValue);
%>
