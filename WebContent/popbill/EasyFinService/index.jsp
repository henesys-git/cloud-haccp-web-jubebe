<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="popbill/resources/main.css" media="screen"/>
    <title>팝빌 SDK jsp Example.</title>
</head>
<body>
<div id="content">
    <p class="heading1">팝빌 계좌 간편조회 API SDK jsp Example.</p>
    <br/>
    <fieldset class="fieldset1">
        <legend>계좌관리</legend>
        <ul>
            <li><a href="registBankAccount.jsp">registBankAccount</a> - 계좌 등록</li>
            <li><a href="updateBankAccount.jsp">updateBankAccount</a> - 계좌 정보 수정</li>
            <li><a href="getBankAccountInfo.jsp">getBankAccountInfo</a> - 계좌 정보 확인</li>
            <li><a href="listBankAccount.jsp">listBankAccount</a> - 계좌 목록 확인</li>
            <li><a href="getBankAccountMgtURL.jsp">getBankAccountMgtURL</a> - 계좌 관리 팝업 URL</li>
            <li><a href="closeBankAccount.jsp">closeBankAccount</a> - 계좌 정액제 해지요청</li>
            <li><a href="revokeCloseBankAccount.jsp">revokeCloseBankAccount</a> - 계좌 정액제 해지요청 취소</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>계좌 거래내역 수집</legend>
        <ul>
            <li><a href="requestJob.jsp">requestJob</a> - 수집 요청</li>
            <li><a href="getJobState.jsp">getJobState</a> - 수집 상태 확인</li>
            <li><a href="listActiveJob.jsp">listActiveJob</a> - 수집 상태 목록 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>계좌 거내내역 관리</legend>
        <ul>
            <li><a href="search.jsp">search</a> - 거래 내역 조회</li>
            <li><a href="summary.jsp">summary</a> - 거래 내역 요약정보 조회</li>
            <li><a href="saveMemo.jsp">saveMemo</a> - 거래 내역 메모저장</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>포인트 관리 / 정액제 신청</legend>
        <ul>
            <li><a href="getFlatRatePopUpURL.jsp">getFlatRatePopUpURL</a> - 정액제 서비스 신청 URL</li>
            <li><a href="getFlatRateState.jsp">getFlatRateState</a> - 정액제 서비스 상태 확인</li>
            <li><a href="getBalance.jsp">getBalance</a> - 연동회원 잔여포인트 확인</li>
            <li><a href="getChargeURL.jsp">getChargeURL</a> - 연동회원 포인트충전 URL</li>
            <li><a href="getPartnerBalance.jsp">getPartnerBalance</a> - 파트너 잔여포인트 확인</li>
            <li><a href="getPartnerURL.jsp">getPartnerURL</a> - 파트너 포인트충전 URL</li>
            <li><a href="getChargeInfo.jsp">getChargeInfo</a> - 과금정보 확인</li>
        </ul>
    </fieldset>
    <fieldset class="fieldset1">
        <legend>회원정보</legend>
        <ul>
            <li><a href="checkIsMember.jsp">checkIsMember</a> - 연동회원 가입여부 확인</li>
            <li><a href="checkID.jsp">checkID</a> - 아이디 중복 확인</li>
            <li><a href="joinMember.jsp">joinMember</a> - 연동회원 신규가입</li>
            <li><a href="getAccessURL.jsp">getAccessURL</a> - 팝빌 로그인 URL</li>
            <li><a href="getCorpInfo.jsp">getCorpInfo</a> - 회사정보 확인</li>
            <li><a href="updateCorpInfo.jsp">updateCorpInfo</a> - 회사정보 수정</li>
            <li><a href="registContact.jsp">registContact</a> - 담당자 등록</li>
            <li><a href="listContact.jsp">listContact</a> - 담당자 목록 확인</li>
            <li><a href="updateContact.jsp">updateContact</a> - 담당자 정보 수정</li>
        </ul>
    </fieldset>
</div>
</body>
</html>
