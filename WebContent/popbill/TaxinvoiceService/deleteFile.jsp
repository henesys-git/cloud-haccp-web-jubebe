<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen" />
		<title>팝빌 SDK jsp Example.</title>
	</head>

<%@ include file="common.jsp" %>
<%@page import="com.popbill.api.PopbillException"%>
<%@page import="com.popbill.api.Response"%>
<%@page import="com.popbill.api.taxinvoice.MgtKeyType"%>

<%
	/*
	 * 세금계산서에 첨부된 파일을 삭제합니다.
	 * - 파일을 식별하는 파일아이디는 첨부파일 목록(GetFileList API) 의 응답항목
	 *   중 파일아이디(AttachedFile) 값을 통해 확인할 수 있습니다.
   * - https://docs.popbill.com/taxinvoice/java/api#DeleteFile
	 */

	// 팝빌회원 사업자번호
	String testCorpNum = "1234567890";

	// 세금계산서 유형. SELL : 매출, BUY : 매입, TRUSTEE : 수탁
	MgtKeyType keyType = MgtKeyType.SELL;

	// 세금계산서 문서번호
	String mgtKey = "20190107-100";

	// 파일 아이디, 파일아이디는 첨부파일목록(getFiles)의 attachedFile 변수값 확인
	String fileID = "3662614B-A90F-4957-991C-E2E4227A15FA.PBF";

	Response CheckResponse = null;

	try {

		CheckResponse = taxinvoiceService.deleteFile(testCorpNum, keyType, mgtKey, fileID);

	} catch (PopbillException pe) {
		//적절한 오류 처리를 합니다. pe.getCode() 로 오류코드를 확인하고, pe.getMessage()로 관련 오류메시지를 확인합니다.
		//예제에서는 exception.jsp 페이지에서 오류를 표시합니다.
		throw pe;
	}

%>
	<div id="content">
		<p class="heading1">Response</p>
		<br/>
		<fieldset class="fieldset1">
			<legend>첨부파일 삭제</legend>
			<ul>
				<li>Response.code : <%=CheckResponse.getCode()%></li>
				<li>Response.message : <%=CheckResponse.getMessage()%></li>
			</ul>
		</fieldset>
	 </div>
</html>
