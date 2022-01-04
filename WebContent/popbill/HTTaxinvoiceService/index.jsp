<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen"/>
    <title>팝빌 SDK jsp Example.</title>
</head>
<body>
<div id="content">
    <p class="heading1">팝빌 홈택스연동(전자세금계산서) SDK jsp Example.</p>
    <br/>
    <fieldset class="fieldset1">
        <legend>홈택스 전자세금계산서 매입/매출 내역 수집</legend>
        <ul>
            <li><a href="popbill/HTTaxinvoiceService/requestJob.jsp">requestJob</a> - 수집 요청</li>
            <li><a href="popbill/HTTaxinvoiceService/getJobState.jsp">getJobState</a> - 수집 상태 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/listActiveJob.jsp">listActiveJob</a> - 수집 상태 목록 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>홈택스 전자세금계산서 매입/매출 내역 수집 결과 조회</legend>
        <ul>
            <li><a href="popbill/HTTaxinvoiceService/search.jsp">search</a> - 수집 결과 조회</li>
            <li><a href="popbill/HTTaxinvoiceService/summary.jsp">summary</a> - 수집 결과 요약정보 조회</li>
            <li><a href="popbill/HTTaxinvoiceService/getTaxinvoice.jsp">getTaxinvoice</a> - 상세정보 확인 - JSON</li>
            <li><a href="popbill/HTTaxinvoiceService/getXML.jsp">getXML</a> - 상세정보 확인 - XML</li>
            <li><a href="popbill/HTTaxinvoiceService/getPopUpURL.jsp">getPopUpURL</a> - 홈택스 전자세금계산서 보기 팝업 URL</li>
            <li><a href="popbill/HTTaxinvoiceService/getPrintURL.jsp">getPrintURL</a> - 홈택스 전자세금계산서 인쇄 팝업 URL</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>홈택스연동 인증 관리</legend>
        <ul>
            <li><a href="popbill/HTTaxinvoiceService/getCertificatePopUpURL.jsp">getCertificatePopUpURL</a> - 홈택스연동 인증 관리 팝업 URL</li>
            <li><a href="popbill/HTTaxinvoiceService/getCertificateExpireDate.jsp">getCertificateExpireDate</a> - 홈택스연동 공인인증서 만료일자 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/checkCertValidation.jsp">checkCertValidation</a> - 홈택스 공인인증서 로그인 테스트</li>
            <li><a href="popbill/HTTaxinvoiceService/registDeptUser.jsp">registDeptUser</a> - 부서사용자 계정등록</li>
            <li><a href="popbill/HTTaxinvoiceService/checkDeptUser.jsp">checkDeptUser</a> - 부서사용자 등록정보 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/checkLoginDeptUser.jsp">checkLoginDeptUser</a> - 부서사용자 로그인 테스트</li>
            <li><a href="popbill/HTTaxinvoiceService/deleteDeptUser.jsp">deleteDeptUser</a> - 부서사용자 등록정보 삭제</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>포인트 관리 / 정액제 신청</legend>
        <ul>
            <li><a href="popbill/HTTaxinvoiceService/getBalance.jsp">getBalance</a> - 연동회원 잔여포인트 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/getChargeURL.jsp">getChargeURL</a> - 연동회원 포인트충전 URL</li>
            <li><a href="popbill/HTTaxinvoiceService/getPartnerBalance.jsp">getPartnerBalance</a> - 파트너 잔여포인트 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/getPartnerURL.jsp">getPartnerURL</a> - 파트너 포인트충전 URL</li>
            <li><a href="popbill/HTTaxinvoiceService/getChargeInfo.jsp">getChargeInfo</a> - 과금정보 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/getFlatRatePopUpURL.jsp">getFlatRatePopUpURL</a> - 정액제 서비스 신청 URL</li>
            <li><a href="popbill/HTTaxinvoiceService/getFlatRateState.jsp">getFlatRateState</a> - 정액제 서비스 상태 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>회원정보</legend>
        <ul>
            <li><a href="popbill/HTTaxinvoiceService/checkIsMember.jsp">checkIsMember</a> - 연동회원 가입여부 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/checkID.jsp">checkID</a> - 아이디 중복 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/joinMember.jsp">joinMember</a> - 연동회원 신규가입</li>
            <li><a href="popbill/HTTaxinvoiceService/getAccessURL.jsp">getAccessURL</a> - 팝빌 로그인 URL</li>
            <li><a href="popbill/HTTaxinvoiceService/getCorpInfo.jsp">getCorpInfo</a> - 회사정보 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/updateCorpInfo.jsp">updateCorpInfo</a> - 회사정보 수정</li>
            <li><a href="popbill/HTTaxinvoiceService/registContact.jsp">registContact</a> - 담당자 등록</li>
            <li><a href="popbill/HTTaxinvoiceService/listContact.jsp">listContact</a> - 담당자 목록 확인</li>
            <li><a href="popbill/HTTaxinvoiceService/updateContact.jsp">updateContact</a> - 담당자 정보 수정</li>
        </ul>
    </fieldset>
</div>
</body>
</html>
