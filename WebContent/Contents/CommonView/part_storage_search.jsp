<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ include file="/strings.jsp" %>


<%
	DoyosaeTableModel TableModel;

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String[] strColumnHead 	= {"원부자재코드", "개정번호", "원부자재명","창고","렉","선반","칸","입고수","입고전","입고후","안전재고"};	
	
	String  GV_PART_CD="";

	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");	
	
	String param = GV_PART_CD + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "part_cd", GV_PART_CD);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M202S120100E204", strColumnHead, jArray);
    int RowCount =TableModel.getRowCount();
    
    String rtHTML = "";
    if(RowCount>0){
    	Vector targetCustVector = (Vector)(TableModel.getVector().get(0));
        rtHTML = targetCustVector.get(0).toString() + "|" +
        		targetCustVector.get(1).toString() + "|" +
        		targetCustVector.get(2).toString() + "|" +
        		targetCustVector.get(3).toString() + "|" +
        		targetCustVector.get(4).toString() + "|" +
        		targetCustVector.get(5).toString() + "|" +
        		targetCustVector.get(6).toString() + "|" +
        		targetCustVector.get(7).toString() + "|" +
        		targetCustVector.get(8).toString() + "|" +
        		targetCustVector.get(9).toString() + "|" +
        		targetCustVector.get(10).toString() + "|" 
        		;
    }

    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-store");
    response.getWriter().print(rtHTML);
%>

