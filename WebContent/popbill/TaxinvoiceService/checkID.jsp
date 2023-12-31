<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen" />
		<title>팝빌 SDK jsp Example.</title>
	</head>

<%@ include file="common.jsp" %>
<%@page import="com.popbill.api.Response"%>
<%@page import="com.popbill.api.PopbillException"%>

<%
	/*
	 * 팝빌 회원아이디 중복여부를 확인합니다.
   * - https://docs.popbill.com/taxinvoice/java/api#CheckID
	 */

	// 중복조회할 아이디
	String userID = "testkorea";

	Response CheckResponse = null;

	try {

		CheckResponse = taxinvoiceService.checkID(userID);

	} catch (PopbillException e) {
		//적절한 오류 처리를 합니다. pe.getCode() 로 오류코드를 확인하고, pe.getMessage()로 관련 오류메시지를 확인합니다.
		//예제에서는 exception.jsp 페이지에서 오류를 표시합니다.
		throw e;
	}
%>
	<div id="content">
		<p class="heading1">Response</p>
		<br/>
		<fieldset class="fieldset1">
			<legend>아이디 중복확인</legend>
			<ul>
				<li>Response.code : <%=CheckResponse.getCode()%></li>
				<li>Response.message : <%=CheckResponse.getMessage()%></li>
			</ul>
		</fieldset>
	 </div>
</html>
