<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen" />
		<title>팝빌 SDK jsp Example.</title>
	</head>

<%@ include file="common.jsp" %>
<%@page import="com.popbill.api.PopbillException"%>

<%
    /*
    * 계좌 거래내역 수집을 요청한다.
    * - 검색기간은 현재일 기준 90일 이내로만 요청할 수 있다.
    * - https://docs.popbill.com/easyfinbank/java/api#RequestJob
    */
    Calendar cal = Calendar.getInstance ();
	cal.setTime(new Date());
	
    SimpleDateFormat format1 = new SimpleDateFormat ("yyyyMMdd");
	Date time = new Date();
	String time1 = format1.format(time);
	System.out.println("타임 :" + time1);
	
	cal.add(Calendar.DATE, -90);
	
	System.out.println("타임-90 :" + format1.format(cal.getTime()));
	
  	// 팝빌회원 사업자번호
  	String testCorpNum = "6058632975";

    // 은행코드
    String BankCode = "0032";

    // 계좌번호
    String AccountNumber = "1012030072300"; // 실제 지강푸드 계좌번호 개발서버에서 사용금지 
//     String AccountNumber = "202020";

    // 시작일자, 날짜형식(yyyyMMdd)
    String SDate = format1.format(cal.getTime());

    // 종료일자, 닐짜형식(yyyyMMdd)
    String EDate = time1;

  	String jobID = null;

  	try {

  		jobID = easyFinBankService.requestJob(testCorpNum, BankCode, AccountNumber, SDate, EDate);

  	} catch (PopbillException pe) {
  		//적절한 오류 처리를 합니다. pe.getCode() 로 오류코드를 확인하고, pe.getMessage()로 관련 오류메시지를 확인합니다.
  		//예제에서는 exception.jsp 페이지에서 오류를 표시합니다.
  		throw pe;
  	}
%>
	<body>
		<div id="content">
			<p class="heading1">Response </p>
			<br/>
			<fieldset class="fieldset1">
				<legend>계좌 거래내역 수집 요청</legend>
				<ul>
					<li>jobID (작업아이디) : <%=jobID %> </li>
				</ul>
			</fieldset>
		 </div>
	</body>
</html>
