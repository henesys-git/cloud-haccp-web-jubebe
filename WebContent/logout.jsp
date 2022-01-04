<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*" %>

<%
/* 
String login_id = session.getAttribute("login_id").toString();
String login_ip = session.getAttribute("login_ip").toString();
String login_date = session.getAttribute("login_date").toString();

JSONObject jArray = new JSONObject();
jArray.put("login_id", login_id);
jArray.put("login_ip", login_ip);
jArray.put("login_date", login_date);

DoyosaeTableModel TableModel = new DoyosaeTableModel("M000S100000E122", jArray);
 */
session.invalidate(); 
response.sendRedirect("index.jsp");
%>