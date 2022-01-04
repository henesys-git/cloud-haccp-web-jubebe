<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String zhtml = "";
	
	String  GV_ORDER_NO="",GV_LOTNO="",GV_PROC_CD="",GV_MEMBER_KEY="",
			GV_PRODUCT_PROCESS_YN="",GV_PACKING_PROCESS_YN="" ;

	if(request.getParameter("order_no")== null) 
		GV_ORDER_NO="";
	else 
		GV_ORDER_NO = request.getParameter("order_no");
	
	if(request.getParameter("lotno")== null) 
		GV_LOTNO="";
	else 
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("proc_cd")== null) 
		GV_PROC_CD="";
	else 
		GV_PROC_CD = request.getParameter("proc_cd");
	
	if(request.getParameter("product_process_yn")== null) 
		GV_PRODUCT_PROCESS_YN="";
	else 
		GV_PRODUCT_PROCESS_YN = request.getParameter("product_process_yn");
	
	if(request.getParameter("packing_process_yn")== null) 
		GV_PACKING_PROCESS_YN="";
	else 
		GV_PACKING_PROCESS_YN = request.getParameter("packing_process_yn");
	
	if(request.getParameter("member_key")== null) 
		GV_MEMBER_KEY="";
	else 
		GV_MEMBER_KEY = request.getParameter("member_key");
	
// 	GV_PROC_CD = "P000002"; 	// SMT 공정코드 : P000002
// 	GV_PROD_RETURN_CNT = "0";  // 공정완료 제품개수 : 추후 카메라서버에서 넘겨받은 값 읽어오는 걸로 변경
	
	DoyosaeTableModel TableModel;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "proc_cd", GV_PROC_CD);
	jArray.put( "product_process_yn", GV_PRODUCT_PROCESS_YN);
	jArray.put( "packing_process_yn", GV_PACKING_PROCESS_YN);
	jArray.put( "member_key", GV_MEMBER_KEY);	
	
	TableModel = new DoyosaeTableModel("M303S050100E144", jArray);
 	int RowCount =TableModel.getRowCount();	
    
    StringBuffer html = new StringBuffer();
    if(RowCount>0) {
    	zhtml += TableModel.getValueAt(0,0).toString().trim() + "|"
    		   + TableModel.getValueAt(0,1).toString().trim() + "|"
    		   + TableModel.getValueAt(0,2).toString().trim() + "|"
    		   + TableModel.getValueAt(0,3).toString().trim() + "|"
    		   + TableModel.getValueAt(0,4).toString().trim() + "|"
    		   + TableModel.getValueAt(0,5).toString().trim() + "|"
    		   + TableModel.getValueAt(0,6).toString().trim() + "|"
    		   + TableModel.getValueAt(0,7).toString().trim() + "|"
    		   + TableModel.getValueAt(0,8).toString().trim() + "|"
    		   + TableModel.getValueAt(0,9).toString().trim() + "|"
			   + TableModel.getValueAt(0,10).toString().trim() + "|"
			   + TableModel.getValueAt(0,11).toString().trim() + "|" ;
    }
	
%>
<%=zhtml%>