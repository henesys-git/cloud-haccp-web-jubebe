<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen" />
		<title>팝빌 SDK jsp Example</title>
	</head>

<%@ include file="common.jsp" %>
<%@page import="com.popbill.api.PopbillException"%>
<%@page import="com.popbill.api.Response"%>
<%@page import="com.popbill.api.taxinvoice.MgtKeyType"%>

<%
	/*
	 * 팝빌사이트에서 작성된 세금계산서에 파트너 문서번호를 할당합니다.
   * - https://docs.popbill.com/taxinvoice/java/api#AssignMgtKey
	 */

	// 팝빌회원 사업자번호, '-'제외 10자리
	String testCorpNum = "1234567890";

	// 세금계산서 유형. SELL :매출, BUY : 매입, TRUSTEE : 수탁
	MgtKeyType keyType = MgtKeyType.SELL;

	// 세금계산서 아이템키, 문서 목록조회(Search) API의 반환항목중 ItemKey 참조
	String itemKey = "019010316320100001";

	// 할당할 문서번호, 숫자, 영문 '-', '_' 조합으로 1~24자리까지
	// 사업자번호별 중복없는 고유번호 할당
	String mgtKey = "20190107-002";

	Response CheckResponse = null;

	try {

		CheckResponse = taxinvoiceService.assignMgtKey(testCorpNum, keyType, itemKey, mgtKey);

	} catch (PopbillException pe) {
		//오류 처리를 합니다. pe.getCode() 로 오류코드를 확인하고, pe.getMessage()로 관련 오류메시지를 확인합니다.
		//예제에서는 exception.jsp 페이지에서 오류를 표시합니다.
		throw pe;
	}

%>
	<div id="content">
		<p class="heading1">Response</p>
		<br/>
		<fieldset class="fieldset1">
			<legend>문서번호 할당</legend>
			<ul>
				<li>Response.code : <%=CheckResponse.getCode()%></li>
				<li>Response.message : <%=CheckResponse.getMessage()%></li>
			</ul>
		</fieldset>
	 </div>
</html>
