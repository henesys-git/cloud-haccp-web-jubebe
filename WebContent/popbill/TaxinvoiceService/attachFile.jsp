<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen" />
		<title>팝빌 SDK jsp Example.</title>
	</head>

<%@ include file="common.jsp" %>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.popbill.api.PopbillException"%>
<%@page import="com.popbill.api.Response"%>
<%@page import="com.popbill.api.taxinvoice.MgtKeyType"%>

<%
	/*
	 * 세금계산서에 첨부파일을 등록합니다.
	 * - [임시저장] 상태의 세금계산서만 파일을 첨부할 수 있습니다.
	 * - 첨부파일은 최대 5개까지 등록할 수 있습니다.
   * - https://docs.popbill.com/taxinvoice/java/api#AttachFile
	 */

	// 팝빌회원 사업자번호
	String testCorpNum = "1234567890";

	// 세금계산서 유형. SELL :매출 , BUY : 매입  , TRUSTEE : 수탁
	MgtKeyType keyType = MgtKeyType.SELL;

	// 세금계산서 문서번호
	String mgtKey = "20190107-100";

	// 첨부파일 표시명
	String fileName = "test.jpg";

	// 첨부할 파일스트림
	InputStream stream = new FileInputStream(application.getRealPath("/resources/test.jpg"));

  	Response CheckResponse = null;

	try {

		CheckResponse = taxinvoiceService.attachFile(testCorpNum, keyType, mgtKey, fileName, stream);

	} catch (PopbillException pe) {
		//적절한 오류 처리를 합니다. pe.getCode() 로 오류코드를 확인하고, pe.getMessage()로 관련 오류메시지를 확인합니다.
		//예제에서는 exception.jsp 페이지에서 오류를 표시합니다.
		throw pe;
	} finally {
		if(stream != null)
			try {
					stream.close();
			} catch(IOException e) {}
	}

%>
	<div id="content">
		<p class="heading1">Response</p>
		<br/>
		<fieldset class="fieldset1">
			<legend>세금계산서 첨부파일 등록</legend>
			<ul>
				<li>Response.code : <%=CheckResponse.getCode()%></li>
				<li>Response.message : <%=CheckResponse.getMessage()%></li>
			</ul>
		</fieldset>
	 </div>
</html>
