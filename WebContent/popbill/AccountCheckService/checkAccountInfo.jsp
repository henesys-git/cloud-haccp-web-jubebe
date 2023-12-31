<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen" />
		<title>예금주조회 SDK JSP Example.</title>
	</head>

<%@ include file="common.jsp" %>
<%@page import="com.popbill.api.AccountCheckInfo"%>
<%@page import="com.popbill.api.PopbillException"%>

<%
	/*
	 * 1건의 계좌번호에 대한 예금주성명을 조회합니다.
	 */

	AccountCheckInfo accountInfo = null;

  // 팝빌회원 사업자번호
	String testCorpNum = "1234567890";


  // 기관코드
	String bankCode = "0004";

  // 계좌번호
  String accountNumber = "94324511758";

	try{
		accountInfo = accountCheckService.CheckAccountInfo(testCorpNum, bankCode, accountNumber);
	} catch (PopbillException pe){
		throw pe;
	}

%>

	<body>
		<div id="content">
			<p class="heading1">예금주조회 API SDK - JSP Example.</p>
			<br/>
			<fieldset class="fieldset1">
					<legend>에금주조회 결과</legend>
					<ul>
            <li> bankCode (기관코드) : <%=accountInfo.getBankCode()%></li>
            <li> accountNumber (계좌번호) : <%=accountInfo.getAccountNumber()%></li>
            <li> accountName (예금주 성명) : <%=accountInfo.getAccountName()%></li>
            <li> checkDate (확인일시) : <%=accountInfo.getCheckDate()%></li>
            <li> resultCode (응답코드) : <%=accountInfo.getResultCode()%></li>
            <li> resultMessage (응답메시지) : <%=accountInfo.getResultMessage()%></li>
					</ul>

			</fieldset>
		 </div>

	</body>
</html>
