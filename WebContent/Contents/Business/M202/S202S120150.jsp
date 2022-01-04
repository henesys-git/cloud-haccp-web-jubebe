<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
바코드 출력 절대 수정 금지 : 수정 시 커밋할 때 수정 사유 입력하세요
 */


 
// 	String loginID = session.getAttribute("login_id").toString();

// 	SysConfig sys_config = new SysConfig();
// 	String loginID = session.getAttribute("login_id").toString();
// 	String member_key = session.getAttribute("member_key").toString();
	String rTurnValue="";
	//BarcodePrint BCPrint = new BarcodePrint();
	
	String GV_PART_CD="",GV_BARCODE_PRINT_IP;

	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");  
	
	//2019-03-11 추가
	if(request.getParameter("barcode_print_ip")== null)
		GV_BARCODE_PRINT_IP="";
	else
		GV_BARCODE_PRINT_IP = request.getParameter("barcode_print_ip");  	
	
    if(GV_PART_CD.equals("")){
    	rTurnValue="원부자재번호가 없습니다";
    }
    else{
		/* rTurnValue = BCPrint.DoBarcodePrint(GV_PART_CD, GV_BARCODE_PRINT_IP); */
    }
    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-store");
    response.getWriter().print(rTurnValue);
%>
